set -e
rm -fR Sireum z3* gmp*
if [[ $DESC == *-gmp ]]; then
  USE_GMP=--gmp
  brew install gmp  
  export INCLUDE_PATH=/opt/homebrew/include:$INCLUDE_PATH
  export C_INCLUDE_PATH=/opt/homebrew/include:$C_INCLUDE_PATH
  export CPLUS_INCLUDE_PATH=/opt/homebrew/include:$CPLUS_INCLUDE_PATH
  export LIBRARY_PATH=/opt/homebrew/lib:$LIBRARY_PATH
  export DYLD_LIBRARY_PATH=/opt/homebrew/lib:$DYLD_LIBRARY_PATH
else
  USE_GMP=""
fi
curl -sJLO https://github.com/Z3Prover/z3/archive/refs/tags/z3-$Z3_V.tar.gz
tar xf z3-z3-$Z3_V.tar.gz
cd z3-z3-$Z3_V
python3 scripts/mk_make.py --optimize $USE_GMP
cd build
make -j4
otool -L z3
mkdir -p ../../z3/bin
cp z3 ../../z3/bin/
cp ../LICENSE.txt ../../z3/
cd ../..
git clone --depth=1 https://github.com/sireum/kekinian Sireum
Sireum/bin/init.sh
export SIREUM_HOME=`pwd`/Sireum
bin/cotool.cmd z3/bin/z3
otool -L z3/bin/z3
ls -lah z3/bin
tar -acf z3-$DESC-$Z3_V-$PLATFORM_L.zip z3
rm -fR z3-z3-$Z3_V z3-z3-$Z3_V.zip z3 Sireum
