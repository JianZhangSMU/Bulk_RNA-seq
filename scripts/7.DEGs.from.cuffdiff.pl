#!/usr/bin/perl -w
use strict;
use warnings;

my %Cuffdiff_read_groups_info=read_Cuffdiff_read_groups_info("./cuffdiff/read_groups.info");
my %Cuffdiff_genes_fpkm_tracking=read_Cuffdiff_genes_fpkm_tracking("./cuffdiff/genes.fpkm_tracking");
my %Cuffdiff_genes_read_group_tracking=read_Cuffdiff_genes_read_group_tracking("./cuffdiff/genes.read_group_tracking");

my $genes_fpkm_table="gene.FPKM.filtered.table"; #gene.FPKM.table OR 
open(F,$genes_fpkm_table);
my $head=<F>;
chomp($head);
my @head=split("\t",$head);
my %gene_fpkm;
while (<F>){
    chomp;
    next if(/^$/);
    next if(/tracking_id/);
    my @a=split("\t",$_);
    my $gene_id=$a[0];
    for(my $i=1;$i<@a;$i++){
        my $fpkm=$a[$i];
        my $sample_name=$head[$i];
        $gene_fpkm{$gene_id}{$sample_name}{fpkm}=$fpkm;
    }
}
close(F);

open(F,"./cuffdiff/gene_exp.diff");
my %gene_exp_diff;
$head=<F>;
chomp($head);
while (<F>){
    chomp;
    next if(/^$/);
    next if(/test_id/);
    my @a=split("\t",$_);
    my $test_id=$a[0];
    my $gene_id=$a[1];
    my $gene_short_name=$a[2];
    my $condition_1=$a[4];
    my $condition_2=$a[5];
    $gene_exp_diff{$condition_1}{$condition_2}{$gene_id}{line}=$_;
}
close(F);
mkdir("DEGs") unless(-e "DEGs");
foreach my $condition_1(keys %gene_exp_diff){
    foreach my $condition_2(keys %{$gene_exp_diff{$condition_1}}){
        open(O,'>',"DEGs/$condition_1.VS.$condition_2.all.table");
        print O "$head\tregulation\n";
        open(P,'>',"DEGs/$condition_1.VS.$condition_2.DEGs.table");
        print P "$head\tregulation\n";
        open(Q1,'>',"DEGs/$condition_1.VS.$condition_2.DEGs.gene_id.list"); #for GO enrichment
        open(Q2,'>',"DEGs/$condition_1.VS.$condition_2.DEGs.gene_short_name.list"); #for GO enrichment
        
        open(A,'>',"DEGs/$condition_2.VS.$condition_1.Up.for.plot"); #$log2fold_change = log($value_2/$value_1)/log(2);
        print A "log2fold_change\t-log10q_value\n";
        open(B,'>',"DEGs/$condition_2.VS.$condition_1.Down.for.plot");
        print B "log2fold_change\t-log10q_value\n";
        open(C,'>',"DEGs/$condition_2.VS.$condition_1.normal.for.plot");
        print C "log2fold_change\t-log10q_value\n";
        
        my ($up,$down)=(0,0);
        foreach my $gene_id(keys %{$gene_exp_diff{$condition_1}{$condition_2}}){
            if(exists $gene_fpkm{$gene_id}){
                my $line=$gene_exp_diff{$condition_1}{$condition_2}{$gene_id}{line};
                my @a=split("\t",$line);
                my $test_id=$a[0];
                my $gene_id=$a[1];
                my $gene_short_name=$a[2];
                my $locus=$a[3];
                my $condition_1=$a[4];
                my $condition_2=$a[5];
                my $status=$a[6];
                my $value_1=$a[7];#affect
                my $value_2=$a[8];#control
                $value_1 = 0.001 if($value_1 < 0.001);
                $value_2 = 0.001 if($value_2 < 0.001);
                my $log2fold_change=$a[9];
                $log2fold_change = log($value_2/$value_1)/log(2);
                my $p_value=$a[11];
                my $q_value=$a[12];
                my $log_q_value=-log($q_value)/log(10);
                my $significant=$a[13];
                
                if($status eq "OK"){
                    my $regulation="";
                    if($log2fold_change >= 1 and $significant eq "yes"){
                        $up++;
                        $regulation="up";
                        print A "$log2fold_change\t$log_q_value\n";
                    }elsif($log2fold_change <= -1 and $significant eq "yes"){
                        $down++;
                        $regulation="down";
                        print B "$log2fold_change\t$log_q_value\n";
                    }else{
                        $regulation="-";
                        print C "$log2fold_change\t$log_q_value\n";
                    }
                    print O "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$value_1\t$value_2\t$log2fold_change\t$a[10]\t$a[11]\t$a[12]\t$a[13]\t$regulation\n";
                    
                    if(abs($log2fold_change) >= 1 and $significant eq "yes"){
                        print P "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$value_1\t$value_2\t$log2fold_change\t$a[10]\t$a[11]\t$a[12]\t$a[13]\t$regulation\n";
                        print Q1 "$gene_id\n";
                        print Q2 "$gene_short_name\n";
                    }
                }
            }
        }
        print "$condition_1.VS.$condition_2\tup: $up\tdown: $down\n";
        close(O);close(P);close(Q1);close(Q2);close(A);close(B);close(C);
    }
}

sub read_Cuffdiff_read_groups_info{
    my $file=shift;
    open(F,$file);
    my %r;
    while (<F>) {
        chomp;
        next if(/^$/);
        next if(/file/);
        my @a=split("\t",$_);
        my $file=$a[0];
        my @e=split("\/",$file);
        my $sample_name=$e[-2];
        my $condition=$a[1];
        my $replicate_num=$a[2];
        $r{$sample_name}{condition}=$condition;
        $r{$sample_name}{replicate_num}=$replicate_num;
    }
    close(F);
    return %r;
}
sub read_Cuffdiff_genes_fpkm_tracking{
    my $file=shift;
    open(F,$file);
    my %r;
    my $head=<F>;
    chomp($head);
    my @head=split("\t",$head);
    while (<F>) {
        chomp;
        next if(/^$/);
        next if(/tracking_id/);
        my @a=split("\t",$_);
        my $geneID=$a[3];
        my $gene_short_name=$a[4];
        $r{$geneID}{gene_short_name}=$gene_short_name;
        for(my $i=9;$i<@a;$i=$i+4){
            my $condition_fpkm=$a[$i];
            my $condition=$head[$i];
            $condition=~/(.*)_FPKM/;
            $condition=$1;
            $r{$geneID}{$condition}=$condition_fpkm;
        }
    }
    close(F);
    return %r;
}
sub read_Cuffdiff_genes_read_group_tracking{
    my $file=shift;
    open(F,$file);
    my %r;
    while (<F>) {
        chomp;
        next if(/^$/);
        next if(/tracking_id/);
        my @a=split("\t",$_);
        my $geneID=$a[0];
        my $condition=$a[1];
        my $replicate_num=$a[2];
        my $FPKM=$a[6];
        $r{$geneID}{$condition}{$replicate_num}{FPKM}=$FPKM;
    }
    close(F);
    return %r;
}