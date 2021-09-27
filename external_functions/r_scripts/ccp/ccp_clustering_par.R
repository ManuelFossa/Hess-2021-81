## Packages load
library("R.matlab")
library("pvclust")
library("ConsensusClusterPlus")
library("BiocParallel")
source("/media/fossama1/My Passport/VM shared/these/traitement/R/scripts/scripts_sources/divers/consensusclusterplus/cdf2.R")


## System arguments
args <- commandArgs(trailingOnly=TRUE) # Expect directory of input .mat, name of input .mat, directory of output .mat and name of output .mat

## Variables
nc <- as.integer(14)
fi_path <- file.path(args[1],args[2])
fo_path <- file.path(args[3],args[4])
Y <- readMat(fi_path)
Y <- Y[[1]]
size_x <- dim(Y)[1]
size_idx = dim(Y)[3]
clust<-list()
ml <- list()
xd<-list()
for (i in 1:size_idx){
  xd[[i]] <- as.dist(Y[,,i])  
}



## Pvclust clustering
#clust<-ConsensusClusterPlus(xd,maxK=floor(size_x/2),plot='pdf',reps=30000,innerLinkage = "ward",finalLinkage = "ward", clusterAlg = "hc", pItem = 1)

fun<- function(X){
  clust<-ConsensusClusterPlus(X,maxK=10,plot='pdf',reps=3000,innerLinkage = "ward",finalLinkage = "ward", clusterAlg = "hc", pItem = 1)
}
clust<-bplapply(xd,fun, BPPARAM=MulticoreParam(nc))

## Criteria for choosing the number of clusters and cluster classes
# Highest consensus cluster index+pac+cdf area change
fun1 <-function(clust){
res <- calcICL(clust,plot='pngBMP')
for (i in 2:length(clust)){ml[[i]] <- clust[[i]]$ml}
cdf_res <- cdf2(ml)
agg <- aggregate(res$clusterConsensus[,3], by=list(res$clusterConsensus[,1]), mean,na.action=na.omit)
pacv <- matrix(0,nrow = 1,ncol=length(cdf_res[[1]]))
for (i in 1:length(cdf_res[[1]])){pacv[i] <- cdf_res[[1]][[i]]$pac}
deltak <- cdf_res[[2]]
crit_clust <- agg[,2]+(1-pacv)+(1-deltak)
crit_clust[crit_clust==NaN] <- 0
maxk <- which(crit_clust==max(crit_clust,na.rm = TRUE))
if (maxk==1){
	maxk=2}

# Fetch clusters
tmp <- clust[[maxk]]$consensusClass
clust_pick <- matrix(0,nrow=size_x,ncol=size_x)
for (i in 1:maxk){
ind <- which(tmp==i)
clust_pick[1:length(ind),i] <- ind
}
return(clust_pick)
}

clust_pick<-bplapply(clust,fun1,BPPARAM=MulticoreParam(nc))
clust_pick2 <- array(as.numeric(unlist(clust_pick)), dim=c(size_x, size_x, length(clust_pick)))

# Output
writeMat(fo_path,ccp_clust=clust_pick2)
