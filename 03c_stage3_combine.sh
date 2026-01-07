#!/bin/bash
#SBATCH --job-name=stage03c_combine
#SBATCH --account=courses01
#SBATCH --partition=work
#SBATCH --output=stage03_pipeline/stage3_%j.out
#SBATCH --error=stage03_pipeline/stage3_%j.err
#SBATCH --time=00:05:00
#SBATCH --ntasks=1
#SBATCH --mem=1G

# module loads 
module load python/3.11.6

# This job should only run AFTER all stage 2 array tasks complete
# Submit with: sbatch --dependency=afterok:JOBID_STAGE2 03c_stage3_combine.sh

FINAL_REPORT="stage03_pipeline/final_report.txt"

echo "================================"
echo "STAGE 3: Combine Results"
echo "Job ID: $SLURM_JOB_ID"
echo "Started at: $(date)"
echo "================================"

# Check that all result files exist
MISSING=0
for i in {1..3}; do
    if [ ! -f "stage03_pipeline/results/result_${i}.txt" ]; then
        echo "ERROR: Missing result_${i}.txt"
        MISSING=1
    fi
done

if [ $MISSING -eq 1 ]; then
    echo "ERROR: Not all result files are present!"
    exit 1
fi

# Combine all results into final report
python3 << EOF
import os
from datetime import datetime

# Create final report
with open('$FINAL_REPORT', 'w') as final:
    final.write("="*50 + "\\n")
    final.write("FINAL ANALYSIS REPORT\\n")
    final.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\\n")
    final.write("="*50 + "\\n\\n")
    
    # Read and combine all individual results
    all_means = []
    
    for i in range(1, 4):
        result_file = f'stage03_pipeline/results/result_{i}.txt'
        
        final.write(f"\\n--- Dataset {i} ---\\n")
        
        with open(result_file, 'r') as f:
            content = f.read()
            final.write(content)
            
            # Extract mean for overall statistics
            for line in content.split('\\n'):
                if line.startswith('Mean:'):
                    mean_val = float(line.split(':')[1].strip())
                    all_means.append(mean_val)
    
    # Overall statistics
    final.write("\\n" + "="*50 + "\\n")
    final.write("OVERALL SUMMARY\\n")
    final.write("="*50 + "\\n")
    final.write(f"Total datasets processed: 3\\n")
    final.write(f"Average of all means: {sum(all_means)/len(all_means):.4f}\\n")

print("Final report generated successfully!")
EOF

echo ""
echo "Pipeline complete!"
echo "Final report saved to: $FINAL_REPORT"
echo ""
echo "Report contents:"
echo "================================"
cat $FINAL_REPORT
echo "================================"
echo ""
echo "Finished at: $(date)"
