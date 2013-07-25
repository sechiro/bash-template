#!/bin/bash
set -ue
LANG=C

# ---------------
# Option parsing
# ---------------
option_description="[-s]"
usage(){
    echo "Usage: `basename $0` $option_description"
    exit 1
}

# Init variables because "set -u" requires all variables are defined
silent=0
while getopts "s" OPT
do
    case $OPT in
        s) silent=1;;
        *) usage ;;
    esac
done
# cut options from arguments
shift $(( $OPTIND - 1 ))

# -------------------
# Script env settings
# -------------------
# Get script path and filenames.
script_name=`basename $0 .sh`
script_dir=$(cd $(dirname $0);pwd)
script_logdir=$script_dir/../log

# Set LOG_LEVEL etc.
source $script_dir/../conf/setenv.sh

# Import logger
source $script_dir/../lib/simple_logger.sh

# Import ERR trap
source $script_dir/../lib/err_trap_def.sh

# Import functions
source $script_dir/../lib/functions.sh

# stdout and stderr log and silent mode
if [ $silent = 0 ];then
    exec 3>&1
    exec 1> >( tee -a $script_logdir/$script_name.out )
    exec 2> >( tee -a $script_logdir/$script_name.log )
else
    exec 3>&1
    exec 1>$script_logdir/$script_name.out
    exec 2>$script_logdir/$script_name.log
fi

# コンソールに直接出す（ログファイルには出さず、サイレントモードでも表示される）
echo "test" >&3

logger_info "てすと"
tmp_readable=`is_readable /tmp`
echo $tmp_readable

set +e
ls /temp

logger_info "Script Done."
