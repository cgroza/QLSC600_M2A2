library(plinkQC)
indir <- "qcdir"
name <- 'plink_QLSC600_MS'
refname <- 'HapMapIII_CGRCh37'
prefixMergedDataset <- paste(name, ".", refname, sep="")

exclude_ancestry <-
  evaluate_check_ancestry(indir=indir, name=name,
                          prefixMergedDataset=prefixMergedDataset,
                          refSamplesFile=paste(indir, "/HapMap_ID2Pop.txt",
                                               sep=""), 
                          refColorsFile=paste(indir, "/HapMap_PopColors.txt",
                                              sep=""),
                          interactive=TRUE)
