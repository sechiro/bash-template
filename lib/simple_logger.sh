#!/bin/sh
# Usage:
#
# . ./lib/simple_logger.sh  (Default LOG_LEVEL="info")
#
#   or specify LOG_LEVEL before include this file
#
# LOG_LEVEL="warn"
# . ./lib/simple_logger.sh
LANG=C

# Default log level
LOG_LEVEL=${LOG_LEVEL:-"info"}
LINE_LOG=${LINE_LOG:-"1"}

# Convert all characters to lower case
LOG_LEVEL=$(echo $LOG_LEVEL | tr A-Z a-z)

# set logger date
# "YYYY-MM-DD hh:mm:ss" format
_logger_set_date()
{
    _logger_date=`date '+%Y-%m-%d %H:%M:%S'`
}
# Convert texit "LOG_LEVEL" to the number "_log_level"
_set_log_level()
{
    if [ $LOG_LEVEL = "fatal" ]; then
        _log_level=0
    elif [ $LOG_LEVEL = "error" ]; then
        _log_level=1
    elif [ $LOG_LEVEL = "warn" ]; then
        _log_level=2
    elif [ $LOG_LEVEL = "info" ]; then
        _log_level=3
    elif [ $LOG_LEVEL = "debug" ]; then
        _log_level=4
    elif [ $LOG_LEVEL = "trace" ]; then
        _log_level=5
    else
        _logger_set_date
        echo "$_logger_date ERROR Invalid LOG_LEVEL: $LOG_LEVEL ! Log level is set to TRACE level." 1>&2
        _log_level=5
    fi
}
_set_log_level

# Logger definitions
#
# Output log4j style log like:
# 2013-05-13 23:39:50 INFO log contents
#
_output_log(){
    if [ $LINE_LOG = 1 ];then
        # 元のスクリプトのLINENOは、${BASH_LINENO[]}の最後の1つ前の要素に格納される。
        # ${BASH_LINENO[]}には関数呼び出しなどがある度に、実行行の行番号が先頭に追加される。
        local _line_index=$(( ${#BASH_LINENO[@]} - 2 ))
        echo "$_logger_date $_log_tag [`basename $0`: LineNo: ${BASH_LINENO[$_line_index]}] $@" 1>&2
    else
        echo "$_logger_date $_log_tag $@" 1>&2
    fi
}

logger_info(){
    _log_tag="INFO"
    if [[ $_log_level -ge 3 ]]; then
        _logger_set_date
        _output_log "$@"
    fi
}
logger_warn(){
    _log_tag="WARN"
    if [[ $_log_level -ge 2 ]]; then
        _logger_set_date
        _output_log "$@"
    fi
}
logger_error(){
    _log_tag="ERROR"
    if [[ $_log_level -ge 1 ]]; then
        _logger_set_date
        _output_log "$@"
    fi
}
logger_fatal(){
    _log_tag="FATAL"
    _logger_set_date
    _output_log "$@"
}
logger_debug(){
    _log_tag="DEBUG"
    if [[ $_log_level -ge 4 ]]; then
        _logger_set_date
        _output_log "$@"
        _output_log "$@"
    fi
}
logger_trace(){
    _log_tag="TRACE"
    if [[ $_log_level -ge 5 ]]; then
        _logger_set_date
        _output_log "$@"
    fi
}
