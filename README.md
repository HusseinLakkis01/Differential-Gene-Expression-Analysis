# Differential Gene expression
### This repository includes some of the scripts used in my undergraduate thesis at LAU
### The work is typically gene expression based, and statistical in nature

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

## Merging and filtering:
These 2 datasets were
