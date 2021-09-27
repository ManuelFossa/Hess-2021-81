## Fuzzy Clustering from distance matrix

# Packages load
library("R.matlab")
library("cluster")

# System arguments
args <- commandArgs(trailingOnly=TRUE) # Expects directory of input .mat, name of input .mat, directory of output .mat and name of output .mat

# Variables
fi_path <- file.path(args[1],args[2])
fo_path <- file.path(args[3],args[4])
Y <- readMat(fi_path)
Y <- Y[[1]]

# Fanny clustering
k_i <-floor((dim(Y)[1]/2))-1
fanny_clust <- list()
fanny_widths <- list()
for (k in 1:(k_i-1)){
  fanny_clust[[k]] <- fanny(Y,k_i,diss = TRUE,memb.exp = 1.5, maxit = 3000)
  fanny_widths[[k]] <- fanny_clust[[k]]$silinfo$clus.avg.widths
  k_i<-k_i-1
}

# Computing the optimal number of clusters
fanny_clust_sd <- 1-sapply(fanny_widths,sd)
fanny_clust_mean <- sapply(fanny_widths,mean)
fanny_clust_sum <- fanny_clust_sd+fanny_clust_mean
tmp <- which(fanny_clust_sum == max(fanny_clust_sum))
index_nc <- (floor((dim(Y)[1]/2)))-tmp 


# Keeping the best fuzzy clustering
fanny_clust <- fanny_clust[[index_nc]]$membership

# Output
writeMat(fo_path,fanny_clust=fanny_clust)
