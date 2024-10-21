set -e
export GMP_V=`cat gmp.ver`
export Z3_V=`cat z3.ver`
export PLATFORM_L=`cat platform.l`
export DESC=`cat desc`
rm -fR gmp.ver z3.ver platform.l desc
if [[ "$DESC" == "exe-static-gmp" ]]; then
  USE_GMP=TRUE
  curl -sJLO https://ftp.gnu.org/gnu/gmp/gmp-$GMP_V.tar.xz
  tar xf gmp-$GMP_V.tar.xz
  cd gmp-$GMP_V
  ./configure --disable-shared
  make -j4
  make install
  cd ..
  rm -fR gmp-$GMP_V gmp-$GMP_V.tar.xz
else
  USE_GMP=FALSE
fi
curl -sJLO https://github.com/Z3Prover/z3/archive/refs/tags/z3-$Z3_V.tar.gz
tar xf z3-z3-$Z3_V.tar.gz
cd z3-z3-$Z3_V
mkdir build
cd build
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release \
                          -DZ3_BUILD_LIBZ3_SHARED=FALSE \
                          -DZ3_USE_LIB_GMP=$USE_GMP \
                          -DZ3_SINGLE_THREADED=FALSE \
                          -DCMAKE_EXE_LINKER_FLAGS="-static" \
                          -DCMAKE_EXE_LINKER_FLAGS_RELEASE="-static" \
                          -DZ3_ENABLE_EXAMPLE_TARGETS=FALSE \
                          -DZ3_BUILD_PYTHON_BINDINGS=FALSE \
                          -DZ3_BUILD_DOTNET_BINDINGS=FALSE \
                          -DZ3_BUILD_JAVA_BINDINGS=FALSE \
                          -DZ3_INCLUDE_GIT_DESCRIBE=FALSE \
                          -DZ3_INCLUDE_GIT_HASH=FALSE \
                          -DZ3_BUILD_DOCUMENTATION=FALSE \
                          -DZ3_ALWAYS_BUILD_DOCS=FALSE \
                          -DZ3_BUILD_EXECUTABLE=TRUE \
                          ../
make -j4
ldd z3 || true
mkdir -p ../../z3/bin
cp z3 ../../z3/bin/
cp ../LICENSE.txt ../../z3/
cd ../..
tar -acf z3-$DESC-$Z3_V-$PLATFORM_L.zip z3
rm -fR z3-z3-$Z3_V z3-z3-$Z3_V.zip z3