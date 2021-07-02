#Converting excel sheet to track 1 dividing cell's cytoplasmic to nuclear ratio over time. 

####Step 1 and 2####

#With the visualization of object tracking images generated in CellProfiler, inspect the image to identify dividing cells with the corresponding labeled number on the image. 
#This program tracks the intensity of 1 dividing cell over time. 

v<-12 #labeled number on cell of interest. Change accordingly 
N<-26 #I saved individual datasets in different folders that differed by a number; for ease of changing directory across different samples. 


pathway<-paste("____________",N,sep='') #insert your input file directory here
setwd(pathway)

library(ggplot2)
library(readxl)
library(ggpubr)
library(dplyr)
library(tidyr)
library(gdata)
library(RColorBrewer)

#import excel spread sheet
Nucleus_intensity<-read_excel("MyExpt_Nucleus_2.xlsx")
Cytoplasm_intensity<-read_excel("MyExpt_Cytoplasm.xlsx")

Nucleus_intensity<-as.data.frame(Nucleus_intensity)
Cytoplasm_intensity<-as.data.frame(Cytoplasm_intensity)

#isolate the measurements for the cell of interest 
ratio<-data.frame(Nucleus_intensity$ImageNumber, Nucleus_intensity$ObjectNumber,Nucleus_intensity$TrackObjects_Label_100,Nucleus_intensity$Intensity_MeanIntensity_KTR,Cytoplasm_intensity$Intensity_MeanIntensity_KTR, Cytoplasm_intensity$AreaShape_Area)
colnames(ratio)<-c('ImageNumber','ObjectNumber','TrackObjectsLabel','Nuclear Intensity','Cytoplasmic Intensity', 'Cytoplasm Area')
ratio$Ratio<-ratio$`Cytoplasmic Intensity`/ratio$`Nuclear Intensity`
ratio_2<-subset.data.frame(ratio, ratio$TrackObjectsLabel==v)

####Step 3#####
#label cell trajectory for individual cell (output: dotplot_line)

#when each cell divides, split them into 2 lineages, 0 for parent, 1 and 2 for daughter cell

compiled<-data.frame(matrix(ncol=8,nrow=0))
len<-max(ratio_2$ImageNumber)

for (n in 1:len){
  individual<-subset.data.frame(ratio_2, ratio_2$ImageNumber==n)
  y<-nrow(individual)
  individual$lineage<-ifelse(y==1, 'parent',
                             ifelse(y>=1,'daughter'))
  
  individual$indexing<-c(1:y)
  compiled<-rbind(compiled,individual)
}

#isolate image frames before division and label the image frame as '0' under indexing
individual_2<-subset.data.frame(compiled,compiled$lineage=='parent')
individual_2$indexing<-0

#isolate image frames after division and label the image frame as '1' or '2' under indexing
individual_3<-subset.data.frame(compiled,compiled$lineage=='daughter')
splitframe<-individual_3$ImageNumber[1] #frame in which cell divides 
compiled_2<-rbind(individual_2, individual_3)

#normalize the division time. i.e. the cell will divide when t=0
compiled_2$ImageNumber<-compiled_2$ImageNumber-splitframe
category<-c(compiled_2$indexing)


#generate the cytoplasmic-nuclear ratio vs division time plot as individual datapoints
dotplot<-ggplot(compiled_2, aes(x=ImageNumber,y= `Ratio`,col=category))+geom_jitter(position=position_jitter(0.2))+theme_bw()+xlab('Division Time')

#generate the cytoplasmic-nuclear ratio vs division time plot as a line for the parent cell and daughter cells 
dotplot_line<-ggplot(compiled_2, aes(x=ImageNumber,y= `Ratio`,col=as.factor(indexing)))+geom_line()+theme_bw()+xlab('Division Time')

#I extracted the cytoplasmic area for dividing cells. You can also measure other properties of your interest by changing the properties extracted in line 30 of the code
dotplot_check<-ggplot(compiled_2,aes(x=ImageNumber, y=`Cytoplasm Area`,col=category))+geom_jitter(position=position_jitter(0.2))+theme_bw()+xlab('Division Time')
dotplot_check_line<-ggplot(compiled_2,aes(x=ImageNumber, y=`Cytoplasm Area`,col=as.factor(indexing)))+geom_line()+theme_bw()+xlab('Division Time')


####Step 4####
#population-based data

#This section allows you to plot the total intensity of the cell population overtime to check for photobleaching of the sample (output:timelapse)
#you can also plot the average nuclear-cytoplasmic ratio of all the cells in 1 image over time (output:timelapse_2)
ratio<-subset.data.frame(ratio,ratio$'Cytoplasmic Intensity'>0)
ratio$ratio<-ratio$'Nuclear Intensity'/ratio$'Cytoplasmic Intensity'

