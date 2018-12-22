# As base image it is used trzeci/emscripten
# Dockerhub link: https://hub.docker.com/r/trzeci/emscripten/
# Dockerfile at: https://github.com/trzecieu/emscripten-docker/blob/master/docker/trzeci/emscripten/Dockerfile
# 'trzeci/emscripten' image is adviced by Emscripten's creators
# https://kripken.github.io/emscripten-site/docs/compiling/Travis.html
ARG EMSCRIPTEN_SDK=sdk-tag-1.38.21-64bit
FROM trzeci/emscripten:${EMSCRIPTEN_SDK}

RUN apt-get update \
&&  apt-get install -y git \ 
&&  apt-get install -y wget

#Cmake use $ENV{HOME}/gsl-latest/gsl
ENV HOME /home/root
ENV GSL_PATH $HOME/
RUN mkdir $GSL_PATH

# using clean source files of GSL to compile it to JavaScript
# instead of debian debian source package

RUN cd $GSL_PATH \
&&  wget "https://ftp.gnu.org/gnu/gsl/gsl-latest.tar.gz" \
&&  mkdir $GSL_PATH/gsl-latest \
&&  tar -xzf gsl-latest.tar.gz -C $GSL_PATH/gsl-latest \
&&  mv $GSL_PATH/gsl-latest/** $GSL_PATH/gsl-latest/gsl \
&&  rm -r $GSL_PATH/gsl-latest.tar.gz \
&&  cd $GSL_PATH/gsl-latest/gsl/ \
&&  /bin/bash -c "emconfigure ./configure" \
&&  /bin/bash -c "emmake make"

ARG repoUrl
ARG branch
ARG WASM

WORKDIR /
RUN git clone -b $branch $repoUrl 
RUN cp ${GSL_PATH}/gsl-latest/gsl/.libs/libgsl.a /library/distributions/JavaScript/

WORKDIR /library/distributions/JavaScript/
RUN chmod +x compile_to_js.sh \
&&  /bin/bash -c "./compile_to_js.sh $WASM" 

RUN cp /library/distributions/JavaScript/output/libat.js / \
&&  cp /library/distributions/JavaScript/output/libat.wasm / 2>/dev/null || : #ignore error when build with -s WASM=0 
RUN apt-get -y remove \
	           wget \
		       git \
&&  rm -rf /library \
&&  rm -rf ${GSL_PATH}/gsl-latest/gsl/ \
&&  echo "\nDone"

WORKDIR /
