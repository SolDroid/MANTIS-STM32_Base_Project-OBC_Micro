#!/bin/bash

source .env

BUILD_DEBUG() {
        # Create the build dir
        mkdir -p ${BUILD_DIR_DEBUG}

        # Setup CMake
        cmake . -B ${BUILD_DIR_DEBUG} -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=cross.cmake -DTARGET_GROUP=production -DSEMIHOSTING=0

        # Build main.elf
        make -C ${BUILD_DIR_DEBUG} main.elf
}

BUILD_RELEASE() {
        # Create the build dir
        mkdir -p ${BUILD_DIR_RELEASE}

        # Setup CMake
        cmake . -B ${BUILD_DIR_RELEASE} -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=../../cross.cmake -DTARGET_GROUP=production -DSEMIHOSTING=0

        # Build main.elf
        make -C ${BUILD_DIR_RELEASE} main.elf
}

if [[ $# -lt 1 ]]
then
        echo "No build type specified. Assuming 'debug'."
        BUILD_DEBUG
elif [[ "$1" == "debug" ]]
then
        echo "Specified 'debug' build."
        BUILD_DEBUG
elif [[ "$1" == "release" ]]
then
        echo "Specified 'release' build."
        BUILD_RELEASE
else
        echo "Could not recognize '$1' build. Please select from 'debug' or 'release'."
fi
