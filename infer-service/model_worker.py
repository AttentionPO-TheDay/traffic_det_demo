import sys
import os
import importlib.util as imp

from kafka import KafkaConsumer, KafkaProducer
import torch
import json
import signal


ERROR_DIR_INVALID = -2
TRAFFIC_TOPIC = os.getenv("TRAFFIC_TOPIC", "traffic")
RESULT_TOPIC = os.getenv("RESULT_TOPIC", "traffic_results")

MODEL_FILENAME = "model.pt"
PREPROCESSOR_FILENAME = "preprocessor.py"

# Kafka broker 地址列表，逗号分隔，通过环境变量注入
broker_list = [
    b.strip()
    for b in os.getenv("KAFKA_BOOTSTRAP_SERVERS", "127.0.0.1:9092").split(",")
    if b.strip()
]


# handle SIGTERM signal to exit elegantly
running = True


def handle_sigterm(signum, frame):
    print("Exiting...")
    global running
    running = False


def check_dir_valid(model_dir):
    required_files = {MODEL_FILENAME, PREPROCESSOR_FILENAME}

    if os.path.isdir(model_dir):
        existing_files = set(os.listdir(model_dir))
        if required_files.issubset(existing_files):
            return True
    return False


def load_and_run_module(module_path):
    module_name = module_path.split("/")[-1].split(".")[0]
    spec = imp.spec_from_file_location(module_name, module_path)
    module = imp.module_from_spec(spec)
    spec.loader.exec_module(module)

    # Return the loaded module for further usage
    return module


def load_model(model_dir):
    device = "cuda" if torch.cuda.is_available() else "cpu"
    return torch.jit.load(
        os.path.join(model_dir, MODEL_FILENAME), map_location=torch.device(device)
    )


def model_worker(model_id, model_name, model_dir, dimensions):
    signal.signal(signal.SIGINT, handle_sigterm)  # Handle Ctrl+C
    signal.signal(signal.SIGTERM, handle_sigterm)  # Handle kill
    
    if not check_dir_valid(model_dir):
        print("Invalid Dir")
        sys.exit(ERROR_DIR_INVALID)

    consumer = KafkaConsumer(
        TRAFFIC_TOPIC,
        bootstrap_servers=broker_list,
        value_deserializer=lambda m: json.loads(m.decode("utf-8")),
        max_poll_records = 100
    )

    producer = KafkaProducer(
        bootstrap_servers=broker_list,
        value_serializer=lambda m: json.dumps(m).encode("utf-8"),
    )

    # load network and its parameters
    model = load_model(model_dir)
    model.eval()

    pre = load_and_run_module(os.path.join(model_dir, PREPROCESSOR_FILENAME))

    pull_predict_push_loop(
        pre, model, dimensions, consumer, producer, model_id, model_name
    )


def pull_predict_push_loop(
    pre, model, dimensions, consumer, producer, model_id, model_name
):
    global running
    while running:
        msg_pack = consumer.poll(timeout_ms=1000)
        print("checking>>>")
        for tp, messages in msg_pack.items():
            for message in messages:
                # debug
                print(
                    "%s:%d:%d: key=%s value=%s"
                    % (
                        message.topic,
                        message.partition,
                        message.offset,
                        message.key,
                        message.value,
                    )
                )

                traffic = json.loads(message.value["traffic"])
                uid = message.value["uid"]
                input_tensor = pre.preprocess(traffic)

                print(input_tensor)

                output_batch = model(input_tensor).tolist()
                print(output_batch)

                result = []
                for output in output_batch:
                    result_item = {
                        "uid": uid,
                        "model_id": model_id,
                        "model_name": model_name,
                    }
                    result_item["classification_result"] = list(
                        map(
                            lambda label, prob: {"label": label, "prob": prob},
                            dimensions,
                            output,
                        )
                    )

                    result.append(result_item)
                push_result(producer, result)

    consumer.close()
    producer.close()


def on_send_success(record_metadata):
    print(
        "%s:%s:%s"
        % (record_metadata.topic, record_metadata.partition, record_metadata.offset)
    )


def push_result(producer, data):
    producer.send(RESULT_TOPIC, data).add_callback(on_send_success)


if __name__ == "__main__":
    model_worker("12", "./test")
