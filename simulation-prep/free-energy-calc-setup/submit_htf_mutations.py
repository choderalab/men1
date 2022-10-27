#!/bin/bash

# run for 4 hours
#BSUB -W 4:00

# use no more than 8GB/thread-slot
#BSUB -R "rusage[mem=8]"

# use 1 thread-slots
#BSUB -n 1

# use the CPU queue
#BSUB -q cpuqueue

# write stdout to this file
#BSUB -o %J.htf.log

# run with https://github.com/choderalab/perses/commit/c790a780a20367c7415a86d50879e0983456d92b

MUTATIONS=('MET327VAL' 'MET327ILE' 'GLY331ARG' 'GLY331ASP' 'THR349MET')
#LIGAND_NAME=imatinib
#PROTEIN_FILE=data/kinoml_OEKLIFSKinaseHybridDockingFeaturizer_ABL1_2hyy_chainC_altloc-_imatinib_protein.pdb
#LIGAND_FILE=data/kinoml_OEKLIFSKinaseHybridDockingFeaturizer_ABL1_2hyy_chainC_altloc-_imatinib_ligand_+1.sdf
LIGAND_NAME=sndx
PROTEIN_FILE=data/wt-start-struc.pdb
LIGAND_FILE=data/sndx-docked-pose.sdf

i=$(expr $LSB_JOBINDEX - 1)

# SOURCE MY BASHRC
source ~/.bashrc
module load cuda/10.2
conda activate perses

python scripts/setup_mutation_htf.py -o htfs/${LIGAND_NAME}/${MUTATIONS[i]} -p ${PROTEIN_FILE} -l ${LIGAND_FILE} -m ${MUTATIONS[i]}

