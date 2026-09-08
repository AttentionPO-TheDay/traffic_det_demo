import torch
import numpy as np

proto_dict ={
    "24": 0,
    "6": 1,
    "46": 2,
    "26": 3,
    "108": 4,
    "120": 5,
    "60": 6,
    "55": 7,
    "12": 8,
    "132": 9,
    # "unas": 10,
    "102": 11,
    "20": 12,
    "121": 13,
    "22": 14,
    "53": 15,
    "106": 16,
    "74": 17,
    "32": 18,
    "10": 19,
    "128": 20,
    "90": 21,
    "14": 22,
    "23": 23,
    "56": 24,
    "64": 25,
    "13": 26,
    "57": 27,
    "79": 28,
    "8": 29,
    "38": 30,
    "101": 31,
    "100": 32,
    "103": 33,
    "25": 34,
    "118": 35,
    "98": 36,
    "93": 37,
    # "aes-sp3-d": 38,
    "16": 39,
    "59": 40,
    "15": 41,
    "61": 42,
    "21": 43,
    "129": 44,
    "113": 45,
    "111": 46,
    "117": 47,
    "54": 48,
    "3": 49,
    "27": 50,
    "116": 51,
    "34": 52,
    # "zero": 53,
    "89": 54,
    "65": 55,
    # "sep": 56,
    # "mhrp": 57,
    "107": 58,
    "104": 59,
    "131": 60,
    "130": 61,
    "66": 62,
    "109": 63,
    "31": 64,
    "127": 65,
    # "ipnip": 66,
    "28": 67,
    "122": 68,
    "81": 69,
    "76": 70,
    "30": 71,
    "115": 72,
    "9": 73,
    "82": 74,
    "123": 75,
    # "pri-enc": 76,
    "52": 77,
    "105": 78,
    "97": 79,
    "86": 80,
    "70": 81,
    "19": 82,
    "72": 83,
    "73": 84,
    "85": 85,
    "42": 86,
    "125": 87,
    "18": 88,
    "111": 89,
    "11": 90,
    "62": 91,
    "77": 92,
    "69": 93,
    "87": 94,
    # "ib": 95,
    "95": 96,
    "78": 97,
    "88": 98,
    "29": 99,
    "49": 100,
    "83": 101,
    "133": 102,
    "119": 103,
    "75": 104,
    "84": 105,
    "80": 106,
    "39": 107,
    "45": 108,
    # "isis": 109,
    "91": 110,
    "44": 111,
    "67": 112,
    "47": 113,
    "36": 114,
    "110": 115,
    "41": 116,
    "80": 117,
    "92": 118,
    "108": 119,
    "5": 120,
    "37": 121,
    "7": 122,
    "40": 123,
    "43": 124,
    "112": 125,
    "126": 126,
    "35": 35,
    "17": 128
}

THRESHOLD = 1.0  # 流量空闲阈值

def preprocess(traffic):
    if not trace:
        return torch.zeros(28)
    
    # 基础数据提取
    trace = traffic["trace"]
    sizes = np.array([pkt["size"] for pkt in trace])
    times = np.array([pkt["rel_time"] for pkt in trace])
    is_forward = sizes > 0
    
    # 时间相关计算
    duration = times[-1] - times[0] if len(times) > 1 else 0.0
    
    # 包方向分类
    forward_times = times[is_forward]
    backward_times = times[~is_forward]
    fwd_intervals = np.diff(forward_times) if len(forward_times) > 1 else np.array([0.0])
    bwd_intervals = np.diff(backward_times) if len(backward_times) > 1 else np.array([0.0])
    
    # TCP相关字段假设（取第一个包的值）
    # first_pkt = traffic[0] if traffic else {}
    proto = str(traffic.get('proto')) if traffic.get('proto') else '0' #first_pkt.get('proto', 0)
    try:
        proto= proto.map(proto_dict)
    except Exception as e:
        print(f"Error mapping protocol: {e}")
    sttl = traffic.get('sttl', 64)  # 假设源TTL
    dttl = traffic.get('dttl', 64)  # 假设最后一个包是反向
    
    # 基础统计量
    spkts = len(forward_times)
    dpkts = len(backward_times)
    sbytes = np.sum(np.abs(sizes[is_forward]))
    dbytes = np.sum(np.abs(sizes[~is_forward]))
    
    # 构建特征向量
    feature_vector = [
        duration,                       # dur
        proto,                          # proto
        spkts,                          # spkts
        dpkts,                          # dpkts
        sbytes,                         # sbytes
        dbytes,                         # dbytes
        (sbytes + dbytes) / duration if duration > 0 else 0,  # rate
        sttl,                           # sttl
        dttl,                           # dttl
        sbytes / duration if duration > 0 else 0,  # sload
        dbytes / duration if duration > 0 else 0,  # dload
        traffic["tcp_stat"].get("sloss", 0) if "tcp_stat" in traffic else 0,                              # sloss (需要重传信息)
        traffic["tcp_stat"].get("dloss", 0) if "tcp_stat" in traffic else 0,                              # dloss (需要重传信息)
        np.mean(fwd_intervals) if len(fwd_intervals) > 0 else 0,         # sinpkt
        np.mean(bwd_intervals) if len(bwd_intervals) > 0 else 0,         # dinpkt
        np.std(fwd_intervals) if len(fwd_intervals) > 0 else 0,          # sjit
        np.std(bwd_intervals) if len(bwd_intervals) > 0 else 0,          # djit
        0, #first_pkt.get('window', 0),     # swin
        0, #first_pkt.get('seq', 0),        # stcpb
        0, #trace[-1].get('seq', 0) if trace else 0,  # dtcpb (假设最后一个包是反向)
        0, #trace[-1].get('window', 0) if trace else 0,  # dwin
        0,                              # tcprtt (需要SYN/ACK时间戳)
        traffic["tcp_stat"]["synack"] if traffic.get("tcp_stat") else 0,                              # synack
        traffic["tcp_stat"]["ackdat"] if traffic.get("tcp_stat") else 0,                              # ackdat
        sbytes / spkts if spkts > 0 else 0,  # smean
        dbytes / dpkts if dpkts > 0 else 0,  # dmean
        len(set(pkt.get('seq',0) for pkt in trace)),  # trans_depth (简化的序列号计数)
        sbytes                          # response_body_len (假设正向为响应体)
    ]
    
    return torch.tensor(feature_vector, dtype=torch.float32)

if __name__ == "__main__":
    trace = {"trace":[
            {"rel time":0,
            "size": 60},{
            "rel time":0.0001518726348876953,"size":60},{
            "rel time":0.08847880363464355,"size": 52},{
            "rel time":0.08847880363464355,"size": 475}],
            "sttl": 54,
            "dttl": 64,
            "proto": 6,
            "tcp_stat":{
            "sloss":0,
            "dloss":0,
            "synack":0.0001518726348876953,
            "ackdat":0.08832693099975586}}
    print(preprocess(trace))
    
