########
# Synthetic Species Generator
########
setwd("~/Documents/Oregon State/Research/eBird/synSpecGenApp/")
source("helper.R")
source("../occ and grouping checklists/occ-cluster/run experiments/adversarial/syn_helper.R")

############
# QUESTIONS
############
# 1. is the number of sites (svs) something we can control?
#     maybe that's the benefit of this tool... it creates a GT dataset?
# 2. TODO: draw a diagram of each of these params to understand
#    the way they interact/conflict
# 3. TODO: environmental variables ... points closer are often more similar
#    and this determines det/occ probabilities
genSpecies <- function(
  detectionProbability=-1,
  occupiedProbability=-1,
  homogeneity=-1,
  isFragmented=-1,
  numObservationLocations=-1,
  numObservations=-1,
  observationDistribution=-1,
  numHotspots=-1,
  envVars=-1,
  det_covs=c("day_of_year", "time_observations_started", "duration_minutes", "effort_distance_km", "number_observers"),
  site_covs=c("TCB", "TCG", "TCW", "TCA"),
  OR.env,
  sp_region,
  det.df
){
  
  # adding checklists around the specified number of hotspots
  totObservations <- 0
  ######
  if(numHotspots > 0){
    for(hotspot in 1:numHotspots){
      n.hotspot.observations <- round(numObservationLocations/(3*hotspot))

      # hotspot.observations <- nObs.half_life
      
      hotspot.pts <- data.frame(spsample(sp_region, n.hotspot.observations, type="clustered")@coords)
      names(hotspot.pts) <- c('x', 'y')
      coordinates(hotspot.pts) <- c('x', 'y')
      crs(hotspot.pts) <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
      
      if(hotspot == 1){
        hotspot_df <- hotspot.pts
      } else {
        hotspot_df <- rbind(hotspot_df, hotspot.pts)  
      }
      totObservations <- totObservations + n.hotspot.observations
    }
  }
  ######
  
  random.observations <- numObservationLocations - totObservations
  
  pts <- data.frame(spsample(sp_region, random.observations, type="random")@coords)
  coordinates(pts) <- c('x', 'y')
  crs(pts) <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
  
  all_pts <- rbind(pts, hotspot_df)
  
  pts_proj <- spTransform(all_pts, CRSobj=crs(OR.env))
  
  final_df <- data.frame(
    x=all_pts$x, 
    y=all_pts$y,
    # x_proj=pts_proj$x,
    # y_proj=pts_proj$y,
    # checklist_id=cids,
    raster::extract(OR.env, pts_proj)
  ) 
  
  # final_df <- rbind(pts_df.env, hotspot_df)
  
  # final_norm_df <- prep_syn_df(final_df, det.df)
  final_df.det <- attach_det_vars(final_df, det.df, det_covs)
  
  # normalizing all variables besides lat/long 
  # (environmental & detection)
  df_norm.det <- data.frame(
    longitude=final_df.det$x, 
    latitude=final_df.det$y,
    base::scale(subset(final_df.det, select=-c(x, y)))
  )
  
  return(df_norm.det)
}


addOcc.Det.probs <- function(df, 
                             true_det_coeff, 
                             true_occ_coeff, 
                             det_covs=c("day_of_year", "time_observations_started", "duration_minutes", "effort_distance_km", "number_observers"),
                             site_covs=c("TCB", "TCG", "TCW", "TCA")){
  
  # print("here")
  print(true_det_coeff)
  df$det_prob <- true_det_coeff[1] + 
    df[[det_covs[1]]] * true_det_coeff[2] +
    df[[det_covs[2]]] * true_det_coeff[3] +
    df[[det_covs[3]]] * true_det_coeff[4] +
    df[[det_covs[4]]] * true_det_coeff[5] +
    df[[det_covs[5]]] * true_det_coeff[6]
  
  df$det_prob <- expit(as.double(df$det_prob))
  
  print(true_occ_coeff)
  df$occ_prob <- true_occ_coeff[1] + 
    df[[site_covs[1]]] * true_occ_coeff[2] +
    df[[site_covs[2]]] * true_occ_coeff[3] +
    df[[site_covs[3]]] * true_occ_coeff[4] +
    df[[site_covs[4]]] * true_occ_coeff[5] # +
  # df[[site_covs[5]]] * true_occ_coeff[[6]] 
  
  df$occ_prob <- expit(as.double(df$occ_prob))
  return(df)
}











