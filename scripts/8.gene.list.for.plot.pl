#!/usr/bin/perl -w
use strict;
use warnings;

my $genes_fpkm_table="gene.FPKM.filtered.table"; #gene.FPKM.table OR 
open(F,$genes_fpkm_table);
my $head=<F>;
chomp($head);
my @head=split("\t",$head);
shift @head; #delete the "tracking_id"
my %gene_fpkm;
while (<F>){
    chomp;
    next if(/^$/);
    next if(/tracking_id/);
    my @a=split("\t",$_);
    my $gene_id=$a[0];
    #for(my $i=1;$i<@a;$i++){
    #    my $fpkm=$a[$i];
    #    my $sample_name=$head[$i];
    #    $gene_fpkm{$gene_id}{$sample_name}{fpkm}=$fpkm;
    #}
    shift @a;
    $gene_fpkm{$gene_id}=join("\t",@a);
}
close(F);

open(F,"./cuffdiff/gene_exp.diff");
my %gene_exp_diff;
while (<F>){
    chomp;
    next if(/^$/);
    next if(/test_id/);
    my @a=split("\t",$_);
    my $test_id=$a[0];
    my $gene_id=$a[1];
    my $gene_short_name=$a[2];
    #$gene_short_name=uc $gene_short_name;
    my $condition_1=$a[4];
    my $condition_2=$a[5];
    $gene_exp_diff{$gene_short_name}=$gene_id;
}
close(F);

my $gene_name_list=shift; #from GO and KEEG enrichment results (must delete the blank in komodo first), such as TEX19.1,TEX19.2,REC114
my @a=split(",",$gene_name_list);
print "\t",join("\t",@head),"\n";
foreach my $gene_short_name(@a){
    #$gene_short_name=~s/\s*(\w*\.*\d*)\s*/$1/;
    #$gene_short_name=uc $gene_short_name;
    my @b=split("",$gene_short_name);
    my @c;
    push @c,$b[0];
    for(my $i=1;$i<@b;$i++){
        my $letter=$b[$i];
        $letter=lc $letter;
        push @c,$letter;
    }
    $gene_short_name=join("",@c);
    print "$gene_short_name\n";
    if(exists $gene_exp_diff{$gene_short_name}){
        my $gene_id=$gene_exp_diff{$gene_short_name};
        if(exists $gene_fpkm{$gene_id}){
            print "$gene_short_name\t$gene_fpkm{$gene_id}\n";
        }
    }
}