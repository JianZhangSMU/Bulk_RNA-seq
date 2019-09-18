#!/usr/bin/perl -w
use strict;

my @HTSeq_readcount=glob("./tophat2/*/*.HTSeq.readcount");
@HTSeq_readcount=sort @HTSeq_readcount;
chomp(@HTSeq_readcount);
my %hash;
my @sampleID;
foreach my $file(@HTSeq_readcount){
    chomp($file);
    my @e=split("\/",$file);
    my $sampleID=$e[-2];
    print "$file\t$sampleID\n";
    push @sampleID,$sampleID;
    
    open(F,$file);
    while (<F>) {
        chomp;
        next if(/^$/);
        my @line=split/\s+/,$_;
        my $gene_id=$line[0];
        my $counts=$line[1];
        $hash{$gene_id}{$sampleID}{counts}=$counts;
    }
    close(F);
}

@sampleID=sort @sampleID;
open(O,'>',"HTSeq.counts.table");
print O "#gene_id\t";
for(my $j=0;$j<@sampleID;$j++){
    my $sample_name=$sampleID[$j];
    print O "$sample_name\t";
}
print O "\n";

my @geneID=sort(keys %hash);
for(my $i=0;$i<@geneID;$i++){
    my $gene_id=$geneID[$i];
    print O "$gene_id\t";
    for(my $j=0;$j<@sampleID;$j++){
        my $sample_name=$sampleID[$j];
        if (exists $hash{$gene_id}{$sample_name}) {
            print O "$hash{$gene_id}{$sample_name}{counts}\t";
        }else{
            print O "NA\t";
        }
    }
    print O "\n";
}
close(O);