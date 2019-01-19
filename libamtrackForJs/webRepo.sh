#!/bin/sh

# push new versions of compiled libraries
cd $HOME
git clone https://github.com/libamtrack/web.git
cd $HOME/web
current_date_time="`date "+%Y%m%d_%H%M%S"`"
git checkout -b "feature/compiled_lib/$current_date_time"

rm -f $HOME/web/src/libat.wasm
cp $HOME/compiled/libat.wasm $HOME/web/src/libat.wasm

rm -f $HOME/web/src/static/js/libat.wasm 2>/dev/null || :
cp $HOME/compiled/libat.wasm $HOME/web/src/static/js/libat.wasm

rm -f $HOME/web/src/static/js/libat.js
cp $HOME/compiled/libat.js $HOME/web/src/static/js/libat.js

rm -f $HOME/web/src/static/js/libatwithoutwasm.js
cp $HOME/compiled/libatwithoutwasm.js $HOME/web/src/static/js/libatwithoutwasm.js

git add ./src/libat.wasm
git add ./src/static/js/libat.wasm
git add ./src/static/js/libat.js
git add ./src/static/js/libatwithoutwasm.js
git commit -m "Update compiled library"
git push "https://marwin1991:$GH_TOKEN@github.com/libamtrack/web.git"


# install hub tool and create pull request in web repo
cd $HOME
HUB_RELEASE=2.7.1
wget https://github.com/github/hub/releases/download/v$HUB_RELEASE/hub-linux-amd64-$HUB_RELEASE.tgz
tar -xzf hub-linux-amd64-$HUB_RELEASE.tgz
chmod +x $HOME/hub-linux-amd64-$HUB_RELEASE/bin/hub
cd $HOME/web
$HOME/hub-linux-amd64-$HUB_RELEASE/bin/hub pull-request -m "New versions of libamtrack library compiled to JavaScript with and without WebAssembly"
