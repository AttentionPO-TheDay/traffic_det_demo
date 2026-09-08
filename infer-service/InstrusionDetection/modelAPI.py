import uvicorn
from fastapi import FastAPI, HTTPException, Body
from pydantic import BaseModel
import torch

# Model
preliminaryModel = torch.jit.load('preliminaryModel.pt') # 初步分类模型
instrusionModel = torch.jit.load('instrusionModel.pt') # 入侵分类模型
anomalyModel = torch.jit.load('anomalyModel.pt') # 异常行为检测模型



app= FastAPI()

class FlowRequest(BaseModel):
    feature: list = []

@app.get("/")
async def root():
    return {"message": "Hello, this is XingTang API."}

# 初步分类
@app.post("/preliminaryClassifi")
async def preliminaryClassifi(request: FlowRequest=Body(...)):
    input = torch.tensor(request.feature, dtype=torch.float32)
    output = preliminaryModel(input)
    if output == 0:return {"message": "Normal"}
    elif output == 1:return {"message": "Abnormal"}
    
# 入侵分类
@app.post("/instrusionClassifi")
async def intrusionClassifi(request: FlowRequest=Body(...)):
    name_dict = {0:"Normal",1:"Fuzzers",2:"Analysis",3:"Backdoors",4:"DoS",5:"Exploits",6:"Generic",7:"Reconnaissance",8:"Shellcode",9:"Worms"}
    input = torch.tensor(request.feature, dtype=torch.float32)
    output = instrusionModel(input)
    instrusionName = name_dict.get(output) # 改概率 
    return {"message": instrusionName}

# 行为分类
@app.post("/anomalyClassifi")
async def anomalyClassifi(request: FlowRequest=Body(...)):
    input = torch.tensor(request.feature, dtype=torch.float32)
    output = anomalyModel(input)
    name_dict = {0:"Chat",1:"Email",2:"File Trasfer",3:"Streaming",4:"VoIP",5:"VPN:Chat",6:"VPN:File Transfer",7:"VPN:Email",8:"VPN:Streaming",9:"VPN:Torrent",10:"VPN:VoIP"}
    


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000, reload=True)