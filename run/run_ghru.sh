#!/bin/bash

# ==============================================================================
#                        RUN THE MODIFIED GHRU WORKLOWS
# ==============================================================================
# Input files and settings
fq_dir=$PWD/data/fastq/samantha_renamed
ref_genome=$PWD/data/ref/GCF_000210855.2_ASM21085v2_genomic.fna
species="Salmonella enterica"
ariba_db=card

# Wrapper script to run the workflows
assembly_script=$PWD/mcic-scripts/bact/ghru_assembly.sh
mlst_script=$PWD/mcic-scripts/bact/ghru_mlst.sh
ariba_script=$PWD/mcic-scripts/bact/ghru_ariba.sh
phylo_script=$PWD/mcic-scripts/bact/ghru_phylogeny.sh
bactfinder_script=$PWD/mcic-scripts/bact/nf_bactfinder.sh

# Output dirs for the workflows
assembly_outdir=$PWD/results/ghru_assembly
mlst_outdir=$PWD/results/ghru_mlst
ariba_outdir=$PWD/results/ghru_ariba
phylo_outdir=$PWD/results/ghru_phylo
bactfinder_outdir=$PWD/results/nf_bactfinder

# Assemblies will (tend to...) end up here - these are input for the finder workflow  
asm_dir="$assembly_outdir"/assemblies/warning

# Genome assembly
(mkdir -p "$assembly_outdir" && cd "$assembly_outdir" && \
    sbatch "$assembly_script" --indir "$fq_dir" --outdir .)

# MLST with ARIBA
(mkdir -p "$mlst_outdir" && cd "$mlst_outdir" && \
    sbatch "$mlst_script" --indir "$fq_dir" --species "$species" --outdir .)

# AMR prediction with ARIBA
(mkdir -p "$ariba_outdir" && cd "$ariba_outdir" && \
    sbatch "$ariba_script" --indir "$fq_dir" --db_name "$ariba_db" --outdir .)

# SNP phylogeny
(mkdir -p "$phylo_outdir" && cd "$phylo_outdir" && \
    sbatch "$phylo_script" --indir "$fq_dir" --reference "$ref_genome" --outdir .)

# Resfinder, Virulencefinder, and Plasmidfinder 
(mkdir -p "$bactfinder_outdir" && cd "$bactfinder_outdir" && \
    sbatch "$bactfinder_script" --indir "$asm_dir" --species "$species" --outdir .)


# ==============================================================================
#                        RUN OTHER SCRIPTS
# ==============================================================================
# SISTR
sbatch mcic-scripts/bact/sistr.sh --indir "$asm_dir" --outdir results/sistr
