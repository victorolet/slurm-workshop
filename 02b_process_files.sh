#!/bin/bash
#SBATCH --job-name=process_files
#SBATCH --account=courses01
#SBATCH --partition=work
#SBATCH --output=stage02_results/file_%A_%a.out
#SBATCH --error=stage02_results/file_%A_%a.err
#SBATCH --array=1-5
#SBATCH --time=00:10:00
#SBATCH --ntasks=1
#SBATCH --mem=1G

# Create output directory if it doesn't exist
mkdir -p stage02_results

# Define input and output file names based on array task ID
INPUT_FILE="stage02_input_files/data_${SLURM_ARRAY_TASK_ID}.txt"
OUTPUT_FILE="stage02_results/processed_${SLURM_ARRAY_TASK_ID}.txt"

echo "================================"
echo "Processing input files"
echo "Task ID: $SLURM_ARRAY_TASK_ID"
echo "Input file: $INPUT_FILE"
echo "Output file: $OUTPUT_FILE"
echo "Started at: $(date)"
echo "================================"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "ERROR: Input file $INPUT_FILE not found!"
    exit 1
fi

# Process the file (example: calculate statistics)
# Replace this with your actual processing
python3 << EOF
import sys

# Read the input file
with open('$INPUT_FILE', 'r') as f:
    # Skip comment lines starting with #
    numbers = [float(line.strip()) for line in f if not line.startswith('#') and line.strip()]

# Calculate statistics
if numbers:
    total = sum(numbers)
    avg = total / len(numbers)
    min_val = min(numbers)
    max_val = max(numbers)
    
    # Write results
    with open('$OUTPUT_FILE', 'w') as f:
        f.write(f"Statistics for {numbers[0]} values\\n")
        f.write(f"Sum: {total}\\n")
        f.write(f"Average: {avg:.2f}\\n")
        f.write(f"Min: {min_val}\\n")
        f.write(f"Max: {max_val}\\n")
    
    print(f"Processed {len(numbers)} values")
    print(f"Average: {avg:.2f}")
else:
    print("No valid numbers found in file")
EOF

echo "Finished at: $(date)"
echo "Output saved to: $OUTPUT_FILE"
