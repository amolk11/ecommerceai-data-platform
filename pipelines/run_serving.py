from pipelines.serving.build_product_recommendations import pipeline as product_recommendations_pipeline
from pipelines.serving.build_top_product_recommendations import pipeline as top_product_recommendations_pipeline
from pipelines.serving.build_product_intelligence import pipeline as product_intelligence_pipeline

from pipelines.serving.build_customer_profile import pipeline as customer_profile_pipeline
from pipelines.serving.build_customer_favorite_products import pipeline as customer_favorite_products_pipeline
from pipelines.serving.build_customer_favorite_departments import pipeline as customer_favorite_departments_pipeline
from pipelines.serving.build_customer_favorite_aisles import pipeline as customer_favorite_aisles_pipeline

from utils.logger import get_logger


logger = get_logger(log_name="run_serving", log_folder="pipelines")


def run():

    logger.info("Starting Serving Layer")
    
    logger.info("Building customer_profile")
    customer_profile_pipeline.run()
    
    logger.info("Building customer_favorite_products")
    customer_favorite_products_pipeline.run()
    
    logger.info("Building customer_favorite_departments")
    customer_favorite_departments_pipeline.run()
    
    logger.info("Building customer_favorite_aisles")
    customer_favorite_aisles_pipeline.run()

    logger.info("Building product_recommendations")
    product_recommendations_pipeline.run()

    logger.info("Building top_product_recommendations")
    top_product_recommendations_pipeline.run()

    logger.info("Building product_intelligence")
    product_intelligence_pipeline.run()

    logger.info("Serving Layer Completed")


if __name__ == "__main__":
    run()
    