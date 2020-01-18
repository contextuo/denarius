FROM ubuntu:16.04 as builder

LABEL author="buzzkillb"

RUN apt-get update && apt-get install -y \
    git \
    wget \
    unzip \
    automake \
    build-essential \
    libssl-dev \
    libdb++-dev \
    libboost-all-dev \
    libqrencode-dev \
    libminiupnpc-dev \
    libevent-dev \
    autogen \
    automake \
    libtool \
    make \
    && rm -rf /var/lib/apt/lists/*
    
RUN git clone https://github.com/carsenk/denarius && \
    cd denarius && \
    git checkout v3.4 && \
    cd src && \
    make -f makefile.unix

# final image
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \	
    automake \	
    build-essential \
    libssl-dev \
    libdb++-dev \	
    libboost-all-dev \	
    libqrencode-dev \	
    libminiupnpc-dev \	
    libevent-dev \	
    libtool \	
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /data

VOLUME ["/data"]

COPY --from=builder /denarius/src/denariusd /usr/local/bin/

EXPOSE 9089 9999 33369

ENTRYPOINT ["denariusd", "--datadir=/data", "--printtoconsole"]
