module load Cufflinks （if could not load Cufflinks, Try: module purge, module load Cufflinks）
module load SAMtools
module load Bowtie2
module load Bowtie2/2.2.8-foss-2016b
module load TopHat
module load HTSeq

##### 运行tophat2-cuffdiff，三点必须谨记：
#####（1）reads必须给全路径，即便reads在当前运行目录里面，也必须要给全路径；
#####（2）运行taohat2需要较大内存（至少100G），如果内存不够，会导致运行失败，没有结果；
#####（3）运行cuffdiff，同样需要较大内存（至少100G）；
############################# Sun2 bulk RNA-seq
perl 1.run.tophat2.parallel.pl /home/zj76/project/raw_data/Sun2_Bulk_RNA-seq
perl 2.run.cuffdiff.with.slurm.pl /home/zj76/project/database/mm10/Mus_musculus.GRCm38.96.gtf WT,mCherry,Sun2-1-274,Sun2-FL1,Sun2-FL3
############################# SRF bulk RNA-seq
perl 1.run.tophat2.parallel.pl /home/zj76/project/raw_data/SRF_Bulk_RNA-seq
perl 2.run.cuffdiff.with.slurm.pl /home/zj76/project/database/mm10/Mus_musculus.GRCm38.96.gtf SRFko,SRFwt
############################# Actin_WT_NLS bulk RNA-seq
perl 1.run.tophat2.parallel.for.all.reads.in.one.director.pl
perl 2.run.cuffdiff.with.slurm.pl /home/zj76/project/database/mm10/Mus_musculus.GRCm38.96.gtf 4FH_D4_AIE,4FH_D4_IE,4FH_D4_NLS-AIE,MEF_AIE,MEF_IE,MEF_NLS-AIE
############################# GY bulk RNA-seq
perl 1.run.tophat2.parallel.pl /home/zj76/project/GY/cleandata
perl 2.run.cuffdiff.with.slurm.pl /home/zj76/project/database/hg38/Homo_sapiens.GRCh38.96.gtf s2C,s2D

module load R

library(ggplot2)
library("pheatmap")
a=read.table("gene.FPKM.filtered.table.for.sample.cor",header=T)
b=cor(a,method="kendall") #method = c("pearson", "kendall", "spearman")
pheatmap(b)
c=1-b
d=as.dist(c)
plot(hclust(d,method = "complete"),hang = -1)

e=read.table("gene.FPKM.filtered.table.for.gene.cor",header=T)
pheatmap(log10(e+1),cluster_rows=T,cluster_cols=F,show_rownames=F,show_colnames=T,fontsize_row=1,fontsize_col=10)


normal=read.table("s2C.VS.s2D.normal.for.plot",header=T)
up=read.table("s2C.VS.s2D.Up.for.plot",header=T)
down=read.table("s2C.VS.s2D.Down.for.plot",header=T)
plot(normal,type="p",pch=20,col="gray",xlab="Fold change [log2(FPKMs2D/FPKMs2C)]",ylab="-Log10(FDR)",xlim=c(-4,4),ylim=c(0,3))
points(up,pch=20,col="red")
points(down,pch=20,col="blue")

perl 8.gene.list.for.plot.pl TEX19.1,TEX19.2,REC114,MAEL,AURKC,SYCE2,SYCE1,TDRD12,SYCP1,CLGN,STRA8,RSPH1,PIWIL1,HORMAD1,HORMAD2,SPATA22,TEX11,SMC1B >DEGs_in_GO_0051321_meiotic_cell_cycle
perl 8.gene.list.for.plot.pl ITGAL,CLDN7,H2-Q10,CLDN4,CLDN6,H2-DMB1,CDH1,NRCAM,CD80,H2-EB1,PECAM1,CD2,CNTNAP2,CD22,ESAM,JAM2,CD6,SPN >DEGs_in_KEGG_mmu04514_Cell_adhesion_molecules
a=read.table("DEGs_in_GO_0051321_meiotic_cell_cycle",header=T)
pheatmap(log10(a),cluster_rows=T,cluster_cols=F,show_rownames=T,show_colnames=T,fontsize_row=14,fontsize_col=14)

perl 8.gene.list.for.plot.pl NTRK3,SEPT4,ZMAT3,HMOX1,ALDH1A3,FAS,IGFBP3,DUSP6,BARD1 >DEGs_in_GO_0043065_positive_regulation_of_apoptotic_process
perl 8.gene.list.for.plot.pl CCNB3,CDKN1A,BBC3,ZMAT3,FAS,IGFBP3,SESN1 >DEGs_in_hsa04115_p53_signaling_pathway
