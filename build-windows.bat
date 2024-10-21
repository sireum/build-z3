@echo off
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
set errorlevel=
curl -sJLO https://github.com/Z3Prover/z3/archive/refs/tags/z3-%Z3_V%.tar.gz || goto :error
tar xf z3-z3-%Z3_V%.tar.gz || goto :error
cd z3-z3-%Z3_V%
python scripts/mk_make.py -x --staticbin --optimize --parallel=4 || goto :error
cd build
nmake || goto :error 
md ..\..\z3
md ..\..\z3\bin
copy z3.exe ..\..\z3\bin\
copy ..\LICENSE.txt ..\..\z3\
cd ..\..
tar -acf z3-%DESC%-%Z3_V%-%PLATFORM_L%.zip z3 || goto :error
del z3-z3-%Z3_V%.tar.gz || goto :error
rmdir /s/q z3 z3-z3-%Z3_V% || goto :error
goto :EOF
:error
exit /b %errorlevel%
