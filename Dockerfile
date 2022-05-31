FROM parledoct/tutorials:base

ARG NB_USER=jovyan
ARG NB_UID=1000
ARG TUTORIAL=introduction

ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

WORKDIR ${HOME}

RUN wget https://github.com/parledoct/tutorials/archive/refs/heads/$TUTORIAL.zip && \
	unzip $TUTORIAL.zip -d $TUTORIAL

WORKDIR $TUTORIAL/tutorials-$TUTORIAL

ENTRYPOINT []
