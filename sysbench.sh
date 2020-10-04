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

# start tests
echo "[SYSBENCH TESTS]" | tee ${LOG_FILE}
echo "[START] $(date)" | tee -a ${LOG_FILE}
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
echo "[COMPLETE] $(date)" | tee -a ${LOG_FILE}