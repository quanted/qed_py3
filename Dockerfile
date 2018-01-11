#from latest official python 3 docker build
FROM python:3

#Set working directory to src to run commands
WORKDIR /src

#Add requirements file before install requirements
COPY .requirements_qed/requirements.txt ./requirements.txt

#Install requirements, including nose2
RUN pip install -r requirements.txt
