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

HexPts <-spsample(borderpoly, type="hexagonal", n = 200, offset=c(0,0))

n = length(HexPts)
row.names(HexPts) = 1:n

HexPols <- HexPoints2SpatialPolygons(HexPts)

HexPolsDf = SpatialPolygonsDataFrame(HexPols, data = data.frame("ID" = 1:n, "x" = HexPts@coords[,1], "y" = HexPts@coords[,2]), match.ID = F)

Vraw = as.matrix(dist(HexPts@coords, upper=TRUE)^(-3) * 100) + rnorm(n^2, sd = 10)
V = matrix(0, n, n) + as.matrix(Vraw>0) * Vraw

adj = as.numeric(gTouches(HexPolsDf, byid=TRUE))

writeOGR(HexPolsDf,"./input/temp/testenvironment", "test",  driver="ESRI Shapefile", overwrite_layer=TRUE)
write.csv(V, "./input/temp/testenvironment/V.csv")
write.csv(adj, "./input/temp/testenvironment/adj.csv")
#
# plot(borderpoly)
# plot(HexPols[borderpoly,])
