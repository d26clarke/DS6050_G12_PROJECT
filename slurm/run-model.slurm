#!/bin/bash
# ============================================================
# G12 Fashion-MNIST: Single GPU Experiment By Model (Rivanna/Afton)
# ============================================================
# Assumptions (You are logged onto a Rivanna terminal and are in the ${USER}/development/DS6050_G12_PROJECT directory):
#
#
#   # 1. This script will Request an interactive GPU session to install packages:
#   ijob -J setup -A shakeri_ds6050 -p gpu --gres=gpu:1 -t 01:00:00 --mem=8G -v
#
#   # 2. This script will Load Miniforge and install packages: 
#   module load miniforge/24.11.3-py3.12
#   pip install torch==2.9.0 torchvision==0.24.0 torchaudio==2.9.0 --index-url https://download.pytorch.org/whl/cu130
#   pip install pyyaml scikit-learn xgboost thop
#
#   # 3. This script will verify GPU:
#   python -c "import torch; print(torch.cuda.is_available()); print(torch.cuda.get_device_name(0))"
#
#   # 4. Create project directories:
#   mkdir -p ~/DS6050/Project/logs ~/DS6050/Project/results/curves
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

# Get the config file
CONFIG_FILE=$1

# ---- SLURM Directives ----
#SBATCH --job-name=g12_fmnist
#SBATCH --account=shakeri_ds6050
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --output=logs/g12_%j.out
#SBATCH --error=logs/g12_%j.err
#SBATCH --export=NONE

# ---- Step 1: Load Miniforge ----
echo "[1/1] Loading Miniforge..."
module purge
module load miniforge/24.11.3-py3.12

echo "  Python: $(which python)"
echo "  Version: $(python --version)"

# ---- Verify GPU ----
echo "============================================"
echo "Job ID:        $SLURM_JOB_ID"
echo "Node:          $SLURM_NODELIST"
echo "Partition:     $SLURM_JOB_PARTITION"
echo "Start time:    $(date)"
echo "--------------------------------------------"
echo "Python:        $(which python)"
echo "PyTorch:       $(python -c 'import torch; print(torch.__version__)')"
echo "CUDA avail:    $(python -c 'import torch; print(torch.cuda.is_available())')"
echo "GPU:           $(python -c 'import torch; print(torch.cuda.get_device_name(0) if torch.cuda.is_available() else "NONE")')"
echo "CUDA version:  $(python -c 'import torch; print(torch.version.cuda)')"
echo "============================================"

# ---- Run Experiment ----
python ~/development/DS6050_G12_PROJECT/scripts/train_models.py --config "$CONFIG_FILE"

EXIT_CODE=$?
echo "============================================"
echo "End time:      $(date)"
echo "Exit code:     $EXIT_CODE"
echo "============================================"
exit $EXIT_CODE
