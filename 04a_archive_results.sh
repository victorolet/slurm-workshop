#!/bin/bash
# archive_results.sh - Archive SLURM results to Acacia
# How to run - ./archive_results.sh stage01_results/ param_sweep

# Configuration
BUCKET="username-slurm-workshop"
RESULTS_DIR="$1"  # Pass as argument
ARCHIVE_NAME="$2" # Pass as argument

# Create timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create archive
echo "Creating archive..."
tar -czf ${ARCHIVE_NAME}_${TIMESTAMP}.tar.gz $RESULTS_DIR

# Upload to Acacia with parallel transfers
echo "Uploading to Acacia..."
rclone copy ${ARCHIVE_NAME}_${TIMESTAMP}.tar.gz \
    acacia:${BUCKET}/archives/ \
    --transfers=8 \
    --progress

# Verify upload
echo "Verifying upload..."
rclone ls acacia:${BUCKET}/archives/ | grep ${ARCHIVE_NAME}

echo "Archive complete!"