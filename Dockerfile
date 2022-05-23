#########################################################################################################
#                                                                                                       #
#                                         Base image for all tutorials                                  #
#                                                                                                       #
#########################################################################################################

## Alpine Linux + JupyterLab (interactive python) + Pympi (read/write ELAN files)
##
## Adapted from https://github.com/Docker-Hub-frolvlad/docker-alpine-miniconda3/blob/5eba3a4b61913973f6725e09a151a07491f05524/Dockerfile
FROM frolvlad/alpine-glibc:alpine-3.15_glibc-2.34 as tutorials-base

ARG CONDA_VERSION="py38_4.12.0"
ARG CONDA_MD5="9986028a26f489f99af4398eac966d36"
ARG CONDA_DIR="/opt/conda"

ENV PATH="$CONDA_DIR/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE=1

# Install conda & jupyterlab
RUN echo "**** install dev packages ****" && \
    apk add --no-cache --virtual .build-dependencies bash ca-certificates wget && \
    \
    echo "**** get Miniconda ****" && \
    mkdir -p "$CONDA_DIR" && \
    wget "http://repo.continuum.io/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh" -O miniconda.sh && \
    echo "$CONDA_MD5  miniconda.sh" | md5sum -c && \
    \
    echo "**** install Miniconda ****" && \
    bash miniconda.sh -f -b -p "$CONDA_DIR" && \
    echo "export PATH=$CONDA_DIR/bin:\$PATH" > /etc/profile.d/conda.sh && \
    \
    echo "**** setup Miniconda ****" && \
    conda update --all --yes && \
    conda config --set auto_update_conda False && \
    \
    echo "**** setup python packages ****" && \
    python3 -m pip --no-cache-dir install \
        pympi-ling \
        jupyter \
        jupyterlab && \
    jupyter serverextension enable --py jupyterlab --sys-prefix && \
    mkdir /parledoct-tutorials && \
    \
    echo "**** cleanup ****" && \
    apk del --purge .build-dependencies && \
    rm -f miniconda.sh && \
    conda clean --all --force-pkgs-dirs --yes && \
    find "$CONDA_DIR" -follow -type f \( -iname '*.a' -o -iname '*.pyc' -o -iname '*.js.map' \) -delete && \
    \
    echo "**** finalize ****" && \
    mkdir -p "$CONDA_DIR/locks" && \
    chmod 777 "$CONDA_DIR/locks"

EXPOSE 29796

CMD jupyter lab --ip=* --allow-root --port=29796 --no-browser --notebook-dir=/parledoct-tutorials

#########################################################################################################
#                                                                                                       #
#                                         Individual tutorial images                                    #
#                                                                                                       #
#########################################################################################################

## Image config for audio conversion tutorials
FROM tutorials-base AS audio-conversion

RUN apk add --no-cache ffmpeg parallel && \
    pip install pydub

## Image config for voice activity detection tutorials
FROM tutorials-base AS voice-activity-detection

RUN pip install auditok

## Image config for speaker diarisation tutorials
FROM tutorials-base AS speaker-diarisation

RUN conda install pytorch torchaudio cpuonly -c pytorch && \
    pip install speechbrain spectralcluster scikit-learn auditok
