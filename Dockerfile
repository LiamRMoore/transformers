# python 3.9
FROM docker pull huggingface/transformers-gpu:4.19

ARG YOUR_ENV="dev"

ENV YOUR_ENV=${YOUR_ENV} \
  PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  POETRY_VERSION=1.1.13

# set working directory
WORKDIR /usr/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install system dependencies 
RUN apt-get update \
  && apt-get -y install netcat gcc curl make \
  && apt-get clean

# fix aws security issues
RUN apt-get install -y --only-upgrade openssl systemd

# install poetry
RUN pip install "poetry==$POETRY_VERSION"

# cache python requirements in docker layer
COPY pyproject.toml poetry.lock*  ./

# venv for multi stage build/wheels
RUN poetry config virtualenvs.in-project true 
# install python dependencies
RUN poetry install $(test "$YOUR_ENV" == production && echo "--no-dev") --no-interaction --no-ansi
#RUN poetry lock

# move local code over
COPY . .

CMD ["/bin/bash"]
