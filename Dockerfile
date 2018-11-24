FROM ubuntu:16.04
USER root

RUN apt-get update && apt-get install -y \
    build-essential \
    clang \
    bison \
    flex \
    libreadline-dev \
    gawk \
    tcl-dev \
    libffi-dev \
    git \
    mercurial \
    graphviz \
    xdot \
    pkg-config \
    python3 \
    python-setuptools \
    python-dev \
    autoconf \
    gperf \
    libgmp-dev \
    libboost-program-options-dev \
    libftdi-dev

RUN easy_install pip

RUN git clone https://github.com/cliffordwolf/yosys.git /yosys
RUN git clone https://github.com/cliffordwolf/SymbiYosys.git /SymbiYosys
RUN git clone https://github.com/Z3Prover/z3.git /z3
RUN git clone https://github.com/SRI-CSL/yices2.git /yices2

WORKDIR /yosys
RUN make install

WORKDIR /SymbiYosys
RUN make install

WORKDIR /z3
RUN python scripts/mk_make.py
WORKDIR /z3/build
RUN make install

WORKDIR /yices2
RUN autoconf
RUN ./configure
RUN make
RUN make install

WORKDIR /sby
