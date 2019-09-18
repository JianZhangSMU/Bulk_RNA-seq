#!/usr/bin/perl -w
use strict;

mkdir("cuffdiff") unless(-e "cuffdiff");
#my $mm10_gene_gtf="/home/zj76/project/database/mm10/Mus_musculus.GRCm38.96.gtf";
my $mm10_gene_gtf=shift;

my @bams=glob("./tophat2/*/accepted_hits.bam");
@bams=sort @bams;
chomp(@bams);
for(my $i=0;$i<@bams;$i++){
    my $bam=$bams[$i];
    chomp($bam);
    my @e=split("\/",$bam);
    my $sampleID=$e[-2];
    print "$bam\t$sampleID\n";
}

open(O,'>',"2.cuffdiff.sh");
print O "module load Cufflinks\n";
print O "#normalize the expression levels by cuffnorm\n";
print O "cuffnorm -p 10 -o cuffnorm --labels WT,mCherry,Sun2-1-274,Sun-FL1,Sun2-FL3 $mm10_gene_gtf";
for(my $i=0;$i<@bams;$i=$i+3){
    print O " $bams[$i],$bams[$i+1],$bams[$i+2]";
}
print O "\n";

print O "#differential expressed genes identified by cuffdiff\n";
print O "cuffdiff -p 10 -o cuffdiff --labels WT,mCherry,Sun2-1-274,Sun-FL1,Sun2-FL3 $mm10_gene_gtf";
for(my $i=0;$i<@bams;$i=$i+3){
    print O " $bams[$i],$bams[$i+1],$bams[$i+2]";
}
print O "\n";
close(O);