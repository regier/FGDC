#/bin/bash

# ABOUT
# This script will remove all files related to FGDC from the system.
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

# Change variables to download and build the Next version
# if the user chooses to do so with the "--next" argument.
if [ "$*" = "--next" ]; then
  install_directory="$HOME/FGDC/FlightGear-Next" # Final install directory.
fi


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
message="Welcome to FGDC Uninstaller." say
message="Removing FGDC FlightGear from your system." say
# Deletes installed and downloaded files.
rm -rf "$download_directory" "$compiling_directory" "$install_directory" "$HOME/.fgfsrc"
message="FGDC FlightGear removed." say
