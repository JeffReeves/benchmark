#!/bin/bash
# purpose: runs a suite of sysbench tests to benchmark components
# author: Jeff Reeves

# general formatting function
function print_separator {
    if [ "${1}" == '-' ]; then
        printf '#'
        printf -- '-%.0s' {1..79}
        printf '\n'
    else
        printf '#'
        printf '=%.0s' {1..79}
        printf '\n' 
    fi
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
    echo "[COMMAND] sysbench cpu \\"
    echo "--cpu-max-prime=${CPU_MAX_PRIME} \\"
    echo "--threads=${THREADS} \\"
    echo "run"
    echo ''
    sysbench cpu \
    --cpu-max-prime=${CPU_MAX_PRIME} \
    --threads=${THREADS} \
    run
    echo ''
    print_separator -
done

echo "[END] CPU TESTS"
print_separator
echo ''

#==[MEMORY]====================================================================

# init
MEMORY_THREADS='16 128'
MEMORY_OPERATIONS='read write'
MEMORY_ACCESS_MODE='rnd seq'
MEMORY_TOTAL_SIZE='32G'
MEMORY_BLOCK_SIZE='1M'

# start tests
print_separator
echo "[BEGIN] MEMORY TESTS"
echo ''

for THREADS in ${CPU_THREADS}; do
    echo "[TASK] Start test with ${THREADS} threads ..."
    echo ''
    for OPERATION in ${MEMORY_OPERATIONS}; do
        for MODE in ${MEMORY_ACCESS_MODE}; do
            echo "[TASK] Running test with:"
            echo "OPERATION: '${OPERATION}'"
            echo "MODE:      '${MODE}'"
            echo ''
            echo "[COMMAND] sysbench memory \\"
            echo "--threads=${THREADS} \\"
            echo "--memory-total-size=${MEMORY_TOTAL_SIZE} \\"
            echo "--memory-block-size=${MEMORY_BLOCK_SIZE} \\"
            echo "--memory-scope=global \\"
            echo "--memory-hugetlb=off \\"
            echo "--memory-oper=${OPERATION} \\"
            echo "--memory-access-mode=${MODE} \\"
            echo "run"
            echo ''
            sysbench memory \
            --threads=${THREADS} \
            --memory-total-size=${MEMORY_TOTAL_SIZE} \
            --memory-block-size=${MEMORY_BLOCK_SIZE} \
            --memory-scope=global \
            --memory-hugetlb=off \
            --memory-oper=${OPERATION} \
            --memory-access-mode=${MODE} \
            run
            echo ''
            print_separator -
        done
    done
done

echo "[END] MEMORY TESTS"
print_separator
echo ''

#==[DISK I/O]==================================================================

# init
FILE_SIZE='4G'
FILE_NUM='128'
FILE_BLOCK_SIZE='32768'
FILE_THREADS='16 128'
FILE_SEED='0' # use current time for random number generator
FILE_MAX_EVENTS='0' # unlimited
FILE_MAX_TIME='60'
FILE_TEST_MODES='rndrd seqrd rndwr seqwr rndrw seqrewr'
# rndrd   = random read
# seqrd   = sequential read
# rndwr   = random write
# seqwr   = sequential write
# rndrw   = random read-write
# seqrewr = sequential rewrite

# start tests
print_separator
echo "[BEGIN] DISK I/O TESTS"
echo ''

for THREADS in ${FILE_THREADS}; do

    # create test files
    echo "[TASK] Creating ${FILE_SIZE} test file ..."
    echo "[COMMAND] sysbench fileio \\"
    echo "--file-num=${FILE_NUM} \\"
    echo "--file-block-size=${FILE_BLOCK_SIZE} \\"
    echo "--file-total-size=${FILE_SIZE} \\"
    echo "prepare"
    echo ''
    sysbench fileio \
    --file-num=${FILE_NUM} \
    --file-block-size=${FILE_BLOCK_SIZE} \
    --file-total-size=${FILE_SIZE} \
    prepare
    echo "[INFO] File creation complete"
    print_separator -

    # start running tests
    echo "[TASK] Start test with ${THREADS} threads ..."
    echo ''
    for MODE in ${FILE_TEST_MODES}; do
        echo "[TASK] Running test with mode '${MODE}' ..."
        echo "[COMMAND] sysbench fileio \\"
        echo "--file-test-mode=${MODE} \\"
        echo "--threads=${THREADS} \\"
        echo "--rand-seed=${FILE_SEED} \\"
        echo "--time=${FILE_MAX_TIME} \\"
        echo "--events=${FILE_MAX_EVENTS} \\"
        echo "run"
        echo ''
        sysbench fileio \
        --file-test-mode=${MODE} \
        --threads=${THREADS} \
        --rand-seed=${FILE_SEED} \
        --time=${FILE_MAX_TIME} \
        --events=${FILE_MAX_EVENTS} \
        run
        echo ''
        print_separator -
    done

    # delete test files
    echo "[TASK] Deleting ${FILE_SIZE} test file ..."
    echo "[COMMAND] sysbench fileio \\"
    echo "--file-num=${FILE_NUM} \\"
    echo "--file-block-size=${FILE_BLOCK_SIZE} \\"
    echo "--file-total-size=${FILE_SIZE} \\"
    echo "cleanup"
    echo ''
    sysbench fileio \
    --file-num=${FILE_NUM} \
    --file-block-size=${FILE_BLOCK_SIZE} \
    --file-total-size=${FILE_SIZE} \
    cleanup
    echo "[INFO] File deletion complete"
    print_separator -
    echo ''
done

echo "[END] DISK I/O TESTS"
print_separator
echo ''