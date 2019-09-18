#!/usr/bin/perl -w
use strict;

open(O,'>',"mapping.sta.table");
print O "sample_name\tpaired_reads\toverall_read_mapping_rate\t";
print O "Aligned_pairs\tmultiple_alignments\tdiscordant_alignments\tconcordant_pair_alignment_rate\n";

my @align_summary=glob("./tophat2/*/align_summary.txt");
@align_summary=sort @align_summary;
chomp(@align_summary);
for(my $i=0;$i<@align_summary;$i++){
    my $align_summary=$align_summary[$i];
    chomp($align_summary);
    my @e=split("\/",$align_summary);
    my $sampleID=$e[-2];
    print "$align_summary\t$sampleID\n";
    
    my $left_reads_number;
    my $right_reads_number;
    my $paired_reads;
    my $overall_mapping_rate;
    my $Aligned_pairs;
    my $multiple_alignments;
    my $discordant_alignments;
    my $concordant_pair_alignment_rate; 
    open(F,$align_summary);
    while (<F>) {
        chomp;
        next if(/^$/);
        
        if($_ =~ /Left reads/){
          my $line=<F>;
          if($line =~ /\s+Input\s+\:\s+(\d+)/){
              $left_reads_number=$1;
          }
        }
        if($_ =~ /Right reads/){
          my $line=<F>;
          if($line =~ /\s+Input\s+\:\s+(\d+)/){
              $right_reads_number=$1;
          }
        }
        
        if($_ =~ /(.*) overall read mapping rate\./){
            $overall_mapping_rate=$1;
        }
        if($_ =~ /Aligned pairs\:\s+(\d+)/){
            $Aligned_pairs=$1;
        }
        if($_ =~ /(\d+) \(.*\) have multiple alignments/){
            $multiple_alignments=$1;
        }
        if($_ =~ /(\d+) \(.*\) are discordant alignments/){
            $discordant_alignments=$1;
        }
        if($_ =~ /(.*) concordant pair alignment rate/){
            $concordant_pair_alignment_rate=$1;
        }
    }
    close(F);
    if($left_reads_number == $right_reads_number){
      $paired_reads=$left_reads_number;
    }else{
      print "reads paired ERROR\n";
    }
    print O "$sampleID\t$paired_reads\t$overall_mapping_rate\t";
    print O "$Aligned_pairs\t$multiple_alignments\t$discordant_alignments\t$concordant_pair_alignment_rate\n";
}
close(O);

sub countReads{
  my $file=shift;
  my $r=0;
  open(A,"zcat $file |");
  while(<A>){
    chomp;
    next if(/^$/);
    if(/^\+$/){
      $r++;
    }else{
      
    }
  }
  close(A);
  return $r;
}