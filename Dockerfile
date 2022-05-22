FROM parledoct/alpine-miniconda-jupyterlab

RUN apk add --no-cache ffmpeg parallel && \
	pip install pydub
