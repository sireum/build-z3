set -e
curl -sJLO https://github.com/Z3Prover/z3/archive/refs/tags/z3-$Z3_V.tar.gz
tar xf z3-z3-$Z3_V.tar.gz
cd z3-z3-$Z3_V
python3 scripts/mk_make.py --optimize
cd build
make -j4
otool -L z3
mkdir -p ../../z3/bin
cp z3 ../../z3/bin/
cp ../LICENSE.txt ../../z3/
cd ../..
tar -acf z3-$DESC-$Z3_V-$PLATFORM_L.zip z3
rm -fR z3-z3-$Z3_V z3-z3-$Z3_V.zip z3