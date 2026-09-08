import os
import uuid
import shutil
from datetime import datetime
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Optional
import upload

import json
from contextlib import asynccontextmanager

from typing import Annotated
from fastapi.middleware.cors import CORSMiddleware

from model_manger import ModelWorkerManager

UPLOAD_FOLDER = "./uploaded_models"
DB_FILE = "db.json"
MAX_FILE_SIZE = 2 * 1024 * 1024 * 1024  # 2GB
ALLOWED_EXTENSIONS = {".zip"}

db = {}

def load_db_from_json():
    global db
    db_file_path = os.path.join(UPLOAD_FOLDER, DB_FILE)
    if not os.path.isfile(db_file_path):
        return

    try:
        with open(db_file_path, "r") as f:
            db = json.load(f)
    except json.decoder.JSONDecodeError:
        # in case that f is empty
        db = {}


def dump_db_to_json():
    db_file_path = os.path.join(UPLOAD_FOLDER, DB_FILE)
    with open(db_file_path, "w") as f:
        json.dump(db, f)


@asynccontextmanager
async def lifespan(app: FastAPI):
    # initialize shared object
    manager = ModelWorkerManager()
    load_db_from_json()
    manager.start_all_model(filter(lambda model: model["enabled"], db.values()))
    app.state.manager = manager
    app.state.db = db

    yield

    # clean up before exit
    dump_db_to_json()
    manager.cleanup()
    del app.state.manager
    del app.state.db


app = FastAPI(lifespan=lifespan)

# handle Cross-Origin Resource Sharing (CORS)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(upload.router)


os.makedirs(UPLOAD_FOLDER, exist_ok=True)


# 用于存储模型配置到db
class ModelConfig(BaseModel):
    model_id: str
    name: str
    description: Optional[str] = None
    enabled: bool
    upload_time: datetime
    model_dir: str
    enabled_time: datetime
    dimensions: List[str]


class ModelDetail(BaseModel):
    modelId: str
    name: str
    description: Optional[str] = None
    enabled: bool
    uptime: int


# 辅助函数
def generate_unique_id():
    return str(uuid.uuid4())

@app.get("/models")
def list_models() -> List[ModelDetail]:
    res = map(
        lambda x: {
            "modelId": x["model_id"],
            "name": x["name"],
            "description": x["description"],
            "enabled": x["enabled"],
            "uptime": int(
                (
                    datetime.now() - datetime.fromisoformat(x["enabled_time"])
                ).total_seconds()
            ),
        },
        db.values(),
    )
    print(res)
    return res

@app.get("/models/{model_id}/hparams")
async def get_model_hparams(model_id: str):
    # 检查模型是否存在
    if model_id not in db:
        raise HTTPException(status_code=404, detail="模型不存在")
    # 获取模型目录路径
    model_info = db[model_id]
    model_dir = model_info["model_dir"]
    hparams_path = os.path.join(model_dir, "hparams.json")
    # 检查hparams.json文件是否存在
    if not os.path.isfile(hparams_path):
        return ""  
    # 读取并解析JSON文件
    try:
        with open(hparams_path, "r") as f:
            hparams = json.load(f)
    except json.JSONDecodeError:
        raise HTTPException(status_code=500, detail="Invalid JSON format in hparams.json")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error reading hparams.json: {str(e)}") 
    return hparams

@app.put("/models/{model_id}/status")
def update_model_status(model_id: str, enabled: bool):
    if model_id not in db:
        raise HTTPException(status_code=404, detail="模型不存在")

    model_info = db[model_id]
    current_state = model_info["enabled"]
    if enabled != current_state:
        model_info["enabled"] = enabled
        if enabled:
            model_info["enabled_time"] = str(datetime.now())
            app.state.manager.start_model_process(
                model_id=model_id,
                model_dir=model_info["model_dir"],
                dimensions=model_info["dimensions"],
            )
        else:
            app.state.manager.stop_model_process(model_id)

    return {"message": "状态更新成功"}


@app.delete("/models/{model_id}")
def delete_model(model_id: str):
    if model_id not in db:
        raise HTTPException(status_code=404, detail="模型不存在")

    # 删除文件
    model_folder = os.path.join(UPLOAD_FOLDER, model_id)
    if os.path.exists(model_folder):
        shutil.rmtree(model_folder)

    if db[model_id]["enabled"]:
        app.state.manager.stop_model_process(model_id)
    del db[model_id]
    return {"message": "模型已删除"}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
