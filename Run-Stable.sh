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
release="Stable"
fg_branch="release/2020.3"
fgdc_directory="$HOME/FGDC"
fgdc="$fgdc_directory"
download_directory="$fgdc/Sources" # Directory where the source codes will be downloaded to.
compiling_directory="$fgdc/Build-$release" # Directory where temp buid files will be stored.
install_directory="$fgdc/FlightGear-$release" # Final install directory.
terrasync="$fgdc/TerraSync"
downloaddir="$terrasync"
aircraft="$fgdc/Aircraft"
#fgdata="$install_directory/fgdata"
fgdata="$fgdc/fgdata"
scenery="$fgdata"
fghome="$install_directory/fgfs"
ldlib="$install_directory/lib"

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

# Start of the "Runner" code. Script to launch FlightGear once it is compiled.

mesa_glthread=true # Enables threaded GL.
vblank_mode=0 # Disables VSync/FPS limit.

# Welcome message.
clear
message="Welcome to FlightGear by FGDC!" say
message="Starting FlightGear $release!" say

# Enabling multi threaded mesa subsystem.
export mesa_glthread=true
# Setting OpenSceneGraph variables for multi core systems.
export OSG_NUM_DATABASE_THREADS=$(nproc)
export OSG_OPTIMIZER=REMOVE_REDUNDANT_NODES
export OSG_NUM_HTTP_DATABASE_THREADS=$(nproc)
export OSG_GL_TEXTURE_STORAGE=on
export OSG_COMPILE_CONTEXTS=on
# Telling to FlightGear what is located where.
export FG_PROG="$install_directory" # Tells FG where it is installed.
export FG_ROOT="$fgdata" # Tells FG which directory is the data folder.
export FG_HOME="$fghome" # Tell FG where to save and load configuration files and logs.

mkdir -p "$FG_HOME" # Creates FG_HOME if it doesn't exists.
mkdir -p "$terrasync" "$aircraft"

# Tells user where and what each directory are.
message="Be mindful of your FlightGear FGDC Directories." say
message="FG_ROOT is $FG_ROOT" say
message="FG_HOME is $FG_HOME" say
message="TerraSync is $terrasync" say
message="Install your aircraft to $aircraft" say

fg_options="--prop:/sim/nasal-gc-threaded=true --prop:/sim/rendering/cache=true \
--prop:/sim/rendering/multithreading-mode=CullThreadPerCameraDrawThreadPerContext \
--prop:/sim/gui/current-style=0 \
--terrasync-dir=$terrasync --download-dir=$downloaddir \
--fg-scenery=$scenery --fg-aircraft=$aircraft"

export LD_LIBRARY_PATH="$ldlib" # Makes FG load libraries from its install folder.
cd "$fgdata" && git checkout "$fg_branch"
cd "$install_directory"
# Launch FG with some optimizarions enabled. Like threaded Garbage Collector and threaded rendering stack.
"$install_directory"/bin/fgfs $fg_options $*
