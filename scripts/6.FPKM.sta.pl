#!/usr/bin/perl -w
use strict;
use warnings;

my $genes_fpkm_table=shift;
open(F,$genes_fpkm_table);
my $head=<F>;
chomp($head);
my @head=split("\t",$head);
my %sample_fpkm;
while (<F>){
    chomp;
    next if(/^$/);
    next if(/tracking_id/);
    my @a=split("\t",$_);
    my $gene_id=$a[0];
    for(my $i=1;$i<@a;$i++){
        my $fpkm=$a[$i];
        my $sample_name=$head[$i];
        $sample_fpkm{$sample_name}{$gene_id}=$fpkm;
    }
}
close(F);

open(O,'>',"$genes_fpkm_table.statistic");
print O "sample_name\tFPKM<1\t1<=FPKM<10\t10<=FPKM<100\tFPKM>=100\n";
for(my $i=1;$i<@head;$i++){
    my $sample_name=$head[$i];
    my ($sample_x11,$sample_x12,$sample_x13,$sample_x14)=(0,0,0,0);
    foreach my $gene_id(keys %{$sample_fpkm{$sample_name}}){
        my $fpkm=$sample_fpkm{$sample_name}{$gene_id};
        if ($fpkm < 1) {
            $sample_x11++;
        }elsif($fpkm >= 1 and $fpkm < 10){
            $sample_x12++;
        }elsif($fpkm >= 10 and $fpkm < 100){
            $sample_x13++;
        }elsif($fpkm >= 100){
            $sample_x14++;
        }
    }
    print O "$sample_name\t$sample_x11\t$sample_x12\t$sample_x13\t$sample_x14\n";
}
close(O);
