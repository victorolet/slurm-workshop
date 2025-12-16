#!/bin/bash

# Create directory for input files
mkdir -p input_files

# Generate 5 sample data files
for i in {1..5}; do
    echo "Generating input_files/data_${i}.txt"
    
    # Create a file with random numbers
    cat > input_files/data_${i}.txt << EOF
# Sample data file ${i}
# This file contains random data for processing
$(for j in {1..100}; do echo $((RANDOM % 1000)); done)
EOF
done

echo "Created 5 input files in input_files/"
ls -lh input_files/
