#code based on this resource https://www.datanovia.com/en/blog/how-to-perform-multiple-t-test-in-r-for-different-variables/

library(tidyverse)
library(rstatix)
library(ggpubr)

#median t test for all nasal cells only
fn = "/Users/ruppb/Documents/Github/deepcell/deepcell_summary_samples_nasal_cells_all_forttest.csv"
deepcell_data_allnasal_median <- read.table(fn, header=TRUE, check.names=FALSE, sep = ",")

cols_to_remove <- c("CELL_NUMBER", "TIME_STAMP", "INSTRUMENT_SERIAL_NUMBER", "CELL_FRAME", "IS_BEAD", "IS_CHANNEL_BAR","IS_CUT_CELL","RUN_ID" ,"RUN_START_TIME","SAMPLE_TYPE", "SAMPLE_ID","CELL_ID","UMAP_0", "UMAP1", "leiden" ,"CATEGORY_3_Run Description" , "CATEGORY_4_Sample ID" , "CATEGORY_2_Nostril", "CATEGORY_0_Bloody?", "CATEGORY_5_SampleName", "CATEGORY_1_Healthy/Disease","UMAP_1", "leiden_subclustered")
deepcell_data_allnasal_median <- deepcell_data_allnasal_median[, !names(deepcell_data_allnasal_median) %in% cols_to_remove]

# Transform the data into long format
# Put all variables in the same column except `Species`, the grouping variable
mydata.deepcell_data_allnasal_median <- deepcell_data_allnasal_median %>%
  pivot_longer(-`sample_type`, names_to = "variables", values_to = "value")
mydata.deepcell_data_allnasal_median %>% sample_n(1495)



stat.test_all_nasal <- mydata.deepcell_data_allnasal_median %>%
  group_by(variables) %>%
  t_test(value ~ sample_type) %>%
  adjust_pvalue(method = "BH") %>%
  add_significance()
stat.test_all_nasal
