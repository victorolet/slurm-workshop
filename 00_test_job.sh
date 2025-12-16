#!/bin/bash
#SBATCH --job-name=my_first_job
#SBATCH --account=pawsey0012
#SBATCH --output=output_%j.txt
#SBATCH --error=error_%j.txt
#SBATCH --ntasks=1
#SBATCH --time=00:10:00
#SBATCH --partition=work

echo "Hello from SLURM!"
echo "Job ID: $SLURM_JOB_ID"
echo "Running on: $HOSTNAME"