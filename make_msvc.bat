REM --- STANDALONE BUILD USING MSVC TOOLCHAIN ---

python setup.py build

MKDIR build\standalone
CD build\standalone

CL /EHsc /Fescattnlay.exe ..\..\src\nmie.cc ..\..\src\farfield.cc
CL /EHsc /Fenearfield.exe ..\..\src\nmie.cc ..\..\src\nearfield.cc

COPY scattnlay.exe ..\..\
COPY nearfield.exe ..\..\

CD ..\..
