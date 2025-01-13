#!/bin/bash

sudo apt-get update

sudo apt-get install build-essential cmake cmake-data debhelper dbus google-mock \
    libboost-dev libboost-filesystem-dev libboost-log-dev libboost-iostreams-dev \
    libboost-program-options-dev libboost-system-dev libboost-test-dev lxc git \
    libboost-thread-dev libcap-dev libsystemd-dev libegl1-mesa-dev libsystemd-dev \
    libgles2-mesa-dev libglm-dev libgtest-dev liblxc1 \
    libproperties-cpp-dev libprotobuf-dev libsdl2-dev libsdl2-image-dev lxc-dev \
    pkg-config protobuf-compiler binutils binutils-dev python2 libgmock-dev \
    libexpat1-dev squashfs-tools libegl-dev libgles-dev -y

git -C external/cpu_features checkout v0.9.0
git -C external/sdbus-cpp checkout v2.1.0

sudo rm -rf build > /dev/null
mkdir build
cd build

cmake ..
make
sudo make install

cd ..
