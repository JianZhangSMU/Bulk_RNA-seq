#!/usr/bin/perl -w
use strict;
use warnings;

my $genes_fpkm_table="./cuffnorm/genes.fpkm_table";
my $samples_table="./cuffnorm/samples.table";

open(F,$samples_table);
my %samples;
my @sample_name;
while (<F>){
    chomp;
    next if(/^$/);
    next if(/^sample_id/);
    my @a=split("\t",$_);
    my $sample_id=$a[0];
    my $file_name=$a[1];
    my @e=split("\/",$file_name);
    my $sample_name=$e[-2];
    print "$sample_id\t$sample_name\n";
    push @sample_name,$sample_name;
    $samples{$sample_id}=$sample_name;
}
close(F);
@sample_name=sort @sample_name;

open(F,$genes_fpkm_table);
my %genes_fpkm;
my $head=<F>;
chomp($head);
my @head=split("\t",$head);
while (<F>){
    chomp;
    next if(/^$/);
    next if(/tracking_id/);
    my @a=split("\t",$_);
    my $gene_id=$a[0];
    for(my $i=1;$i<@a;$i++){
        my $fpkm=$a[$i];
        my $sample_id=$head[$i];
        $genes_fpkm{$gene_id}{$samples{$sample_id}}=$fpkm;
    }
}
close(F);

open(O,'>',"gene.FPKM.table");
print O "tracking_id\t",join("\t",@sample_name),"\n";
foreach my $gene_id(sort keys%genes_fpkm){
    my @FPKM;
    for(my $i=0;$i<@sample_name;$i++){
        my $sample_name=$sample_name[$i];
        my $FPKM=$genes_fpkm{$gene_id}{$sample_name};
        #print O "$FPKM\t";
        push @FPKM,$FPKM;
    }
    print O "$gene_id\t",join("\t",@FPKM),"\n";
}
close(O);