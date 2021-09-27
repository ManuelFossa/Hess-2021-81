# Hess-2021-81
Spatio-temporal and cross-scale interactions in hydroclimate variability: a case-study in France

Data supporting the article "Spatio-temporal and cross-scale inteeractions in hydroclimate variability" in review in Hydrology and Earth System Sciences

I) Requirements
  - Any Linux CLI
  - Matlab with the following (official) toolboxes:
      - Parallel toolox
      - Signal analysis toolbox
      - Mapping toolbox
  - R with the following packages
      - "cluster" (https://cran.r-project.org/web/packages/cluster/cluster.pdf)
      - "consensusclusterplus" (https://bioconductor.org/packages/release/bioc/vignettes/ConsensusClusterPlus/inst/doc/ConsensusClusterPlus.pdf)
  - Python (2.7)
      - Pyclits (https://github.com/jajcayn/pyclits)
      
  
      
II) Structure
  - The code is split in two parts
      - qpt_clustering_for_cmi.m 
        - Main script for computations
      - qpt_clustering_plot.m
        - Script for plots
  - Two mat files in data/matlab/ contain results from computations at both monthly and annual time steps:
      - wks_qpt_clustering_for_cmi_monthly_11.mat
      - wks_qpt_clustering_for_cmi_10_annual.mat


        
        

