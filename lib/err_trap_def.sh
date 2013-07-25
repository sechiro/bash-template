#!/bin/bash
# require: simple_logger.sh
# ---------------
# Error trap
# ---------------
__on_error()
{
    errcode=$?
    logger_fatal "ERR trap: command exited with status $errcode."
}
trap '__on_error $LINENO' ERR
