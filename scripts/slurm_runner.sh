#!/bin/bash
# ============================================================
# G12 Fashion-MNIST: Single GPU Experiment By Model (Rivanna/Afton)
# ============================================================
# Assumptions (You are logged onto a Rivanna terminal and are in the ${USER}/development/DS6050_G12_PROJECT directory):
#
# Usage:
#   cd ~/DS6050/Project
#   sbatch slurm/run_model.slurm configs/{YOUR_SELECTED_MODEL}.yaml
#
# Monitor:
#   squeue -u $USER              # Check queue status
#   scancel JOB_ID               # Cancel a specific job
#   seff JOB_ID                  # Efficiency report after completion
#   cat logs/g12_JOBID.out       # Read stdout
# ============================================================

set -e

# Check for required selected model
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <your_selected_model>"
    exit 1
fi

# Get the requested model
SELECTED_MODEL=$1

echo "============================================"
echo "You are preparing to execute run_model.slurm for model: ${SELECTED_MODEL}"
echo "============================================"

# ---- Read Config ----
CONFIG_FILE=~/development/DS6050_G12_PROJECT/configs/${SELECTED_MODEL}
echo "Config:        $CONFIG_FILE"

# ---- Run SLURM ----
#sbatch -p gpu-a6000 --gres=gres/gpu:1 ~/development/DS6050_G12_PROJECT/slurm/run-model.slurm ${CONFIG_FILE}
sbatch slurm/run-model.slurm ${CONFIG_FILE}

EXIT_CODE=$?
echo "============================================"
echo "End time:      $(date)"
echo "Exit code:     $EXIT_CODE"
echo "============================================"
exit $EXIT_CODE
