#Creating all the empty object (except locations, I guess) in a separate step made testing easier.

conditions <- data.frame(
  condition_id=NA,
  person_id=NA,
  condition_concept_id=NA_character_,
  condition_start_date=NA_character_,
  condition_end_date=NA_character_,
  condition_type_concept_id=NA_character_
)%>%filter(!is.na(person_id))

device_exposure <- data.frame(
  device_exposure_id=NA,
  person_id=NA,
  device_concept_id=NA_character_,
  device_exposure_start_date=NA_character_,
  device_exposure_end_date=NA_character_,
  device_type_concept_id=NA_character_
)%>%filter(!is.na(person_id))

observation <- data.frame(
  observation_id=NA,
  person_id=NA,
  observation_concept_id=NA_character_,
  observation_date=NA_character_,
  observation_type_concept_id=NA_character_
)%>%filter(!is.na(person_id))

procedure_occurence <- data.frame(
  procedure_occurence_id=NA,
  person_id=NA,
  procedure_concept_id=NA_character_,
  procedure_start_date=NA_character_,
  procedure_end_date=NA_character_,
  procedure_type_concept_id=NA_character_
)%>%filter(!is.na(person_id))

measurements <- data.frame(
  measurement_id=NA,
  person_id=NA,
  measurement_concept_id=NA_character_,
  measurement_date=NA_character_,
  measurement_type_concept_id=NA_character_,
  value_as_number=NA_real_,
  value_as_concept_id=NA,
  visit_occurence_ids=NA
)%>%filter(!is.na(measurement_id))

drug_exposure <- data.frame(
  drug_exposure_id=NA,
  person_id=NA,
  drug_concept_id=NA_character_,
  drug_exposure_start_date=NA_character_,
  drug_exposure_end_date=NA_character_,
  drug_type_concept_id=NA_character_,
  visit_occurence_ids=NA
)%>%filter(!is.na(person_id))
