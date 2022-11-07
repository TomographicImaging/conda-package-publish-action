FROM continuumio/miniconda3:4.7.10

LABEL "repository"="https://github.com/m0nhawk/conda-package-publish-action"
LABEL "maintainer"="Andrew Prokhorenkov <andrew.prokhorenkov@gmail.com>"

RUN conda install -y anaconda-client mamba boa -c conda-forge
RUN apt-get --allow-releaseinfo-change update
RUN apt-get install -y build-essential --fix-missing
RUN conda config --describe channel_priority
RUN conda config --set channel_priority strict
RUN conda config --describe channel_priority

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
