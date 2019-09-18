#!/usr/bin/perl -w
use strict;
use warnings;

my $genes_fpkm_table="gene.FPKM.table";
open(F,$genes_fpkm_table);
my $head=<F>;
open(O,'>',"gene.FPKM.filtered.table");
print O "$head";
while (<F>){
    chomp;
    next if(/^$/);
    next if(/tracking_id/);
    my @a=split("\t",$_);
    my $gene_id=$a[0];
    my @FPKM;
    for(my $i=1;$i<@a;$i++){
        my $fpkm=$a[$i];
        $fpkm = 0.001 if($fpkm < 0.001);
        push @FPKM,$fpkm;
    }
    my $moreThanOne=0;
    for(my $i=0;$i<@FPKM;$i++){
        if ($FPKM[$i] >= 1){
            $moreThanOne++;
        }
    }
    if ($moreThanOne >= 2){
        print O "$gene_id\t",join("\t",@FPKM),"\n"; 
    }
}
close(F);close(O);

