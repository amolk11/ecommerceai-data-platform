from pipelines.raw.load_raw_data import run as load_raw_data
from utils.sql_file_reader import read_sql_file
from utils.sql_runner import execute_sql
from utils.paths import RAW_SQL_DIR 
from utils.logger import get_logger


logger = get_logger(log_name="run_raw", log_folder="pipelines")


def run() -> None:
    logger.info("Starting Raw Layer")
    
    execute_sql(read_sql_file(RAW_SQL_DIR / "create_platform_schemas.sql"))
    
    logger.info("Creating raw schema and tables")
    execute_sql(read_sql_file(RAW_SQL_DIR / "create_raw_schema.sql"))

    logger.info("Loading raw CSV files")
    load_raw_data()

    logger.info("Creating raw indexes")
    execute_sql(read_sql_file(RAW_SQL_DIR / "create_raw_indexes.sql"))

    logger.info("Raw Layer Completed")


if __name__ == "__main__":
    run()
    