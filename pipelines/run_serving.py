from pipelines.serving.build_product_recommendations import pipeline as product_recommendations_pipeline
from pipelines.serving.build_top_product_recommendations import pipeline as top_product_recommendations_pipeline
from pipelines.serving.build_product_intelligence import pipeline as product_intelligence_pipeline

from utils.logger import get_logger


logger = get_logger(log_name="run_serving", log_folder="pipelines")


def run():

    logger.info("Starting Serving Layer")

    logger.info("Building product_recommendations")
    product_recommendations_pipeline.run()

    logger.info("Building top_product_recommendations")
    top_product_recommendations_pipeline.run()

    logger.info("Building product_intelligence")
    product_intelligence_pipeline.run()

    logger.info("Serving Layer Completed")


if __name__ == "__main__":
    run()
    