FROM dbsmith88/py-gdal as gdal
FROM dbsmith88/py-geos as geos
FROM dbsmith88/py-proj4 as proj4

# from latest official python 3 docker build
# debian linux with buildpack-deps
FROM python:3 as base

# Set working directory to src to run commands
WORKDIR /src

# Set versions for GIS Packages
ENV GEOS_VERSION=3.6.2
ENV GDAL_VERSION=2.3.1
ENV PROJ4_VERSION=5.0.1

# Install GEOS
COPY --from=geos /tmp/geos-${GEOS_VERSION} /tmp/geos-${GEOS_VERSION}
RUN cd /tmp/geos-${GEOS_VERSION} \
    && make install \
    && rm -rf /tmp/geos-${GEOS_VERSION}

# Install GDAL
COPY --from=gdal /tmp/gdal-${GDAL_VERSION} /tmp/gdal-${GDAL_VERSION}
RUN cd /tmp/gdal-${GDAL_VERSION} \
    && make && make install && ldconfig \
    && apt-get update -y \
    && apt-get remove -y --purge build-essential wget \
    && cd $ROOTDIR && cd src/gdal-${GDAL_VERSION}/swig/python \
    && python3 setup.py build \
    && python3 setup.py install \
    && cd $ROOTDIR && rm -Rf src/gdal*

# Install Proj4
COPY --from=proj4 /tmp/proj-${PROJ4_VERSION} /tmp/proj-${PROJ4_VERSION}
RUN cd /tmp/proj-${PROJ4_VERSION} \
   && make install \
   && rm -rf /tmp/proj-${PROJ4_VERSION}

# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats

ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# Add requirements file before install requirements
COPY requirements_qed/requirements.txt ./requirements.txt
COPY static_requirements.txt ./static_requirements.txt

# Install requirements, including nose2
RUN pip install -r requirements.txt
RUN pip install -r static_requirements.txt
RUN python --version
