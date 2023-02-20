#!/bin/bash

# setup.sh - setting up the project, e.g. software installation 

# Get the initial GHRU workflows
git clone https://gitlab.com/cgps/ghru/pipelines/assembly.git workflows/ghru_assembly
git clone https://gitlab.com/cgps/ghru/pipelines/snp_phylogeny workflows/ghru_snp_phylogeny
git clone https://gitlab.com/cgps/ghru/pipelines/mlst workflows/ghru_mlst
git clone https://gitlab.com/cgps/ghru/pipelines/amr_prediction workflows/ghru_amr_prediction
git clone https://gitlab.com/cgps/ghru/pipelines/ariba workflows/ghru_ariba

# 2022-10-22 - Copy and rename Samantha's FASTQ files
cp -r /fs/project/PAS0471/aarevalo/fastqs data/fastq/samantha_original data/fastq/samantha_renamed

mv -v "data/fastq/samantha_renamed/GHabing001_120_R118_S101_R2_001.fastq - Copy.gz" data/fastq/samantha_renamed/GHabing001_120_R118_S101_R2_001.fastq.gz
mv -v "data/fastq/samantha_renamed/GHabing001_121_R118_S102_R1_001.fastq - Copy.gz" data/fastq/samantha_renamed/GHabing001_121_R118_S102_R1_001.fastq.gz

for fastq in data/fastq/samantha_renamed/*; do
    newname=$(echo $fastq | sed -E -e 's/GHabing001_//' -e 's/_001//' -e 's/_S[0-9]+//')
    mv -v "$fastq" "$newname"
done
