# Sc_morpholomics
Analysis of Deepcell single cell embeddings 

## Files

### Deepcell_analysis.ipynb

Input- From Axon (Deepcell data analysis platform) either export .tsv file or .json file containing all cells with feature values (Human interpretable and DL) and neccessary metadata. Metadata can be added in to the dataframe generated using .json file if needed

Output- Box plots/histograms, UMAPs from Axon generated x+y values colored by desired variable, cell ids from subsetted proportions, normalized data, .csv files for following analysis in R

### Statistical_testing.R

Input- .csv file where each row represents 1 patient, labelled by disease type, and each column is a median features value (DL_01, AREA, ....)

Output- Welch t-test results comparing each disease state


### Triwise_plot_generator.R

Input- .csv file with 3 columns (one per disease state) and each row representing the normalized mean value of each feature

Output- triwise plot with all features distributed across health and 2 disease states 

### Volcano_plot_generator.R

Input- 

-protein_data.csv (Each column corresponds to 1 cell in the dataset, each row corresponds to a normalized feature value)

-clinical_data.csv (Each row corresponds to 1 cell in the dataset (must be in the same order as the protein_data.csv), each column corresponds to a metadata variable (must include disease state)

Output - .svg file of a volcano plot comparing 2 disease states

### 20260518_Machine_learning.ipynb
Preliminary machine learning testing, added during revisions
