#!/usr/bin/perl -w
use strict;

my $reads_dir=shift;
my @Reads=`ls $reads_dir`;
my %reads;
foreach my $file(@Reads){
    my $basename=`basename $file`;
    chomp($basename);
    print "$basename\n";
    my $sample;
    my $Reads1;
    my $Reads2;
    if($basename =~ /XH_(\d+)_S(\d+)_L005_R1_001.fastq.gz/){ #(\w+-\d)_H33YMCCXY_(\w+)_1\.clean\.fq\.gz
        $sample=$1;
        $Reads1="$reads_dir/$basename";
        $Reads2="$reads_dir/XH_$1_S$2_L005_R2_001.fastq.gz";
        $reads{$sample}{Reads1}=$Reads1;
        $reads{$sample}{Reads2}=$Reads2;
    }
}

open(O,'>',"1.tophat2.sh");
my $mm10_Bowtie2Index="/gpfs/ysm/datasets/genomes/Mus_musculus/UCSC/mm10/Sequence/Bowtie2Index/genome";
my $mm10_gene_gtf="/gpfs/ysm/datasets/genomes/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf";
print O "module load SAMtools\n";
print O "module load Bowtie2\n";
print O "module load TopHat\n";
print O "module load HTSeq\n";
print O "module load Cufflinks\n";
print O "#mapping reads to mm10 with tophat2\n";
my @bam;
foreach my $sample(sort keys %reads){
    my $Reads1=$reads{$sample}{Reads1};
    my $Reads2=$reads{$sample}{Reads2};
    print O "tophat2 -p 10 --library-type fr-unstranded -G $mm10_gene_gtf -o tophat_$sample $mm10_Bowtie2Index $Reads1 $Reads2\n";
    my $bam = "tophat_$sample/accepted_hits.bam";
    push @bam, $bam;
    my $sort_bam = "tophat_$sample/accepted_hits.sort.bam";
    #print O "samtools sort $bam >$sort_bam\n";
    #print O "#get reads count by HTseq\n";
    #print O "htseq-count -f bam -m union -s no -t exon -q $sort_bam $mm10_gene_gtf >tophat_$sample/$sample.HTSeq.readcount\n";
}

#print O "#Quantifying gene and transcript expression in RNA-Seq samples: FPKM by cuffquant\n";
#print O "mkdir cuffquant\n";
#print O "cuffquant -p 10 -o cuffquant $mm10_gene_gtf";
#for(my $i=0;$i<@bam;$i=$i+3){
#    print O " $bam[$i],$bam[$i+1],$bam[$i+2]";
#}
#print O "\n";
#
#print O "#normalize the expression levels by cuffnorm\n";
#print O "mkdir cuffnorm\n";
#print O "cuffnorm -p 10 -o cuffnorm --labels ";
#my @samples=sort keys %reads;
#for(my $i=0;$i<@samples-1;$i++){
#    print O "$samples[$i],";
#}
#print O "$samples[-1] $mm10_gene_gtf";
#for(my $i=0;$i<@bam;$i=$i+3){
#    print O " $bam[$i],$bam[$i+1],$bam[$i+2]";
#}
#print O "\n";
#
#print O "#differential expressed genes identified by cuffdiff\n";
#print O "mkdir cuffdiff\n";
#print O "cuffdiff -p 10 -o cuffdiff --labels WT,mCherry,Sun2-1-274,Sun-FL1,Sun2-FL3 $mm10_gene_gtf";
#for(my $i=0;$i<@bam;$i=$i+3){
#    print O " $bam[$i],$bam[$i+1],$bam[$i+2]";
#}
#print O "\n";

close(O);