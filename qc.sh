qcdir='qcdir'
refdir='reference'
name='plink_QLSC600_MS'
refname='HapMapIII_CGRCh37'
highld="/home/cgroza/R/x86_64-pc-linux-gnu-library/3.5/plinkQC/extdata/high-LD-regions-hg19-GRCh37.txt"

mkdir -p $qcdir/plink_log
set -x

# cd $refdir

ftp=ftp://ftp.ncbi.nlm.nih.gov/hapmap/genotypes/2009-01_phaseIII/plink_format/
prefix=hapmap3_r2_b36_fwd.consensus.qc.poly

# wget $ftp/$prefix.map.bz2
# bunzip2 $prefix.map.bz2

# wget $ftp/$prefix.ped.bz2
# bunzip2 $prefix.per.bz2

# wget $ftp/relationships_w_pops_121708.txt

# plink1.9 --file $refdir/$prefix --noweb \
#       --make-bed \
#       --out $refdir/HapMapIII_NCBI36

# mv $refdir/HapMapIII_NCBI36.log $refdir/log

# awk '{print "chr" $1, $4 -1, $4, $2 }' $refdir/HapMapIII_NCBI36.bim | \
#     sed 's/chr23/chrX/' | sed 's/chr24/chrY/' > \
#                               $refdir/HapMapIII_NCBI36.tolift

# liftOver $refdir/HapMapIII_NCBI36.tolift $refdir/hg18ToHg19.over.chain \
#          $refdir/HapMapIII_CGRCh37 $refdir/HapMapIII_NCBI36.unMapped

# extract mapped variants
# awk '{print $4}' $refdir/HapMapIII_CGRCh37 > $refdir/HapMapIII_CGRCh37.snps
# # extract updated positions
# awk '{print $4, $3}' $refdir/HapMapIII_CGRCh37 > $refdir/HapMapIII_CGRCh37.pos

# plink1.9 --bfile $refdir/HapMapIII_NCBI36 \
#       --extract $refdir/HapMapIII_CGRCh37.snps \
#       --update-map $refdir/HapMapIII_CGRCh37.pos \
#       --make-bed \
#       --out $refdir/HapMapIII_CGRCh37

# mv $refdir/HapMapIII_CGRCh37.log $refdir/log

# plink1.9 --bfile  $qcdir/$name \
#       --exclude range  $highld \
#       --indep-pairwise 50 5 0.2 \
#       --out $qcdir/$name
# mv  $qcdir/$name.prune.log $qcdir/plink_log/$name.prune

# plink1.9 --bfile  $qcdir/$name \
#       --extract $qcdir/$name.prune.in \
#       --make-bed \
#       --out $qcdir/$name.pruned
# mv  $qcdir/$name.pruned.log $qcdir/plink_log/$name.pruned

# plink1.9 --bfile  $refdir/$refname \
#       --extract $qcdir/$name.prune.in \
#       --make-bed \
#       --out $qcdir/$refname.pruned
# mv  $qcdir/$refname.pruned.log $qcdir/plink_log/$refname.pruned

# awk 'BEGIN {OFS="\t"} FNR==NR {a[$2]=$1; next} \
#     ($2 in a && a[$2] != $1)  {print a[$2],$2}' \
#     $qcdir/$name.pruned.bim $qcdir/$refname.pruned.bim | \
#     sed -n '/^[XY]/!p' > $qcdir/$refname.toUpdateChr

# plink1.9 --bfile $qcdir/$refname.pruned \
#       --update-chr $qcdir/$refname.toUpdateChr 1 2 \
#       --make-bed \
#       --out $qcdir/$refname.updateChr
# mv $qcdir/$refname.updateChr.log $qcdir/plink_log/$refname.updateChr.log

# awk 'BEGIN {OFS="\t"} FNR==NR {a[$2]=$4; next} \
#     ($2 in a && a[$2] != $4)  {print a[$2],$2}' \
#     $qcdir/$name.pruned.bim $qcdir/$refname.pruned.bim > \
#     $qcdir/${refname}.toUpdatePos

# awk 'BEGIN {OFS="\t"} FNR==NR {a[$1$2$4]=$5$6; next} \
#     ($1$2$4 in a && a[$1$2$4] != $5$6 && a[$1$2$4] != $6$5)  {print $2}' \
#     $qcdir/$name.pruned.bim $qcdir/$refname.pruned.bim > \
#     $qcdir/$refname.toFlip

# plink1.9 --bfile $qcdir/$refname.updateChr \
#       --update-map $qcdir/$refname.toUpdatePos 1 2 \
#       --flip $qcdir/$refname.toFlip \
#       --make-bed \
#       --out $qcdir/$refname.flipped
# mv $qcdir/$refname.flipped.log $qcdir/plink_log/$refname.flipped.log

# awk 'BEGIN {OFS="\t"} FNR==NR {a[$1$2$4]=$5$6; next} \
#     ($1$2$4 in a && a[$1$2$4] != $5$6 && a[$1$2$4] != $6$5) {print $2}' \
#     $qcdir/$name.pruned.bim $qcdir/$refname.flipped.bim > \
#     $qcdir/$refname.mismatch

# plink1.9 --bfile $qcdir/$refname.flipped \
#       --exclude $qcdir/$refname.mismatch \
#       --make-bed \
#       --out $qcdir/$refname.clean
# mv $qcdir/$refname.clean.log $qcdir/plink_log/$refname.clean.log

# plink1.9 --bfile $qcdir/$name.pruned  \
#       --bmerge $qcdir/$refname.clean.bed $qcdir/$refname.clean.bim \
#       $qcdir/$refname.clean.fam  \
#       --make-bed \
#       --out $qcdir/$name.merge.$refname
# mv $qcdir/$name.merge.$refname.log $qcdir/plink_log

# plink1.9 --bfile $qcdir/$name.merge.$refname \
#       --pca \
#       --out $qcdir/$name.$reference
# mv $qcdir/$name.$reference.log $qcdir/plink_log
