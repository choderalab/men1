"""
This script aggregates the results of free energy calculations with Perses and NEQ.
"""
import pandas as pd


mutations = ['MET327VAL', 'MET327ILE', 'GLY331ARG', 'GLY331ASP', 'THR349MET']
ligands = ["sndx"]

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
