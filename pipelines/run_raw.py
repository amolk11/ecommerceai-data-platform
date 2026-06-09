from pipelines.raw.load_raw_data import run as load_raw_data
from utils.sql_file_reader import read_sql_file
from utils.sql_runner import execute_sql
from utils.paths import SQL_DIR
from utils.logger import get_logger


logger = get_logger(log_name="run_raw", log_folder="pipelines")


RAW_SQL_DIR = SQL_DIR / "raw"


def run() -> None:
    logger.info("Starting Raw Layer")

    logger.info("Creating raw schema and tables")
    execute_sql(read_sql_file(RAW_SQL_DIR / "create_raw_schema.sql"))

    logger.info("Loading raw CSV files")
    load_raw_data()

    logger.info("Creating raw indexes")
    execute_sql(read_sql_file(RAW_SQL_DIR / "create_raw_indexes.sql"))

    logger.info("Raw Layer Completed")


if __name__ == "__main__":
    run()