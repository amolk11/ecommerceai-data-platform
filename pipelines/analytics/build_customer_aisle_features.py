from pipelines.base_pipeline import SQLPipeline
from utils.paths import ANALYTICS_SQL_DIR

pipeline = SQLPipeline(
    pipeline_name="build_customer_aisle_features",
    log_folder="analytics",
    sql_file=ANALYTICS_SQL_DIR / "customer_aisle_features.sql"
)

if __name__ == "__main__":
    pipeline.run()
    