#!/bin/bash
# PROJECT DESCRIPTION GOES HERE 

# WALL TIME REQUESTED
#BSUB -W 168:00

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
#BSUB -e %J.error.err

# SUBMIT JOB NAME
#BSUB -J "reAssign-wt-sndx"

echo "Job $JOBID/$NJOBS"
echo "LSB_HOSTS: $LSB_HOSTS"

# SOURCE MY BASHRC
source ~/.bashrc

# ACTIVATE ENVIRONMENT
conda activate msm
export PREFIX="ras_shared"
let JOBID=$LSB_JOBINDEX-1

# Run the thing
export OMP_NUM_THREADS=30
export NUMEXPR_MAX_THREADS=30
export TMPDIR="./scratch"

SELECTION='protein and chainid 0 and backbone and element S P O N C'
CENTERS_IN='/home/singhs15/data/menin/clustering/shared_backbone_ss1_apo_wt_0.207/centers.pickle'
RADIUS=0.18

PROTEIN_1='wt-sndx'
TRAJS_1='/home/singhs15/data/menin/trajs/16476/*.h5'
TOP_1="/home/singhs15/data/menin/strucs/struc-16476-r0.pdb"
SELECTION_1="$SELECTION"

MEM_FRAC='0.5'
OUTPUT_PATH=$PROTEIN_1'_'$RADIUS
OUTPUT_ASSIGNMENTS=$OUTPUT_PATH'_assignments.h5'
OUTPUT_DIST=$OUTPUT_PATH'_dists.h5'

# go!
python -u /home/singhs15/src/enspara/enspara/apps/reassign.py \
  --trajectories $TRAJS_1 \
  --topology $TOP_1 \
  --atoms "$SELECTION_1" \
  --centers $CENTERS_IN \
  --output-path $OUTPUT_PATH \
  --mem-fraction 0.5 \
  --distances $OUTPUT_DIST \
  --assignments $OUTPUT_ASSIGNMENTS \


sleep 1


