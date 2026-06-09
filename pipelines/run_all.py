from utils.logger import get_logger

from pipelines.run_raw import run as run_raw
from pipelines.run_staging import run as run_staging
from pipelines.run_features import run as run_features
from pipelines.run_analytics import run as run_analytics


logger = get_logger(
    log_name="run_all",
    log_folder="pipelines"
)


def run():

    logger.info("Starting CommerceAI Pipeline")
    
    run_raw()

    run_staging()

    run_features()

    run_analytics()

    logger.info("CommerceAI Pipeline Completed")


if __name__ == "__main__":
    run()
    