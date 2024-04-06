#!/bin/bash

source .env

DEBUG() {
        make -C ${BUILD_DIR_DEBUG} flash
}

# Auto-detect build presence
if [[ -f ${BUILD_DIR_DEBUG}/main.elf ]]
then
        echo "Auto-detected '${BUILD_DIR_DEBUG}' build present."

        read -p "Have you started an OpenOCD instance? (Y/n): " yn

        case $yn in 
                [Yy]* ) echo "OK. Proceeding...";
                        ;;
                [Nn]* ) echo "You'll need to start en OpenOCD instance before you can debug.";
                        echo "Hint: You can use the 'autoocd.sh' script to do that in another shell ;-)";
                        exit;
                        ;;
                * )     echo "Please enter 'Y/n'"; 
                        exit;
                        ;;
        esac

        DEBUG
else
        echo "Could not auto-detect 'debug' build. ABORTING."
fi
