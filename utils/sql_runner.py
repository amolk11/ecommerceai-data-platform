from sqlalchemy import text

from utils.database import engine


def execute_sql(sql_text: str):

    with engine.begin() as conn:
        conn.execute(text(sql_text))
        