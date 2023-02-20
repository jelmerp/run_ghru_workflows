# Info on running the modified GHRU workflows

- Use the code in the submission script `run/run_ghru.sh`.

- Check the options for each of the scripts below using the '-h' option:

```bash
bash mcic-scripts/bact/ghru_assembly.sh -h
bash mcic-scripts/bact/ghru_mlst.sh -h
bash mcic-scripts/bact/ghru_ariba.sh -h
bash workflows/mcic-scripts/bact/nf_bactfinder.sh --help
```

- Make sure to update your copy of the `mcic-scripts` repository by running:

```bash
cd mcic-scripts && git pull
```

- Or if you haven't downloaded the repository yet, run:

```bash
git clone https://github.com/mcic-osu/mcic-scripts.git
```

- There is no need to copy any other files!

- All of these workflows can be run simultaneously, since they all use raw FASTQ files of input

- In order to be able to run all workflows simultaneously, 
  each script is submitted from a different directory using a 'subshell' with '()'
