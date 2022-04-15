# python 3.9
FROM huggingface/transformers-gpu:latest

ENV PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  POETRY_VERSION=1.1.13 \
  PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1 \
  HOME="/root" \
  PYTHON_VERSION=3.7.9

# install system dependencies 
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install \
  -y --no-install-recommends \
  make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
  libsqlite3-dev wget ca-certificates curl llvm libncurses5-dev xz-utils \
  tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev mecab-ipadic-utf8 \
  git \
  && apt-get clean

# set working directory
WORKDIR $HOME

# Set-up necessary Env vars for PyEnv
ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
# Install pyenv
RUN set -ex \
    && curl https://pyenv.run | bash \
    && pyenv update \
    && pyenv install $PYTHON_VERSION \
    && pyenv global $PYTHON_VERSION \
    && pyenv rehash

# install poetry
RUN pip install "poetry==$POETRY_VERSION"

# cache python requirements in docker layer
COPY pyproject.toml poetry.lock*  ./

# venv for multi stage build/wheels
RUN poetry config virtualenvs.in-project true
# install python dependencies
RUN poetry install --no-interaction --no-ansi
#RUN poetry lock

ENV NVIDIA_DRIVER_VERSION 495
ENV NVIDIA_DRIVER nvidia-driver-$NVIDIA_DRIVER_VERSION
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y $NVIDIA_DRIVER

# move local code over
COPY . .

# notebook port
EXPOSE 8888

CMD [
  "poetry",
  "run",
  "jupyter-notebook",
  "--no-browser",
  "--allow-root",
  "--ip",
  "0.0.0.0"
]
