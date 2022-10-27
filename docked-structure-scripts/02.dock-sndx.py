"""
This script was used to dock the compound SNDX-5613 into the PDB entry 6PKC that
was already prepared using the prepare_complex.py script.
The following package versions were used:
KinoML (https://github.com/openkinome/kinoml/commit/270fae0191a6ed4d202d870fbf30e39574712d58)
OpenEye toolkit 2020.2.4
"""
from kinoml.docking.OEDocking import create_hybrid_receptor, pose_molecules
from kinoml.modeling.OEModeling import (
    read_molecules,
    read_smiles,
    remove_non_protein,
    write_molecules
)

print("Reading molecules ...")
structure = read_molecules("../data/6pkc_protein_prep.pdb")[0]
ligand = read_molecules("../data/6pkc_ligand_prep.sdf")[0]
sndx_smiles = "CCN(C(C)C)C(=O)C1=C(C=CC(=C1)F)OC2=CN=CN=C2N3CC4(C3)CCN(CC4)CC5CCC(CC5)NS(=O)(=O)CC"  # from PubChem
sndx_molecule = read_smiles(sndx_smiles)

print("Extracting protein ...")
protein = remove_non_protein(structure, remove_water=True)

print("Creating hybrid receptor ...")
hybrid_receptor = create_hybrid_receptor(protein, ligand)

print("Posing molecule ...")
sndx_pose = pose_molecules(hybrid_receptor, [sndx_molecule])[0]

print("Writing docking pose ...")
write_molecules([sndx_pose], "../data/6pkc_sndx_docking_pose.sdf")

print("Finished!")
