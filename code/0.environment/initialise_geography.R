# init

require("sp")
require("Imap")
require("gepaf")
require("rgeos")
require("rgdal")
require("scales")

setwd("/Users/tilmangraff/Documents/GitHub/TJ")

# set up geography
# read in some border polygon
borderpoly = SpatialPolygons(readOGR("./input/temp/testenvironment/borderpolygon/ng.shp")@polygons)

# grid it with hexagons
HexPts <-spsample(borderpoly, type="hexagonal", n = 200, offset=c(0,0))

n = length(HexPts)
row.names(HexPts) = 0:(n-1)

# convert the hexagon centroids to polygons
HexPols <- HexPoints2SpatialPolygons(HexPts)

# save it all in one SpatialPolygonsDataFrame (not sure thats actually needed)
HexPolsDf = SpatialPolygonsDataFrame(HexPols, data = data.frame("ID" = 0:(n-1), "x" = HexPts@coords[,1], "y" = HexPts@coords[,2]), match.ID = F)

# create some pseudo travel volumes based on some bogus gravity
Vraw = as.matrix(dist(HexPts@coords, upper=TRUE)^(-3) * 100) + rnorm(n^2, sd = 10)
V = matrix(0, n, n) + as.matrix(Vraw>0) * Vraw

# back out the adjacency matrix
adj = matrix(as.numeric(gTouches(HexPolsDf, byid=TRUE)), n ,n)

# run dijkstra once to get shortest paths for driving


row.names(V) = 0:(n-1)
colnames(V) = 0:(n-1)
row.names(adj) = 0:(n-1)
colnames(adj) = 0:(n-1)

writeOGR(HexPolsDf,"./input/temp/testenvironment", "test",  driver="ESRI Shapefile", overwrite_layer=TRUE)
write.csv(V, "./input/temp/testenvironment/V.csv", row.names=FALSE)
write.csv(adj, "./input/temp/testenvironment/adj.csv", row.names=FALSE)
#
# plot(borderpoly)
# plot(HexPols[borderpoly,])
