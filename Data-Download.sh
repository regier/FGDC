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
if [[ "$*" =~ .*"--next".* ]]; then
  release="Next"
  fg_branch="next"
else
  release="Stable"
  fg_branch="release/2020.3"
fi

fgdc_directory="$HOME/FGDC"
fgdc="$fgdc_directory"
download_directory="$fgdc"

clear # Clear screen.

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

# Function to clone the required components.
git_clone () {
  message="Checking if $component is already downloaded" say
  # IF condition to check if the component directory already exists in the download dir.
  # If if finds a download dir with the expected name it will then switch to the correct
  # correct branch and update it. Otherwise, it will proceed to do a clean download.
  if [ -d "$download_directory/$component" ]; then
    message="$component already downloaded. Updating it." say
	message="git checkout $branch" say
    cd "$download_directory/$component" && git checkout "$branch" && git pull
  else
    message="$component was not found. Downloading it" say
	message="git clone -b $branch $repo $component" say
    cd "$download_directory" && git clone -b "$branch" "$repo" "$component"
  fi
}

message="Welcome to FlightGear Data Downloader" say
message="Getting Data release $release"

mkdir -p "$download_directory"

# FlightGear Data
repo="git://git.code.sf.net/p/flightgear/fgdata" # Repository.
branch="$fg_branch" # Branch to use.
component="fgdata"
#rm -rf "$install_directory"/"$component"
git_clone
