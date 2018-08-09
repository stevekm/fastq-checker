# Fastq Checker

Quick workflow for checking the validity of `.fastq.gz` files

- make sure all `.fastq.gz` are valid `.gz` archives

- make sure that all read 1 and read 2 fastq files have the same number of entries

# Usage

Clone this repository

```
git clone fastq-checker
cd fastq-checker
```

Run the workflow on the contents of the included `input` directory

```
make run
```

## Example

Run the workflow on the included `demo` files, using the included Nextflow config for NYU's phoenix compute cluster

```
make run EP='-profile phoenix --inputDir demo'
```

# Software Requirements

- Java 8 (Nextflow)

- bash shell

- GraphViz Dot (to compile flowchart; optional)
