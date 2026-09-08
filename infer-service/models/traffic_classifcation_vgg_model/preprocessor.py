import torch
import numpy as np

# assume that the flow switch to idle after 1s
THRESHOLD = 1.0

def preprocess(traffic):
    if not traffic:
        return torch.zeros(23)
    
    trace = traffic["trace"]
    sizes = np.array([pkt["size"] for pkt in trace])
    times = np.array([pkt["rel_time"] for pkt in trace])
    
    duration = times[-1] - times[0] if len(times) > 1 else 0.0
    
    forward_times = np.diff(times[sizes > 0])  # 仅计算正数size（正向）的时间间隔
    backward_times = np.diff(times[sizes < 0])  # 仅计算负数size（反向）的时间间隔
    flow_times = np.diff(times)  # 所有包的时间间隔
    
    def extract_features(time_diffs):
        return [
            np.mean(time_diffs) if len(time_diffs) > 0 else 0,
            np.min(time_diffs) if len(time_diffs) > 0 else 0,
            np.max(time_diffs) if len(time_diffs) > 0 else 0,
            np.std(time_diffs) if len(time_diffs) > 0 else 0,
        ]
    
    fwd_features = extract_features(forward_times)
    bwd_features = extract_features(backward_times)
    flow_features = extract_features(flow_times)
    
    active_times = []
    idle_times = []
    last_active_time = times[0]
    for t in times[1:]:
        gap = t - last_active_time
        if gap > THRESHOLD:
            idle_times.append(gap)
        else:
            active_times.append(gap)
        last_active_time = t
    
    active_features = extract_features(active_times)
    idle_features = extract_features(idle_times)
    
    total_bytes = np.abs(sizes).sum()
    flow_rate = total_bytes / duration if duration > 0 else 0
    packet_rate = len(trace) / duration if duration > 0 else 0
    
    feature_vector = [
        duration,
        *fwd_features,
        *bwd_features,
        *flow_features,
        *active_features,
        *idle_features,
        flow_rate,
        packet_rate,
    ]
    
    return torch.tensor(feature_vector, dtype=torch.float32).view(1, 1, -1)
