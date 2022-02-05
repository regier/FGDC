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
install_directory="$HOME/FGDC/FlightGear-Stable" # Final install directory.
download_directory="$install_directory"
fg_branch="release/2020.3"

# Change variables to download and build the Next version
# if the user chooses to do so with the "--next" argument.
if [ "$*" = "--next" ]; then
  install_directory="$HOME/FGDC/FlightGear-Next" # Final install directory.
  download_directory="$install_directory"
  fg_branch="next" # Sets downloader to use the latest dev version.
fi


clear # Clear screen.

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

# Function to clone the required components.
git_clone () {
  message="Checking if $component is already downloaded" say
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
# Creates install dir.
message="Creating ""$install_directory" say
mkdir -p "$install_directory"

# FlightGear Data
repo="git://git.code.sf.net/p/flightgear/fgdata" # Repository.
branch="$fg_branch" # Branch to use.
component="fgdata"
#rm -rf "$install_directory"/"$component"
git_clone
