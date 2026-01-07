#!/bin/bash
#SBATCH --job-name=stage03a_generate
#SBATCH --account=courses01
#SBATCH --partition=work
#SBATCH --output=stage03_pipeline/stage1_%j.out
#SBATCH --error=stage03_pipeline/stage1_%j.err
#SBATCH --time=00:05:00
#SBATCH --ntasks=1
#SBATCH --mem=1G

# module loads 
module load python/3.11.6

# Create directories
mkdir -p stage03_pipeline/data

echo "================================"
echo "STAGE 1: Generate Data"
echo "Job ID: $SLURM_JOB_ID"
echo "Started at: $(date)"
echo "================================"

# Generate 3 data files for processing
for i in {1..3}; do
    echo "Generating stage03_pipeline/data/input_${i}.txt"
    
    # Create sample data file
    python3 << EOF
import random

with open('stage03_pipeline/data/input_${i}.txt', 'w') as f:
    f.write(f"# Dataset ${i}\\n")
    # Generate 50 random numbers
    for _ in range(50):
        f.write(f"{random.uniform(0, 100):.2f}\\n")

print(f"Generated dataset ${i}")
EOF
done

echo "Data generation complete!"
echo "Created files:"
ls -lh stage03_pipeline/data/
echo "Finished at: $(date)"
