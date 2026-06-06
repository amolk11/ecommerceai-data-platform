from pipelines.base_pipeline import SQLPipeline

from utils.paths import FEATURE_SQL_DIR


pipeline = SQLPipeline(
    pipeline_name="build_order_level",
    log_folder="features",
    sql_file=FEATURE_SQL_DIR / "order_level.sql"
)

pipeline.run()
