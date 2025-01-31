FROM continuumio/miniconda3:latest

LABEL "repository"="https://github.com/m0nhawk/conda-package-publish-action"
LABEL "maintainer"="Andrew Prokhorenkov <andrew.prokhorenkov@gmail.com>"

RUN conda install -y anaconda-client mamba boa -c conda-forge
RUN apt-get --allow-releaseinfo-change update
RUN apt-get install -y build-essential --fix-missing

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
