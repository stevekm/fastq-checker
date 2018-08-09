// get all pairs of fastq files
params.filenamePattern = '*R{1,2}_001.fastq.gz'
Channel.fromFilePairs("${params.inputDir}/${params.filenamePattern}", size: 2).into { fastqPairs; fastqPairs2 }

// convert to a channel of each individual file
fastqPairs2.flatMap{ sampleID, fastqList ->
        return(fastqList)
    }
    .set { allFastqs }

// make sure we've got only .gz files
allFastqs.filter(~/.*\.gz$/).set { allFastqGz }

// validate .gz archive integrity
process validateGz {
    tag "${fastqGz}"

    input:
    file(fastqGz) from allFastqGz

    script:
    """
    gzip -t "${fastqGz}"
    """
}

// make sure the line counts between R1 and R2 match
process countReadsR1R2 {
    tag "${prefix}"

    input:
    set val(sampleID), file(fastqs) from fastqPairs

    script:
    fastqR1 = fastqs[0]
    fastqR2 = fastqs[1]
    prefix = "${fastqR1}.${fastqR2}"
    """
    linesR1="\$(zcat '${fastqR1}' | wc -l)"
    linesR2="\$(zcat '${fastqR2}' | wc -l)"
    echo "${fastqR1}: \${linesR1}, ${fastqR2}: \${linesR2}"
    if [ ! "\${linesR1}" -eq "\${linesR2}" ]; then echo "ERROR: ${fastqR1} and ${fastqR2} have differing number of reads"; exit 1 ; fi
    """
}
