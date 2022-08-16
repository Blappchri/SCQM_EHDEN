#Our information is not very detailed here.

location<-visits%>%select(institution)%>%distinct()%>%mutate(
  location_id=NA,
  country_concept_id="4330427",
  location_source_value=paste0(institution,"_",snapshot)
)