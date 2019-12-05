FROM quanted/py-gdal
ENV PATH /root/anaconda3/bin:$PATH

# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats

# Add requirements file before install requirements
COPY requirements_qed/requirements.txt ./requirements.txt
COPY static_requirements.txt ./static_requirements.txt

RUN pip install 'fsspec>=0.3.3'

# Install requirements, including nose2
RUN pip install -r requirements.txt
RUN python --version
