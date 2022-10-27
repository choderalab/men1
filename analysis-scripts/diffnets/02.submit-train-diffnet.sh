#!/usr/bin/env bash
# Set walltime limit
#BSUB -W 168:00
#
# Set output file
#BSUB -o  equil.log
#BSUB -e error-%J.log
#
# Specify node group
#BSUB -m "lg-gpu lt-gpu lp-gpu ld-gpu lv-gpu lx-gpu ly-gpu lu-gpu"
#BSUB -q gpuqueue
#
# nodes: number of nodes and GPU request (ptile: number of processes per node)
#BSUB -n 1 -R "rusage[mem=30] span[ptile=1]"
#BSUB -gpu "num=1:j_exclusive=yes:mode=shared"
#
# job name (default = name of script file)
#BSUB -J "diffnet-train-apo"
#
# source my environment variables in ~/.bashrc
source ~/.bashrc

# activate my conda environment
conda activate diffnets

module add cuda/10.2

CONFIG_1="/data/chodera/sukrit/menin/diffnets/apo-wt-g331d/train_config.yml"

python -u /home/singhs15/src/diffnets/diffnets/cli/main.py train $CONFIG_1

sleep 1
