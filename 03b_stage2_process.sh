#!/bin/bash
#SBATCH --job-name=stage2_process
#SBATCH --account=<your_project_account>
#SBATCH --partition=work
#SBATCH --output=pipeline/stage2_%A_%a.out
#SBATCH --error=pipeline/stage2_%A_%a.err
#SBATCH --array=1-3
#SBATCH --time=00:05:00
#SBATCH --ntasks=1
#SBATCH --mem=1G

# module loads 
module load python/3.11.6

# This job should only run AFTER stage 1 completes successfully
# Submit with: sbatch --dependency=afterok:JOBID_STAGE1 03b_stage2_process.sh

INPUT_FILE="pipeline/data/input_${SLURM_ARRAY_TASK_ID}.txt"
OUTPUT_FILE="pipeline/results/result_${SLURM_ARRAY_TASK_ID}.txt"

# Create results directory
mkdir -p pipeline/results

echo "================================"
echo "STAGE 2: Process Data"
echo "Array Job ID: $SLURM_ARRAY_JOB_ID"
echo "Task ID: $SLURM_ARRAY_TASK_ID"
echo "Input: $INPUT_FILE"
echo "Output: $OUTPUT_FILE"
echo "Started at: $(date)"
echo "================================"

# Check if input exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "ERROR: Input file not found!"
    exit 1
fi

# Process the data
python3 << EOF
import math

# Read input
with open('$INPUT_FILE', 'r') as f:
    numbers = [float(line.strip()) for line in f if not line.startswith('#') and line.strip()]

# Perform analysis
mean = sum(numbers) / len(numbers)
variance = sum((x - mean) ** 2 for x in numbers) / len(numbers)
std_dev = math.sqrt(variance)

# Save results
with open('$OUTPUT_FILE', 'w') as f:
    f.write(f"Analysis Results for Dataset ${SLURM_ARRAY_TASK_ID}\\n")
    f.write(f"{'='*40}\\n")
    f.write(f"Sample size: {len(numbers)}\\n")
    f.write(f"Mean: {mean:.4f}\\n")
    f.write(f"Std Dev: {std_dev:.4f}\\n")
    f.write(f"Min: {min(numbers):.4f}\\n")
    f.write(f"Max: {max(numbers):.4f}\\n")

print(f"Processed dataset {SLURM_ARRAY_TASK_ID}: mean={mean:.2f}")
EOF

echo "Processing complete!"
echo "Finished at: $(date)"
