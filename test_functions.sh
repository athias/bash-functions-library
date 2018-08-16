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
# Welcome to the test_functions.sh script!
#
# This script is meant to test the various functions provided in the related
# scripts and to provide examples of usage.
#
################################################################################

source func_baseline.sh

################################################################################
# root_check
################################################################################

root_check
status_message success "Root check has passed"

################################################################################
# selinux_check
################################################################################

selinux_check
status_message success "SELinux check has passed"

################################################################################
# status_message
################################################################################

# Usage of select functions:
#   status_message (status) (message)
#     (status)    error, warning, notice, info, success
#     (message)   "must be contained within quotes"
#

# Series of tests for status_message
#status_message error "You have failed me for the last time"
#status_message potato potato
#status_message error "You have failed me for the last time"
#status_message warning "You have failed me for the last time"
#status_message info "You have failed me for the last time"
#status_message notice "You have failed me for the last time"
#status_message success "You have failed me for the last time"

################################################################################
# color_message
################################################################################

# Usage:
#   color_message (format) (color) (message)
#     (format)    normal, bold, underline, contrast, reverse
#     (color)     black, red, green, yellow, blue, indigo, cyan, white
#     (message)   "must be contained within quotes"

# Series of tests for color_message
#color_message
#color_message test test "test"
#color_message bold test "test"
#color_message test red "test"
#color_message bold red test message
color_message bold red "test message"
color_message reverse blue "test message"
color_message contrast green "This is my weapon; there are many like it, but this one is mine!"
color_message normal yellow "This is my weapon; there are many like it, but this one is mine!"
color_message bold cyan "This is my weapon; there are many like it, but this one is mine!"
color_message underline magenta "This is my weapon; there are many like it, but this one is mine!"

VAR="hello"

color_message underline green "This is a test for VAR being ${VAR}"


################################################################################
# host_check
################################################################################

# Usage:
#   hostcheck (host1) (host2) ...

host_check dev
host_check dev.example.com
# expected to fail
host_check dev1 dev2 dev3 dev1.example.com
