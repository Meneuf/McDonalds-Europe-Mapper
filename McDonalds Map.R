library(rvest)
library(ggmap)
library(XML)




theurl <- "http://www.nkpdwudodmsib.de/mcd/country/de"
tables <- readHTMLTable(theurl)

restaurant.list <- tables[[1]]
restaurant.list$D <- ifelse(restaurant.list$D == "", 0, 1)
restaurant.list$C <- ifelse(restaurant.list$C == "", 0, 1)
restaurant.list$S <- ifelse(restaurant.list$S == "", 0, 1)

restaurant.list$PLZ <- as.character(restaurant.list$PLZ)
restaurant.list$Ort <- as.character(restaurant.list$Ort)
restaurant.list$Straße <- as.character(restaurant.list$Straße)


restaurant.list$Adress <- apply( restaurant.list[ , c(4,2,3) ] , 1 , paste , collapse = " " )
koords[305,]$Adress <- "Gewerbepark Schoenthal 1, 91287 Plech"


restaurant.list <- data.frame(restaurant.list, geocode(restaurant.list$Adress, output = "latlon"))



#############################################################################################################
# Mapping
#############################################################################################################

basemap <- get_map(location='Germany', zoom = 6, maptype='terrain', color='color', source='google')
ggmap(basemap)


map <- ggmap(basemap, extent='panel', base_layer=ggplot(restaurant.list, aes(x=lon, y=lat)))

# add data points
map <- map + geom_point(color = "red", size = 4) 

# add plot labels
map <- map + labs(title="McDonald's Deutschland", x="Longitude", y="Latitude") 

# add title theme
map <- map + theme(plot.title = element_text(hjust = 0, vjust = 1, face = c("bold")))

map
