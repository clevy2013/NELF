# make variograms of a set of tifs
#Written by Arthur Elmes, Edited by Charlotte Levy on 11/27/2020

# IMPORT LIBRARY  ---------
library(raster)
library(rgdal)
library(gstat)
library(ggplot2)

# VARIABLES -------
size<-100 #500

# IMPORT DATA -------------
# set wd -----
wd_path <- 'D:/NELF_Project/0_OriginalMosaickedTiles/ByMonth' #'/lovells/data02/arthur.elmes/greenland/sensor_intercompare/tif/LC8/wsa/'
setwd(wd_path)

# shapefile to clip with   --------
clip_file_name <- readOGR('D:/NELF_Project/GeographyShapefiles/GeographyShapefiles_4326reproject/MA_reproject.gpkg', verbose = FALSE) #/lovells/data02/arthur.elmes/greenland/sensor_intercompare/shp/intersection_006013_T22WEV_h16v02.shp

file_names <- dir(wd_path, pattern="mosaic.tif")

plot_list = list()

iter = length(file_names) - 1

# For loop to sample -----
for(i in 1:iter){
  try({
    print(file_names[i])
    tif_raster <- raster(file_names[i])
    tif_raster_variable <- tools::file_path_sans_ext(file_names[i])
    
    print("masking raster")  
    # clip the raster to the shapefile and its extent (trim)
    
    masked_raster <- mask(tif_raster, clip_file_name)
    non_na_raster <- trim(masked_raster)
    
    # construct a SpatailPointsDataFrame from a sample of the raster, because using all points, as in the commented out line,
    # is waaaay to resource intensive
    point_data <- as(non_na_raster, 'SpatialPointsDataFrame')
    
    print("sampling raster")
    point_data <- as.data.frame(sampleRandom(x=non_na_raster, size = size, na.rm = TRUE, ext = clip_file_name, xy = TRUE))
    xy <- cbind(point_data[1], point_data[2])
    
    print("masking spatialpointsdf")
    point_data <- SpatialPointsDataFrame(xy, point_data)
    
    # plot the layers to check
    #plot(non_na_raster)
    #plot(point_data, add=TRUE)
    
    tif_raster_variable<-gsub("-", ".", tif_raster_variable)
    f <- paste(tif_raster_variable, "~ 1")
    h <- as.formula(f)
    
    print("running variogram")
    gstat_variogram <- variogram(h, data = point_data)
    # print("ok the variogram is created")
    
    #plot_title = file_names[i]
    #p = plot(gstat_variogram, main = plot_title, cex.main=0.25)
    #plot_list[[i]] = p
    
    # Ok this is dumb.. python I miss you
    x = strsplit(file_names[i], ".", fixed = TRUE)[0:4]
    y = x[[1]][1:4]
    z = paste(y[[1]], y[[2]], y[[3]], y[[4]])
    
    p = ggplot(gstat_variogram, aes(x=dist,y=gamma)) + geom_point()
    q = p + ggtitle(z) + theme(plot.title = element_text(hjust = 0.5))
    plot_list[[i]] = q
    
  })
}

# PLOT OUTPUTS ------------
for(i in 1:length(plot_list)){
  file_name = paste("variogram_", i, ".tif", sep="")
  tiff(file_name)
  print(plot_list[[i]])
  dev.off()
}