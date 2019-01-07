#!/bin/sh

#if [ $TRAVIS_BRANCH == 'master' ]; then
  # push new versions of compiled libraries
  cd /
  git clone https://github.com/libamtrack/web.git
  cd /web
  current_date_time="`date "+%Y%m%d_%H%M%S"`"
  git checkout -b "feature/compiled_lib/$current_date_time"

  rm -f /web/src/libat.wasm
  cp $HOME/compiled/libat.wasm /web/src/libat.wasm

  rm -f /web/src/static/js/libat.wasm 2>/dev/null || :
  cp $HOME/compiled/libat.wasm /web/src/static/js/libat.wasm

  rm -f /web/src/static/js/libat.js
  cp $HOME/compiled/libat.js /web/src/static/js/libat.js

  rm -f /web/src/static/js/libatwithoutwasm.js
  cp $HOME/compiled/libatwithoutwasm.js /web/src/static/js/libatwithoutwasm.js

  git add /src/libat.wasm
  git add /src/static/js/libat.wasm
  git add /src/static/js/libat.js
  git add /src/static/js/libatwithoutwasm.js
  git commit -m "Update compiled library"
  git push "https://marwin1991:$GH_TOKEN@github.com/libamtrack/web.git"


  # install hub tool and create pull request in web repo
  cd /
  wget https://github.com/github/hub/releases/download/v2.7.0/hub-linux-amd64-2.7.0.tgz
  tar -xzf hub-linux-amd64-2.7.0.tgz
  export GITHUB_TOKEN="$GH_TOKEN"
  chmod +x /hub-linux-amd64-2.7.0/bin/hub
  cd /web
  /hub-linux-amd64-2.7.0/bin/./hub pull-request -m "New versions of compiled libamtrack library to JavaScript with and without WebAssembly"
#fi