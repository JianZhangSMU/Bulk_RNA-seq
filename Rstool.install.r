###################################### install Rstools
# delete 00LOCK
unlink("d:/Users/ZhangJian/Anaconda3/Lib/R/library/00LOCK", recursive = TRUE)
unlink("C:/Users/ZhangJian/Documents/R/win-library/3.6/00LOCK", recursive = TRUE)

install.packages("installr")
library("installr")
install.Rtools()

# check path enviromnet
writeLines(strsplit(Sys.getenv("PATH"), ";")[[1]])

Sys.setenv(PATH = paste("C:/Rtools/bin", Sys.getenv("PATH"), sep=";"))
Sys.setenv(BINPREF = "C:/Rtools/mingw_$(WIN)/bin/")
Sys.unsetenv(c("D:/Rtoolsbin","C:/RBuildTools/3.5/bin","d:/Rtools/bin"))

# check Rtools
library("devtools")
find_rtools(T)
pkgbuild::find_rtools(debug = TRUE)
.Call("rs_canBuildCpp")

#Add to the PATH on the system C:\Rtools\bin & C:\Rtools\mingw_64\bin & C:\Rtools\mingw_32\bin.

# or
pkgbuild::has_build_tools()
pkgbuild::check_build_tools()

###################################### install python packages
library(reticulate)
reticulate::py_install(packages = 'umap-learn')
reticulate::py_install("louvain") #do not work
# use anoconda bash: conda install -c vtraag louvain


###################################### install curl
install.packages("curl") # do not work in the new deaktop computer
install.packages("curl", dependencies=TRUE, INSTALL_opts = c('--no-lock'))
