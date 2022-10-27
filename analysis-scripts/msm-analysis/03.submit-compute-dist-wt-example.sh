#!/bin/bash
# PROJECT DESCRIPTION GOES HERE 

# WALL TIME REQUESTED
#BSUB -W 168:00

# MEMORY USAGE - 8 GB/CPU is THIS SETTING
#BSUB -R "rusage[mem=8]"

# NUMBER OF TASKS RUNNING IN PARALLEL - DEFAULT IS 1 AT A TIME
#BSUB -n 24

# HOW MANY CORES PER TASK USED - SPECIFICY PTILE
#BSUB -R "span[ptile=24]"

# SPECIFY CPU-QUEUE
#BSUB -q cpuqueue

# LOG OUTPUT NAME
#BSUB -o %J.cpu-output.out
#BSUB -e %J.error.err

# SUBMIT JOB NAME
#BSUB -J "dist-wt-apo"

echo "Job $JOBID/$NJOBS"
echo "LSB_HOSTS: $LSB_HOSTS"

# SOURCE MY BASHRC
source ~/.bashrc

# ACTIVATE ENVIRONMENT
conda activate msm
export PREFIX="ras_shared"
let JOBID=$LSB_JOBINDEX-1

# Run the thing
export OMP_NUM_THREADS=24
export NUMEXPR_MAX_THREADS=24
export TMPDIR="./scratch"

SELECTION='protein and chainid 0 and backbone and element S P O N C'
CENTERS_IN='/home/singhs15/data/menin/clustering/shared_backbone_ss1_apo_wt_0.207/centers.pickle'

PROTEIN_1='wt-apo'
TRAJS_1='/home/singhs15/data/menin/trajs/16472/*.h5'
TOP_1="/home/singhs15/data/menin/strucs/struc-16472-r0.pdb"
SELECTION_1="$SELECTION"

MEM_FRAC='0.5'
OUTPUT_PATH=$PROTEIN_1'_'$RADIUS
OUTPUT_ASSIGNMENTS=$OUTPUT_PATH'_assignments.h5'
OUTPUT_DIST=$OUTPUT_PATH'_dists.h5'

# G334-CA to #Y366-CA

# go!
python /home/singhs15/scripts/compute-atom-pair-dists.py \
-d /home/singhs15/data/menin/trajs/16472 \
-f h5 \
-n 24 \
-t /home/singhs15/data/menin/strucs/struc-16472-r0.pdb \
-fa 5214 \
-sa 5727 \
-o wt-apo-c334-y366-dist \


sleep 1

