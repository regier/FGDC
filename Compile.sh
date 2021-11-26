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
download_directory="" # Directory where the source codes will be downloaded to.
compiling_directory="" # Directory where temp buid files will be stored.
install_directory="" # Final install directory.
