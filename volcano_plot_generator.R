#based on previously developed code https://github.com/VCU-Bioinformatics-Core/20241011.kevin_byrd.ibd_nulisa/tree/main


library(readxl)
library(sets)
library(tidyverse)
library(limma)
library(gplots)
library(ggplot2)
library(dplyr)
library(ROSE)
library(scutr)
library(openxlsx)


create_volcano_plot_v2 <- function(results, topn=10, highlight_genes=NULL, filename='', save=FALSE) {
  
  # Create a logical column for significance
  results$significant <- results$P.Value <= 0.05
  
  # Identify the top 10 genes based on P.Value
  top_genes <- results%>%
    arrange(.data[["P.Value"]], .by_group = FALSE) %>%
    slice_head(n = topn)
  
  # Create a new column for color based on logFC
  results$color <-ifelse(results$significant & results$logFC < 0, "#4f6dae", 
                         ifelse(results$significant & results$logFC > 0, "#6d6e71", "lightgrey"))
  
  #4f6d7a-health color ,#4f6dae
  ##6d6e71- CRS color, #ff9071 tumor color
  # If highlight_genes is provided, update the color and zorder
  if (!is.null(highlight_genes)) {
    for (gene in highlight_genes) {
      results$color[rownames(results) == gene$name] <- gene$color
      results$size[rownames(results) == gene$name] <- 4  # Increase size for highlighted gene
    }
  }
  
  # Create the volcano plot
  p <- ggplot(results, aes(x = logFC, y = -log10(P.Value), color = color)) +
    geom_point(aes(size = ifelse(rownames(results) %in% highlight_genes$name, 4, 2)), 
               alpha = 0.6) +
    scale_color_identity() +  # Use the colors defined in the data
    theme_minimal() +
    labs(title = "", x = "Log2 Fold Change (logFC)", y = "-Log10 P-value") +
    theme(legend.position = "none",
          panel.background = element_rect(fill = "white", color = NA),
          plot.background = element_rect(fill = "white", color = NA)) +  # Hide legend if not needed
    geom_text(data = top_genes, aes(label = rownames(top_genes)), 
              vjust = 1, hjust = 0.5, size = 5, color = "black") +  # Annotate top 10 genes
    geom_point(data = results[results$rownames %in% highlight_genes$name, ],
               aes(x = logFC, y = -log10(P.Value)),
               color= highlight_genes$color, size = 2, alpha = 1, 
               position = position_jitter(width = 0.1, height = 0.1))+# Higher z-order for highlighted genes
    ylim(0,400)
  
  
  
  
  if (save == TRUE){
    ggsave(filename, plot = p, width = 8, height = 6)
  }
  return(p)
}




# set working directory
setwd('/Users/ruppb/Documents/GitHub/20241011.kevin_byrd.ibd_nulisa')

# set the output directory
outdir <- "deepcell_results"

# Check if the directory exists, and create it if it doesn't
if (!dir.exists(outdir)) {
  dir.create(outdir)
}


# set working directory
setwd('/Users/ruppb/Documents/GitHub/deepcell')

# set the output directory
outdir <- "deepcell_results"

# Check if the directory exists, and create it if it doesn't
if (!dir.exists(outdir)) {
  dir.create(outdir)
}


# load protein data
fn = "all_epicells_mean_normal_protein_data.csv"
protein_data <- read.table(fn, header=TRUE, check.names=FALSE,  row.names = 1, sep = ",")


# load clinical data
fn = "all_epicells_mean_normal_clinical_data.csv"
clinical_data <- read.table(fn, header=TRUE, sep=",")


group <- factor(clinical_data$CATEGORY_1_Healthy.Disease, levels=c("HC","CRS", "T", "TA", "Eosinophlis", "B", "Basophils", "CD4 T", "CRS + F", "F", "NK", "Monocytes", "Neutrophils", "CD8 T" ))
design <- model.matrix(~ group)


# # fit linear model for data
fit <- lmFit(protein_data, design)

# apply empirical bayes
fit <- eBayes(fit)


# get results
results_CRS <- topTable(fit, adjust="BH", coef="groupCRS", number=Inf)
results_T <- topTable(fit, adjust="BH", coef="groupT", number=Inf)

# write the data frame to an Excel file
fn = file.path(outdir, "limma.all_data.deepcell.xlsx")
write.xlsx(results_CRS, fn, asTable = TRUE, rowNames=TRUE)

# get reorganized results results
binary_results <- decideTests(fit, method="global", adjust.method="BH")
binary_results <- as.data.frame(binary_results)

fn = file.path(outdir, "limma.all_data.Deepcell.svg")
fn = file.path(outdir, "test.svg")
p <- create_volcano_plot_v2(results_CRS, topn=66,  filename=fn); p


