set -e
export GMP_V=`cat gmp.ver`
export Z3_V=`cat z3.ver`
if [[ -f cosmocc.ver ]]; then
  export COSMOCC_V=`cat cosmocc.ver`
fi
export PLATFORM_L=`cat platform.l`
export DESC=`cat desc`
rm -fR gmp.ver z3.ver cosmocc.ver platform.l desc z3* gmp*
if [[ -n COSMOCC_V ]]; then
  sudo wget -O /usr/bin/ape https://cosmo.zip/pub/cosmos/bin/ape-$(uname -m).elf
  sudo chmod +x /usr/bin/ape
  sudo sh -c "echo ':APE:M::MZqFpD::/usr/bin/ape:' >/proc/sys/fs/binfmt_misc/register" || true
  sudo sh -c "echo ':APE-jart:M::jartsr::/usr/bin/ape:' >/proc/sys/fs/binfmt_misc/register" || true
  rm -fR cosmocc*
  curl -JLOs https://github.com/jart/cosmopolitan/releases/download/$COSMOCC_V/cosmocc-$COSMOCC_V.zip
  mkdir cosmocc
  cd cosmocc
  unzip -qq ../cosmocc-$COSMOCC_V.zip
  cd bin
  ln -s cosmocc cc
  ln -s cosmoc++ c++
  ln -s ar.ape ar
  cd ../..
  export PATH=`pwd`/cosmocc/bin:$PATH
  export CXX=`pwd`/cosmocc/bin/cosmoc++
  export CC=`pwd`/cosmocc/bin/cosmocc
  export AR=`pwd`/cosmocc/bin/ar.ape
fi
if [[ $DESC == *-gmp ]]; then
  USE_GMP=--gmp
  curl -sJLO https://ftp.gnu.org/gnu/gmp/gmp-$GMP_V.tar.xz
  tar xf gmp-$GMP_V.tar.xz
  cd gmp-$GMP_V
  ./configure --disable-shared ARFLAGS=
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
if [[ -n COSMOCC_V ]]; then
  mkdir build
  cd build
  cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release \
                            -DZ3_BUILD_LIBZ3_SHARED=FALSE \
                            -DZ3_USE_LIB_GMP=$USE_GMP \
                            -DZ3_SINGLE_THREADED=FALSE \
                            -DCMAKE_EXE_LINKER_FLAGS="-static" \
                            -DCMAKE_EXE_LINKER_FLAGS_RELEASE="-static" \
                            -DCMAKE_CXX_ARCHIVE_CREATE="<CMAKE_AR> rcsD <TARGET> <LINK_FLAGS> <OBJECTS>" \
                            -DCMAKE_CXX_USE_RESPONSE_FILE_FOR_OBJECTS=OFF \
                            -DZ3_ENABLE_EXAMPLE_TARGETS=FALSE \
                            -DZ3_BUILD_PYTHON_BINDINGS=FALSE \
                            -DZ3_BUILD_DOTNET_BINDINGS=FALSE \
                            -DZ3_BUILD_JAVA_BINDINGS=FALSE \
                            -DZ3_INCLUDE_GIT_DESCRIBE=FALSE \
                            -DZ3_INCLUDE_GIT_HASH=FALSE \
                            -DZ3_BUILD_DOCUMENTATION=FALSE \
                            -DZ3_BUILD_EXECUTABLE=TRUE \
                            ../
  make -j4 || true
else
  python3 scripts/mk_make.py --staticbin --staticlib --optimize $USE_GMP
  cd build
  make -j4
fi
ldd z3 || true
mkdir -p ../../z3/bin
cp z3 ../../z3/bin/z3.com
cp ../LICENSE.txt ../../z3/
cd ../..
zip -r z3-$DESC-$Z3_V-$PLATFORM_L.zip z3
rm -fR z3-z3-$Z3_V z3-z3-$Z3_V.zip z3