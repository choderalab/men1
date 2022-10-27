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
#BSUB -J "diffnet-proc-menin-apo"

echo "Job $JOBID/$NJOBS"
echo "LSB_HOSTS: $LSB_HOSTS"

# SOURCE MY BASHRC
source ~/.bashrc

# ACTIVATE ENVIRONMENT
conda activate diffnets
export PREFIX="menin_shared"
let JOBID=$LSB_JOBINDEX-1

PROTEIN_1='menin'
TRAJS_1='/data/chodera/sukrit/menin/diffnets/apo-wt-g331d/traj_list_h5_pair_docs-like.npy'
TOP_1="/data/chodera/sukrit/menin/diffnets/apo-wt-g331d/pdb_fn_pair_list.npy"
ATOMS_1="/data/chodera/sukrit/menin/diffnets/apo-wt-g331d/menin_backbone_atom_list_pair.npy"
OUTDIR_1="/data/chodera/sukrit/menin/diffnets/apo-wt-g331d/processed-dirs"

python -u /home/singhs15/src/diffnets/diffnets/cli/main.py process $TRAJS_1 $TOP_1 $OUTDIR_1 -a $ATOMS_1

sleep 1