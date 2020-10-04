#!/bin/bash
# purpose: runs a suite of sysbench tests to benchmark components
# author: Jeff Reeves

# general formatting function
function print_separator {
    printf '#'
    printf '=%.0s' {1..79}
    printf '\n'
}

#==[CPU]=======================================================================

# init
CPU_MAX_PRIME='20000'
CPU_THREADS='16 128'

# start tests
print_separator
echo "[BEGIN] CPU TESTS"
echo ''

for THREADS in ${CPU_THREADS}; do
    echo "[TASK] Start test with ${THREADS} threads ..."
    echo "[COMMAND] sysbench cpu \
    --cpu-max-prime=${CPU_MAX_PRIME} \
    --threads=${THREADS} \
    run"
    sysbench cpu \
    --cpu-max-prime=${CPU_MAX_PRIME} \
    --threads=${THREADS} \
    run
    echo ''
done

echo "[END] CPU TESTS"
print_separator
echo ''

#==[MEMORY]====================================================================

# # init

# # start tests
# print_separator
# echo "[BEGIN] MEMORY TESTS"
# echo ''

# echo "[END] MEMORY TESTS"
# print_separator
# echo ''

#==[DISK I/O]==================================================================

# init
FILE_SIZE='6G'
FILE_BLOCK_SIZE='16384'
FILE_THREADS='16 128'
FILE_SEED='0' # current time used for random number generator
FILE_MAX_EVENTS='0' # unlimited
FILE_MAX_TIME='60'
FILE_TEST_MODES='seqwr seqrewr seqrd rndrd rndwr rndrw'

# start tests
print_separator
echo "[BEGIN] DISK I/O TESTS"
echo ''

# create test files
echo "[TASK] Creating ${FILE_SIZE} test file ..."
sysbench fileio --file-total-size=${FILE_SIZE} prepare
echo "[INFO] File creation complete"
echo ''

for THREADS in ${FILE_THREADS}; do
    echo "[TASK] Start test with ${THREADS} threads ..."
    echo ''
    for MODE in ${FILE_TEST_MODES}; do
        echo "[TASK] Running test with mode '${MODE}' ..."
        echo "[COMMAND] sysbench fileio \
        --file-total-size=${FILE_SIZE} \
        --file-test-mode=${MODE} \
        --threads=${THREADS} \
        --file-block-size=${FILE_BLOCK_SIZE} \
        --rand-seed=${FILE_SEED} \
        --time=${FILE_MAX_TIME} \
        --events=${FILE_MAX_EVENTS} \
        run"
        sysbench fileio \
        --file-total-size=${FILE_SIZE} \
        --file-test-mode=${MODE} \
        --threads=${THREADS} \
        --file-block-size=${FILE_BLOCK_SIZE} \
        --rand-seed=${FILE_SEED} \
        --time=${FILE_MAX_TIME} \
        --events=${FILE_MAX_EVENTS} \
        run
        echo ''
    done
done

# delete test files
echo "[TASK] Deleting ${FILE_SIZE} test file ..."
sysbench fileio --file-total-size=${FILE_SIZE} cleanup
echo "[INFO] File deletion complete"
echo ''

echo "[END] DISK I/O TESTS"
print_separator
echo ''