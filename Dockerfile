FROM parledoct/alpine-miniconda-jupyterlab

RUN conda install pytorch torchaudio cpuonly -c pytorch && \
    pip install speechbrain spectralcluster scikit-learn auditok pympi-ling
