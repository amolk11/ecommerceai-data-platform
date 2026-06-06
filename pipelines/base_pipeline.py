from utils.logger import get_logger
from utils.sql_file_reader import read_sql_file
from utils.sql_runner import execute_sql
from utils.timer import Timer


class SQLPipeline:

    def __init__(self, pipeline_name: str, log_folder: str, sql_file: str):
        self.pipeline_name = pipeline_name
        self.logger = get_logger(pipeline_name, log_folder)
        self.sql_file = sql_file

    def run(self):

        self.logger.info(f"Starting pipeline: {self.pipeline_name}")

        try:
            sql = read_sql_file(self.sql_file)

            with Timer() as timer:
                execute_sql(sql)

            self.logger.info(f"Completed in {timer.elapsed:.2f} seconds")

        except Exception:
            self.logger.exception(f"Pipeline failed: {self.pipeline_name}")
            raise