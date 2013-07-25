#!/bin/bash
# require: simple_logger.sh
# -----------------------
# File check functions
# -----------------------
file_exists()
{
    local _target="$1"
    if [ ! -e "$_target" ];then
        logger_debug "$_target doesn't exist"
        echo 0
    else
        logger_debug "$_target exists"
        echo 1
    fi
}

is_readable()
{
    local _target="$1"
    local _errcode="${2:-1}"
    if [ ! -r "$_target" ];then
        logger_debug "Can't read $_target"
        echo 0
    else
        logger_debug "Readable: $_target"
        echo 1
    fi
}

is_writable()
{
    local _target="$1"
    local _errcode="${2:-1}"
    if [ ! -w "$_target" ];then
        logger_debug "Can't read $_target"
        echo 0
    else
        logger_debug "writable: $_target"
        echo 1
    fi
}

# -----------------------
# Text check functions
# -----------------------
is_include()
{
    local _text="$1"
    local _target_word="$2"
    local _is_include=`echo "$_text" | grep -e "$_target_word" | wc -l`
    if [ $_is_include -ge 1 ]; then
        logger_info "$2 is found $_is_include times"
        echo 1
    else
        logger_info "$2 is not found"
        echo 0
    fi
}
