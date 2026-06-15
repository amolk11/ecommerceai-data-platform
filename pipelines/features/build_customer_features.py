from pipelines.base_pipeline import SQLPipeline

from utils.paths import FEATURE_SQL_DIR


pipeline = SQLPipeline(
    pipeline_name="build_customer_features",
    log_folder="features",
    sql_file=FEATURE_SQL_DIR / "customer_features.sql"
)

if __name__ == "__main__":
    pipeline.run()
