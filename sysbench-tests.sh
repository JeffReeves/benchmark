#!/bin/bash
# purpose: runs a suite of sysbench tests to benchmark components
# author: Jeff Reeves

#==[CPU]=======================================================================

# init
CPU_MAX_PRIME='20000'
CPU_THREADS='16 128'

# start tests
echo "[TASK] Running CPU tests ..."
echo ''

for THREADS in ${CPU_THREADS}; do
    echo "[TASK] Start test with ${THREADS} threads ..."
    echo "[COMMAND] sysbench cpu --cpu-max-prime=${CPU_MAX_PRIME} --threads=${THREADS} run"
    sysbench cpu --cpu-max-prime=${CPU_MAX_PRIME} --threads=${THREADS} run
    echo ''
done

echo "[INFO] CPU tests complete"
echo ''

#==============================================================================