# helper funcs

library(geostatsp)

library('geostatsp')
library(raster)
library(RandomFieldsUtils)
# library(RandomFields)

findBetaParams <- function(prob, numObservationLocations){
  beta.1 <- -1
  beta.2 <- 0
  if(prob >= .5){
    beta.1 <- 0
    beta.2 <- -1
  }
  beta.1_init <- 10
  beta.2_init <- 10
  avg.prob <- sum(rbeta(numObservationLocations, beta.1_init, beta.2_init))/numObservationLocations
  while (TRUE){
    if((prob - .1) < avg.prob & avg.prob < (prob + .1)){
      break  
    }
    beta.1_init <- beta.1_init+beta.1
    beta.2_init <- beta.2_init+beta.2
    avg.prob <- sum(rbeta(numObservationLocations, beta.1_init, beta.2_init))/numObservationLocations
  }
  return(c(beta.1_init, beta.2_init))
}


constructEnvs <- function(){
  print("creating random field!")
  model <- c(var=5, range=runif(1),shape=runif(1))
  
  # 1550x1550 col x rows --> 51.3x71.7m resolution
  # for a 1x1 degree region ... pretty small, but
  # maybe thats fine for the synthetic data
  myraster = raster(ncol=1550,nrow=1550,xmn=-121,xmx=-120,ymn=44,ymx=45, 
                    crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
  
  set.seed(runif(1)) 
  
  simu <- RFsimulate(model, x=myraster, n=4)
  print("returning random field!")
  return(simu)
  # 
  
  # 
  # # conditional simulation
  # firstSample = RFsimulate(
  #   model, 
  #   x=SpatialPoints(myraster)[seq(1,ncell(myraster), len=100), ],
  #   n=3
  # )
  # 
  # secondSample = RFsimulate(
  #   model = cbind(var=5:3, range=seq(1.5, 0.5, len=3), shape=seq(0.5, 1.5, len=3)),
  #   err.model = 1,
  #   x= myraster,
  #   data=firstSample,n=4
  # )
  # 
  # plot(secondSample)
  # 
  # # convert the model to RandomFields format and plot
  # if(requireNamespace('RandomFields', quietly=TRUE)) {
  #   RandomFields::plot(modelRandomFields(model))
  # }
}



constructClusteredObs <- function(){
  region <- data.frame(x=c(0,0,50,50), y=c(0,50,0,50))
  subr.1 <- data.frame(x=c(0,0,25,25), y=c(0,25,0,25))
  subr.2 <- data.frame(x=c(0,0,25,25), y=c(0,50,0,50))
  subr.3 <- data.frame(x=c(25,25,50,50), y=c(0,25,0,25))
  subr.4 <- data.frame(x=c(25,25,50,50), y=c(0,50,0,50))
  
  plot(region)
  spsample(z, n = 500, "random", bbox(z1))
}