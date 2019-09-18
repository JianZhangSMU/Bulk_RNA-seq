#!/usr/bin/perl -w
use strict;

my $job_name=shift;

my $sh_file=shift;

print "#!/bin/bash\n";
print "#SBATCH --partition=general\n";
print "#SBATCH --job-name=$job_name\n";
print "#SBATCH --ntasks=1 --nodes=1\n";
print "#SBATCH --mem-per-cpu=10000\n";
print "#SBATCH --time=240:00:00\n";
#print "#SBATCH --mail-type=ALL\n";
#print "#SBATCH --mail-user=zhang.jian\@yale.edu\n";
print "\n";
print "sh $sh_file\n";