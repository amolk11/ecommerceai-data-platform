from pipelines.base_pipeline import SQLPipeline

from utils.paths import STAGING_SQL_DIR


pipeline = SQLPipeline(
    pipeline_name="build_order_items",
    log_folder="staging",
    sql_file=STAGING_SQL_DIR / "order_items.sql"
)

pipeline.run()
