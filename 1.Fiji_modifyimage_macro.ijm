//input folder containing original images. insert your input folder directory here 
folder= "___________________" 

//output folder for modified images. insert your output folder directory here  
folder_2= "___________________"

// open file sequentially in folder
fileList= getFileList(folder); 
numFiles= lengthOf (fileList); 

setBatchMode(true);

//run for loop which will optimize the brightness and contrast of images for further segmentation
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
