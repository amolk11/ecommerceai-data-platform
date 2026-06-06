from pipelines.base_pipeline import SQLPipeline

from utils.paths import ANALYTICS_SQL_DIR


pipeline = SQLPipeline(
    pipeline_name="register_feature_registry",
    log_folder="analytics",
    sql_file=ANALYTICS_SQL_DIR /
             "feature_registry.sql"
)

if __name__ == "__main__":
    pipeline.run()
