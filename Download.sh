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
if [[ "$*" =~ .*"--next".* ]]; then
  release="Next"
  fg_branch="next"
else
  release="Stable"
  fg_branch="release/2020.3"
fi
fgdc_directory="$HOME/FGDC"
fgdc="$fgdc_directory"
download_directory="$fgdc/Sources" # Directory where the source codes will be downloaded to.
osg_branch="OpenSceneGraph-3.6" # OpenSceneGraph branch to use. Latest stable by default.

# Function to draw messages from the variable $message
say () {
  length=$(expr length "$message")

  spacesize="4"
  linesize=$(expr $spacesize + $length + $spacesize)

  tput sgr0
  printf "╔"; printf "%0.s═" $(seq 1 $linesize); printf "╗\n"
  printf "║"; printf "%0.s " $(seq 1 $spacesize); tput bold; printf "$message"; tput sgr0;   printf "%0.s " $(seq 1 $spacesize); printf "║\n"
  printf "╚"; printf "%0.s═" $(seq 1 $linesize); printf "╝\n"
}

clear
message="Welcome to FGDC Downloader." say
message="Will download FlightGear $release"

# Precreates directories.
mkdir -p "$download_directory"

# Function to clone the required components.
git_clone () {
  message="Checking if $component is already downloaded on branch $branch" say
  # IF condition to check if the component directory already exists in the download dir.
  # If if finds a download dir with the expected name it will then switch to the correct
  # correct branch and update it. Otherwise, it will proceed to do a clean download.
  if [ -d "$download_directory/$component" ]; then
    message="$component already downloaded. Updating it." say
    cd "$download_directory/$component" && git checkout "$branch" && git pull
  else
    message="$component was not found. Downloading it" say
    cd "$download_directory" && git clone -b "$branch" "$repo" "$component"
  fi
}

# Creates required directories.
# Creates download dir.
message="Creating $download_directory" say
mkdir -p "$download_directory"

# Enters download dir where sources will be downloaded to.
message="Switching to $download_directory directory." say
cd "$download_directory"

# PLIB
message="Downloading PLIB" say
plib_compacted="plib-1.8.5.tar.gz"
plib_extracted="plib-1.8.5"
plib_url="http://plib.sourceforge.net/dist/$plib_compacted"
cd "$download_directory"
wget -c "$plib_url" # Downloads/Resume downloads of PLIB from SF.
message="Extracting PLIB" say
tar zvxf "$plib_compacted" # Extracts PLIB
rm -rf PLIB # Deletes previously extract PLIB if exists.
message="Renaming $plib_extracted to PLIB." say
mv "$plib_extracted" PLIB # Renames extracted dir to PLIB, easier to use at later stage.

# OpenSceneGraph
repo="https://github.com/openscenegraph/OpenSceneGraph.git" # Repository.
branch="$osg_branch" # Branch to use.
component="OSG" # Downloading OSG, SG or FG.
git_clone

# SimGear
repo="https://gitlab.com/flightgear/simgear.git" # Repository.
branch="$fg_branch" # Branch to use.
component="SG" # Downloading OSG, SG or FG.
git_clone

# FlightGear
repo="https://gitlab.com/flightgear/flightgear.git" # Repository.
branch="$fg_branch" # Branch to use.
component="FG" # Downloading OSG, SG or FG.
git_clone
