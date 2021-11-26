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

say () {
echo ""
echo "####################################################"
echo ">>>  ""$message"
echo "####################################################"
echo ""

# Creates required directories.
message="Creating ""$download_directory"
say
mkdir -p "$download_directory"
message="Creating ""$compiling_directory"
say
mkdir -p "$compiling_directory"
message="Creating ""$install_directory"
say
mkdir -p "$install_directory"

# PLIB
wget -c http://plib.sourceforge.net/dist/plib-1.8.5.tar.gz "$download_directory"/plib.tar.gz
cd "$download_directory"/
tar zxf "$download_directory"/plib.tar.gz
