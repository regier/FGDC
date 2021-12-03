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
install_directory="$HOME/FlightGearFGDC" # Final install directory.

cp Run.sh "$install_directory"/ # Copy custom launcher options to install directory.

# Function to draw messages from the variable $message
say () {
  echo ""
  echo "####################################################"
  echo ">>>  ""$message"
  echo "####################################################"
  echo ""
}

# Compiler options
compiler_flags="-O2 -march=native -mtune=native"
export CFLAGS="$compiler_flags"
export CXXFLAGS="$compiler_flags"

# Compile function.
build () {
  make -j $(nproc)
  make install
}

# PLIB
component="PLIB"
message="Compiling and Installing ""$component" say
cd "$download_directory"/"$component"
./configure --prefix="$install_directory"
build

# OSG
component="OSG"
message="Compiling and Installing ""$component" say
cd "$compiling_directory"
mkdir -p "$component" && cd "$component"
cmake "$download_directory"/"$component" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$install_directory"
build

# SG
component="SG"
message="Compiling and Installing ""$component" say
cd "$compiling_directory"
mkdir -p "$component" && cd "$component"
cmake "$download_directory"/"$component" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$install_directory"
build

# FG
component="FG"
message="Compiling and Installing ""$component" say
cd "$compiling_directory"
mkdir -p "$component" && cd "$component"
cmake "$download_directory"/"$component" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$install_directory"
build
