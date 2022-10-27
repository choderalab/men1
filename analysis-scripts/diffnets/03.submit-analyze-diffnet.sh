#!/bin/bash
# PROJECT DESCRIPTION GOES HERE 

# WALL TIME REQUESTED
#BSUB -W 72:00

# MEMORY USAGE - 8 GB/CPU is THIS SETTING
#BSUB -R "rusage[mem=8]"

# NUMBER OF TASKS RUNNING IN PARALLEL - DEFAULT IS 1 AT A TIME
#BSUB -n 30

# HOW MANY CORES PER TASK USED - SPECIFICY PTILE
#BSUB -R "span[ptile=30]"

# SPECIFY CPU-QUEUE
#BSUB -q cpuqueue

# LOG OUTPUT NAME
#BSUB -o %J.cpu-output.out

# SUBMIT JOB NAME
#BSUB -J "menin-apo-analyze"

echo "Job $JOBID/$NJOBS"
echo "LSB_HOSTS: $LSB_HOSTS"

# SOURCE MY BASHRC
source ~/.bashrc

# ACTIVATE ENVIRONMENT
conda activate diffnets
export PREFIX="menin_shared"
let JOBID=$LSB_JOBINDEX-1

PROTEIN_1='menin'
TRAJS_1='/data/chodera/sukrit/menin/diffnets/wt-apo-sndx/traj_list_h5_pair_docs-like.npy'
TOP_1="/data/chodera/sukrit/menin/diffnets/wt-apo-sndx/pdb_fn_pair_list.npy"
ATOMS_1="/data/chodera/sukrit/menin/diffnets/wt-apo-sndx/menin_backbone_atom_list_pair.npy"
OUTDIR_1="/data/chodera/sukrit/menin/diffnets/wt-apo-sndx/processed-dirs"

DATA_DIR='/data/chodera/sukrit/menin/diffnets/apo-wt-g331d/processed-dirs'
NET_DIR='/data/chodera/sukrit/menin/diffnets/apo-wt-g331d/sae_e10_lr0001_lat50_rep0_em'

python -u /home/singhs15/src/diffnets/diffnets/cli/main.py analyze $DATA_DIR $NET_DIR 

sleep 1