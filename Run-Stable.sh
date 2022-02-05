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
install_directory="$HOME/FGDC/FlightGear-Stable" # Final install directory.

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

# Start of the "Runner" code. Script to launch FlightGear once it is compiled.

mesa_glthread=true # Enables threaded GL.
vblank_mode=0 # Disables VSync/FPS limit.

# Welcome message.
clear
message="Welcome to FlightGear by FGDC!" say
message="Starting FlightGear." say

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
export FG_ROOT="$install_directory"/fgdata # Tells FG which directory is the data folder.
export FG_HOME="$install_directory"/fgfs # Tell FG where to save and load configuration files and logs.
mkdir -p "$FG_HOME" # Creates FG_HOME if it doesn't exists.

# Tells user where and what each directory are.
message="Be mindful of your FlightGear FGDC Directories." say
message="FG_ROOT is $FG_ROOT" say
message="FG_HOME is $FG_HOME" say

export LD_LIBRARY_PATH="$install_directory"/lib # Makes FG load libraries from its install folder.
# Launch FG with some optimizarions enabled. Like threaded Garbage Collector and threaded rendering stack.
"$install_directory"/bin/fgfs $*
