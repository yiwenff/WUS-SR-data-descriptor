# WUS-SR-data-descriptor
This repository contains Matlab scripts used to generate the figures in the data descriptor paper.

Datasets used in the scripts are uploaded in the data folder. To run f4_plot_sample_SWE, raw netcdf files need to be downloaded from website and stored in directory:
_output_dir_/N39_0W120_0_agg_16/WY2019/SWE_SCA_POST/N39_0W120_0_agg_16_SWE_SCA_POST_WY2018_19.nc

where _output_dir_ is the directory you store these netcdf files.
You can modify the directory structure in the scripts when reading these files instead.

External Functions used in the code includes:

1. getPyPlot_cMap
Konrad (2020). PyColormap4Matlab (https://github.com/f-k-s/PyColormap4Matlab), GitHub. Retrieved July 09, 2020.

2. tight_subplot
Pekka Kumpulainen (2020). tight_subplot(Nh, Nw, gap, marg_h, marg_w) 
(https://www.mathworks.com/matlabcentral/fileexchange/27991-tight_subplot-nh-nw-gap-marg_h-marg_w), 
MATLAB Central File Exchange. Retrieved November 11, 2020.

3. dscatter
Robert Henson (2021). Flow Cytometry Data Reader and Visualization (https://www.mathworks.com/matlabcentral/fileexchange/8430-flow-cytometry-data-reader-and-visualization), MATLAB Central File Exchange. Retrieved July 30, 2021.
