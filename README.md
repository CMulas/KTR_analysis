# KTR_analysis

Kinase Translocation Reporters (KTRs) are an effective method to quantify intracellular signalling pathways. When the protein of interest is phosphorylated, KTRs exit the nucleus to the cytoplasm- measuring the cytoplasmic to nuclear activity will be an indication of protein activity. This pipeline facilitates KTR image analysis by calculating the cytoplasmic-nuclear ratio for dividing cells in live-cell imaging videos. The final output is a measure of the cytoplasmic to nuclear ratio of a dividing cell tracked across time (as shown): 
![image](https://user-images.githubusercontent.com/46695970/121275710-db83dd80-c8ff-11eb-9b01-75433284d26c.png)

And a list of all cells identified per image, with its associated properties (intensity, location, nearest neighbours, etc.): 
![image](https://user-images.githubusercontent.com/46695970/121278201-b5ad0780-c904-11eb-8460-20d8aff02e89.png)


In this analysis example, samples were imaged using SiR-DNA and DHB-mVenus (KTR for CDK2 activity). Example images have been uploaded under the 'Example Data' folder.

## Image Analysis Pipeline 

Different stages of the pipeline will segment cells in an image into the nucleus and the cytoplasm per cell, track and measure properties of each identified cell, and calculate the cytoplasmic to nuclear ratio of dividing cells overtime. The pipeline consists of 4 stages as denoted below: 
1. Fiji: modify original image
2. CellPose: generate cell segmentation
3. CellProfiler: all downstream steps of data analysis (nuclear segmentation, measuring properties) 
4. Rstudio: calculation of the cytoplasmic-nuclear ratio for a successfully tracked cell overtime

### Image Analysis Pipeline [Stage 1] 
Using the Fiji software (downloadable [here](https://imagej.net/software/fiji/downloads)), the original microscopy images should be auto-adjusted for brightness and contrast, followed by smoothing the image twice. This modification improves segmentation accuracy downstream of the pipeline, and can be automated using a Fiji macro. The Fiji macro is uploaded under "1.Fiji_modifyimage_macro.ijm" for ease of use. 

### Image Analysis Pipeline [Stage 2] 
In the CellPose software (downloadable [here](https://colab.research.google.com/github/HenriquesLab/ZeroCostDL4Mic/blob/master/Colab_notebooks/Beta%20notebooks/Cellpose_2D_ZeroCostDL4Mic.ipynb)), cell segmentation is conducted to isolate each individual cell as a 'cell object'. There are instructions to conduct cell segmentation in-built within the software. Details on the parameters used is uploaded under "2.CellPose_parameters.txt"

### Image Analysis Pipeline [Stage 3] 
Using CellProfiler (downloadable [here](https://cellprofiler.org/)), nuclear segmentation, property measuremnet and object tracking will be conducted. The pipeline used for analysis is uploaded under "3.CellProfiler_pipeline.cpp". Instructions for each function or items to optimized ared denoted in the "3.CellProfiler_parameters.txt". 

### Image Analysis Pipeline [Stage 4] 
Using Rstudio (downloadable [here](https://www.rstudio.com/)), the cytoplasmic-nuclear intensity ratio per successfully-tracked dividing cell is calculated with respect to the division time. The code used to do this calculation is uploaded under "4.R_CytotoNuRatio.R".

## Optimization Parameters 
The pipeline has been tested using different markers and imaging parameters (microscope, magnification). Tunable parameters which can be optimized per sample is listed in the "Optimization_Parameters.txt". 


