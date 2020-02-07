FROM quanted/py-gdal:latest
ENV PATH /root/anaconda3/bin:$PATH

RUN apt update -y && pip install -U pip

# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats

# Add requirements file before install requirements
COPY requirements_qed/requirements.txt ./requirements.txt

RUN conda install fsspec>=0.3.3 -c conda-forge

# Install requirements, including nose2
#RUN pip install -r requirements.txt --ignore-installed
RUN conda config --append channels conda-forge && \
    conda config --set channel_priority false && \
    conda config --set allow_conda_downgrades true && \
    conda install --name base --file requirements.txt -c conda-forge
RUN python --version
