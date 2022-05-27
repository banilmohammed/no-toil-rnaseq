FROM ubuntu:14.04

RUN apt-get update && apt-get install -y \
	python \
	python-pip \
	python-dev \
	build-essential \
	wget \
	perl-doc \
 	cython \
	zlib1g-dev \
	libncurses-dev

# install cutadapt 1.9
WORKDIR /tmp
RUN wget https://github.com/marcelm/cutadapt/archive/refs/tags/v1.9.tar.gz
RUN tar -xzf v1.9.tar.gz
WORKDIR /tmp/cutadapt-1.9
RUN python setup.py install
RUN python setup.py build_ext -i

# install STAR 2.4.2a
WORKDIR /tmp
RUN wget https://github.com/alexdobin/STAR/archive/refs/tags/STAR_2.4.2a.tar.gz
RUN tar -xzf STAR_2.4.2a.tar.gz
WORKDIR /tmp/STAR-STAR_2.4.2a/source
RUN make STAR
RUN mv STAR /usr/local/bin

# install RSEM 1.2.25
WORKDIR /opt
RUN wget https://github.com/deweylab/RSEM/archive/refs/tags/v1.2.25.tar.gz
RUN tar -xzf v1.2.25.tar.gz
WORKDIR /opt/RSEM-1.2.25
RUN make
ENV PATH /opt/RSEM-1.2.25:$PATH

# copy over run script and set workdir
RUN mkdir /opt/rna_seq
WORKDIR /opt/rna_seq
COPY wrapper.sh /opt/rna_seq/

ENTRYPOINT ["/bin/bash", "/opt/rna_seq/wrapper.sh"]
