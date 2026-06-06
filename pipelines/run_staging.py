from pipelines.staging.build_order_items import pipeline as order_items_pipeline

from utils.logger import get_logger


logger = get_logger(
    log_name="run_staging",
    log_folder="pipelines"
)


def run():

    logger.info("Starting Staging Layer")

    order_items_pipeline.run()

    logger.info("Staging Layer Completed")


if __name__ == "__main__":
    run()
    