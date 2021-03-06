#/bin/bash

# ABOUT
# This script will compile the source code for PLIB, OSG, SG and FG.
#
# By default the build options will be conservative for a stable build.
# GitHub Repo: https://github.com/regier/FGDC
#
# AUTHOR
# Created by Regier Kunkel on 26/11/2021
# Contact: regier (dot) kunkel (at) gmail (dot) com
#
# LICENSE
# Licensed under GPL 3


# Main script variables.
# Change variables to download and build the Next version
# if the user chooses to do so with the "--next" argument.
if [[ "$*" =~ .*"--next".* ]]; then
  release="Next"
else
  release="Stable"
fi

fgdc_directory="$HOME/FGDC"
fgdc="$fgdc_directory"
download_directory="$fgdc/Sources" # Directory where the source codes will be downloaded to.
compiling_directory="$fgdc/Build-$release" # Directory where temp buid files will be stored.
install_directory="$fgdc/FlightGear-$release" # Final install directory.

mkdir -p "$install_directory" "$compiling_directory" "$install_directory" # Precreates directories.
cp FlightGearFGDC.desktop "Run-$release.sh" "$install_directory/" # Copy custom launcher to install directory.


# Function to draw messages from the variable $message
say () {
  length=$(expr length "$message")

  spacesize="4"
  linesize=$(expr $spacesize + $length + $spacesize)

  tput sgr0
  printf "╔"; printf "%0.s═" $(seq 1 $linesize); printf "╗\n"
  printf "║"; printf "%0.s " $(seq 1 $spacesize); tput bold; printf "$message"; tput sgr0; printf "%0.s " $(seq 1 $spacesize); printf "║\n"
  printf "╚"; printf "%0.s═" $(seq 1 $linesize); printf "╝\n"
}


fgdc_start () {
	clear

	# Compiler options. Enable core dump debug friendly options if --debug is used.
	if [[ "$*" =~ .*"--debug".* ]]; then
	  compiler_flags="-ggdb -w -march=native -O2 -mtune=native -pipe" # Set compiler flags here.
	else
	  compiler_flags="-w -march=native -O3 -mtune=native -pipe" # Set compiler flags here.
	fi

	message="Welcome to FGDC Compiler." say
    message="Will compile FlightGear $release" say
}

set_vars () {
	# Makes script cache compiler output using cmake if cmake is available.
	export PATH="/usr/lib/ccache:${PATH}"
	export CFLAGS="$compiler_flags"
	export CXXFLAGS="$compiler_flags"
}


# build function.
# This function will compile the source code for each component.
# Using the number of logical CPUs as the amount of simultaneous compile jobs.
build () {
  make -j $(nproc)
  make install
}


# cmake function.
# For OSG, SG and FG, this function will run cmake to set build options.
# So then after we can build the source code with the options we want.
cmaking () {
  message="Compiling and Installing $component" say
  rm -rf "$compiling_directory" # Deletes previous building files for a fresh build.
  mkdir -p "$compiling_directory/$component" && cd "$compiling_directory/$component" # Recreates build dirs.
  cmake "$download_directory"/"$component" -DCMAKE_CXX_FLAGS="$compiler_flags" -DCMAKE_C_FLAGS="$compiler_flags" -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG -DCMAKE_INSTALL_PREFIX="$install_directory" $cmake_flags
}


# cp fgfsrc "$HOME/.fgfsrc" # Install custom settings for a better FlightGear Experience.

# Start
fgdc_start


# Set vars
set_vars


# PLIB
component="PLIB"
message="Compiling and Installing $component" say
cd "$download_directory/$component"
./configure --prefix="$install_directory"
build


# OSG
component="OSG"
export cmake_flags="-DBUILD_OSG_APPLICATIONS=OFF -DBUILD_OSG_DEPRECATED_SERIALIZERS=OFF"
cmaking
build


# SG
component="SG"
export cmake_flags="-DENABLE_SIMD_CODE=ON -DENABLE_TESTS=OFF"
cmaking
build


# FG
component="FG"
#export cmake_flags="-DENABLE_COMPOSITOR=ON -DFG_BUILD_TYPE=Release -DBUILD_TESTING=OFF"
export cmake_flags="-DFG_BUILD_TYPE=Release -DBUILD_TESTING=OFF"
cmaking
build
