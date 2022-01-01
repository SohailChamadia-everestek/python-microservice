#!/usr/bin/env bash
: "${SERVICE:="datasetworker"}"

# Alembic migration script to be inserted
#yoyo apply -b --database postgresql://$DATASET_DB_USER:$DATASET_DB_PASS@$DATASET_DB_HOST:$DATASET_DB_PORT/$DATASET_DB_NAME /code/datasets/migrations

if [ "$SERVICE" == "datasetapi" ]; then
    echo "Starting dataset api"
    gunicorn -c datasets/gunicorn_config.py --worker-class gevent --workers ${DATASET_WORKERS:-3} --worker-connections ${DATASET_WORKER_CONNECTIONS:-1000} --max-requests ${DATASET_WORKER_MAX_REQUESTS:-1000} --bind "${DATASET_HTTP_HOST:-0.0.0.0}:${DATASET_HTTP_PORT:-9000}" datasets.app:application
fi

if [ "$SERVICE" == "datasetworker" ]; then
    echo "Starting dataset worker"
    dataset start
fi