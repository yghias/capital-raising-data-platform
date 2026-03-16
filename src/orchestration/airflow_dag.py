from __future__ import annotations

from datetime import datetime

from airflow import DAG
from airflow.operators.python import PythonOperator

from src.ingestion.api_clients import main as ingest_market_intel
from src.ml.train_forecast import main as run_forecast_training
from src.orchestration.helpers import DEFAULT_ARGS
from src.orchestration.sql_tasks import print_deployment_order, validate_sql_assets


with DAG(
    dag_id="capital_raising_intelligence_daily",
    default_args=DEFAULT_ARGS,
    description="Daily ingestion, warehouse SQL validation, and forecasting workflow for investor intelligence",
    schedule="0 6 * * *",
    start_date=datetime(2026, 1, 1),
    catchup=False,
    tags=["capital-markets", "investor-intelligence"],
) as dag:
    extract_market_data = PythonOperator(
        task_id="extract_market_data",
        python_callable=ingest_market_intel,
    )

    validate_warehouse_sql = PythonOperator(
        task_id="validate_warehouse_sql",
        python_callable=validate_sql_assets,
    )

    log_deployment_order = PythonOperator(
        task_id="log_deployment_order",
        python_callable=print_deployment_order,
    )

    train_forecast_model = PythonOperator(
        task_id="train_forecast_model",
        python_callable=run_forecast_training,
    )

    extract_market_data >> validate_warehouse_sql >> log_deployment_order >> train_forecast_model
