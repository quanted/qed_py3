FROM python:3.7

RUN apt update -y && \
    apt install -y --fix-missing --no-install-recommends \
    python3-pip software-properties-common build-essential \
    cmake sqlite3 gfortran python-dev && \
    pip install -U pip

# Add requirements file before install requirements
COPY requirements_qed/requirements.txt ./requirements.txt

RUN pip install fsspec>=0.3.3
RUN pip install uWSGI

RUN pip install -r requirements.txt --ignore-installed
RUN python --version
