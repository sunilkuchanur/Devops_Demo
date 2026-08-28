#!/bin/bash

check_disk() {
    echo "=============================="
    echo "Checking Disk Usage"
    echo "=============================="
    df -h
}

check_memory() {
    echo "=============================="
    echo "Checking Memory Usage"
    echo "=============================="
    free -h
}
# test comment
check_processes() {
    echo "=============================="
    echo "PROCESS CHECK"
    echo "=============================="

    PROCESS_COUNT=$(ps aux | wc -l)

    echo "Running processes: $PROCESS_COUNT"
}

check_disk
check_memory
check_processes
check_disk
