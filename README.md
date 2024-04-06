# MANTIS STM32 Base Project
Base FreeRTOS Project Repo for the MANTIS CubeSat Core Software.

## Original README
See [STM32_BASE_PROJECT.md](/STM32_BASE_PROJECT.md) for the original README of the parent repo.

## Getting Started
To get started, clone the repo on a Windows (WSL), MacOS or Linux system:

```
$ git clone --recurse-submodules git@github.com:DalhousieSpaceSystemsLab/MANTIS-STM32_Base_Project.git 
```

### Running the `bootstrap.sh` script
Run the `boostrap.sh` script:

```
$ ./bootstrap.sh
```

This will primarily install [Nix](https://nix.dev/) on your machine, a prerequisite for the MANTIS DevEnv.

## Entering the DevEnv
Once Nix is installed, the MANTIS DevEnv must be entered by running `nix-shell -v` in the root of the repo. 

_This step is mandatory to ensure all required build dependencies and tooling are available_.

## Building, Flashing and Debugging
Once entered the DevEnv, you'll be in an ad-hoc shell environment with all of the build dependencies needed for the project to build.

```
[nix-shell:~/MANTIS-STM32_Base_Project]$ echo "hello"
```

You can inspect the [shell.nix](/shell.nix) file to see what dependencies are fetched.

### Building
To build the project, the `autobuild.sh` script automates just that.

```
$ ./autobuild.sh
```
Running without specifying the build type will default to the 'debug' variant.

#### Specifying the build variant
You can specify whether to build the 'debug' or the 'release' variant of the build by passing it as an argument to the script:

```
# Builds 'debug'
$ ./autobuild.sh debug

# Builds 'release'
$ ./autobuild.sh release
```

### Flashing
To flash the built project to the STM32 board, the `autoflash.sh` script makes this possible in a single step.

```
$ ./autoflash.sh
```

When no build type is specified, it will auto-detect the presence of `main.elf` in either the 'debug' or the 'release' variant build directory. 

When both are present, it will always prioritize the 'debug' build.

#### Specifying which build variant to flash
The build variant to flash can be specified by passing 'debug' or 'release' to the script.

```
# Flashes the 'debug' variant
$ ./autoflash.sh debug

# Flashes the 'release' variant
$ ./autoflash.sh release
```

Make sure that your board is plugged in and not actively engaged by the debugger.

Also, if your board is significantly different from the STM32 F411RE Nucleo, consider making significant changes to the CMakeLists.txt file and the linker script.

### Debugging
Contrary to simply flashing, debugging the project involves `openocd` to both flash and debug (single-stepping) the project on the board in real time.

While the `autodebug.sh` will not start the `openocd` daemon for you, the `autoocd.sh` will - and is necessary to be run before `autodebug.sh` can be run.

```
# First, start the openocd daemon
$ ./autoocd.sh

# In another terminal, run the debug script
$ ./autodebug.sh
```

Unlike [Building](#Building) and [Flashing](#Flashing), debugging the project must be done with the 'debug' variant of the project build. 

But just like in the case of flashing, the build must be complete before debugging is possible.

## Doing everything manually or by hand
AKA something went wrong in the automation scripts and you need a way out.

I'm a pretty solid believer in at least having the chance to see and understand how things work, whether wanted or needed, so this section simply exposes what goes on under the hood in those scripts.

### Manually building
First, CMake must be configured using the CMakeLists.txt file in the corresponding 'debug' or 'release' directory.

```
# Directory for 'debug' build
$ mkdir -p build/debug

# Directory for 'release' build
$ mkdir -p build/release
```

Navigate to the directory of the build you'd like to configure and run the corresponding CMake configuration command:

```
# Configure 'debug' build
$ cd build/debug
$ cmake ../../ -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=../../cross.cmake -DTARGET_GROUP=production -DSEMIHOSTING=0

# Configure 'release' build
$ cd build/release
$ cmake ../../ -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=../../cross.cmake -DTARGET_GROUP=production -DSEMIHOSTING=0
```

Once setup successfully, the project can be built _in either directories_ using:
```
$ make main.elf
```

### Manually starting the `openocd` daemon
The `openocd` daemon can be started by running
```
$ openocd -f board/st_nucleo_f4.cfg
```
while the board is plugged in.

This configuration is attuned to the STM32 F411RE Nucleo board. A different board may require a significantly different command.

### Manually debugging
In case of a successful 'debug' build, one can debug using
```
$ make flash
```
in the `build/debug` build directory.

This will require the board to be plugged in and for the `openocd` daemon to be running.

### Manually converting the `main.elf` to `main.bin`
Converting the `.elf` requires a complete build of either the 'debug' or the 'release' variant (refer up to `make main.elf` step).

Before the project can be flashed to the board without debugging, it must be converted to a `.bin` file. This mainly strips the `.elf` binary of unneeded sections and information.

```
$ arm-none-eabi-objcopy -O binary main.elf main.bin
```

Due to it being a one-time operation, it must be done every time `main.elf` is re-built.

### Manually flashing
Flashing the project to the board without debugging requires a complete 'debug' or 'release' variant build to be complete (refer up to `main.bin` step).

The board must be plugged in and not busied by the `openocd` daemon (shut it off).

```
$ st-flash --reset write main.bin 0x8000000
```

The memory address `0x8000000` is specific to the STM32 F411RE Nucleo board. A different board may require a significantly different value.
