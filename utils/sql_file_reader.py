from pathlib import Path


def read_sql_file(sql_path: Path) -> str:
    with open(sql_path, "r", encoding="utf-8") as file:
        return file.read()