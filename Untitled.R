

findBetaParams <- function(detectionProbability, numObservationLocations){
  beta.1 <- -1
  beta.2 <- 0
  if(detectionProbability >= .5){
    beta.1 <- 0
    beta.2 <- -1
  }
  beta.1_init <- 10
  beta.2_init <- 10
  avg.det_prob <- sum(rbeta(numObservationLocations, beta.1_init, beta.2_init))/numObservationLocations
  while (TRUE){
    if(detectionProbability - .1 < avg.det_prob & avg.det_prob < detectionProbability + .1){
      break  
    }
    avg.det_prob <- sum(rbeta(numObservationLocations, beta.1_init, beta.2_init))/numObservationLocations
  }
}