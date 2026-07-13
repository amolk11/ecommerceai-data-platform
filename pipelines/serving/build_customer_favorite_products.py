from pipelines.base_pipeline import SQLPipeline
from utils.paths import SERVING_SQL_DIR

pipeline = SQLPipeline(
    pipeline_name="build_customer_favorite_products",
    log_folder="serving",
    sql_file=SERVING_SQL_DIR / "customer_favorite_products.sql"
)

if __name__ == "__main__":
    pipeline.run()