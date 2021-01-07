# As base image it is used emscripten/emsdk
# Dockerhub link: https://hub.docker.com/r/emscripten/emsdk
FROM emscripten/emsdk

RUN apt-get update \
&&  apt-get install -y git wget

#Cmake use $ENV{HOME}/gsl-latest/gsl
ENV HOME /home/root
ENV GSL_PATH $HOME/
ENV GSL_ROOT_DIR $GSL_PATH/gsl-latest/gsl/usr
ENV GSL_INCLUDE_DIRS $GSL_ROOT_DIR/include
ENV GSL_LIBRARY $GSL_ROOT_DIR/lib/libgsl.a
ENV GSL_CBLAS_LIBRARY $GSL_ROOT_DIR/lib/libgslcblas.a
RUN mkdir -p $GSL_PATH

# using clean source files of GSL to compile it to JavaScript
# instead of debian source package
# since version 1.39.16 Emscripten cannot build shared libraries
# we can hence disable them as we need only static ones
RUN cd $GSL_PATH \
&&  wget -q "http://ftpmirror.gnu.org/gnu/gsl/gsl-latest.tar.gz" \
&&  mkdir $GSL_PATH/gsl-latest \
&&  tar -xzf gsl-latest.tar.gz -C $GSL_PATH/gsl-latest \
&&  mv $GSL_PATH/gsl-latest/** $GSL_PATH/gsl-latest/gsl \
&&  rm -r $GSL_PATH/gsl-latest.tar.gz \
&&  cd $GSL_PATH/gsl-latest/gsl/ \
&&  /bin/bash -c "emconfigure ./configure --disable-shared --prefix=$PWD/usr" \
&&  /bin/bash -c "emmake make -j2" \
&&  /bin/bash -c "emmake make install"

ARG repoUrl
ARG branch
ARG WASM

WORKDIR /
RUN git clone -b $branch $repoUrl 
RUN cp ${GSL_ROOT_DIR}/lib/libgsl.a /library/distributions/JavaScript/
RUN cp ${GSL_ROOT_DIR}/lib/libgslcblas.a /library/distributions/JavaScript/

WORKDIR /library/distributions/JavaScript/
RUN /bin/bash -c "./compile_to_js.sh $WASM"

# copy JS and WASM products outside docker filesystem
RUN cp /library/distributions/JavaScript/output/libat.js / \
&&  cp /library/distributions/JavaScript/output/libat.wasm / 2>/dev/null || : #ignore error when build with -s WASM=0 
RUN apt-get -y remove wget git file \
&&  rm -rf /library \
&&  rm -rf ${GSL_PATH}/gsl-latest/gsl/ \
&&  echo "\nDone"

WORKDIR /
