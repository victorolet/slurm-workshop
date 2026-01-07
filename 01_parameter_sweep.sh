#!/bin/bash
#SBATCH --job-name=param_sweep
#SBATCH --account=courses01
#SBATCH --partition=work
#SBATCH --output=stage01_results/param_%A_%a.out
#SBATCH --error=stage01_results/param_%A_%a.err
#SBATCH --array=1-5
#SBATCH --time=00:10:00
#SBATCH --ntasks=1
#SBATCH --mem=1G

# module loads 
module load python/3.11.6

# Create output directory if it doesn't exist
mkdir -p stage01_results

# Define parameter values for each array task
# Each task will test a different parameter value
case $SLURM_ARRAY_TASK_ID in
    1) PARAM=0.1 ;;
    2) PARAM=0.5 ;;
    3) PARAM=1.0 ;;
    4) PARAM=2.0 ;;
    5) PARAM=5.0 ;;
esac

echo "================================"
echo "Running parameter sweep"
echo "Task ID: $SLURM_ARRAY_TASK_ID"
echo "Parameter value: $PARAM"
echo "Started at: $(date)"
echo "================================"

# Simulate some computational work with this parameter
# Replace this with your actual program
python3 << EOF
import time
import math

param = $PARAM
print(f"Processing with parameter = {param}")

# Simulate computation
result = 0
for i in range(1000000):
    result += math.sin(i * param)

print(f"Result: {result}")
print(f"Parameter {param} completed successfully")
EOF

echo "Finished at: $(date)"
