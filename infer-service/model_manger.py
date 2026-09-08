from multiprocessing import Process
from threading import Thread
import time
from model_worker import model_worker, ERROR_DIR_INVALID


class ModelWorkerManager:
    """ModelWorkerManager creates a sub-process for each active classification model
    and monitors the state of each sub-process.
    """

    def __init__(self):
        self.active_models = {}

    def start_model_process(self, model):
        model_id = model["model_id"]
        model_dir = model["model_dir"]
        if model_id in self.active_models:
            return

        p = Process(
            target=model_worker,
            args=(
                model["model_id"],
                model["name"],
                model["model_dir"],
                model["dimensions"],
            ),
            daemon=True,
        )
        p.start()
        self.active_models[model_id] = {
            "model_id": model_id,
            "process": p,
            "model_dir": model_dir,
        }
        print(f"Model Worker started [ID={model_id}] [DIR={model_dir}] [PID={p.pid}]")

    def stop_model_process(self, model_id):
        if model_id not in self.active_models:
            return

        p = self.active_models[model_id]["process"]
        del self.active_models[model_id]
        p.terminate()
        p.join()
        print(f"Model Worker stopped [ID={model_id}]")

    def start_monitoring(self):
        def monitor_workers():
            while True:
                time.sleep(5)
                for model_id, model_info in list(self.active_models.items()):
                    if not model_info["process"].is_alive():
                        exit_code = model_info["process"].exitcode
                        if exit_code == ERROR_DIR_INVALID:
                            # we don't have to repeatedly restart the process
                            # until the user upload a proper model directory
                            print(
                                f"Model dir {model_info['model_dir']} is invalid. Make sure that it contains both .pt and .py files."
                            )
                        else:
                            print(
                                f"Model worker died [ID={model_id}] [PID={model_info['process'].pid}]. Restarting..."
                            )
                            self.stop_model_process(model_id)
                            self.start_model_process(model_id, model_info["model_dir"])

        # monitoring should happen on another thread apart from the main thread
        # because it contains a infinite loop
        monitor_thread = Thread(target=monitor_workers, daemon=True)
        monitor_thread.start()

    def start_all_model(self, model_list):
        for model in model_list:
            self.start_model_process(model)

    def cleanup(self):
        models = [key for key in self.active_models.keys()]
        for model_id in models:
            self.stop_model_process(model_id)
