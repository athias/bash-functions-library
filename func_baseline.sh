#!/bin/bash
################################################################################
#
# Copyright (c) 2018 Matthew Ryan Sawyer
#
# Released under MIT License
#
# This is part of the bash-functions-library located at:
#   https://github.com/athias/bash-functions-library
#
################################################################################
#
# Welcome to the func_baseline.sh script!
#
# This script is intended to be sourced by more complex scripts and is intended
# to provide a baseline set of functions expected to be required.
# 
# This script will provide the following functions:
#   status_message    Displays customized notification messages
#   color_message     Displays messages based on color and format choices
#   root_check        Verifies the script is being run with root privileges
#   selinux_check     verifies the root user has the correct selinux contexts
#   set_variables     Establishes a baseline set of commonly used variables
#
# Usage of select functions:
#   status_message (status) (message)
#     (status)    error, warning, notice, info, success
#     (message)   must be contained within quotes
#   color_message (format) (color) (message)
#     (format)    normal, bold, underline, contrast, reverse
#     (color)     black, red, green, yellow, blue, indigo, cyan, white
#     (message)   must be contained within quotes
#
################################################################################
# status_message function
################################################################################

status_message() {

# Usage:
#   status_message (status) (message)
#     (status)    error, warning, notice, info, success
#     (message)   must be contained within quotes

# uncomment to assist with debugging
#echo "### Testing info"
#echo $1
#echo $2
#echo $3
#echo "### Testing info"

  if [[ -z ${1} ]] || [[ -z ${2} ]];then
    printf "\e[0;31mERROR:   \e[0m\tThe status_message function was not called with the correct number of variables.\n"
  elif [[ ${1} != "error" ]] && [[ ${1} != "warning" ]] && [[ ${1} != "notice" ]] && [[ ${1} != "info" ]] && [[ ${1} != "success" ]];then
    printf "\e[0;31mERROR:   \e[0m\tThe status_message function was called with an invalid status option.\n"
  elif [[ -n ${3} ]];then
    printf "\e[0;31mERROR:   \e[0m\tThe status_message function was called with extra variables.\n"
    printf "\e[0;35mNOTICE:  \e[0m\tThis is most likely caused by not using quotes around the message.\n"
  elif [[ ${1} == "error" ]];then
    printf "\e[0;31mERROR:   \e[0m\t${2}\n"
  elif [[ ${1} == "warning" ]];then
    printf "\e[0;33mWARNING:\e[0m\t${2}\n"
  elif [[ ${1} == "notice" ]];then
    printf "\e[0;35mNOTICE: \e[0m\t${2}\n"
  elif [[ ${1} == "info" ]];then
    printf "\e[0;36mINFO:   \e[0m\t${2}\n"
  elif [[ ${1} == "success" ]];then
    printf "\e[0;32mSUCCESS:\e[0m\t${2}\n"
  else
    printf "\e[0;31mERROR:   \e[0m\tI have no idea how you got here, but congratulations you broke my script!\n"
    exit
  fi

}

################################################################################
# color_message function
################################################################################

