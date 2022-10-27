#!/bin/bash

MUTATIONS=('MET327VAL' 'MET327ILE' 'GLY331ARG' 'GLY331ASP' 'THR349MET')
PHASES=('apo' 'complex')
LIGANDS=('sndx')

for mutation in "${MUTATIONS[@]}"; do
  for phase in "${PHASES[@]}"; do
    for ligand in "${LIGANDS[@]}"; do
      sed -i "24s/.*/LIGAND=${ligand}/" submit_neq.sh
      sed -i "25s/.*/PHASE=${phase}/" submit_neq.sh
      sed -i "26s/.*/MUTATION=${mutation}/" submit_neq.sh
      bsub -J "${ligand}_${phase}_${mutation}[1-100]" < submit_neq.sh
    done
  done
done


