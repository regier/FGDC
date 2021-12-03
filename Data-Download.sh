#/bin/bash

# ABOUT
# This script will download FlightGear Data.
# fgdata is a collection of files required to run FG.
# $FG_ROOT is set to fgdata. It contains airports models and navigation data.
# GitHub Repo: https://github.com/regier/FGDC
#
# AUTHOR
# Created by Regier Kunkel on 26/11/2021
# Contact: regier (dot) kunkel (at) gmail (dot) com
#
# LICENSE
# Licensed under GPL 3

# Main script variables.
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
  git clone --depth=1 --single-branch -b "$branch" "$repo" "$install_directory"/"$component"
}

# Creates required directories.
# Creates install dir.
message="Creating ""$install_directory" say
mkdir -p "$install_directory"

# FlightGear Data
repo="https://gitlab.com/flightgear/fgdata.git" # Repository.
branch="release/2020.3" # Branch to use.
component="fgdata"
#rm -rf "$install_directory"/"$component"
git_clone
