#!/bin/bash

# Function to handle cleanup
cleanup() {
    echo "Monitoring stopped by user."
    exit 0
}

# Register signal handler for Ctrl+C
trap cleanup SIGINT

# Function to monitor log file
monitor_log() {
    log_file="$1"
    echo "Monitoring started..."
    tail -f "$log_file" | while read -r line; do
        echo "$line"
        analyze_log "$line"
    done
}

# Function to analyze log entries
analyze_log() {
    log_line="$1"
    keywords=("ERROR" "CRITICAL")  
    for kw in "${keywords[@]}"; do
        if [[ $log_line == *"$kw"* ]]; then
            echo "Keyword '$kw' found: $log_line"
        fi
    done
}

# Main function
main() {
    log_file="/var/log/httpd" 
    monitor_log "$log_file"
}

main "$@"

