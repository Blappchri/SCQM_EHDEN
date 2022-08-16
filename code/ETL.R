#load from rdb, transform and - not yet implemented- load into a local DB

snapshot<-"20220701"

library(dplyr)
library(lubridate)
library(magrittr)
library(scqm.dev)
library(readr)

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

#while we have not implemented the permanent storage

save(
  condition_occurrence,
  device_exposure,
  drug_exposure,
  location,
  measurements,
  observation,
  observation_period,
  procedure_occurence,
  specimen,
  person,
  file = paste0("EHDEN_Data_",snapshot,".Rdata"))

tables=c(
  "person",
  "observation_period",
  "visit_occurrence",
  "condition_occurrence",
  "drug_exposure",
  "procedure_occurrence",
  "device_exposure",
  "measurements",
  "observation",
  "specimen"
)

output_summary<-data.frame(
  number_of_rows=sapply(tables,function(x){x%>%parse(text = .)%>%eval()%>%nrow()})
)

write.csv(output_summary,file = "Summary_of_result.csv")
