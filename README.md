# KTR_analysis

Kinase Translocation Reporters (KTRs) are an effective method to quantify intracellular signalling pathways. When the protein of interest is phosphorylated, KTRs exit the nucleus to the cytoplasm. Measuring the cytoplasmic to nuclear activity will be an indication of protein activity. This pipeline facilitates image analysis by calculating the cytoplasmic-nuclear ratio for dividing cells in live-cell imaging videos. The final output is a measure of the cytoplasmic to nuclear ratio of a dividing cell tracked across time (as shown): 

/insert picture here of nice graph/

In this analysis example, samples were imaged using SiR-DNA and DHB-mVenus (KTR for CDK2 activity). Example images have been uploaded under the 'Example Data' folder.

## Image Analysis Pipeline 

The pipeline consists of 3 stages as denoted below: 
1. Fiji: modify original image
2. CellPose: generate cell segmentation
3. CellProfiler: all downstream steps of data analysis

### Image Analysis Pipeline [Stage 1] 
Using the Fiji software (downloadable [here](https://imagej.net/software/fiji/downloads)), the original microscopy images should be auto-adjusted for brightness and contrast, followed by smoothing the image twice. This modification improves segmentation accuracy downstream of the pipeline, and can be automated using a Fiji macro. The Fiji macro is uploaded under "1.Fiji_modifyimage_macro.ijm" for ease of use. 

### Image Analysis Pipeline [Stage 2] 
In the CellPose software (downloadable [here](https://colab.research.google.com/github/HenriquesLab/ZeroCostDL4Mic/blob/master/Colab_notebooks/Beta%20notebooks/Cellpose_2D_ZeroCostDL4Mic.ipynb)), cell segmentation is conducted to isolate each individual cell as a 'cell object'. There are instructions to conduct cell segmentation in-built within the software. Details on the parameters used is uploaded under "2.CellPose_parameters.txt"

### Image Analysis Pipeline [Stage 3] 

