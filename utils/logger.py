import logging
from pathlib import Path

from utils.paths import LOG_DIR


def get_logger(
    log_name: str,
    log_folder: str = "general"
) -> logging.Logger:

    logger_name = f"{log_folder}.{log_name}"

    logger = logging.getLogger(logger_name)

    if logger.handlers:
        return logger

    logger.setLevel(logging.INFO)
    logger.propagate = False

    formatter = logging.Formatter(
        "%(asctime)s | %(levelname)s | %(name)s | %(message)s"
    )

    log_dir = LOG_DIR / log_folder
    log_dir.mkdir(
        parents=True,
        exist_ok=True
    )

    log_file = log_dir / f"{log_name}.log"

    file_handler = logging.FileHandler(
        log_file,
        encoding="utf-8"
    )
    file_handler.setFormatter(formatter)

    console_handler = logging.StreamHandler()
    console_handler.setFormatter(formatter)

    logger.addHandler(file_handler)
    logger.addHandler(console_handler)

    return logger
