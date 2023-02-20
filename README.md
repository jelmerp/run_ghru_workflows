# Info on running the GHRU workflows

- Use the code in the submission script `run/run_ghru.sh`.

- Check the options for each of the scripts below using '-h' or '--help':

```bash
bash mcic-scripts/bact/ghru_assembly.sh --help
bash mcic-scripts/bact/ghru_mlst.sh --help
bash mcic-scripts/bact/ghru_ariba.sh --help
bash mcic-scripts/bact/nf_resfinder.sh --help
```

- Make sure to update your copy of the mcic-scripts repo:
(cd mcic-scripts && git pull)

- Or if you haven't downloaded the repository yet, run:
git clone https://github.com/mcic-osu/mcic-scripts.git

- There is no need to copy any other files!

- All of these workflows can be run simultaneously, since they all use raw FASTQ files of input

- In order to be able to run all workflows simultaneously, 
  each script is submitted from a different directory using a 'subshell' with '()'
