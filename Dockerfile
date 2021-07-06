FROM quanted/py-gdal:mc3.8_3.1.4
ENV PATH /root/anaconda3/bin:$PATH

RUN apt update -y && \
    apt upgrade -y && \
    apt install build-essential python3 python3-dev python3-pip python3-dbg python3-llvmlite -y
RUN pip3 --version

# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats

# Add requirements file before install requirements
# COPY requirements_qed/requirements.txt ./requirements.txt

#RUN pip install fsspec>=0.3.3
RUN activate base
RUN conda install -c conda-forge uwsgi numpy
RUN conda install --channel=numba numba

RUN cd /tmp && git clone -b dev https://github.com/quanted/requirements_qed.git && \
    pip3 install --upgrade -r requirements_qed/requirements.txt

RUN python --version
