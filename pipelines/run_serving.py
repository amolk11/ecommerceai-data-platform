from pipelines.serving.build_product_recommendations import pipeline as product_recommendations_pipeline
from pipelines.serving.build_top_product_recommendations import pipeline as top_product_recommendations_pipeline

from utils.logger import get_logger


logger = get_logger(
    log_name="run_serving",
    log_folder="pipelines"
)


def run():

    logger.info("Starting Serving Layer")

    product_recommendations_pipeline.run()
    top_product_recommendations_pipeline.run()

    logger.info("Serving Layer Completed")


if __name__ == "__main__":
    run()
    