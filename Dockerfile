FROM continuumio/miniconda3:4.7.10

LABEL "repository"="https://github.com/m0nhawk/conda-package-publish-action"
LABEL "maintainer"="Andrew Prokhorenkov <andrew.prokhorenkov@gmail.com>"

RUN conda install -y anaconda-client conda-build
RUN apt-get --allow-releaseinfo-change update
RUN apt-get install -y build-essential --fix-missing
RUN apt install -y libgl1-mesa-glx
RUN apt-get install -y -qq libegl1-mesa libegl1-mesa-dev   

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
