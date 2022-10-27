"""
This script aggregates the results of free energy calculations with Perses and NEQ.
"""
import pandas as pd


mutations = [
    'MET244VAL', 'LEU248ARG', 'LEU248VAL', 'GLY250GLU', 'GLY250ARG', 'GLY251ASP', 'GLY251GLU',
    'GLN252GLU', 'GLN252HIS', 'GLN252LYS', 'GLN252MET', 'GLN252ARG', 'TYR253PHE', 'TYR253HIS',
    'GLU255LYS', 'GLU255VAL', 'VAL256LEU', 'VAL268ALA', 'LEU273MET', 'GLU275LYS', 'ASP276ALA',
    'ASP276GLY', 'THR277ALA', 'GLU279LYS', 'GLU279TYR', 'GLU281LYS', 'GLU282GLY', 'GLU282LYS',
    'VAL289ALA', 'VAL289PHE', 'GLU292VAL', 'LEU298PHE', 'VAL299LEU', 'PHE311LEU', 'THR315ALA',
    'THR315ILE', 'THR315ASN', 'PHE317CYS', 'PHE317ILE', 'PHE317LEU', 'PHE317THR', 'PHE317VAL',
    'TYR320CYS', 'LEU324GLN', 'ASP325GLY', 'ARG328MET', 'VAL338PHE', 'MET343THR', 'MET351LYS',
    'MET351THR', 'GLU352ASP', 'GLU352GLY', 'TYR353HIS', 'GLU355ALA', 'GLU355GLY', 'PHE359ALA',
    'PHE359CYS', 'PHE359ILE', 'PHE359VAL', 'LEU364ILE', 'ASN368SER', 'ASN374TYR', 'LYS378ARG',
    'VAL379ILE', 'LEU384MET', 'LEU387PHE', 'LEU387MET', 'MET388LEU', 'HIE396ARG', 'GLY398ARG',
    'SER417TYR', 'ILE418VAL', 'LYS419GLU', 'SER438CYS', 'ASP444TYR', 'GLU450ALA', 'GLU450GLY',
    'GLU450LYS', 'GLU453ALA', 'GLU453ASP', 'GLU453GLY', 'GLU453LEU', 'GLU459GLY', 'GLU459LYS',
    'GLU459GLN', 'ASP482VAL', 'PHE486SER', 'GLU494GLY', 'THR495ARG'
]
ligands = ["imatinib", "dasatinib"]

for ligand in ligands:
    print(ligand)
    results = {}
    for mutation in mutations:
        print(mutation)
        with open(f"../neqs/{ligand}/{mutation}/ddg.txt", "r") as file:
            result = file.read()
            print(result)
            results[mutation] = (float(result.split(" ")[1]), float(result.split(" ")[3]))

    results = pd.DataFrame.from_dict(results, orient="index", columns=["DDG", "dDDG"])
    results.to_csv(f"../data/neq_results_{ligand}.csv")
print("Finished!")
