from pathlib import Path

# Project Root
PROJECT_ROOT = Path(__file__).resolve().parent.parent

# Data Directory
DATA_DIR = PROJECT_ROOT / "data"

# SQL Directories
SQL_DIR = PROJECT_ROOT / "sql"

RAW_SQL_DIR = SQL_DIR / "raw"
STAGING_SQL_DIR = SQL_DIR / "staging"
FEATURE_SQL_DIR = SQL_DIR / "features"
ANALYTICS_SQL_DIR = SQL_DIR / "analytics"

# Pipeline Directories
PIPELINE_DIR = PROJECT_ROOT / "pipelines"

STAGING_PIPELINE_DIR = PIPELINE_DIR / "staging"
FEATURE_PIPELINE_DIR = PIPELINE_DIR / "features"
ANALYTICS_PIPELINE_DIR = PIPELINE_DIR / "analytics"
SERVING_PIPELINE_DIR = PIPELINE_DIR / "serving"

# Documentation
DOCS_DIR = PROJECT_ROOT / "docs"

# Notebooks
NOTEBOOKS_DIR = PROJECT_ROOT / "notebooks"

# Logs
LOG_DIR = PROJECT_ROOT / "logs"

STAGING_LOG_DIR = LOG_DIR / "staging"
FEATURE_LOG_DIR = LOG_DIR / "features"
ANALYTICS_LOG_DIR = LOG_DIR / "analytics"

SERVICE_LOG_DIR = LOG_DIR / "services"
API_LOG_DIR = LOG_DIR / "api"

SERVING_SQL_DIR = SQL_DIR / "serving"

# Create Log Directories Automatically
for directory in [
    LOG_DIR,
    STAGING_LOG_DIR,
    FEATURE_LOG_DIR,
    ANALYTICS_LOG_DIR,
    SERVICE_LOG_DIR,
    API_LOG_DIR,
]:
    directory.mkdir(
        parents=True,
        exist_ok=True
    )
    