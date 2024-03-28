#Our information is not very detailed here. Note that the very *proper* names are applied at the end for all the objects and columns

location<-visits%>%select(institution)%>%distinct()%>%mutate(
  location_id=NA,
  country_concept_id="4330427",
  location_source_value=paste0(institution,"_",snapshot)
  #location_source_value=NA
)