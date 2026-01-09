if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("triwise")

#installation of triwise trouble shooting

install.packages("remotes")
library(remotes)
remotes::install_github("saeyslab/triwise")
devtools::install_github("saeyslab/triwise")
BiocManager::install("mgsa")

Sys.setenv(PATH = paste(
  "C:/rtools44/usr/bin",
  "C:/rtools44/x86_64-w64-mingw32.static.posix/bin",
  Sys.getenv("PATH"),
  sep = ";"
))
Sys.which("make")
Sys.setenv(PATH = paste(
  "C:/RBuildTools/4.4/usr/bin",
  "C:/RBuildTools/4.4/x86_64-w64-mingw32.static.posix/bin",
  Sys.getenv("PATH"),
  sep = ";"
))

# from https://zouter.github.io/triwise/vignette.html#expression-preprocessing
library(triwise)
library(limma)
library(Biobase)
library(ggplot2)
library(ggrepel)

#try with deepcell data_z score all nasal cells
fn = "/Users/ruppb/Documents/Github/deepcell/nasal_only_mean_normal_for_triwise.csv"
deepcell_data_normalized_mean_nasal<- read.table(fn, header=TRUE, check.names=FALSE, sep = ",")

rownames(deepcell_data_normalized_mean_nasal) <- deepcell_data_normalized_mean_nasal [,1]
deepcell_data_normalized_mean_nasal  <- deepcell_data_normalized_mean_nasal [,-1]

barycoords = transformBarycentric(deepcell_data_normalized_mean_nasal)
str(barycoords)

plotDotplot(barycoords)

# WARNING: Replace this part with how to get your actual coordinates from triwise output
x_coords <- barycoords$x
y_coords <- barycoords$y


# Add labels using rownames of your original data (deepcell_data_cluster2_5_median_average)
p <- plotDotplot(barycoords, rmax = 1)
p +geom_text_repel(aes(x=x_coords,y=y_coords,label = rownames(deepcell_data_normalized_mean_nasal)), max.overlaps = 10) 




