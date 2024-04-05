#!/bin/bash

# Create a new conda environment for local testing of the ColabFold notebook.

conda create -n localcolabfold -y

# Activate the new environment.
source activate localcolabfold

echo $CONDA_PREFIX

# Install the required packages.
conda install -c conda-forge -c bioconda python=3.10 openmm=7.7.0 pdbfixer kalign2=2.04 hhsuite=3.3.0 mmseqs2=15.6f452 -y

# # Go the location of environment.
cd $CONDA_PREFIX

# Load the CUDA module.
module load cuda

# Check the nvcc version.
nvcc --version

# colabfold github package
pip install --no-warn-conflicts "colabfold @ git+https://github.com/sokrypton/ColabFold"

# Install jax and colabfold
pip install --upgrade "jax[cuda12_pip]==0.4.23" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
pip install "colabfold[alphafold]"

# Install tensorflow.
pip install --upgrade tensorflow[and-cuda]
pip install silence_tensorflow

# Edit the scripts to match the local environment configuration.
pushd "$CONDA_PREFIX/lib/python3.10/site-packages/colabfold"
sed -i -e "s#from matplotlib import pyplot as plt#import matplotlib\nmatplotlib.use('Agg')\nimport matplotlib.pyplot as plt#g" plot.py
sed -i -e "s#appdirs.user_cache_dir(__package__ or \"colabfold\")#\"${CONDA_PREFIX}/colabfold\"#g" download.py
sed -i -e "s#from io import StringIO#from io import StringIO\nfrom silence_tensorflow import silence_tensorflow\nsilence_tensorflow()#g" batch.py
rm -rf __pycache__
popd

# Download the weights.
python3 -m colabfold.download
exit