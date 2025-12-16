#!/bin/bash

# This script submits a 3-stage pipeline with job dependencies
# Stage 1: Generate data files
# Stage 2: Process each file (job array)
# Stage 3: Combine all results

echo "================================"
echo "Submitting 3-Stage Pipeline"
echo "================================"

# Create output directory
mkdir -p pipeline

# Stage 1: Generate data
echo "Submitting Stage 1 (Generate data)..."
JOB1=$(sbatch --parsable 03a_stage1_generate.sh)
echo "  Job ID: $JOB1"

# Stage 2: Process data (depends on Stage 1)
echo "Submitting Stage 2 (Process data - array job)..."
JOB2=$(sbatch --parsable --dependency=afterok:$JOB1 03b_stage2_process.sh)
echo "  Job ID: $JOB2 (array)"

# Stage 3: Combine results (depends on Stage 2)
echo "Submitting Stage 3 (Combine results)..."
JOB3=$(sbatch --parsable --dependency=afterok:$JOB2 03c_stage3_combine.sh)
echo "  Job ID: $JOB3"

echo ""
echo "================================"
echo "Pipeline submitted successfully!"
echo "================================"
echo "Job dependencies:"
echo "  $JOB1 (Stage 1) -> $JOB2 (Stage 2) -> $JOB3 (Stage 3)"
echo ""
echo "Monitor progress with:"
echo "  squeue -u \$USER"
echo ""
echo "Check results when complete:"
echo "  cat pipeline/final_report.txt"
echo "================================"
