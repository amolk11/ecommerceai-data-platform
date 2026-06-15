import pandas as pd

from utils.database import engine
from utils.logger import get_logger
from utils.timer import Timer
from utils.paths import DATA_DIR

logger = get_logger(log_name="load_raw_data", log_folder="raw")


RAW_TABLES = {
    "aisles": {
        "file": DATA_DIR / "aisles.csv",
        "dtypes": {
            "aisle_id": "Int64",
            "aisle": "string",
        },
    },
    "departments": {
        "file": DATA_DIR / "departments.csv",
        "dtypes": {
            "department_id": "Int64",
            "department": "string",
        },
    },
    "orders": {
        "file": DATA_DIR / "orders.csv",
        "dtypes": {
            "order_id": "Int64",
            "user_id": "Int64",
            "eval_set": "string",
            "order_number": "Int64",
            "order_dow": "Int64",
            "order_hour_of_day": "Int64",
            "days_since_prior_order": "float64",
        },
    },
    "products": {
        "file": DATA_DIR / "products.csv",
        "dtypes": {
            "product_id": "Int64",
            "product_name": "string",
            "aisle_id": "Int64",
            "department_id": "Int64",
        },
    },
    "order_products_prior": {
        "file": DATA_DIR / "order_products__prior.csv",
        "dtypes": {
            "order_id": "Int64",
            "product_id": "Int64",
            "add_to_cart_order": "Int64",
            "reordered": "Int64",
        },
    },
    "order_products_train": {
        "file": DATA_DIR / "order_products__train.csv",
        "dtypes": {
            "order_id": "Int64",
            "product_id": "Int64",
            "add_to_cart_order": "Int64",
            "reordered": "Int64",
        },
    },
}


def load_table(table_name: str, config: dict) -> None:
    file_path = config["file"]

    if not file_path.exists():
        raise FileNotFoundError(f"Missing raw data file: {file_path}")

    logger.info(f"Loading raw.{table_name} from {file_path}")

    total_rows = 0
    first_chunk = True

    with Timer() as timer:
        for chunk in pd.read_csv(
            file_path,
            dtype=config["dtypes"],
            chunksize=1000000,
        ):
            chunk.to_sql(
                name=table_name,
                schema="raw",
                con=engine,
                if_exists="replace" if first_chunk else "append",
                index=False,
                chunksize=50000,
                method="multi",
            )

            total_rows += len(chunk)
            first_chunk = False

            logger.info(f"Loaded {total_rows} rows into raw.{table_name}")

    logger.info(
        f"Loaded raw.{table_name}: {total_rows} rows in {timer.elapsed:.2f} seconds"
    )


def run() -> None:
    logger.info("Starting Raw Data Load")

    for table_name, config in RAW_TABLES.items():
        load_table(table_name, config)

    logger.info("Raw Data Load Completed")


if __name__ == "__main__":
    run()
    