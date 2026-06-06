from pipelines.features.build_customer_features import pipeline as customer_pipeline
from pipelines.features.build_product_features import pipeline as product_pipeline
from pipelines.features.build_order_level import pipeline as order_pipeline
from pipelines.features.build_user_product_features import pipeline as user_product_pipeline
from pipelines.features.build_department_features import pipeline as department_pipeline
from pipelines.features.build_aisle_features import pipeline as aisle_pipeline


def run():

    customer_pipeline.run()
    product_pipeline.run()
    order_pipeline.run()
    user_product_pipeline.run()
    department_pipeline.run()
    aisle_pipeline.run()


if __name__ == "__main__":
    run()
    