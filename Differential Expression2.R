# import required libraries
library(dendextend)
library(genefilter)
library(GSEABase)
library(annotate)
library(org.Hs.eg.db)
# set the working directory
setwd("/Users/husseinalilakkis/Desktop/CAPSTONE_DATA/")

# read the already merged dataset to get the label
data = read.csv(file = "finalData.csv", header = TRUE)
data = as.data.frame(data)

#set the class label
class <- data$STATUS

# read the gene expression data from the text files
AD_EXPR <- read.table(file = "Adeno_expression.txt", header = TRUE)
SC_EXPR <- read.table(file = "Squamous_expression.txt", header = TRUE)
#*****************************************************************************************************************
# turn the read data into matrices
AD_EXPR = as.matrix(AD_EXPR)
SC_EXPR = as.matrix(SC_EXPR)
# transform the matrices into 2 data frames
AD_EXPR = as.data.frame(AD_EXPR)
SC_EXPR = as.data.frame(SC_EXPR)
# transpose the dataframes to get samples as rows so we can merge by row
AD_EXPR = t(AD_EXPR)
SC_EXPR = t(SC_EXPR)
# Merge the 2 dataframes by rows to get the complete dataset
data = rbind(AD_EXPR,SC_EXPR )
data = as.data.frame(data)
# set the label 
data$class = class

# remove the normal individuals as these are not of interest
data = subset(data, data$class != "NORMAL")
data = data[,1:20429]

# transpose the data back to samples being as columns
data = t(data)

#*****************************************************************************************************************
# filter genes with low variance as they just add noise, keep top 50%
data <-varFilter(data, var.func=IQR, var.cutoff=0.5, filterByQuantile=TRUE)

# redefine the dataframe
data = as.data.frame(data)
#*****************************************************************************************************************

# Check the loaded dataset
dim(data) # Dimension of the dataset
head(data) # First few rows
tail(data) # Last few rows

###################
# Exploratory plots
###################
str(data)
# Check the behavior of the data
hist(as.matrix(data), col = "gray", main="total Cases - Histogram", ylim=c(0, 10^6))

# Hierarchical clustering of the "samples" based on
# the correlation coefficients of the expression values 
hc = hclust(as.dist(1-cor(data)))
plot(hc, main="Cancer - Hierarchical Clustering", labels=FALSE)
complete_dend <- color_branches(hc, h = 0.4)
dend <- as.dendrogram(complete_dend)
order = as.data.frame(order.dendrogram(dend))

# define dendrogram object to play with, might need to ececute twice:
dend <-  hc %>% as.dendrogram %>% 
  set("labels_to_character") %>% color_branches(k=5)
dend_list <- get_subdendrograms(dend, 5)
# Plotting the result
plot(dend, main = "Original dendrogram", labels = FALSE)
sapply(dend_list, plot)


# Open a PDF for plotting; units are inches by default
pdf("/Users/husseinalilakkis/Desktop/CAPSTONE_DATA/file.pdf", width=80, height=15)

# Do some plotting
plot(dend, main = "Original dendrogram", labels = FALSE)
sapply(dend_list, plot)

# Close the PDF file's associated graphics device (necessary to finalize the output)
dev.off()

#######################################
# Differential expression analysis
#######################################

# Separate the two conditions into two smaller data frames
ADLC = data[,1:517]
SCLC = data[,518:1018]

# Compute the means of the samples of each condition
ADLC.mean = apply(ADLC, 1, mean)
SCLC.mean = apply(SCLC, 1, mean)

head(ADLC.mean)

head(SCLC.mean)

# Just get the maximum of all the means to use for the scale of graphs
limit = max(ADLC.mean, SCLC.mean)

# Scatter plot of the 2 subtypes
plot(SCLC.mean ~ ADLC.mean, xlab = "ADLC", ylab = "SCLC",
     main = "Cancer - Scatter", xlim = c(0, limit), ylim = c(0, limit))
# Diagonal line
abline(0, 1, col = "red")

# Compute fold-change (biological significance)
# Difference between the means of the conditions, can be the other way around
fold = ADLC.mean - SCLC.mean

# Histogram of the fold differences
hist(fold, main = "Cancer - fold differences", col = "gray", ylim = c(0, 6000))

# Compute statistical significance using t-test
pvalue = NULL # Empty list for p-values
tstat = NULL # Empty list for t test statistics

