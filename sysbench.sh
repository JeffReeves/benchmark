#!/bin/bash
# purpose: use sysbench to benchmark components
# author: Jeff Reeves

# install sysbench if not installed
echo "[TASK] Verifing sysbench is installed ..."
SYSBENCH_PRESENT=$(which sysbench)
if [ -z "${SYSBENCH_PRESENT}" ]; then
    echo "[WARNING] sysbench command is not present"
    echo "[TASK] Installing sysbench..."
    echo "[COMMAND] sudo apt-get install sysbench -y"
    sudo apt-get install sysbench -y
else
    echo "[SUCCESS] sysbench is already installed:"
    echo "${SYSBENCH_PRESENT}"
fi
echo ''

# create log file
DATE=$(date +%Y-%b-%d | tr '[a-z]' '[A-Z]')
LOG_FILE="/tmp/sysbench-tests_${DATE}.txt"
echo "[INFO] Output from tests will be tee'd to:"
echo "${LOG_FILE}"
echo ''

# start tests
START_TIME=$(date)
echo "[SYSBENCH TESTS]" | tee ${LOG_FILE}
echo "[START] ${START_TIME}" | tee -a ${LOG_FILE}
echo '' | tee -a ${LOG_FILE}

# get this script's current directory
REAL_PATH=$(realpath "${BASH_SOURCE[0]}")
CURRENT_DIRECTORY=$(dirname "${REAL_PATH}")

# run test suite
TEST_SUITE='sysbench-tests.sh'
echo "[TASK] Starting sysbench test suite ..." 
echo "[COMMAND] ${CURRENT_DIRECTORY}/${TEST_SUITE}"
"${CURRENT_DIRECTORY}/${TEST_SUITE}" | tee -a ${LOG_FILE}
echo '' | tee -a ${LOG_FILE}

# print completion message
END_TIME=$(date)
echo "[COMPLETE] ${END_TIME}" | tee -a ${LOG_FILE}

# function to format hours, minutes, and seconds
function format_time {
    local VALUE="${1}"
    local UNIT="${2}"
    case ${VALUE} in
    0)
        echo ''
        ;;
    1)
        echo "${VALUE} ${UNIT}"
        ;;
    [2-9]|[1-5][0-9])
        echo "${VALUE} ${UNIT}s"
        ;;
    *)
        echo ''
        ;;
    esac
}

# set defaults for completion time
SECONDS=0
MINUTES=0
HOURS=0

# determine total seconds spent
START_SECONDS=$(date -d "${START_TIME}" '+%s')
END_SECONDS=$(date -d "${END_TIME}" '+%s')
SECONDS=$((END_SECONDS - START_SECONDS))

# if seconds exceed 60, add minutes
if [ ${SECONDS} -gt 60 ]; then 
    MINUTES=$((SECONDS / 60))
    SECONDS=$((SECONDS % 60))
fi

# if minutes exceed 60, add hours
if [ ${MINUTES} -gt '60' ]; then 
    HOURS=$((MINUTES / 60))
    MINUTES=$((MINUTES % 60))
fi

# format plurals
HOURS_FORMATTED=$(format_time ${HOURS} 'hour')
MINUTES_FORMATTED=$(format_time ${MINUTES} 'minute')
SECONDS_FORMATTED=$(format_time ${SECONDS} 'second')

TOTAL_TIME="${HOURS_FORMATTED} ${MINUTES_FORMATTED} ${SECONDS_FORMATTED}"

# output the total time spent
echo "[INFO] Total time spent running tests:"
echo "${TOTAL_TIME}"