FROM python:3.12-slim

ARG USERNAME=akcit

ENV HOME=/home/${USERNAME} \
    DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR ${HOME}

RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    nano \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Instala o uv direto no PATH do sistema
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

ENV PATH="$HOME/.local/bin:$PATH"

COPY requirements.txt .

RUN uv pip install -r requirements.txt --system

RUN rm requirements.txt

RUN uv pip install --system \
    jupyterlab \
    notebook \
    ipywidgets

RUN echo 'export PS1="\[\e[1;35m\]'"$USERNAME"'@\h:\w\$ \[\e[0m\]"' >> ${HOME}/.bashrc
