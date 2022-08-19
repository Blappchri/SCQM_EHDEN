#load from rdb, transform and - not yet implemented- load into a local DB

snapshot<-"20220801"

library(dplyr)
library(lubridate)
library(magrittr)
library(scqm.dev)
library(readr)
library(DBI)
library(RSQLite)

source("code_files/load_scqm_data.R")

source("code_files/map_localizations.R")

source("code_files/create_skeletons.R")

source("code_files/map_hi_system.R")

source("code_files/map_measurements.R")

source("code_files/map_medi_system.R")

source("code_files/map_mixed_pro.R")

source("code_files/map_observation_period.R")

source("code_files/map_other_conditions.R")

source("code_files/map_other_medi.R")

source("code_files/map_other_observations_1.R")

source("code_files/map_person.R")

source("code_files/map_puppets.R")

source("code_files/map_visit_occurrence.R")

source("code_files/map_specimen.R")

source("code_files/finish_and_clean.R")

source("code_files/proper_types.R")

#for ease of checking. Will be commented out eventually.

save(
  condition_occurrence,
  visit_occurrence,
  device_exposure,
  drug_exposure,
  location,
  measurement,
  observation,
  observation_period,
  procedure_occurrence,
  specimen,
  person,
  file = paste0("EHDEN_Data_",snapshot,".Rdata"))

stor <- dbConnect(SQLite(), "SCQM_EHDEN.sqlite")

tables=c(
  "person",
  "location",
  "observation_period",
  "visit_occurrence",
  "condition_occurrence",
  "drug_exposure",
  "procedure_occurrence",
  "device_exposure",
  "measurement",
  "observation",
  "specimen"
)

for (a in tables) {
  dbWriteTable(stor, a, parse(text = a)%>%eval(),overwrite=TRUE)
}

output_summary<-data.frame(
  number_of_rows=sapply(tables,function(x){x%>%parse(text = .)%>%eval()%>%nrow()})
)

write.csv(output_summary,file = "Summary_of_result.csv")

source_concept_match<-rbind(
  data.frame(
    source="internal identifiers",concept="any",table="person"
  ),
  data.frame(
    source="internal identifiers",concept="any",table="location"
  ),
  data.frame(
    source="internal identifiers",concept="any",table="visit_occurrence"
  ),
  condition_occurrence%>%select(concept=condition_concept_id,source=condition_source_value)%>%mutate(table="condition_occurrence")%>%distinct(),
  drug_exposure%>%select(concept=drug_concept_id,source=drug_source_value)%>%mutate(table="drug_exposure")%>%distinct(),
  procedure_occurrence%>%select(concept=procedure_concept_id,source=procedure_source_value)%>%mutate(table="procedure_occurrence")%>%distinct(),
  device_exposure%>%select(concept=device_concept_id,source=device_source_value)%>%mutate(table="device_exposure")%>%distinct(),
  measurement%>%select(concept=measurement_concept_id,source=measurement_source_value)%>%mutate(table="measurement")%>%distinct(),
  observation%>%select(concept=observation_concept_id,source=observation_source_value)%>%mutate(table="observation")%>%distinct()
)

write.csv(source_concept_match,file = "source_to_concept_map.csv")
