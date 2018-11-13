# As base image it is used trzeci/emscripten
# Dockerhub link: https://hub.docker.com/r/trzeci/emscripten/
# Dockerfile at: https://github.com/trzecieu/emscripten-docker/blob/master/docker/trzeci/emscripten/Dockerfile
# 'trzeci/emscripten' image is adviced by Emscripten's creators
# https://kripken.github.io/emscripten-site/docs/compiling/Travis.html
ARG EMSCRIPTEN_SDK=sdk-tag-1.38.18-64bit
FROM trzeci/emscripten:${EMSCRIPTEN_SDK}

WORKDIR /emsdk_portable/
RUN emsdk install latest \
&&  emsdk activate latest

RUN apt-get update \
&&  apt-get install -y git \ 
&&  apt-get install -y wget

RUN wget "https://ftp.gnu.org/gnu/gsl/gsl-latest.tar.gz" \
&&  mkdir /gsl-latest \
&&  tar -xzvf gsl-latest.tar.gz -C /gsl-latest \
&&  mv /gsl-latest/** /gsl-latest/gsl 
WORKDIR /gsl-latest/gsl/
RUN /bin/bash -c "source /emsdk_portable/emsdk_env.sh && emconfigure ./configure" 
RUN /bin/bash -c "source /emsdk_portable/emsdk_env.sh && emmake make"

ARG repoUrl
ARG branch

WORKDIR /
RUN git clone -b $branch $repoUrl 
RUN rm /library/js/libgsl.a \
&&  rm /library/js/libgsl.so \
&&  cp /gsl-latest/gsl/.libs/libgsl.a /library/js/ \
&&  cp /gsl-latest/gsl/.libs/libgsl.so /library/js/ 

WORKDIR /library
RUN chmod +x compile_to_js.sh \
&&  /bin/bash -c "./compile_to_js.sh" 

RUN  cp /library/libat.js / \
&&  cp /library/libat.wasm / \
&&  apt-get -y remove \
        wget \
        git \
&&  apt-get -y clean \
&&  apt-get -y autoclean \
&&  apt-get -y autoremove \
&&  echo "\nDone"

WORKDIR /
