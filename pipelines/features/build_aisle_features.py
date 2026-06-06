from pipelines.base_pipeline import SQLPipeline

from utils.paths import FEATURE_SQL_DIR


pipeline = SQLPipeline(
    pipeline_name="build_aisle_features",
    log_folder="features",
    sql_file=FEATURE_SQL_DIR / "aisle_features.sql"
)

pipeline.run()
