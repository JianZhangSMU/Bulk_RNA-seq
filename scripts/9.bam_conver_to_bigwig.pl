#!/usr/bin/perl -w
use strict;

my $sh_file="bam_convert_to_bigwig.sh";
open(O,'>',"$sh_file");
print O "module load foss/2018b\n";
print O "module load SAMtools/1.9-foss-2018b\n";
print O "module load deepTools\n";

my @bams=glob("./tophat2/*/accepted_hits.sort.bam");
@bams=sort @bams;
chomp(@bams);
for(my $i=0;$i<@bams;$i++){
    my $bam=$bams[$i];
    chomp($bam);
    my @e=split("\/",$bam);
    my $sampleID=$e[-2];
    print "$bam\t$sampleID\n";
    
    print O "samtools index $bam $bam.bai\n";
    print O "bamCoverage -b $bam -o ./tophat2/$sampleID.coverage.bw\n"
}
close(O);


open(O,'>',"$sh_file.run.slurm.sh");
print O "#!/bin/bash\n";
print O "#SBATCH --partition=general\n";
print O "#SBATCH --job-name=$sh_file\n";
print O "#SBATCH --ntasks=1 --nodes=1\n";
#print O "#SBATCH --mem-per-cpu=100000\n"; 
print O "#SBATCH --mem=10000\n";
print O "#SBATCH --time=240:00:00\n";
print O "\n";
print O "sh $sh_file\n";
close(O);
