# SLURM Job Arrays and Dependencies - Simple Examples

This directory contains minimal examples for learning SLURM job arrays and dependencies.

## Prerequisites

Make all scripts executable:
```bash
chmod +x *.sh
```

---

## Example 1: Parameter Sweep with Job Arrays

**Use Case:** Test your program with different parameter values

**Files:**
- `01_parameter_sweep.sh` - Job array that runs with 5 different parameters

**How to Run:**
```bash
# Submit the job array
sbatch 01_parameter_sweep.sh

# Check status
squeue -u $USER

# View results
ls results/param_*
cat results/param_*.out
```

**What it does:**
- Runs 5 jobs in parallel (array tasks 1-5)
- Each task uses a different parameter value (0.1, 0.5, 1.0, 2.0, 5.0)
- Each task produces its own output file
- Good for: testing parameters, hyperparameter tuning, sensitivity analysis

**Key Concept:** `--array=1-5` creates 5 jobs, each with unique `$SLURM_ARRAY_TASK_ID`

---

## Example 2: Process Multiple Input Files

**Use Case:** Process several data files in parallel

**Files:**
- `02a_generate_input_files.sh` - Creates 5 sample input files
- `02b_process_files.sh` - Job array that processes all files

**How to Run:**
```bash
# Step 1: Generate input files
bash 02a_generate_input_files.sh

# Step 2: Submit processing job array
sbatch 02b_process_files.sh

# Check status
squeue -u $USER

# View results
cat results/processed_*.txt
```

**What it does:**
- Creates 5 input files (data_1.txt through data_5.txt)
- Processes all 5 files in parallel using a job array
- Each array task processes one file
- Calculates statistics for each file
- Good for: batch processing, parallel data analysis

**Key Concept:** Each task uses `$SLURM_ARRAY_TASK_ID` to select its input file

---

## Example 3: Job Dependencies (3-Stage Pipeline)

**Use Case:** Chain multiple jobs where each depends on the previous

**Files:**
- `03a_stage1_generate.sh` - Stage 1: Generate data
- `03b_stage2_process.sh` - Stage 2: Process data (array job)
- `03c_stage3_combine.sh` - Stage 3: Combine results
- `03d_submit_pipeline.sh` - Submits entire pipeline

**How to Run:**

**Option A: Automatic (Recommended)**
```bash
# Submit entire pipeline at once
bash 03d_submit_pipeline.sh

# Monitor progress
squeue -u $USER
watch -n 5 'squeue -u $USER'

# View final report when complete
cat pipeline/final_report.txt
```

**Option B: Manual (for learning)**
```bash
# Stage 1: Generate data
JOB1=$(sbatch --parsable 03a_stage1_generate.sh)
echo "Stage 1 Job ID: $JOB1"

# Stage 2: Process data (waits for Stage 1)
JOB2=$(sbatch --parsable --dependency=afterok:$JOB1 03b_stage2_process.sh)
echo "Stage 2 Job ID: $JOB2"

# Stage 3: Combine results (waits for Stage 2)
JOB3=$(sbatch --parsable --dependency=afterok:$JOB2 03c_stage3_combine.sh)
echo "Stage 3 Job ID: $JOB3"

# Check the pipeline
squeue -u $USER
```

**What it does:**
1. **Stage 1**: Generates 3 data files
2. **Stage 2**: Processes all 3 files in parallel (job array)
3. **Stage 3**: Combines all results into final report

**Key Concepts:**
- `--dependency=afterok:JOBID` - Job waits until previous job succeeds
- `--parsable` - Returns only the job ID for scripting
- Good for: multi-stage workflows, data pipelines

**Pipeline Flow:**
```
Stage 1 (1 job)
    ↓
Stage 2 (3 jobs in parallel)
    ↓
Stage 3 (1 job)
```

---

## Common Patterns

### Job Array Pattern
```bash
#SBATCH --array=1-N        # Creates N array tasks
```
Use `$SLURM_ARRAY_TASK_ID` in your script to differentiate tasks.

### Dependency Pattern
```bash
# Submit with dependency
sbatch --dependency=afterok:PREVIOUS_JOBID script.sh
```

### Capture Job ID Pattern
```bash
JOBID=$(sbatch --parsable script.sh)
```

---

## Troubleshooting

**Job stays in PD state:**
- Check available resources: `sinfo`
- Verify dependency jobs completed successfully
- Check if you have sufficient allocation

**Job fails immediately:**
- Check error file: `cat results/*.err`
- Verify input files exist
- Check file permissions

**Missing output files:**
- Ensure directories exist (scripts create them, but check)
- Verify jobs completed: `sacct -u $USER`
- Check error logs

---

## Modifying for Your Use

### For Parameter Sweeps:
1. Edit the `case` statement in `01_parameter_sweep.sh`
2. Add your parameter values
3. Replace the Python code with your actual program
4. Adjust `--array=1-N` for number of parameters

### For File Processing:
1. Change array range to match your number of files
2. Modify file naming pattern if needed
3. Replace processing code with your analysis

### For Pipelines:
1. Add/remove stages as needed
2. Adjust dependencies between stages
3. Modify what each stage does
4. Keep the `--dependency` pattern

---