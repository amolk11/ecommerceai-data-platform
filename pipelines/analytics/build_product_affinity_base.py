from pipelines.base_pipeline import SQLPipeline

from utils.paths import ANALYTICS_SQL_DIR


pipeline = SQLPipeline(
    pipeline_name="build_product_affinity_base",
    log_folder="analytics",
    sql_file=ANALYTICS_SQL_DIR /
             "product_affinity_base.sql"
)
if __name__ == "__main__": 
    pipeline.run()
