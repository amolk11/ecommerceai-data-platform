from pipelines.analytics.build_customer_department_features import pipeline as customer_department_pipeline
from pipelines.analytics.build_customer_aisle_features import pipeline as customer_aisle_pipeline

from pipelines.analytics.build_customer_business_scores import pipeline as customer_business_scores_pipeline
from pipelines.analytics.build_customer_behavior import pipeline as customer_behavior_pipeline

from pipelines.analytics.build_customer_favorite_products import pipeline as customer_favorite_products_pipeline
from pipelines.analytics.build_customer_favorite_departments import pipeline as customer_favorite_departments_pipeline
from pipelines.analytics.build_customer_favorite_aisles import pipeline as customer_favorite_aisles_pipeline
from pipelines.analytics.build_customer_shopping_preferences import pipeline as customer_shopping_preferences_pipeline

from pipelines.analytics.build_product_affinity_base import pipeline as affinity_base_pipeline
from pipelines.analytics.build_product_affinity_features import pipeline as affinity_features_pipeline
from pipelines.analytics.build_product_intelligence_base import pipeline as product_intelligence_pipeline

from pipelines.analytics.register_feature_registry import pipeline as registry_pipeline

from utils.logger import get_logger


logger = get_logger(
    log_name="run_analytics",
    log_folder="pipelines"
)


def run():

    logger.info("Starting Analytics Layer")

    # Existing Customer Analytics
    logger.info("Building customer_department_features")
    customer_department_pipeline.run()

    logger.info("Building customer_aisle_features")
    customer_aisle_pipeline.run()

    # New Customer Intelligence Analytics
    logger.info("Building customer_business_scores")
    customer_business_scores_pipeline.run()

    logger.info("Building customer_behavior")
    customer_behavior_pipeline.run()

    logger.info("Building customer_favorite_products")
    customer_favorite_products_pipeline.run()

    logger.info("Building customer_favorite_departments")
    customer_favorite_departments_pipeline.run()

    logger.info("Building customer_favorite_aisles")
    customer_favorite_aisles_pipeline.run()

    logger.info("Building customer_shopping_preferences")
    customer_shopping_preferences_pipeline.run()

    # Existing Product Analytics
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
    