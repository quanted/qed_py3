FROM python:3.7 as master

RUN apt update -y && apt install -y --fix-missing --no-install-recommends \
    python3-pip software-properties-common build-essential ca-certificates \
    git make cmake wget unzip libtool automake curl autoconf \
    zlib1g-dev libsqlite3-dev pkg-config sqlite3 gcc g++ gfortran \
    python-dev

RUN cd /tmp && curl -O https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh && \
    bash Anaconda3-5.0.1-Linux-x86_64.sh -b && \
    rm Anaconda3-5.0.1-Linux-x86_64.sh
ENV PATH /root/anaconda3/bin:$PATH

# Updating Anaconda packages
RUN conda install -c conda-forge gdal -y && \
    conda install -c conda-forge fiona -y && \
    conda install -c conda-forge geos -y && \
    conda install -c conda-forge pyproj -y
RUN conda install -c conda-forge uwsgi -y

# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats

# Add requirements file before install requirements
COPY requirements_qed/requirements.txt ./requirements.txt
COPY static_requirements.txt ./static_requirements.txt

# Install requirements, including nose2
RUN pip install -r requirements.txt
RUN python --version
