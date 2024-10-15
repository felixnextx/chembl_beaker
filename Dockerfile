FROM continuumio/miniconda3:latest

ENV PYTHONUNBUFFERED 1

RUN apt-get update && \
    apt-get install -y osra libopenbabel7 libpotrace0 && \
    apt-get -qq -y autoremove && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

# create the conda env and activate it
COPY environment.yml /tmp/environment.yml

RUN conda env create -n chembl-beaker -f /tmp/environment.yml
ENV PATH /opt/conda/envs/chembl-beaker/bin:$PATH

# copy beaker and config file
COPY src/chembl_beaker chembl_beaker
COPY beaker.conf beaker.conf

ENTRYPOINT [ "python", "chembl_beaker/run_beaker.py", "-p", "beaker.conf" ]