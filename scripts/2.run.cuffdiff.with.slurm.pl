#!/usr/bin/perl -w
use strict;

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

#my $mm10_gene_gtf="/home/zj76/project/database/mm10/Mus_musculus.GRCm38.96.gtf";
my $gene_gtf=shift;

my $sh_file="cuffdiff.sh";
open(O,'>',"$sh_file");
print O "module load Cufflinks\n";
print O "module load SAMtools\n";
print O "#normalize the expression levels by cuffnorm\n";
print O "cuffnorm -p 10 -o cuffnorm $gene_gtf";
for(my $i=0;$i<@bams;$i=$i+3){
    print O " $bams[$i],$bams[$i+1],$bams[$i+2]";
}
print O "\n";

my $labels=shift; #eg. WT,mCherry,Sun2-1-274,Sun-FL1,Sun2-FL3
print O "#differential expressed genes identified by cuffdiff\n";
print O "cuffdiff -p 10 -o cuffdiff --labels $labels $gene_gtf";
for(my $i=0;$i<@bams;$i=$i+3){
    print O " $bams[$i],$bams[$i+1],$bams[$i+2]";
}
print O "\n";
close(O);


open(O,'>',"$sh_file.run.slurm.sh");
print O "#!/bin/bash\n";
print O "#SBATCH --partition=general\n";
print O "#SBATCH --job-name=$sh_file\n";
print O "#SBATCH --ntasks=1 --nodes=1\n";
#print O "#SBATCH --mem-per-cpu=100000\n"; 
print O "#SBATCH --mem=100000\n";
print O "#SBATCH --time=240:00:00\n";
print O "\n";
print O "sh $sh_file\n";
close(O);
