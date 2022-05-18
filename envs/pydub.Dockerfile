FROM jupyter/base-notebook:python-3.8.5

# Change to root to install packages
USER root

RUN apt-get update && apt-get install -y ffmpeg unzip

# jupyter/base-notebook's default user is jovyan
# See https://github.com/jupyter/docker-stacks/issues/358
USER jovyan

RUN pip install pydub

WORKDIR /home/jovyan/work
