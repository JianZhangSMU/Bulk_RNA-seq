##########################################Yale server
修改屏幕字体颜色： .bashrc
nano ~/.bashrc
alias ls='ls --color=auto'
Save the file and exit. #########In nano, press Ctrl+O and then press Enter to save, then press Ctrl+X to exit.
source ~/.bashrc

查看存储：getquota (check your current storage usage & limits by running)

#########################################Run Jobs with Slurm
sbatch <script>      ######Submit a submission script (see below for details)
squeue -u$USER       ######List queued and running jobs
scancel <job_id>     ######Cancel a queued job or kill a running job
sacct -j <job_id>    ######Check status of individual job (including failed or completed)
srun --pty -p interactive bash  #####Interactive Jobs
srun --pty --mem=100000 -p interactive bash
srun --pty --x11 -p interactive bash   #######To use a GUI application (such as Matlab), when in an interactive job, use the --x11 flag

##########################################Load Software with Modules
module list  （List All Loaded Modules）
module avail  （Find Available Modules）
module avail python
module load R
module unload R
module save environment_name 
module restore environment_name
man module  （More Information）

#########################Install Python or R package to Your Project Directory
module load miniconda
conda create -n legacy_application python=2.7 openblas
conda create -n py37_dev python=3.7 numpy scipy pandas matplotlib ipython jupyter
conda create -n r_env r-essentials r-base
conda create -n brian2 --channel conda-forge brian2
conda create -n bioinfo --channel conda-forge --channel bioconda biopython bedtools bowtie2 repeatmasker
source activate env_name ###Using Your Environment
conda install numpy
conda install r-ggplot2 ###All R packages are prepended with r-.
########install seurat by conda
module load miniconda
#conda create -y -n seurat -c conda-forge -c bioconda r-seurat
#conda create -y -n umap-learn -c conda-forge umap-learn
#conda create -y -n seurat -c conda-forge -c bioconda umap-learn
#conda create -y -n seurat -c conda-forge -c bioconda r-seurat umap-learn
conda create -y -n seurat -c conda-forge -c bioconda -c r rstudio umap-learn r-seurat  ##Here is how I would install the two packages and RStudio all in one environment
###########then to use seurat
module load miniconda
source activate seurat
source activate /gpfs/ysm/project/zj76/conda_envs/seurat
#conda activate umap-learn
# To activate this environment, use:
# > conda activate seurat
#
# To deactivate an active environment, use:
# > conda deactivate

R
source("test.r")


####################### important software should be loaded
module load R
module load RStudio
module load MATLAB
module load Python/3.7.0-fosscuda-2018b
module load miniconda


####################### GUI to used the RStudio
module load R
module load RStudio
srun --x11 --pty -p interactive bash
rstudio
####################### GUI to used the RStudio with local R packages
module load R
module load RStudio
###module load miniconda
###source activate seurat
srun --x11 --pty -p interactive bash
rstudio
####################### GUI to used the IGV
module load foss/2018b
module load SAMtools/1.9-foss-2018b
samtools index accepted_hits.sort.bam accepted_hits.sort.bam.bai
module load IGV/2.4.5-Java-1.8.0_121

srun --x11 --pty -p interactive bash

igv.sh
####################### GUI to used the matlab
module load MATLAB/2018b
srun --x11 --pty -p interactive bash

matlab

#########################
Linux和UNIX
按Ctrl+C键，中断R正在运行的程序而不退出R软件。

######################## bam convert to bigwig
module load foss/2018b
module load SAMtools/1.9-foss-2018b
module load deepTools
samtools index accepted_hits.sort.bam
bamCoverage -b ./accepted_hits.sort.bam -o XH_1916_coverage.bw

