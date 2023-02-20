
## 2023-02-19 - ResFinder troubleshooting

ResFinder fails when the input is FASTQ (instead of assembly FASTA) _and_
the point-mutation option is used -- this seems to be a bug.
Work-around is to just use and assembly FASTA file.

```bash
# Try ResFinder manually - with FASTA
for asm in "$asm_dir"/*fasta; do
    outdir=results/resfinder2/$(basename "$asm" .fasta)
    sbatch scripts/resfinder.sh "$asm" "$outdir"
done

# Try ResFinder manually - with FASTQ #! ERROR - Open issue
for R1 in "$fq_dir"/*_R1.fastq.gz; do
    R2=${R1/_R1./_R2.}
    outdir=results/resfinder_fq/$(basename "$R1" _R1.fastq.gz)
    sbatch scripts/resfinder_fq.sh "$R1" "$R2" "$outdir"
done
```

## 2022-10-20 - GHRU MLST pipeline troubleshooting

- This pipeline uses the MLST calling functionality of ARIBA.
- ARIBA Documentation: https://github.com/sanger-pathogens/ariba/wiki/MLST-calling-with-ARIBA

- **The container failed, so I used a Conda environment**
- **I added a process `GET_ARIBA_DB` to download the ARIBA DB, since it was using a DB in the container**

- Testing ARIBA program manually:

```bash
conda activate /fs/project/PAS0471/jelmer/conda/ariba-2.14.6

## Download the db for a specific species
ariba pubmlstget "Salmonella enterica" get_mlst

## Run the MLST typing
R1=data/example/AG21-0050_S8_L001_R1_001.fastq.gz
R2=data/example/AG21-0050_S8_L001_R2_001.fastq.gz
#ariba run <ref-db-dir> <R1> <R2> <outdir>
ariba run results/ariba_mlst_db/ref_db "$R1" "$R2" MLST_TEST
```

----

## 2022-10-19 - Bactopia troubleshooting

- Switching from `module load python` to `module load miniconda3` solved a problem
  with the the `conda` command not being exported.

- Annoyingly, Bactopia modified resource maxima, seemingly based on what's
  available in the compute node that the main Bactopia process was running on.
  It was reporting `[cpus/memory] was adjusted to fit your system` etc.
  To fix this,
  **I commented out calls to `_get_max_memory` and ` _get_max_cpus` in the `functions.nf`**
  **file inside `/fs/project/PAS0471/jelmer/conda/bactopia/share/bactopia-2.1.x/lib/nf/functions.nf`**

```bash
grep -nr "was adjusted to fit your system" /fs/project/PAS0471/jelmer/conda/bactopia/share/bactopia-2.1.x/
#> /fs/project/PAS0471/jelmer/conda/bactopia/share/bactopia-2.1.x/lib/nf/functions.nf:115:        log.warn "Maximum memory (${requested}) was adjusted to fit your system (${available})"
#> /fs/project/PAS0471/jelmer/conda/bactopia/share/bactopia-2.1.x/lib/nf/functions.nf:126:        log.warn "Maximum CPUs (${requested}) was adjusted to fit your system (${available})"
```

- For unclear reasons, some of the container downloading/building was failing.
  I downloaded 2 outside of the workflow using the commands shown by the error
  messages, and putting them in the standard container dir:

```bash
singularity pull --name /fs/project/PAS0471/containers/quay.io-bactopia-annotate_genome-2.1.1.img docker://quay.io/bactopia/annotate_genome:2.1.1
```

-----

## 2022-10-18 - GHRU Assembly pipeline troubleshooting

- I commented out the failing `kat` command in process `genome_size_estimation` and replaced
  the `minima` variable with a hardcoded value of `3`, as per Bactopia in
  <https://github.com/bactopia/bactopia/blob/master/modules/local/bactopia/gather_samples/main.nf>.

- Changed `confindr.py` command in `check_for_contamination`.
  Got error:
  > Failed to open FASTA index /home/bio/software_data/confindr_database/Salmonella_db_cgderived.fasta.fai : Read-only file system"
  > "Could not build fai index /home/bio/software_data/confindr_database/Salmonella_db_cgderived.fasta.fai"
  
  Removed `-d` argument, since databases are not needed for Salmonella, see <https://github.com/OLC-Bioinformatics/ConFindr>
  See also <https://olc-bioinformatics.github.io/ConFindr/install/#downloading-confindr-databases>

- Added `publishDir` directives to `genome_size_estimation` and `species_identification` (bactinspector)

