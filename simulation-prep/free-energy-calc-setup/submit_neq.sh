#!/bin/bash

# run for 12 hours
#BSUB -W 24:00

# use no more than 16GB/thread-slot
#BSUB -R "rusage[mem=16]"

# use one thread-slot
#BSUB -n 1

# pack all thread-slots onto one node
#BSUB -R "span[ptile=1]"

# use the GPU queue
#BSUB -q gpuqueue

# use 1 GPU in shared mode (multiple contexts) exclusive to my job
#BSUB -gpu "num=1:mode=shared:mps=no:j_exclusive=yes"

# write stdout to this file
#BSUB -o %J.log

LIGAND=sndx
PHASE=complex
MUTATION=THR349MET

source activate perses

python scripts/run_neq_complex.py -i htfs-cpu-try2/${LIGAND}/${MUTATION} -o neqs/${LIGAND}/${MUTATION} -p ${PHASE} -c $LSB_JOBINDEX


