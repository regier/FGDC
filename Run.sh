#/bin/bash

# ABOUT
# This script will try to run FlightGear after it was compiled.
#
# By default conservative performance settings will be used.
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

# Function to draw messages from the variable $message
say () {
  echo ""
  echo "####################################################"
  echo ">>>  ""$message"
  echo "####################################################"
  echo ""
}

clear
message="Welcome to FlightGear by FGDC!" say
message="Starting FlightGear." say

export OSG_NUM_DATABASE_THREADS=$(nproc)
export OSG_OPTIMIZER=REMOVE_REDUNDANT_NODES
export OSG_NUM_HTTP_DATABASE_THREADS=$(nproc)
export OSG_GL_TEXTURE_STORAGE=on
export OSG_COMPILE_CONTEXTS=on
export FG_PROG="$install_directory"
export FG_ROOT="$install_directory"/fgdata
export FG_HOME="$install_directory"/fgfs
mkdir -p "$FG_HOME"

message="Be mindful of your FlightGear FGDC Directories." say
message="FG_ROOT is ""$FG_ROOT"" fgdata dir placed here." say
message="FG_HOME is ""$FG_HOME"" configuration files here." say

export LD_LIBRARY_PATH="$install_directory"/lib
"$install_directory"/bin/fgfs --disable-hud-3d --prop:/sim/nasal-gc-threaded=true --prop:/sim/rendering/cache=true --prop:/sim/rendering/multithreading-mode=CullThreadPerCameraDrawThreadPerContext --prop:/sim/gui/current-style=0 --log-level=info $*