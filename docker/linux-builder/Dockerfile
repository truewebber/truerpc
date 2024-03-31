FROM ubuntu:24.04

RUN apt-get update
RUN apt-get install -y cmake=3.28.3-1build5 git=1:2.43.0-1ubuntu5
RUN apt-get install -y libgtk-4-dev=4.14.1+ds-0ubuntu1
RUN apt-get install -y libprotobuf-dev=3.21.12-8.2 protobuf-compiler=3.21.12-8.2
RUN apt-get install -y build-essential=12.10ubuntu1 autoconf=2.71-3 libtool=2.4.7-7 pkg-config=1.8.1-2 \
    libgflags-dev=2.2.2-2 libgtest-dev=1.14.0-1 clang=1:18.0-59~exp1 libc++-dev=1:18.0-59~exp1

RUN cd / && git clone --recurse-submodules -b v1.62.1 https://github.com/grpc/grpc && \
    cd /grpc && mkdir -p cmake/build && cd cmake/build && cmake -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF ../.. && \
    make -j 4 && make install && cd / && rm -rf /grpc

RUN apt-get autoremove && apt-get autoclean
