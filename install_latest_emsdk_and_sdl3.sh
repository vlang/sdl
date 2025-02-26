#!/usr/bin/env bash

unalias -a
shopt -s expand_aliases
alias notrace='{ set +x; } 2>/dev/null; resetx_after'
function resetx_after() { "$@"; set -x; }
function ilog() { echo "$(tput bold; tput setaf 4; tput setab 3)## $1$(tput sgr0)"; }
set -x

pushd $PWD

notrace ilog 'Cleanup potential remains from previous runs:'
rm -rf ~/code/emsdk/
rm -rf ~/code/SDL3-3.2.4/

notrace ilog 'Install latest emsdk in ~/code/emsdk:'
git clone https://github.com/emscripten-core/emsdk ~/code/emsdk
cd ~/code/emsdk
notrace ilog 'The command below will download ~350MB, that will expand to ~1.4GB'
./emsdk install latest
./emsdk activate latest

notrace ilog 'Check that emsdk works, and can find its parts:'
source ~/code/emsdk/emsdk_env.sh
notrace ilog 'The command below should show something like "emcc (Emscripten gcc/clang-like replacement + linker emulating GNU ld) 4.0.4"'
emcc --version
notrace ilog 'The command below should show something like "EMSDK=~/code/emsdk"'
env|grep EMSDK

notrace ilog 'Download an archive of SDL3-3.2.4'
wget https://github.com/libsdl-org/SDL/releases/download/release-3.2.4/SDL3-3.2.4.tar.gz
notrace ilog 'Extract it to ~/code/SDL3-3.2.4 ...'
tar -xf SDL3-3.2.4.tar.gz
mv SDL3-3.2.4 ~/code/SDL3-3.2.4
rm -rf SDL3-3.2.4.tar.gz
notrace ilog 'Build it for emscripten ...'
mkdir -p ~/code/SDL3-3.2.4/emscripten_build/
cd ~/code/SDL3-3.2.4/emscripten_build/
emcmake cmake ..
notrace ilog 'Install the static libSDL3.a library, the .pc file,'
notrace ilog 'and the headers to an emcc specific location,'
notrace ilog 'where later V and emcc can find them'
emmake make install

notrace ilog 'Make sure, that V and the vlang/sdl wrapper, can find the newly build SDL3 static library and headers:'
export PKG_CONFIG_PATH_DEFAULTS=$EMSDK/upstream/emscripten/cache/sysroot/lib/pkgconfig

notrace ilog 'Check that the vlang/sdl examples work, by compiling it with V and emcc:'
cd ~
TEXTURES_EXAMPLE=~/.vmodules/sdl/examples/ports/renderer/06-textures
v -os wasm32_emscripten $TEXTURES_EXAMPLE/textures.v -o $TEXTURES_EXAMPLE/index.html

notrace ilog 'The command below should show a newly generated "index.html", "index.js" and "index.wasm" files:'
ls -la $TEXTURES_EXAMPLE

notrace ilog 'Your browser should now show 3 SDL logos:'
emrun $TEXTURES_EXAMPLE/index.html

notrace ilog ''
notrace ilog 'If everything worked so far, and you saw the 3 logos,'
notrace ilog 'you can add these lines to your ~/.bashrc or ~/.profile file:'
notrace ilog '    source ~/code/emsdk/emsdk_env.sh'
notrace ilog '    export PKG_CONFIG_PATH_DEFAULTS=$EMSDK/upstream/emscripten/cache/sysroot/lib/pkgconfig'

popd

notrace ilog 'Have fun using V and SDL3 :-) .'
