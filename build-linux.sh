set -e
export GMP_V=`cat gmp.ver`
export Z3_V=`cat z3.ver`
export PLATFORM_L=`cat platform.l`
export DESC=`cat desc`
rm -fR gmp.ver z3.ver platform.l desc
if [[ $DESC == *-gmp ]]; then
  USE_GMP=--gmp
  curl -sJLO https://ftp.gnu.org/gnu/gmp/gmp-$GMP_V.tar.xz
  tar xf gmp-$GMP_V.tar.xz
  cd gmp-$GMP_V
  ./configure --disable-shared
  make -j4
  make install
  cd ..
  rm -fR gmp-$GMP_V gmp-$GMP_V.tar.xz
else
  USE_GMP=""
fi
curl -sJLO https://github.com/Z3Prover/z3/archive/refs/tags/z3-$Z3_V.tar.gz
tar xf z3-z3-$Z3_V.tar.gz
cd z3-z3-$Z3_V
python3 scripts/mk_make.py --staticbin --optimize $USE_GMP
cd build
make -j4
ldd z3 || true
mkdir -p ../../z3/bin
cp z3 ../../z3/bin/
cp ../LICENSE.txt ../../z3/
cd ../..
zip -r z3-$DESC-$Z3_V-$PLATFORM_L.zip z3
rm -fR z3-z3-$Z3_V z3-z3-$Z3_V.zip z3