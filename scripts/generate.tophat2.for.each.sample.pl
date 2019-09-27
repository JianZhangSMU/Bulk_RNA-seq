#!/usr/bin/perl -w
use strict;

my $reads_dir=shift; ##raw reads sample dir
my $sampleID=shift;

my @left_reads=`ls $reads_dir/*R1*.fastq.gz`;
@left_reads=get_sample_reads(@left_reads);
@left_reads=sort @left_reads;
chomp(@left_reads);
my $left_reads=join(",",@left_reads);

my @right_reads=`ls $reads_dir/*R2*.fastq.gz`;
@right_reads=get_sample_reads(@right_reads);
@right_reads=sort @right_reads;
chomp(@right_reads);
my $right_reads=join(",",@right_reads);

##download mm10(v96) from ensemble and index with bowtie2
##bowtie2-build Mus_musculus.GRCm38.dna_rm.toplevel.fa mm10Bowtie2
my $mm10_Bowtie2Index="/home/zj76/project/database/mm10/mm10Bowtie2";
my $mm10_gene_gtf="/home/zj76/project/database/mm10/Mus_musculus.GRCm38.96.gtf";

print "module load Python/2.7.15-foss-2018b\n";
print "module load SAMtools\n";
#print "module load Bowtie2/2.2.8-foss-2016b\n";
print "module load Bowtie2\n";
print "module load TopHat\n";

print "tophat2 -o $sampleID -p 10 --library-type fr-unstranded -G $mm10_gene_gtf $mm10_Bowtie2Index $left_reads $right_reads\n";
my $bam = "$sampleID/accepted_hits.bam";
my $sort_bam = "$sampleID/accepted_hits.sort.bam";
print "samtools sort $bam >$sort_bam\n";

print "module load HTSeq\n";
print "htseq-count -f bam -t exon -q $sort_bam $mm10_gene_gtf >$sampleID/$sampleID.HTSeq.readcount\n";

sub get_sample_reads{
    my @data=@_;
    my @r;
    foreach my $file(@data){
        if($file =~ /$sampleID/){
            push @r,$file;
        }
    }
    return @r;
}