FROM quanted/py-gdal:mc3.8_3.1.4
ENV PATH /root/anaconda3/bin:$PATH
ENV PYTHONPATH /opt/conda/envs/pyenv:/opt/conda:/opt/conda/bin

RUN apt update -y && \
    apt upgrade -y && \
    apt install build-essential python3 python3-dev python3-pip python3-dbg python3-llvmlite -y

# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats

SHELL ["conda", "run", "-n", "pyenv", "/bin/bash", "-c"]
RUN conda install -n pyenv -c conda-forge uwsgi
RUN conda install -n pyenv --channel=numba numba

RUN cd /tmp && git clone -b dev https://github.com/quanted/requirements_qed.git
RUN conda run -n pyenv pip3 install --force-reinstall -r /tmp/requirements_qed/requirements.txt

RUN python --version