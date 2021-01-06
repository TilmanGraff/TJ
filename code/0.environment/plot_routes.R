require("sp")
require("rgdal")
require("rgeos")

setwd("/Users/tilmangraff/Documents/GitHub/TJ")

colors = c("#0098D4", "#E32017", "#FFD300", "#00782A", "#00A4A7", "#F3A9BB", "#A0A5A9", "#9B0056")

hex = readOGR("./input/temp/testenvironment/test.shp")
adj = gTouches(hex, byid=TRUE)

n = length(hex)

# find some random paths

nlines = 6

starts = sample(1:n, nlines)

for(i in 1:nlines){
  thisline = starts[i]
  breaker = 0
  while((length(thisline) < 3 | runif(1)<0.95) & breaker == 0){
    currstation = thisline[length(thisline)]
    nextstops = as.numeric(which(adj[currstation,], arr.ind = TRUE))
    nextstops = nextstops[!nextstops %in% thisline]
    if(length(nextstops) > 1){
      newstop = sample(nextstops,1)
      thisline = c(thisline, newstop)
    }
    if(length(nextstops) == 1){
      newstop = nextstops
      thisline = c(thisline, newstop)
    }
    if(length(nextstops) == 0){
      breaker = 1
    }
  }
  assign(paste0("line", i), thisline)
}

plot(hex, lwd = .5)
#text(HexPts@coords, labels = 1:n, cex = .8)
for(i in 1:nlines){
  points(hex@data[get(paste0("line", i)), c("x","y")], type = "o", col = colors[i], lwd = 5, pch = 19)
}

# identify overlapping lines
nd2trps = function(x){
  x0 = c("", paste(x))
  x1 = c(paste(x),"")
  trps = vector()
  for(i in 2:(length(x0)-1)){
    trps = c(trps, paste(x0[i], x1[i], sep = "to"), paste(x1[i], x0[i], sep = "to"))
  }
  trps = trps[2:(length(trps)-1)]
  return(trps)

}

# identify hubs
alllines = vector()
alltrips = vector()
for(i in 1:nlines){
  alllines = c(alllines, get(paste0("line", i)))
  alltrips = c(alltrips, nd2trps(get(paste0("line", i))))
}

trunktrps = alltrips[which(duplicated(alltrips))]

# draw trunktrips
for(thistrp in trunktrps){
  to = as.numeric(gsub(".*to", "", thistrp))
  from = as.numeric(gsub("to.*", "", thistrp))

  if(to > from){
  whichlines = vector()
  for(i in 1:nlines){
    if(thistrp %in% nd2trps(get(paste0("line", i)))){
      whichlines = c(whichlines, i)
    }
  }

  lineseq.n = length(whichlines)
  for(lineseg in 1:lineseq.n){
    thislineseg = whichlines[lineseg]
    points(hex@data[c(to,from), c("x")], hex@data[c(to,from), c("y")], type = "l", col = colors[thislineseg], lwd = 15-12/(1-lineseq.n) + lineseg*12/(1-lineseq.n))
  }
}
}


hubs = alllines[which(duplicated(alllines))]
points(hex@data[hubs, c("x","y")], col = "black", pch = 21, cex = 2, bg = "white")

legend("bottomright", legend=c("Line 1", "Line 2", "Line 3", "Line 4", "Line 5", "Line 6"), col=colors, lty=1, lwd = 15)
