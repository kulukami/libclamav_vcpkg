vcpkg install `
curl[openssl]:x64-windows-static `
json-c:x64-windows-static `
libxml2:x64-windows-static `
pcre2:x64-windows-static `
pthreads:x64-windows-static `
zlib:x64-windows-static `
pdcurses:x64-windows-static  `
bzip2:x64-windows-static `
check:x64-windows-static


$VCPKG_PATH="C:\vcpkg"
$VCPKG_INSTALL_PATH="C:\vcpkg\installed\x64-windows-static\"

$env:VCPKG_DEFAULT_TRIPLET="x64-windows-static"

$env:VCPKGRS_DYNAMIC=0

git clone https://github.com/kulukami/clamav -b rel/0.104

cd clamav
mkdir build_x64
cd build_x64
cmake .. -A x64 `
  -D CMAKE_TOOLCHAIN_FILE="$VCPKG_PATH\scripts\buildsystems\vcpkg.cmake" `
  -D VCPKG_TARGET_TRIPLET="x64-windows-static"                           `
  -D CMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded                            `
  -D ENABLE_TESTS=OFF                                                    `
  -D ENABLE_STATIC_LIB=ON                                                `
  -D ENABLE_LIBCLAMAV_ONLY=ON                                            `
  -D ENABLE_SYSTEMD=OFF                                                  `
  -D ENABLE_SHARED_LIB=OFF                                               `
  -D BYTECODE_RUNTIME=none                                               `
  -D ENABLE_UNRAR=ON                                                     `
  -D ENABLE_FUZZ=OFF                                                     `
  -D ENABLE_APP=OFF                                                      `
  -D ENABLE_CLAMONACC=OFF                                                `
  -D ENABLE_MILTER=OFF                                                   `
  -D ENABLE_MAN_PAGES=OFF                                                `
  -D CMAKE_INSTALL_PREFIX="install"


cmake --build . --config Release --target install -j5


cd ../..
mkdir libclamav_vcpkg_x64
cp clamav\build_x64\libclamav\Release\libclamav_static.lib .\libclamav_vcpkg_x64
cp clamav\build_x64\libclammspack\Release\libclammspack_static.lib .\libclamav_vcpkg_x64
cp clamav\build_x64\libclamunrar\Release\libclamunrar_static.lib .\libclamav_vcpkg_x64
cp clamav\build_x64\libclamunrar_iface\Release\libclamunrar_iface_static.lib .\libclamav_vcpkg_x64
cp clamav\build_x64\win32\compat\Release\libwin32_compat.lib .\libclamav_vcpkg_x64

mkdir lib_static_vcpkg_x64

cp clamav\build_x64\install\*.dll .\lib_static_vcpkg_x64
cp clamav\build_x64\install\*.lib .\lib_static_vcpkg_x64
cp $VCPKG_INSTALL_PATH\lib\*.lib .\lib_static_vcpkg_x64

mkdir include_x64 
cp clamav\libclamav\clamav.h .\include_x64
cp clamav\libclamav\matcher.h .\include_x64
cp clamav\libclamav\matcher-ac.h .\include_x64
cp clamav\libclamav\others.h .\include_x64
cp clamav\build_x64\install\include\*.h .\include_x64
cp -r C:\vcpkg\installed\x64-windows-static\include\* .\include_x64

mkdir output
mv include_x64 output
mv lib_static_vcpkg_x64 output
mv libclamav_vcpkg_x64 output