
import argparse
import os

import json

def get_edgelist(file):
    with open(file, 'r') as G:
        data = json.load(G)
    edgelist = []
    for edge in data['edges']:
        source = edge['data']['source']
        target = edge['data']['target']
        edgelist.append(f"{source} {target}")
    return edgelist

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("folder", type=str)
    args = parser.parse_args()
    source_folder = "../raw-data/" + args.folder
    target_folder = "../data/" + args.folder
    if not os.path.exists(target_folder):
        os.makedirs(target_folder)
    source_files = sorted(
        [f for f in os.listdir(source_folder) if f.endswith(".cy")]
    )
    for file in source_files:
        edgelist = get_edgelist(f"{source_folder}/{file}")
        with open(f"{target_folder}/{file.replace('.cy','')}.txt", 'w') as f:
            f.write('\n'.join(edgelist))
