#load from RDB, transform and load into SQL

#General summary of SCQM strucuture
#A few patient variables, mainly socio-demographics
#Information from doctors collected at certain visits
#Information from patient collected close to visits via app questionnaires
#Information from patients collected weekly or monthly via app questionnaires separate from any visit
#A medication system where for a selected list of medications a list per patient exists with start, stop, dosage and frequency
#A health_issue system similar to the medications. Does not use a standardised vocabulary unfortunately
#Extra informations like biokits or images that were not mapped

snapshot<-"2023-12-01"

library(dplyr)
library(lubridate)
library(magrittr)
library(scqm.dev)#not openly available atm, but any function used from there should be pretty simple and have a nice name
library(readr)
library(DBI)
library(RSQLite)

#comments are in the respective files, though sometimes a shared explanation will be in an earlier code chunk.

source("code/code_files/0_load_scqm_data.R")

source("code/code_files/1_prepare_skeletons.R")


source("code/code_files/2a_map_into_location.R")

source("code/code_files/2b_map_from_HI_system.R")

source("code/code_files/2c_map_into_measurement.R")

source("code/code_files/2d1_map_from_medications_into_drug_exposure.R")

source("code/code_files/2d2_map_from_other_into_drug_exposure.R")

source("code/code_files/2e_map_into_observation_period.R")

source("code/code_files/2f_map_into_person.R")

source("code/code_files/2g_map_into_visit_occurrence.R")

source("code/code_files/2h_map_into_specimen.R")

source("code/code_files/2i1_map_into_condition_occurrence.R")

source("code/code_files/2i2_map_from_puppets_into_condition_occurrence.R")

source("code/code_files/2j_map_into_observation.R")


source("code/code_files/3_combine_and_adjust.R")

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

#snapshot. Last step is done on different machine.
save(list = tables_uncleaned,file = "before_last_step.Rdata")

warning("at this point move to remote instance!")

source("code/code_files/4_finalization.R")

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
