ARG PYTHON_VERSION=3.9
FROM python:${PYTHON_VERSION} AS base-image

RUN apt-get update -y && apt-get install -y procps vim gcc build-essential

WORKDIR /code
RUN python -m venv /service_venv

ENV PATH="/service_venv/bin:$PATH"
RUN pip install --no-cache-dir --compile --upgrade pip poetry wheel

COPY ./pyproject.toml /code/pyproject.toml
COPY ./poetry.lock /code/poetry.lock

RUN poetry config virtualenvs.create false \
    && poetry install --no-root

ARG PYTHON_VERSION=3.9
FROM python:${PYTHON_VERSION} AS debug-image

WORKDIR /code
COPY --from=base-image /service_venv /service_venv

ENV PATH="/service_venv/bin:$PATH"

COPY ./pyproject.toml /code/pyproject.toml
COPY ./poetry.lock /code/poetry.lock

COPY ./src /code/service

ARG PYTHON_VERSION=3.9
FROM python:${PYTHON_VERSION} AS build-image

LABEL version="1"

WORKDIR /code
COPY --from=base-image /service_venv /service_venv

ENV PATH="/service_venv/bin:$PATH"
COPY ./src /code/service

COPY ./pyproject.toml /code/pyproject.toml
COPY ./poetry.lock /code/poetry.lock

RUN pip install --no-cache-dir --compile /code/.

EXPOSE 9001
CMD ["/code/deployments/entrypoint.sh"]