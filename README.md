# Differential Gene expression
### This repository includes some of the scripts used in my undergraduate thesis at LAU
### The work is typically gene expression based, and statistical in nature

*** Prerequisites ***
Please install all libraries required in the code. The libraries imported are typically mentioned in the first few lines.

## Introduction:
Gene expression arrays permit the classification of cancers into subgroups in addition to the discovery of cancer-specific biomarkers. The levels of gene expression can be used to identify the production rates of protein in lung tumor cells relative to healthy cells which helps differentiate the types of cells. This Work, in R, is done mainly to discover new genes that can aid in distinguishing the subtypes of non-small cell lung cancers. 

Lung cancer in both men and women is the primary cause of cancer-related deaths worldwide. It is classified into two large histological groups: small cell lung carcinoma (15% of all lung cancers) and non-SCLC (NSCLC, 85% of all lung cancers). Typically, NSCLCs are sub- categorized as adenocarcinoma (ADLC), squamous cell carcinoma (SCLC) or large cell
carcinoma. Clinical studies suggest that lung cancer represents a group of morphologically and molecularly heterogeneous diseases even within the same subtype.The goal of this research was to determine the genetic biomarkers for NSCLC histological subtyping.

## Datasets:
We used two publicly available data sets related to gene expression to test the efficacy of different machine learning algorithms. This data is obtained through Lung Cancer Explorer.

Lung Cancer Explorer (LCE) is an online tool developed by the Quantitative Biomedical Research Center (QBRC) of the UT Southwestern Medical Center that allows you to explore information on gene expression from hundreds of public lung cancer databases online for free

### 1. TCGA LUAD 2016, Cancer Genome Atlas Research Group: 
Comprehensive molecular profiling of lung adenocarcinoma published in Nature (https://www.ncbi.nlm.nih.gov/pubmed/?term=25079552). This dataset contains information from 576 patient tissue samples (517 tumors, and 59 normal). The data contains clinical information about the patients, in addition to the gene expression of each patient and some of their normal counterparts (20429 probes). The patients were segmented into their respective stage and substage and many factors were included.
### 2. TCGA LUSC 2016, Cancer Genome Atlas Research Group: 
Comprehensive molecular profiling of squamous cell lung cancer and published in Nature (https://www.ncbi.nlm.nih.gov/pubmed/?term=22960745). Similar to the previous set, and under the same conditions, this dataset contains both clinical and gene expression information from 552 patient tissue samples (501 tumors, and 51 normal).

## Procedure:

### 1. Removing the normal samples as the goal is to perform the analysis on ADLC and SCLC samples:
Only tumor samples were selected for the analysis.
### 2. CLustering and visualization of data:
Dendrograms and histograms were plotted to visualize the behavior of the data.
### 3. Filterinbg out the least variant probes:
These probes were dropped out of the analysis as research shows that less variance does not add signifiance and makes the procedure computationally expensive.
### 4. Computing the means and statistical significance across the two conditions:
Expression means were calculated and t-test was performed to check the significance of each gene probe in the expression set.
### 5. Fold difference calculation 
The difference in mean was set to be the fold difference since the data was log transformed and fold differnece based on ratios would not be statistically accurate.
### 6. Setting the cutoff to select top 13 upregulated and top 13 underregulated genes:
A breaking point approach was used to select top up and downregulated genes, which resulted in asymmetric cutoffs which is fine since the fold is computed based on difference not ratios.
### 7. Finding the differentially expressed genes:
Volcano plots amd heatmaps were generated to visualize the results.


