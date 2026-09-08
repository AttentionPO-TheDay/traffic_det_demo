from datetime import datetime
from fastapi import APIRouter, HTTPException, UploadFile, Form, Request
from fastapi.middleware.cors import CORSMiddleware
from typing import Annotated
import uuid
import os
import zipfile
import shutil

router = APIRouter()

upload_task = {}
UPLOAD_MODEL_FOLDER = "./uploaded_models"
UPLOAD_CHUNK_FOLDER = './uploaded_chunks'

@router.post("/upload")
def upload_init(
  name: Annotated[str, Form()],
  description: Annotated[str, Form()],
  dimension: Annotated[str, Form()],
  
  filename: Annotated[str, Form()],
  total_size: Annotated[int, Form()],
  total_chunks: Annotated[int, Form()],
  file_hash: Annotated[str, Form()]
):
    upload_id = str(uuid.uuid4())
    upload_task[upload_id] = {
        'name': name,
        'description': description,
        'dimension': dimension,
        
        'filename': filename,
        'totalSize': total_size,
        'totalChunks': total_chunks,
        'fileHash': file_hash,
        'uploadChunks': [],
    }
    
    print(upload_task[upload_id])

    return {"code": 200, "uploadId": upload_id}


@router.get("/upload/status")
def upload_status(upload_id: str | None = None):
    if not upload_id:
      res = [{**v, 'uploadId': k} for (k, v) in upload_task.items()]
      return {"code": 200, "data": res}
    
    if upload_id not in upload_task:
      raise HTTPException(status_code=404, detail='Upload ID does not exist.')

    res = {**upload_task[upload_id], 'uploadId': upload_id}
    return {"code": 200, "data": res}


@router.post("/upload/chunk")
def upload_chunk(
    file: UploadFile,
    chunk_index: Annotated[int, Form()],
    upload_id: Annotated[str, Form()],
):
  if upload_id not in upload_task:
    raise HTTPException(status_code=404, detail='Upload ID does not exist.')
  
  upload_path = os.path.join(UPLOAD_CHUNK_FOLDER, upload_id)
  os.makedirs(upload_path, exist_ok=True)
  
  chunk_path = os.path.join(upload_path, f'chunk_{chunk_index}')
  
  with open(chunk_path, 'wb') as buffer:
    shutil.copyfileobj(file.file, buffer)
  
  upload_task[upload_id]['uploadChunks'].append(chunk_index)
  return {
    'code': 200,
    'msg': f'Chunk {chunk_index} uploaded successfully.'
  }


def validate_archive(file_path: str) -> bool:
    """验证压缩包内容是否合法"""
    required_files = {".pt", ".py"}
    found_files = set()
    
    with zipfile.ZipFile(file_path, "r") as z:
        print(z.namelist())
        for name in z.namelist():
            if name.endswith(".pt"):
                found_files.add(".pt")
            elif name.endswith(".py"):
                found_files.add(".py")

    return required_files.issubset(found_files)


def extract_archive(zip_path: str, extract_to: str, chunk_size: int = 1024 * 1024):
    with zipfile.ZipFile(zip_path, "r") as z:
        all_paths = z.namelist()

        # find common parent directory if exists
        outer_dirs = {p.split("/")[0] for p in all_paths}
        common_prefix = outer_dirs.pop() + "/" if len(outer_dirs) == 1 else ""

        # strip the common parent directory while extracting files
        for file in all_paths:
            if file.endswith("/"):  # skip directories
                continue

            target_path = os.path.join(extract_to, file[len(common_prefix) :])
            with z.open(file) as src, open(target_path, "wb") as dest:
                # read in chunks in case the zip file is extremely large
                while chunk := src.read(chunk_size):
                    dest.write(chunk)

@router.post('/upload/merge/{upload_id}')
def merge_chunks(upload_id: str, request: Request):
    if upload_id not in upload_task:
      raise HTTPException(status_code=404, detail='Upload ID does not exist.')
    
    upload_path = os.path.join(UPLOAD_CHUNK_FOLDER, upload_id)
    filename = upload_task[upload_id]['filename']
    final_file_path = os.path.join(upload_path, filename)
    
    with open(final_file_path, 'wb') as final_file:
      for i in range(upload_task[upload_id]['totalChunks']):
        chunk_path = os.path.join(upload_path, f'chunk_{i}')
        
        # check for existance
        if not os.path.isfile(chunk_path):
          raise HTTPException(status_code=400, detail='Chunk file missing! Merge aborted.')
        
        with open(chunk_path, 'rb') as chunk_file:
          shutil.copyfileobj(chunk_file, final_file)
    
    model_id = str(uuid.uuid4())
    model_path = os.path.join(UPLOAD_MODEL_FOLDER, model_id)
    try:
        if not validate_archive(final_file_path):
            raise HTTPException(status_code=400, detail='Required files missing! Merge aborted!')
        
        os.makedirs(model_path)
        extract_archive(final_file_path, model_path)
    except zipfile.BadZipFile:
      raise HTTPException(status_code=400, detail='File extraction failed! Merge aborted!')
        
    # update global db records
    upload_desc = upload_task[upload_id]
    
    model_config = {
        'model_id': model_id,
        'name': upload_desc['name'],
        'description': upload_desc['description'],
        'enabled': True,
        'upload_time': str(datetime.now()),
        'model_dir': model_path,
        'enabled_time': str(datetime.now()),
        'dimensions': upload_desc['dimension'].split(','),
      }
    request.app.state.db[model_id] = model_config
    request.app.state.manager.start_model_process(model_config)
    del upload_task[upload_id]
    
    return {
      'code': 200,
      'msg': 'Merge completed.'
    }
    
@router.delete('/upload/{upload_id}')
def delete_upload(upload_id: str):
  if upload_id not in upload_task:
    raise HTTPException(status_code=404, detail='Upload ID does not exist.')
  
  del upload_task[upload_id]
  return {
    'code': 200,
    'msg': 'Task deleted successfully.'
  }
