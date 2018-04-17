#from latest official python 3 docker build
FROM python:3

#Set working directory to src to run commands
#WORKDIR /src

ENV GDAL_VERSION=2.2.1

# Install GDAL
RUN wget http://download.osgeo.org/gdal/$GDAL_VERSION/gdal-${GDAL_VERSION}.tar.gz -O /tmp/gdal-${GDAL_VERSION}.tar.gz && tar -x -f /tmp/gdal-${GDAL_VERSION}.tar.gz -C /tmp

RUN cd /tmp/gdal-${GDAL_VERSION} && \
    ./configure \
        --prefix=/usr \
        --with-python \
        --with-geos \
        --with-sfcgal \
        --with-geotiff \
        --with-jpeg \
        --with-png \
        --with-expat \
        --with-libkml \
        --with-openjpeg \
        --with-pg \
        --with-curl \
        --with-spatialite && \
    make -j $(nproc) && make install

RUN rm /tmp/gdal-${GDAL_VERSION} -rf

#Add requirements file before install requirements
COPY requirements_qed/requirements.txt ./requirements.txt
#COPY requirements.txt ./requirements.txt

#Install requirements, including nose2
RUN pip install -r requirements.txt
