FROM quanted/py-gdal:mc_3.1.4
ENV PATH /root/anaconda3/bin:$PATH

RUN apt update -y && \
    apt install build-essential python3-dev -y && \
    pip install -U pip

# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats

# Add requirements file before install requirements
# COPY requirements_qed/requirements.txt ./requirements.txt

RUN pip install fsspec>=0.3.3

RUN conda install -c conda-forge uwsgi

RUN cd /tmp && git clone -b dev https://github.com/quanted/requirements_qed.git && \
    pip install -r requirements_qed/requirements.txt

RUN python --version
