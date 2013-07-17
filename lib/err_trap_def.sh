#!/bin/bash
# Dependency: simple_logger.sh
# ---------------
# Error trap
# ---------------
__on_error()
{
    errcode=$?
    logger_fatal "$0: error line $1: command exited with status $errcode."
}
trap '__on_error $LINENO' ERR