# loop over all genes
for(i in 1 : nrow(data)) { # For each gene : 
  x = ADLC[i,] # ADLC of gene number i
  y = SCLC[i,] # SCLC of gene number i
  
  # Compute t-test between the two conditions
  t = t.test(x, y)
  
  # Put the current p-value in the pvalues list
  pvalue[i] = t$p.value
  # Put the current t-statistic in the tstats list
  tstat[i] = t$statistic
}

head(pvalue)

# Histogram of p-values, use (-log10)
hist(-log10(pvalue), col = "gray")

# put the biological significance (fold-change)
# and statistical significance (p-value) in one plot
plot(fold, -log10(pvalue), main = "Cancer - Volcano", xlim =c(-2.5,2.5))

# set the lower limit cutoff
fold_cutoff = -1.7
pvalue_cutoff = 0.01
abline(v = 1.04, col = "blue", lwd = 3)
abline(v = fold_cutoff, col = "red", lwd = 3)
abline(h = -log10(pvalue_cutoff), col = "green", lwd = 3)

# Screen for the genes that satisfy the filtering criteria
# Fold-change filter for "biological" significance
filter_by_fold = fold <= fold_cutoff | fold >= 1.04

# check the size of the filtered by fold 
dim(data[filter_by_fold, ])

# P-value filter for "statistical" significance
filter_by_pvalue = pvalue <= pvalue_cutoff
dim(data[filter_by_pvalue, ])

# Combined filter (both biological and statistical)
filter_combined = filter_by_fold & filter_by_pvalue

# get rid of all other non filtered genes from the dataframe
filtered = data[filter_combined,]
dim(filtered)

head(filtered)


# generate the volcano plot again,
# highlight the significantly differentially expressed genes in red
plot(fold, -log10(pvalue), main = "Cancer - Volcano #2", xlim = c(-2.5,2.5))
points (fold[filter_combined], -log10(pvalue[filter_combined]),
        pch = 16, col = "red")

# Highlighting SCLC up-regulated in red and ADLC upregulated in blue
plot(fold, -log10(pvalue), main = "CANCER - Volcano #3", xlim = c(-2.5,2.5))
points (fold[filter_combined & fold < 0],
        -log10(pvalue[filter_combined & fold < 0]),
        pch = 16, col = "red")
points (fold[filter_combined & fold > 0],
        -log10(pvalue[filter_combined & fold > 0]),
        pch = 16, col = "blue")

# Cluster the rows (genes) & columns (samples) by correlation
rowv = as.dendrogram(hclust(as.dist(1-cor(t(filtered)))))
colv = as.dendrogram(hclust(as.dist(1-cor(filtered))))
filtered = as.matrix(filtered)

# Takes the gene ENTREZIDS of  expression data
geneSymbols = as.character(row.names(filtered))

# Search the database for the respective gene symbols
annotations = select(org.Hs.eg.db, geneSymbols, "SYMBOL", "ENTREZID")

# set gene symbol as names instead of entrezID
row.names(filtered) <- annotations$SYMBOL

# Generate a heatmap of the selected genes
heatmap(filtered, Rowv=rowv, Colv=colv, cexCol=0.7)

# Save the DE genes to a text file
write.table (filtered, "DIFEX.txt", sep = "\t",
             quote = FALSE)

#############################################################################
# this is just to check the correlation between filtered genes and the significance
# not included in the report
#############################################################################

n = nrow(filtered)

cor.table = NULL
x = NULL
y = NULL
cor.val = NULL
cor.sig = NULL

for (i in 1 : (n-1)) {
  x_name = rownames(filtered)[i]
  x_exps = filtered[i, ]	
  
  for (j in (i+1) : n) {
    y_name = rownames(filtered)[j]
    y_exps = filtered[j, ]
    
    output = cor.test(x_exps,y_exps)
    
    x = c(x, x_name)
    y = c(y, y_name)
    cor.val = c(cor.val, output$estimate)
    cor.sig = c(cor.sig, output$p.value)
  }
}

cor.table = data.frame (x, y, cor.val, cor.sig)

dim(cor.table)
head(cor.table)

sig_cutoff = 0.001

cor.filtered = subset (cor.table, cor.sig < sig_cutoff)

dim(cor.filtered)
head(cor.filtered)

#############################################################################