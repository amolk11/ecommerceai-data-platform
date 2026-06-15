from pipelines.analytics.build_customer_department_features import pipeline as customer_department_pipeline
from pipelines.analytics.build_customer_aisle_features import pipeline as customer_aisle_pipeline
from pipelines.analytics.build_product_affinity_base import pipeline as affinity_base_pipeline
from pipelines.analytics.build_product_affinity_features import pipeline as affinity_features_pipeline
from pipelines.analytics.build_product_intelligence_base import pipeline as product_intelligence_pipeline
from pipelines.analytics.register_feature_registry import pipeline as registry_pipeline

from utils.logger import get_logger


logger = get_logger(log_name="run_analytics", log_folder="pipelines")


def run():

    logger.info("Starting Analytics Layer")

    logger.info("Building customer_department_features")
    customer_department_pipeline.run()

    logger.info("Building customer_aisle_features")
    customer_aisle_pipeline.run()

    logger.info("Building product_affinity_base")
    affinity_base_pipeline.run()

    logger.info("Building product_affinity_features")
    affinity_features_pipeline.run()

    logger.info("Building product_intelligence_base")
    product_intelligence_pipeline.run()

    logger.info("Updating feature registry")
    registry_pipeline.run()

    logger.info("Analytics Layer Completed")


if __name__ == "__main__":
    run()
    