#!/bin/bash
#SBATCH --job-name=my_first_job
#SBATCH --account=courses01
#SBATCH --output=stage00_test/output_%j.txt
#SBATCH --error=stage00_test/error_%j.txt
#SBATCH --ntasks=1
#SBATCH --time=00:10:00
#SBATCH --partition=work

mkdir -p stage00_test

echo "Hello from SLURM!"
echo "Job ID: $SLURM_JOB_ID"
echo "Running on: $HOSTNAME"
