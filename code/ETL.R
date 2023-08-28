#load from rdb, transform and load into an SQLite

#General summary of SCQM strucuture
#A few per patient variables, pretty much the obvious stuff
#Lots of information from doctors collected at certain visits
#Lots of information from patient collected close to visits via app questionnaires
#Lots of information from patients collected weekly or monthly via app questionnaires separate from any visit
#A medication system where for a selected list of medications a list per patient exists with start, stop, dosage and frequency
#A health_issue system similar to the medications. Does not use a standardised vocabulary unfortunately
#Some weird odds and ends like biokits or images that should not really matter

snapshot<-"20230801"

library(dplyr)
library(lubridate)
library(magrittr)
library(scqm.dev)#not openly available atm, but any function used from there should be pretty simple and have a nice name
library(readr)
library(DBI)
library(RSQLite)

#comments are in the respective files, though sometimes a shared explanation will be in an earlier code chunk.

source("code/code_files/load_scqm_data.R")

source("code/code_files/map_localizations.R")

source("code/code_files/create_skeletons.R")

source("code/code_files/map_hi_system.R")

source("code/code_files/map_measurements.R")

source("code/code_files/map_medi_system.R")

source("code/code_files/map_mixed_pro.R")

source("code/code_files/map_observation_period.R")

source("code/code_files/map_other_conditions.R")

source("code/code_files/map_other_medi.R")

source("code/code_files/map_other_observations.R")

source("code/code_files/map_person.R")

source("code/code_files/map_puppets.R")

source("code/code_files/map_visit_occurrence.R")

source("code/code_files/map_specimen.R")

source("code/code_files/finish_and_clean.R")

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

tables_uncleaned=c(
  "person",
  "location",
  "observation_period",
  "visit_occurrence",
  "condition_occurrence",
  "drug_exposure",
  "procedure_occurence",
  "device_exposure",
  "measurements",
  "observation",
  "specimen"
)

#snapshot so Pierre can fix smaller things:
save(list = tables_uncleaned,file = "before_last_step.Rdata")

source("code/code_files/proper_types.R")

#for ease of checking, thus now commented out
# save(
#   condition_occurrence,
#   visit_occurrence,
#   device_exposure,
#   drug_exposure,
#   location,
#   measurement,
#   observation,
#   observation_period,
#   procedure_occurrence,
#   specimen,
#   person,
#   file = paste0("data/EHDEN_Data_",snapshot,".Rdata"))

stor <- dbConnect(SQLite(), "data/SCQM_EHDEN.sqlite")

for (a in tables) {
  dbWriteTable(stor, a, parse(text = a)%>%eval(),overwrite=TRUE)
}

dbGetQuery(stor,"SELECT sql 
FROM sqlite_schema 
WHERE tbl_name = 'person';")

#for the summary
# output_summary<-data.frame(
#   number_of_rows=sapply(tables,function(x){x%>%parse(text = .)%>%eval()%>%nrow()})
# )
#write.csv(output_summary,file = "Summary_of_result.csv")

#for the source-concept map asked for in a milestone
# source_concept_match<-rbind(
#   data.frame(
#     source="internal identifiers",concept="any",table="person"
#   ),
#   data.frame(
#     source="internal identifiers",concept="any",table="location"
#   ),
#   data.frame(
#     source="internal identifiers",concept="any",table="visit_occurrence"
#   ),
#   condition_occurrence%>%select(concept=condition_concept_id,source=condition_source_value)%>%mutate(table="condition_occurrence")%>%distinct(),
#   drug_exposure%>%select(concept=drug_concept_id,source=drug_source_value)%>%mutate(table="drug_exposure")%>%distinct(),
#   procedure_occurrence%>%select(concept=procedure_concept_id,source=procedure_source_value)%>%mutate(table="procedure_occurrence")%>%distinct(),
#   device_exposure%>%select(concept=device_concept_id,source=device_source_value)%>%mutate(table="device_exposure")%>%distinct(),
#   measurement%>%select(concept=measurement_concept_id,source=measurement_source_value)%>%mutate(table="measurement")%>%distinct(),
#   observation%>%select(concept=observation_concept_id,source=observation_source_value)%>%mutate(table="observation")%>%distinct()
# )
#write.csv(source_concept_match,file = "source_to_concept_map.csv")
