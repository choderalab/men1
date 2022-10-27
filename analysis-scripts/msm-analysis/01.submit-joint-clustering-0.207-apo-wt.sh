#!/bin/bash
# PROJECT DESCRIPTION GOES HERE 

# WALL TIME REQUESTED
#BSUB -W 168:00

# MEMORY USAGE - 8 GB/CPU is THIS SETTING
#BSUB -R "rusage[mem=10]"

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
#BSUB -J "cluster-menin-0.207"

echo "Job $JOBID/$NJOBS"
echo "LSB_HOSTS: $LSB_HOSTS"

# SOURCE MY BASHRC
source ~/.bashrc

# ACTIVATE ENVIRONMENT
conda activate msm
export PREFIX="menin_shared"
let JOBID=$LSB_JOBINDEX-1

# Run the thing
export OMP_NUM_THREADS=30
export NUMEXPR_MAX_THREADS=30
export TMPDIR="./scratch"

# submit with:
# qsub -pe smp $( maxnode all ) scripts/submit/cluster.sh

# for high-memory jobs:
# qsub -pe smp 24 -q all.q@node09 scripts/submit/cluster.sh

PROTEIN='menin_shared'
RADIUS='0.207'
NSLOTS='30'
# SUBSAMPLE='10'

SELECTION_NAME='shared_backbone'
SELECTION='protein and chainid 0 and backbone and element S P O N C'
#SELECTION='name C or name O or name CA or name N'
ALGORITHM='khybrid'

PROTEIN_1='wt-apo'
TRAJS_1='/home/singhs15/data/menin/trajs/16472/*.h5'
TOP_1="/home/singhs15/data/menin/strucs/struc-16472-r0.pdb"
SELECTION_1="$SELECTION"

PROTEIN_2='m327v-apo'
TRAJS_2='/home/singhs15/data/menin/trajs/16473/*.h5'
TOP_2="/home/singhs15/data/menin/strucs/struc-16473-r0.pdb"
SELECTION_2="$SELECTION"


PROTEIN_3='m327i-apo'
TRAJS_3='/home/singhs15/data/menin/trajs/16474/*.h5'
TOP_3="/home/singhs15/data/menin/strucs/struc-16474-r0.pdb"
SELECTION_3="$SELECTION"

PROTEIN_4='g331r-apo'
TRAJS_4='/home/singhs15/data/menin/trajs/16475/*.h5'
TOP_4="/home/singhs15/data/menin/strucs/struc-16475-r0.pdb"
SELECTION_4="$SELECTION"

PROTEIN_5='g331d-apo'
TRAJS_5='/home/singhs15/data/menin/trajs/16484/*.h5'
TOP_5="/home/singhs15/data/menin/strucs/struc-16484-r0.pdb"
SELECTION_5="$SELECTION"

PROTEIN_6='t349m-apo'
TRAJS_6='/home/singhs15/data/menin/trajs/16486/*.h5'
TOP_6="/home/singhs15/data/menin/strucs/struc-16486-r0.pdb"
SELECTION_6="$SELECTION"

PROTEIN_7='wt-sndx'
TRAJS_7='/home/singhs15/data/menin/trajs/16476/*.h5'
TOP_7="/home/singhs15/data/menin/strucs/struc-16476-r0.pdb"
SELECTION_7="$SELECTION"

PROTEIN_8='m327v-sndx'
TRAJS_8='/home/singhs15/data/menin/trajs/16477/*.h5'
TOP_8="/home/singhs15/data/menin/strucs/struc-16477-r0.pdb"
SELECTION_8="$SELECTION"

PROTEIN_8='m327i-sndx'
TRAJS_8='/home/singhs15/data/menin/trajs/16478/*.h5'
TOP_8="/home/singhs15/data/menin/strucs/struc-16478-r0.pdb"
SELECTION_8="$SELECTION"

PROTEIN_9='g331r-sndx'
TRAJS_9='/home/singhs15/data/menin/trajs/16479/*.h5'
TOP_9="/home/singhs15/data/menin/strucs/struc-16479-r0.pdb"
SELECTION_9="$SELECTION"

PROTEIN_10='g331d-sndx'
TRAJS_10='/home/singhs15/data/menin/trajs/16485/*.h5'
TOP_10="/home/singhs15/data/menin/strucs/struc-16485-r0.pdb"
SELECTION_10="$SELECTION"

PROTEIN_11='g331d-sndx'
TRAJS_11='/home/singhs15/data/menin/trajs/16487/*.h5'
TOP_11="/home/singhs15/data/menin/strucs/struc-16487-r0.pdb"
SELECTION_11="$SELECTION"



# output options
#PLOT_PATH='figures/implied'
#REASSIGN_BOOL='False'
OUTPUT_PATH='shared_backbone_ss1_apo_wt_'$RADIUS
#TAG=$PROTEIN-$SELECTION_NAME-$SUBSAMPLE'subsample'
OUTPUT_DIST=$OUTPUT_PATH'/dists.h5'
OUTPUT_CENTERS=$OUTPUT_PATH'/centers.pickle'
OUTPUT_ASSIGNMENTS=$OUTPUT_PATH'/assignments.h5'
OUTPUT_CENTERS_INDS=$OUTPUT_PATH'/center-indices.pickle'

# steal the output
#exec &> log/$TAG-$ALGORITHM-"$RADIUS"-cluster-$JOB_ID.log

## activate conda environment
#source activate std

mkdir -p $OUTPUT_PATH

# mpiexec python -u hello.py

# echo foo


# go!
python -u /home/singhs15/src/enspara/enspara/apps/cluster.py \
  --trajectories "$TRAJS_1" \
  --topology $TOP_1 \
  --atoms "$SELECTION_1" \
  --algorithm $ALGORITHM \
  --cluster-radius $RADIUS \
  --subsample 1 \
  --distances $OUTPUT_DIST \
  --center-indices $OUTPUT_CENTERS_INDS \
  --center-features $OUTPUT_CENTERS \
  --assignments $OUTPUT_ASSIGNMENTS \


#  --no-reassign \

sleep 1
