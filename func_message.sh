#!/bin/bash
################################################################################
#
# Copyright (c) 2023 Matthew Ryan Sawyer
#
# Released under GPLv3 License
#
# This is part of the bash-functions-library located at:
#   https://github.com/athias/bash-functions-library
#
################################################################################
#
# Name:    func_message.sh
# Purpose: Provide methods of producing standard and colorized messages easier
#
################################################################################

################################################################################
# Function - message::status
#   Colorizes a status message based on the status type
# Globals:
#   None
# Arguments:
#   ${1} - Status Type (Error, warning, notice, info, success, failure)
#   ${2} - Quoted message
# Returns:
#   None
################################################################################

message::status () {

  if [[ -z ${1} ]] || [[ -z ${2} ]];then
    printf "\e[0;31mERROR:   \e[0m\tThe message::status function was not called with the correct number of variables.\n"
  elif [[ ${1} != "error" && ${1} != "warning" && ${1} != "notice" && ${1} != "info" && ${1} != "success" && ${1} != "failure" ]];then
    printf "\e[0;31mERROR:   \e[0m\tThe message::status function was called with an invalid status option.\n"
  elif [[ -n ${3} ]];then
    printf "\e[0;31mERROR:   \e[0m\tThe message::status function was called with extra variables.\n"
    printf "\e[0;35mNOTICE:  \e[0m\tThis is most likely caused by not using quotes around the message.\n"
  elif [[ ${1} == "error" ]];then
    printf "\e[0;31mERROR:   \e[0m\t${2}\n"
  elif [[ ${1} == "failure" ]];then
    printf "\e[0;31mFAILURE:   \e[0m\t${2}\n"
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
# Function - message::color
#   Colorizes a message based on style and color
# Globals:
#   None
# Arguments:
#   ${1} - Text Style (normal, bold, dim, italic, underline, reverse)
#   ${2} - Text Color (normal,black,red,green,yellow,blue,magenta,cyan,white)
#   ${3} - Quoted message
# Returns:
#   None
################################################################################

message::color () {

  # Perform Error Checking and identify Errors
  if [[ -z ${1} ]] || [[ -z ${2} ]] || [[ -z ${3} ]];then
    message::status error "The message::color function was not called with the correct number of variables."
    ERROR=1
  elif [[ -n ${4} ]];then
    message::status error "The message::color function was called with an extra variable."
    message::status notice "This is most likely caused by not using quotes around the message."
    ERROR=1
  elif [[ ${2} != "normal" && ${2} != "black" && ${2} != "red" && ${2} != "green" && ${2} != "yellow" && ${2} != "blue" && ${2} != "magenta" && ${2} != "cyan" && ${2} != "white" ]];then
    message::status error "The message::color function did not receive a valid color to use"
    ERROR=1
  elif [[ ${1} != "normal" && ${1} != "bold" && ${1} != "dim" && ${1} != "italic" && ${1} != "underline" && ${1} != "reverse" && ${1} != "strikethrough" ]];then
    message::status error "The message::color function did not receive a valid format to use"
    ERROR=1
  else
    ERROR=0
  fi

  # Determine message format to be used
  if [[ ${1} == "normal" ]];then
    FORMAT='\e[0'
  elif [[ ${1} == "bold" ]];then
    FORMAT='\e[1'
  elif [[ ${1} == "dim" ]];then
    FORMAT='\e[2'
  elif [[ ${1} == "italic" ]];then
    FORMAT='\e[3'
  elif [[ ${1} == "underline" ]];then
    FORMAT='\e[4'
  elif [[ ${1} == "reverse" ]];then
    FORMAT='\e[7'
  elif [[ ${1} == "strikethrough" ]];then
    FORMAT='\e[9'
  elif [[ ${ERROR} == 1 ]];then
    :
  else
    message::status error "This error should be impossible, exiting!"
    exit
  fi

  # Determine message format to be used
  if [[ ${2} == "normal" ]];then
    COLOR='m'
  elif [[ ${2} == "black" ]];then
    COLOR=';30m'
  elif [[ ${2} == "red" ]];then
    COLOR=';31m'
  elif [[ ${2} == "green" ]];then
    COLOR=';32m'
  elif [[ ${2} == "yellow" ]];then
    COLOR=';33m'
  elif [[ ${2} == "blue" ]];then
    COLOR=';34m'
  elif [[ ${2} == "magenta" ]];then
    COLOR=';35m'
  elif [[ ${2} == "cyan" ]];then
    COLOR=';36m'
  elif [[ ${2} == "white" ]];then
    COLOR=';37m'
  elif [[ ${ERROR} == 1 ]];then
    :
  else
    message::status error "This error should be impossible, exiting!"
    exit
  fi

  # Print message provided no errors exist
  if [[ ${ERROR} == 1 ]];then
    :
  elif [[ -n ${FORMAT} ]] && [[ -n ${COLOR} ]];then
    printf "${FORMAT}${COLOR}${3}\e[0m\n"
  else
    message::status error "I have no idea how you got here, but congratulations you broke my script!"
    exit
  fi

}

################################################################################
# End
################################################################################
