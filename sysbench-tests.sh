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
    echo "[COMMAND] sysbench cpu --cpu-max-prime=${CPU_MAX_PRIME} --threads=${THREADS} run"
    sysbench cpu --cpu-max-prime=${CPU_MAX_PRIME} --threads=${THREADS} run
    echo ''
done

echo "[END] CPU TESTS"
print_separator
echo ''

#==============================================================================