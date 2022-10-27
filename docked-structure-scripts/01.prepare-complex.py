"""
This script was used to prepare the PDB entry 6PKC for MD simulations and
relative free energy calculations. The following package versions were used:
KinoML (https://github.com/openkinome/kinoml/commit/270fae0191a6ed4d202d870fbf30e39574712d58)
OpenEye toolkit 2020.2.4
"""
from openeye import oechem

from kinoml.core.sequences import AminoAcidSequence
from kinoml.features.complexes import OEKLIFSKinaseHybridDockingFeaturizer
from kinoml.modeling.OEModeling import (
    read_molecules,
    prepare_complex,
    delete_clashing_sidechains,
    delete_partial_residues,
    delete_short_protein_segments,
    apply_deletions,
    apply_mutations,
    renumber_structure,
    apply_insertions,
    assign_caps,
    remove_non_protein,
    update_residue_identifiers,
    write_molecules
)

print("Reading PDB file ...")
structure = read_molecules("../data/6pkc.pdb")[0]

print("Retrieving sequence from UniProt ...")
protein_sequence = AminoAcidSequence.from_uniprot("O00255")

print("Generating design unit ...")
design_unit = prepare_complex(structure, cap_termini=False)

print("Extracting components ...")
# used for extracting components, renumbering and assembling components
featurizer = OEKLIFSKinaseHybridDockingFeaturizer()
protein, solvent, ligand = featurizer._get_components(design_unit)

print(f"Deleting residues with clashing side chains ...")
protein = delete_clashing_sidechains(protein)

print("Deleting residues with missing atoms ...")
protein = delete_partial_residues(protein)

print("Deleting loose protein segments ...")
protein = delete_short_protein_segments(protein)

print("Applying deletions ...")
protein = apply_deletions(protein, protein_sequence)

print("Applying mutations ...")
protein = apply_mutations(protein, protein_sequence)

print("Renumbering residues ...")
residue_numbers = featurizer._get_kinase_residue_numbers(protein, protein_sequence)
protein = renumber_structure(protein, residue_numbers)

print("Applying insertions ...")
protein = apply_insertions(protein, protein_sequence, "~/.OpenEye/rcsb_spruce.loop_db")

print("Assigning caps ...")
protein = assign_caps(protein)

print("Assembling components ...")
protein_ligand_complex = featurizer._assemble_components(protein, solvent, ligand)
oechem.OEClearPDBData(protein_ligand_complex)
oechem.OESetPDBData(
    protein_ligand_complex,
    "COMPND",
    "\t6PKC"
)

print("Splitting components for seperate saving ...")
solvated_protein = remove_non_protein(protein_ligand_complex, remove_water=False)
split_options = oechem.OESplitMolComplexOptions()
ligand = list(oechem.OEGetMolComplexComponents(
    protein_ligand_complex, split_options, split_options.GetLigandFilter())
)[0]

print("Writing molecules ...")
write_molecules([solvated_protein], "../data/6pkc_protein_prep.pdb")
write_molecules([ligand], "../data/6pkc_ligand_prep.sdf")

print("Finished!")
