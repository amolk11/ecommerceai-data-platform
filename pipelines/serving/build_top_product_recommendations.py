from pipelines.base_pipeline import SQLPipeline

from utils.paths import SERVING_SQL_DIR


pipeline = SQLPipeline(
    pipeline_name="build_top_product_recommendations",
    log_folder="serving",
    sql_file=SERVING_SQL_DIR / "top_product_recommendations.sql"
)

if __name__ == "__main__": 
    pipeline.run()
    