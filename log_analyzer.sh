#!/bin/bash

# Function to display help message
usage() {
  echo "Usage: $0 -f logfile -e keyword"
  echo "  -f logfile        Specify the log file to analyze (e.g., /var/log/syslog)"
  echo "  -e keyword        Specify the keyword to search for (e.g., ERROR, WARNING)"
  exit 1
}

# Check if no arguments are provided
if [ $# -eq 0 ]; then
  usage
fi

# Parse options
while getopts "f:e:h" opt; do
  case $opt in
    f) logfile=$OPTARG ;;
    e) keyword=$OPTARG ;;
    h) usage ;;
    *) usage ;;
  esac
done

# Check if both logfile and keyword are provided
if [[ -z $logfile || -z $keyword ]]; then
  echo "Error: Both log file and keyword must be provided."
  usage
fi

# Check if the log file exists
if [[ ! -f $logfile ]]; then
  echo "Error: Log file '$logfile' does not exist."
  exit 1
fi

# Search for the keyword in the log file
grep -i "$keyword" "$logfile" > extracted_errors.log

# Count the occurrences of the keyword
error_count=$(grep -ic "$keyword" "$logfile")

# Output the results
echo "Found $error_count occurrences of '$keyword' in '$logfile'."
echo "Extracted lines saved to 'extracted_errors.log'."
