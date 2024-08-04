FROM ubuntu:22.04 as base

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --allow-unauthenticated --no-install-recommends -y \
        jackd2 \
        jack-tools \
        jalv && \
    rm -rf /var/lib/apt/lists/*

FROM base as builder

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --allow-unauthenticated --no-install-recommends -y \
        build-essential \
        ca-certificates \
        ccache \
        clang \
        cmake \
        git && \
        rm -rf /var/lib/apt/lists/*

# Configure ccache
RUN cp /usr/bin/ccache /usr/local/bin
RUN ln -s ccache /usr/local/bin/gcc
RUN ln -s ccache /usr/local/bin/g++

COPY ./neural-amp-modeler-lv2 /neural-amp-modeler-lv2

# RUN \
#     git clone --recurse-submodules -j4 https://github.com/mikeoliphant/neural-amp-modeler-lv2 \
#     && cd neural-amp-modeler-lv2/build

WORKDIR /neural-amp-modeler-lv2/build
RUN --mount=type=cache,target=/root/.ccache \
    cmake .. -DCMAKE_BUILD_TYPE="Release" \
    && make -j 1