total<-data.frame(matrix(ncol=3, nrow=0))
colnames(total)<-c('z','mean','sd')

for (z in 1:33){
  Nucleus_intensity_KTR<-data.frame(cbind(Nucleus_intensity$ImageNumber, Nucleus_intensity$ObjectNumber,Nucleus_intensity$Intensity_MeanIntensity_KTR))
  Nucleus_intensity_KTR_individual<-subset(Nucleus_intensity_KTR,Nucleus_intensity$ImageNumber==z)
  colnames(Nucleus_intensity_KTR_individual)<-c("ImageNumber", "ObjectNumber", "Intensity")
  
  
  Cytoplasm_intensity_KTR<-data.frame(cbind(Cytoplasm_intensity$ImageNumber,Cytoplasm_intensity$ObjectNumber,Cytoplasm_intensity$Intensity_MeanIntensity_KTR))
  Cytoplasm_intensity_KTR_individual<-subset(Cytoplasm_intensity_KTR,Cytoplasm_intensity$ImageNumber==z)
  colnames(Cytoplasm_intensity_KTR_individual)<-c("ImageNumber","ObjectNumber","Intensity")
  
  
  combined2<-cbind(Nucleus_intensity_KTR_individual,Cytoplasm_intensity_KTR_individual$Intensity)
  colnames(combined2)<-c("Image Number", "Object Number", "Nuclear Intensity", "Cytoplasmic Intensity (Cell Pose)")
  combined2<-subset.data.frame(combined2,combined2$'Cytoplasmic Intensity'>0)
  combined2$whole_intensity<-combined2$`Nuclear Intensity`+ combined2$`Cytoplasmic Intensity (Cell Pose)`
  combined2$ratio<-combined2$`Nuclear Intensity`/ combined2$`Cytoplasmic Intensity (Cell Pose)`
  
  mean<-mean(combined2$whole_intensity)
  sd<-sd(combined2$whole_intensity)
  
  mean_ratio<-mean(combined2$ratio)
  sd_ratio<-sd(combined2$ratio)
  
  individual<-data.frame(z, mean, sd, mean_ratio,sd_ratio)
  colnames(individual)<-c('z','mean','sd','ratio mean', 'ratio sd')
  
  total<-rbind(total, individual)
  
}

sd<-c(total$sd)
timelapse<-ggplot(data=total,
                  aes(x=total$z,y=total$mean))+geom_point(color='red')+geom_errorbar(width=.1, aes(ymin=total$mean-sd,ymax=total$mean+sd))+geom_line(color='red')+theme_Publication()+labs(x='Frame no.',y='Mean Whole Intensity')
sd_2<-c(total$'ratio sd')
timelapse_2<-ggplot(data=total,
                    aes(x=total$z,y=total$'ratio mean'))+geom_point(color='red')+geom_errorbar(width=.1, aes(ymin=total$'ratio mean'-sd_2,ymax=total$'ratio mean'+sd_2))+geom_line(color='red')+theme_Publication()+labs(x='Frame no.',y='Intensity Ratio')

####Step 5####
#outlier analysis

#if you are interested to see which cells create outlier ratio intensities, outliers and the corresponding object number has also been generated (output:dotplot_2)
#generate dotplot
df_dotplot<-data.frame(ratio$ImageNumber,ratio$TrackObjectsLabel, ratio$ratio)
colnames(df_dotplot)<-c('ImageNumber','TrackObjectsLabel', 'ratio')
UpperboundOutlier<-mean(ratio$ratio)+2*sd(ratio$ratio)
LowerboundOutlier<-mean(ratio$ratio)-2*sd(ratio$ratio)
df_dotplot$outlier<-ifelse(ratio$ratio>=UpperboundOutlier|ratio$ratio<=LowerboundOutlier,'Yes','No')

outlier_type<-c(df_dotplot$outlier)

dotplot_2<-ggplot(df_dotplot, aes(group=ImageNumber,x=ImageNumber,y=ratio,col=outlier))+geom_jitter(position=position_jitter(0.2))+theme_bw()+geom_text(data=subset(df_dotplot,outlier=='Yes'),aes(ImageNumber,ratio,label=TrackObjectsLabel),hjust=1,vjust=1,size=3,colour='black')

####Step 6#### 
#export data from graphs into csv file. Un-comment the file if you want to export the data. Data will be exported into a folder named 'data'.
# #export data
#  output_2<-paste(pathway,'/data/','total.csv',sep='')
#  write.csv(total,output_2)
# #
#  output_3<-paste(pathway,'/data/',v,'_individualcell.csv',sep='')
#  write.csv(compiled_2, output_3)
