//input folder containing original images 
folder= "C:/Users/belle/OneDrive - NUS High School/Documents/College/Junior/Winter/Cambridge/Winter/CellCycleData/DHB-Venus_KTR_live-20210519T071242Z-001/DHB-Venus_KTR_live"

//output folder for modified images  
folder_2= "C:/Users/belle/OneDrive - NUS High School/Documents/College/Junior/Winter/Cambridge/Winter/CellCycleData/DHB-Venus_KTR_live-20210519T071242Z-001/edited"

// open file sequentially in folder
fileList= getFileList(folder); 
numFiles= lengthOf (fileList); 

setBatchMode(true);

for (i=0;i<numFiles;i++){
	file=fileList[i];
	open(folder+"/"+file);
	selectWindow(file);	
	run("Enhance Contrast", "saturated=0.35");
	run("Smooth", "stack");
	run("Smooth", "stack");
	outputfilename=folder_2+"/"+file+"_edited.tif";
	saveAs("tiff", outputfilename);
	close();
	
}
