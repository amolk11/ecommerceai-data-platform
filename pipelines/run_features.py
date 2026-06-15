from pipelines.features.build_customer_features import pipeline as customer_pipeline
from pipelines.features.build_product_features import pipeline as product_pipeline
from pipelines.features.build_order_level import pipeline as order_pipeline
from pipelines.features.build_user_product_features import pipeline as user_product_pipeline
from pipelines.features.build_department_features import pipeline as department_pipeline
from pipelines.features.build_aisle_features import pipeline as aisle_pipeline

from utils.logger import get_logger


logger = get_logger(log_name="run_features", log_folder="pipelines")


def run():

    logger.info("Starting Features Layer")

    logger.info("Building customer_features")
    customer_pipeline.run()

    logger.info("Building product_features")
    product_pipeline.run()

    logger.info("Building order_level")
    order_pipeline.run()

    logger.info("Building user_product_features")
    user_product_pipeline.run()

    logger.info("Building department_features")
    department_pipeline.run()

    logger.info("Building aisle_features")
    aisle_pipeline.run()

    logger.info("Features Layer Completed")


if __name__ == "__main__":
    run()
    