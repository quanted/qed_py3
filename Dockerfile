FROM dbsmith88/py-gdal:dev as gdal
FROM dbsmith88/py-geos as geos
FROM dbsmith88/py-proj4 as proj4

# from latest official python 3 docker build
# debian linux with buildpack-deps
FROM python:3 as base

# Set working directory to src to run commands
WORKDIR /src

# Set versions for GIS Packages
ENV GEOS_VERSION 3.7.0
ENV GDAL_VERSION 2.3.2
ENV PROJ4_VERSION 5.2.0

# Install GEOS
COPY --from=geos /tmp/geos-${GEOS_VERSION} /tmp/geos-${GEOS_VERSION}
RUN cd /tmp/geos-${GEOS_VERSION} \
    && make install \
    && rm -rf /tmp/geos-${GEOS_VERSION}

# Install GDAL
COPY --from=gdal /tmp/gdal-${GDAL_VERSION} /tmp/gdal-${GDAL_VERSION}
RUN cd /tmp/gdal-${GDAL_VERSION} \
    && make install && ldconfig \
    && apt-get update -y \
#    && apt-get remove -y --purge build-essential wget \
    && cd /tmp/gdal-${GDAL_VERSION}/swig/python \
#    && python3 setup.py build \
#    && python3 setup.py install \
    && rm -Rf /tmp/gdal*

# Install Proj4
COPY --from=proj4 /tmp/proj-${PROJ4_VERSION} /tmp/proj-${PROJ4_VERSION}
RUN cd /tmp/proj-${PROJ4_VERSION} \
   && make install \
   && rm -rf /tmp/proj-${PROJ4_VERSION}

# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats

ENV CPLUS_INCLUDE_PATH /usr/include/gdal
ENV C_INCLUDE_PATH /usr/include/gdal
ENV PROJ_DIR /lib/

RUN apt install build-essential -y && apt install python-dev -y && apt update -y \
    && python -m pip install --upgrade pip setuptools wheel

# Temporary direct install of pyproj due to error using pip for Python 3.7
RUN pip install cython && pip install pyproj
# RUN pip install cython && pip install git+https://github.com/jswhit/pyproj.git#egg=pyproj
# Direct install of celery from github master branch, support for Python 3.7 not expected in pip package until celery 5
# RUN pip install git+https://github.com/celery/celery.git#egg=celery

# Add requirements file before install requirements
COPY requirements_qed/requirements.txt ./requirements.txt
COPY static_requirements.txt ./static_requirements.txt

# Install requirements, including nose2
RUN pip install -r requirements.txt
RUN pip install -r static_requirements.txt
RUN python --version
