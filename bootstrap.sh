#!/bin/bash

WINDOWS_MAC_LINUX() {
        # Windows (WSL) / MacOS / Linux ?
        read -p "Are you running Windows (WSL), MacOS or Linux? (W/M/L): " wml

        case $wml in 
                [Ww]* ) echo "Windows (WSL) Selected. Proceeding.";
                        ;;
                [Mm]* ) echo "MacOS Selected. Proceeding.";
                        ;;
                [Ll]* ) echo "Linux Selected. Proceeding.";
                        ;;
                * )     echo "Unknown option '$wml'. Please select 'W', 'M' or 'L' (Windows (WSL), MacOS or Linux).";
                        echo "ABORTING."
                        exit;
                        ;;
        esac
}

INSTALL_NIX() {
        if [[ -z $wml ]]
        then
                WINDOWS_MAC_LINUX
        fi

        case $wml in 
                [Ww]* ) echo "Installing Nix for Windows (WSL)...";
                        curl -L https://nixos.org/nix/install | sh -s -- --no-daemon;
                        ;;
                [Mm]* ) echo "Installing Nix for MacOS...";
                        curl -L https://nixos.org/nix/install | sh
                        ;;
                [Ll]* ) echo "Installing Nix for Linux...";
                        curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
                        ;;
                * ) echo "Fatal error. Did not recognize \$wml ($wml).";
                        echo "ABORTING.";
                        exit;
                        ;;
        esac

        echo ""
        echo "If all went well, you'll need to restart the terminal you're in."
        echo "Afterwards, re-run this bootstrap script."
}

# Nix
read -p "Has Nix already been installed on your system? (Y/n): " yn

case $yn in
        [Nn]* ) echo "No installation yet. Proceeding to install.";
                INSTALL_NIX;
                exit;
                ;;
        * )     echo "Nix already installed. Proceeding.";
                ;;
esac

# Nix Shell
echo "Running 'nix-shell -v' to enter the MANTIS DevEnv..."
nix-shell -v
