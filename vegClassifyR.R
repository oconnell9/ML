##    VEG  CLASSIFYR           ##
##      SEPT 2022              ##
##  ERIN CATHERINE O'CONNELL   ##
#################################

#### THE PURPOSE OF THIS SCRIPT IS TO CLASSIFY RS VEG FOR ROCKER B ###


#######################
ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

packages <- c('httr','jsonlite','geojsonio','geojsonR','rgdal',
              'sp','RODBC','raster','rasterVis','RColorBrewer','sf','ggplot2','getPass',
              'dplyr','tidyr','readr','lubridate','plotly',
              'plotly', 'glmmTMB','animation', 'terra')

### More packages may be added to the previous vector as needed ###
ipak(packages)
####################

#START:
# Pull in NAIP IMAGERY
    RB<- rast('/Volumes/big_game/Erin_OConnell/data/RB OIL DATA/FIELD_DATA/ecog_imagery/Final.tif') #Imagery 

    
    #### PASTURE BOUNDARES ###
    rb.aoi <- vect('/Users/eco20il/Downloads/Rocker_B_Pastures/Rocker_B_Pastures.shp')  
    
    # NIR
    plot(RB$Final_4)
    plot(rb.aoi, add= TRUE)
    
    
    # Unsup
    nir<- RB$Final_4
    nir <- getValues(nir)
    
    RB<- raster('/Volumes/big_game/Erin_OConnell/data/RB OIL DATA/FIELD_DATA/ecog_imagery/Final.tif') #Imagery 
    class(RB)
    
    hist(RB)
    
    # rgb<- raster::stack(RB$Final_4,RB$Final_1, RB$Final_2 )
    
    plotRGB(RB, r = RB$Final_1, g = RB$Final_3, b = RB$Final_2)
    
    # Pull values from raster 
    
    
    
#### INTERACTIVE NIR
# Pulled from Justin's 
    
    ###---------------------------------###
    ### Interactive map of NAIP Imagery ###
    ###---------------------------------###
    
    ### Packages and Credentials ###--------------------------------
    
    ipak <- function(pkg){
      new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
      if (length(new.pkg)) 
        install.packages(new.pkg, dependencies = TRUE)
      sapply(pkg, require, character.only = TRUE)
    }
    
    ipak(c('getPass','httr','jsonlite','geojsonio','geojsonR','rgdal','rstac','tmap','basemaps',
           'lubridate', 'RPostgres', 'rpostgis','sf','sfheaders','terra','rasterVis'));rm(ipak)
    
    # Connect to BRI database
    con <- RPostgres::dbConnect(RPostgres::Postgres(), 
                                dbname = 'bri_warehouse', host = '10.1.4.132', port = 5432, 
                                user = getPass('Username'), password = getPass('Password')) 
    
    
    ### Load Image ###----------------------------------------------
    
    ext <- basemaps::draw_ext()
    
    img <- rast('/Volumes/big_game/Erin_OConnell/data/RB OIL DATA/FIELD_DATA/ecog_imagery/Final.tif')
    
    
    img <- crop(rast('/Volumes/big_game/Erin_OConnell/data/RB OIL DATA/FIELD_DATA/ecog_imagery/Final.tif'),
                vect(st_transform(ext, st_crs(img))))
    
    #plot(img)
    
    RGB(img) <- c(4,1,2)
    
    plot(img) 
    
    ### Make a tmap ###---------------------------------------------
    
    tmap_options(#max.categories = length(unique(dat.gps$animal_id)),
      basemaps = c(Topographic = "Esri.WorldTopoMap",
                   Imagery = "Esri.WorldImagery"))
    
    tmap_mode('view')
    
    tpMap2 <- 
      tm_shape(img) +
      tm_rgb(4,1,2) 
    
    tpMap2
    