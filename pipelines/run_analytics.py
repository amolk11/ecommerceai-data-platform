from pipelines.analytics.build_customer_department_features import pipeline as customer_department_pipeline
from pipelines.analytics.build_customer_aisle_features import pipeline as customer_aisle_pipeline
from pipelines.analytics.build_product_affinity_base import pipeline as affinity_base_pipeline
from pipelines.analytics.build_product_affinity_features import pipeline as affinity_features_pipeline
from pipelines.analytics.register_feature_registry import pipeline as registry_pipeline


def run():

    customer_department_pipeline.run()
    customer_aisle_pipeline.run()
    affinity_base_pipeline.run()
    affinity_features_pipeline.run()
    registry_pipeline.run()


if __name__ == "__main__":
    run()
    