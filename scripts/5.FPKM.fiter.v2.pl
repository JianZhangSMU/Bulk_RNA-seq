#!/usr/bin/perl -w
use strict;
use warnings;

my $genes_fpkm_table="gene.FPKM.table";
open(F,$genes_fpkm_table);
my $head=<F>;
close(F);

chomp $head;
my @head=split("\t",$head);
shift @head; #delete the "tracking_id"
print "sample number: ",scalar @head,"\n";

my $outdir="sample.cor.and.gene.cor";
mkdir($outdir) unless(-e $outdir);

for(my $n=0;$n<=@head;$n++){
    my $filter_criterion=$n;
    my $out_file_1="$outdir/FPKM.moreThanOne.in.$filter_criterion.samples.for.sample.cor";
    open(O,'>',"$out_file_1");
    print O join("\t",@head),"\n";
    
    my $out_file_2="$outdir/FPKM.moreThanOne.in.$filter_criterion.samples.for.gene.cor";
    open(P,'>',"$out_file_2");
    print P "\t",join("\t",@head),"\n";
    
    open(F,$genes_fpkm_table);
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
        if ($moreThanOne >= $filter_criterion){
            print O join("\t",@FPKM),"\n";
            print P "$gene_id\t",join("\t",@FPKM),"\n";
        }
    }
    close(O);close(P);
    
    #my $out_file_3="$outdir/FPKM.moreThanOne.in.$filter_criterion.samples.cor.r";
    #open(O,'>',$out_file_3);
    #print O "library(\"pheatmap\")\n";
    #print O "a=read.table(\"$out_file_1\",header=T)\n";
    #print O "png(file = \"$out_file_1.png\",type=\"cairo\",width = 480, height = 480)\n";
    #print O "pheatmap(cor(a,method=\"spearman\"))\n"; #method = c("pearson", "kendall", "spearman")
    #print O "dev.off()\n";
    #print O "b=read.table(\"$out_file_2\",header=T)\n";
    #print O "png(file = \"$out_file_2.png\",type=\"cairo\",width = 480, height = 480)\n";
    #print O "pheatmap(log10(b),cluster_rows=T,cluster_cols=F,show_rownames=F,show_colnames=T,fontsize_row=1,fontsize_col=14)\n"; #method = c("pearson", "kendall", "spearman")
    #print O "dev.off()\n";
    #close(O);
    ### module load R
    #`Rscript $out_file_3`;
}
