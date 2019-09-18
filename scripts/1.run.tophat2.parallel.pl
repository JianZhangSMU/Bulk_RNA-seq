#!/usr/bin/perl -w
use strict;

mkdir("tophat2") unless(-e "tophat2");

#my $reads_dir="/home/zj76/project/raw_data/SRF_Bulk_RNA-seq/Sample_SRF--11_iPS-1_006";
#my $sampleID="SRF--11_iPS-1";
#my $tophat2_sh="$sampleID.tophat2.sh";
#my $job_name="run.$tophat2_sh";
#my $slurm_sh="$sampleID.slurm.sh";
#`perl generate.tophat2.for.each.sample.pl $reads_dir $sampleID >tophat2/$tophat2_sh`;
#`perl generate.slurm.pl $job_name $tophat2_sh >tophat2/$slurm_sh`;
#`cd tophat2;sbatch $slurm_sh;cd -`;

my $sample_dir=shift; #from the raw data, eg. /home/zj76/project/raw_data/Sun2_Bulk_RNA-seq
my @samples=`ls $sample_dir`;
foreach my $sample(@samples){
    chomp($sample);
    my $reads_dir="$sample_dir/$sample";
    my $sampleID;
    if($sample =~ /Sample_(.*)/){
        $sampleID=$1;
    }
    my $tophat2_sh="$sampleID.tophat2.sh";
    my $job_name="$tophat2_sh";
    my $slurm_sh="$sampleID.slurm.sh";
    `perl generate.tophat2.for.each.sample.pl $reads_dir $sampleID >tophat2/$tophat2_sh`;
    `perl generate.slurm.pl $job_name $tophat2_sh >tophat2/$slurm_sh`;
    `cd tophat2;sbatch $slurm_sh;cd -`;
}

