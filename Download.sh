#/bin/bash

# ABOUT
# This script will download the source code for PLIB, OSG, SG and FG.
# The source code will be downloaded from their SVG and Git repos.
# By default the latest stable release will be used.
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

clear # Clear screen.

# Function to draw messages from the variable $message
say () {
  echo ""
  echo "####################################################"
  echo ">>>  ""$message"
  echo "####################################################"
  echo ""
}

# Function to clone the required components.
git_clone () {
  message="Downloading ""$component" say
  git clone --depth=1 --single-branch -b "$branch" "$repo" "$component"
}

# Creates required directories.
# Creates download dir.
message="Creating ""$download_directory" say
mkdir -p "$download_directory"

# Creates building dir.
message="Creating ""$compiling_directory" say
mkdir -p "$compiling_directory"

# Creates install dir.
message="Creating ""$install_directory" say
mkdir -p "$install_directory"

# Enters download dir where sources will be downloaded to.
message="Switching to ""$download_directory"" directory." say
cd "$download_directory"

# PLIB
plib_file="plib-1.8.5" # PLIB filename/version
message="Downloading PLIB" say
curl "http://plib.sourceforge.net/dist/"$plib_file".tar.gz" -O # Downloads PLIB from SF.
message="Extracting PLIB" say
tar zxf "$download_directory"/""$plib_file".tar.gz" # Extracts PLIB
rm -rf PLIB # Deletes previously extract PLIB if exists.
mv "$plib_file" PLIB # Renames extracted dir to PLIB, easier to use at later stage.
rm "$plib_file"".tar.gz" # Deletes compacted PLIB.

# OpenSceneGraph
repo="https://github.com/openscenegraph/OpenSceneGraph.git" # Repository.
branch="OpenSceneGraph-3.6" # Branch to use.
component="OSG" # Downloading OSG, SG or FG.
rm -rf "$component"
git_clone

# SimGear
repo="https://gitlab.com/flightgear/simgear.git" # Repository.
branch="release/2020.3" # Branch to use.
component="SG" # Downloading OSG, SG or FG.
rm -rf "$component"
git_clone

# FlightGear
repo="https://gitlab.com/flightgear/flightgear.git" # Repository.
branch="release/2020.3" # Branch to use.
component="FG" # Downloading OSG, SG or FG.
rm -rf "$component"
git_clone
