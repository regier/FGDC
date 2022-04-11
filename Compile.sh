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
download_directory="/tmp/FGDC/Sources" # Directory where the source codes will be downloaded to.
compiling_directory="/tmp/FGDC/Build" # Directory where temp buid files will be stored.
install_directory="$HOME/FGDC/FlightGear-Stable" # Final install directory.

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

clear
message="Welcome to FGDC Compiler." say

# Makes script cache compiler output using cmake if cmake is available.
export PATH="/usr/lib/ccache:${PATH}"

# Change variables to download and build the Next version
# if the user chooses to do so with the "--next" argument.
if [ "$*" = "--next" ]; then
  install_directory="$HOME/FGDC/FlightGear-Next" # Final install directory.
  # Precreates directories.
  mkdir -p "$install_directory" "$compiling_directory" "$install_directory"
  cp FlightGearFGDC.desktop Run-Next.sh "$install_directory"/ # Copy custom launcher to install directory.
else
  # Precreates directories.
  mkdir -p "$install_directory" "$compiling_directory" "$install_directory"
  cp FlightGearFGDC.desktop Run-Stable.sh "$install_directory"/ # Copy custom launcher to install directory.
fi

# Compiler options.
compiler_flags="-w -march=native -O2 -mtune=native -pipe" # Set compiler flags here.
export CFLAGS="$compiler_flags"
export CXXFLAGS="$compiler_flags"

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
  message="Compiling and Installing ""$component" say
  rm -rf "$compiling_directory" # Deletes previous building files for a fresh build.
  mkdir -p "$compiling_directory"/"$component" && cd "$compiling_directory"/"$component" # Recreates build dirs.
  cmake "$download_directory"/"$component" -DCMAKE_CXX_FLAGS="$compiler_flags" -DCMAKE_C_FLAGS="$compiler_flags" -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG -DCMAKE_INSTALL_PREFIX="$install_directory" $cmake_flags
}

cp fgfsrc "$HOME/.fgfsrc" # Install custom settings for a better FlightGear Experience.

# PLIB
component="PLIB"
message="Compiling and Installing ""$component" say
cd "$download_directory"/"$component"
./configure --prefix="$install_directory"
build

# OSG
component="OSG"
export cmake_flags="-DBUILD_OSG_APPLICATIONS=OFF -DBUILD_OSG_DEPRECATED_SERIALIZERS=OFF"
cmaking
build

# SG
component="SG"
export cmake_flags="-DENABLE_SIMD_CODE=ON -DENABLE_TESTS=OFF -DSIMGEAR_HEADLESS=ON"
cmaking
build

# FG
component="FG"
export cmake_flags="-DFG_BUILD_TYPE=Release -DBUILD_TESTING=OFF"
cmaking
build
