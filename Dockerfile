FROM jupyter/base-notebook:python-3.8.5

# Change to root to install packages
USER root

RUN apt-get update

RUN apt-get install -y unzip

# jupyter/base-notebook's default user is jovyan
# See https://github.com/jupyter/docker-stacks/issues/358
USER jovyan

RUN pip install auditok pympi-ling matplotlib

WORKDIR /home/jovyan/work
