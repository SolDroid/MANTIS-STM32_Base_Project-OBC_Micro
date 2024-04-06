let 
        nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
        pkgs = import nixpkgs { config = {}; overlays = []; };
in
        pkgs.mkShellNoCC {
                packages = with pkgs; [
                        gcc-arm-embedded
                        stlink
                        cmake
                        openocd
                        vim
                ];

                GREETING = ''
                Entering MANTIS DevEnv 1.0.0 You should have everything you need to build and launch our code :-) Good luck!
                '';

                shellHook = ''
                        echo ""
                        echo $GREETING
                '';
        }
