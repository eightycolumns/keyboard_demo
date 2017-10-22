FROM debian:9

RUN apt-get update && apt-get -y install \
    csound=1:6.08.0~dfsg-1 \
    make \
    samplerate-programs

RUN useradd -m csound
