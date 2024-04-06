#!/bin/bash

source .env

FLASH_DEBUG() {
        make -C ${BUILD_DIR_DEBUG} flash_st
}

FLASH_RELEASE() {
        make -C ${BUILD_DIR_RELEASE} flash_st
}

AUTO_DETECT() {
        # Auto-detect build presence
        if [[ -f ${BUILD_DIR_DEBUG}/main.elf ]]
        then
                echo "Auto-detected '${BUILD_DIR_DEBUG}' build present."
                FLASH_DEBUG
        elif [[ -f ${BUILD_DIR_RELEASE}/main.elf ]]
        then
                echo "Auto-detected '${BUILD_DIR_RELEASE}' build present."
                FLASH_RELEASE
        else
                echo "Could not auto-detect build. ABORTING."
        fi
}

if [[ $# -lt 1 ]]
then
        echo "Auto-detecting build presence..."
        AUTO_DETECT
elif [[ "$1" == "debug" ]]
then
        echo "Flashing 'debug' build..."
        FLASH_DEBUG
elif [[ "$1" == "release" ]]
then
        echo "Flashing 'release' build..."
        FLASH_RELEASE
else
        echo "Could not recognize option to flash '$1'. Try 'debug' or 'release'."
fi
