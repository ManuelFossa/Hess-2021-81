# arima simulations from matlab time series
library("R.matlab")
library("forecast")
library("methods")
args <- commandArgs(trailingOnly=TRUE) # Expect directory of input .mat, name of input .mat, directory of output .mat and name of output .mat

# Variables
narima = 2000
fi_path <- file.path(args[1],args[2])
fo_path <- file.path(args[3],args[4])
#exportR = readMat(fi_path)
exportR = readMat('/media/fossama1/My Passport/VM shared/these/traitement/matlab/objets/articles/z500_qpt_clustering/output/matlab/exportR.mat')
exportR = exportR[[1]]
s1 = length(exportR)
for (i in 1:s1){
  s2 = dim(exportR[[i]][[1]])[2]
  exportR[[i]] = exportR[[i]][[1]][1:s2]
}
exportR_arima = lapply(exportR,auto.arima)
arima_trials = function(x){
  tmp = replicate(narima,simulate(x,bootstrap = TRUE, future = FALSE))
  return(tmp)
  
}
exportR_trials = lapply(exportR_arima,arima_trials)
exportR_trials2 = array(as.numeric(unlist(exportR_trials)),dim=c(s2,narima,s1))
writeMat('/media/fossama1/My Passport/VM shared/these/traitement/matlab/objets/articles/z500_qpt_clustering/data/matlab/arima_trials.mat',arima_trials = exportR_trials2)