color_message() {

# Usage:
#   color_message (format) (color) (message)
#     (format)    normal, bold, underline, contrast, reverse
#     (color)     black, red, green, yellow, blue, indigo, cyan, white
#     (message)   must be contained within quotes

# uncomment to assist with debugging
#echo *****
#echo ${1}
#echo ${2}
#echo ${3}
#echo ${4}
#echo ${FORMAT}
#echo ${COLOR}
#echo ****

  # Perform Error Checking and identify Errors
  if [[ -z ${1} ]] || [[ -z ${2} ]] || [[ -z ${3} ]];then
    status_message error "The color_message function was not called with the correct number of variables."
    ERROR=1
  elif [[ -n ${4} ]];then
    status_message error "The color_message function was called with an extra variable."
    status_message notice "This is most likely caused by not using quotes around the message."
    ERROR=1
  elif [[ ${2} != "black" ]] && [[ ${2} != "red" ]] && [[ ${2} != "green" ]] && [[ ${2} != "yellow" ]] && [[ ${2} != "blue" ]] && [[ ${2} != "magenta" ]] && [[ ${2} != "cyan" ]] && [[ ${2} != "white" ]];then
    status_message error "The color_message function did not receive a valid color to use"
    ERROR=1
  elif [[ ${1} != "normal" ]] && [[ ${1} != "bold" ]] && [[ ${1} != "underline" ]] && [[ ${1} != "contrast" ]] && [[ ${1} != "reverse" ]];then
    status_message error "The color_message function did not receive a valid format to use"
    ERROR=1
  else
    ERROR=0
  fi

  # Determine message format to be used
  if [[ ${1} == "normal" ]];then
    FORMAT='\e[0;'
  elif [[ ${1} == "bold" ]];then
    FORMAT='\e[1;'
  elif [[ ${1} == "underline" ]];then
    FORMAT='\e[4;'
  elif [[ ${1} == "contrast" ]];then
    FORMAT='\e[5;'
  elif [[ ${1} == "reverse" ]];then
    FORMAT='\e[7;'
  elif [[ ${ERROR} == 1 ]];then
    :
  else
    status_message error "This error should be impossible, exiting!"
    exit
  fi

  # Determine message format to be used
  if [[ ${2} == "black" ]];then
    COLOR='30m'
  elif [[ ${2} == "red" ]];then
    COLOR='31m'
  elif [[ ${2} == "green" ]];then
    COLOR='32m'
  elif [[ ${2} == "yellow" ]];then
    COLOR='33m'
  elif [[ ${2} == "blue" ]];then
    COLOR='34m'
  elif [[ ${2} == "magenta" ]];then
    COLOR='35m'
  elif [[ ${2} == "cyan" ]];then
    COLOR='36m'
  elif [[ ${2} == "white" ]];then
    COLOR='37m'
  elif [[ ${ERROR} == 1 ]];then
    :
  else
    status_message error "This error should be impossible, exiting!"
    exit
  fi

  # Print message provided no errors exist
  if [[ ${ERROR} == 1 ]];then
    :
  elif [[ -n ${FORMAT} ]] && [[ -n ${COLOR} ]];then
    # Referenced for debugging
    #echo "printf \"${FORMAT}${COLOR}${3}\\e[0m\\n\""
    printf "${FORMAT}${COLOR}${3}\e[0m\n"
  else
    status_message error "I have no idea how you got here, but congratulations you broke my script!"
    exit
  fi

}

################################################################################
# root_check function
################################################################################

root_check() {

  if [[ ${EUID} -ne "0" ]];then
    status_message error "You must have root privileges to run this script!"
    exit 1
  fi

}

################################################################################
# set_variables function
################################################################################

set_variables() {

# Set Variables
CUR_DATE=$(date +%Y%m%d)
CUR_TIME=$(date +%H:%M:%S)
CUR_DATE_TIME=$(date +%Y%m%d.%H:%M:%S)
HOST=$(hostname -f)
DOMAIN=$(hostname -d)
ORIG_DIR=$(pwd)

# Things to work out
#MY_PATH="`dirname \"$0\"`"              # relative
#BASEDIR="`( cd \"$MY_PATH\" && pwd )`"  # absolutized and normalized

}

################################################################################
# selinux_check function
################################################################################

selinux_check() {

  SELINUX_ROLE=$(id -Z | cut -d: -f2)
  SELINUX_TYPE=$(id -Z | cut -d: -f3)
  
  if [[ ${SELINUX_ROLE} != "unconfined_r" ]];then
    status_message error "Your SELinux role must be 'unconfined_r' to run this script!"
    exit 1
  elif [[ ${SELINUX_TYPE} != "unconfined_t" ]];then
    status_message error "Your SELinux type must be 'unconfined_t' to run this script!"
    exit 1
  fi

}

################################################################################
# host_check function
################################################################################

host_check() {

  set_variables
  HOST_LIST=${*}
  HOST_VALID="no"
  
  for CUR_HOST in ${HOST_LIST};do
    if [[ ${HOST} == "${CUR_HOST}.${DOMAIN}" ]] || [[ ${HOST} == ${CUR_HOST} ]];then
      HOST_VALID="yes"
      break
    fi
  done

  if [[ ${HOST_VALID} == "no" ]];then
    status_message error "This script can only be run on the following hosts:"
    for CUR_HOST in ${HOST_LIST};do
      color_message normal cyan "\t${CUR_HOST}"
    done
    exit 1
  fi

}

################################################################################
# End of script
################################################################################
