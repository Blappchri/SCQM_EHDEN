
person<-person%>%transmute(
  person_id=as.integer(person_id),
  gender_concept_id=as.integer(gender_concept_id),
  year_of_birth=as.integer(year_of_birth),
  month_of_birth=as.integer(month_of_birth),
  race_concept_id=as.integer(race_concept_id),
  ethnicity_concept_id=as.integer(0),
  person_source_value,
  person_source_value
)%>%distinct()

summary(person)

observation_period<-observation_period%>%transmute(
  observation_period_id=as.integer(row_number()),
  person_id=as.integer(person_id),
  observation_period_start_date=as.Date(observation_period_start_date),
  observation_period_end_date=as.Date(observation_period_end_date),
  period_type_concept_id=as.integer(period_type_concept_id)
)%>%distinct()

summary(observation_period)

visit_occurrence<-visit_occurrence%>%transmute(
  visit_occurrence_id=as.integer(visit_occurrence_id),
  person_id=as.integer(person_id),
  visit_concept_id=as.integer(visit_concept_id),
  visit_start_date=as.Date(visit_start_date),
  visit_end_date=as.Date(visit_end_date),
  visit_source_value
)%>%distinct()

summary(visit_occurrence)

condition_occurrence<-condition_occurrence%>%transmute(
  condition_occurrence_id=as.integer(condition_occurrence_id),
  person_id=as.integer(person_id),
  condition_concept_id=as.integer(condition_concept_id),
  condition_start_date=as.Date(condition_start_date),
  condition_type_concept_id=as.integer(condition_type_concept_id),
  condition_source_value
)%>%distinct()

summary(condition_occurrence)

drug_exposure<-drug_exposure%>%transmute(
  drug_exposure_id=as.integer(drug_exposure_id),
  person_id=as.integer(person_id),
  drug_concept_id=as.integer(drug_concept_id),
  drug_exposure_start_date=as.Date(drug_exposure_start_date),
  drug_exposure_end_date=as.Date(drug_exposure_end_date),
  drug_type_concept_id=as.integer(drug_type_concept_id),
  quantity=as.numeric(quantity),
  route_concept_id=as.integer(route_concept_id),
  visit_occurrence_id=as.integer(visit_occurrence_id),
  drug_source_value
)%>%distinct()

summary(drug_exposure)

procedure_occurrence<-procedure_occurence%>%transmute(
  procedure_occurrence_id=as.integer(procedure_occurence_id),
  person_id=as.integer(person_id),
  procedure_concept_id=as.integer(procedure_concept_id),
  procedure_date=as.Date(procedure_start_date),
  procedure_type_concept_id=as.integer(procedure_type_concept_id),
  procedure_source_value
)%>%distinct()

summary(procedure_occurrence)

device_exposure<-device_exposure%>%transmute(
  device_exposure_id=as.integer(device_exposure_id),
  person_id=as.integer(person_id),
  device_concept_id=as.integer(device_concept_id),
  device_exposure_start_date=as.Date(device_exposure_start_date),
  device_exposure_end_date=as.Date(device_exposure_end_date),
  device_type_concept_id=as.integer(device_type_concept_id),
  device_source_value
)%>%distinct()

summary(device_exposure)

measurement<-measurements%>%transmute(
  measurement_id=as.integer(measurement_id),
  person_id=as.integer(person_id),
  measurement_concept_id=as.integer(measurement_concept_id),
  measurement_date=as.Date(measurement_date),
  measurement_type_concept_id=as.integer(measurement_type_concept_id),
  value_as_number,
  value_as_concept_id=as.integer(value_as_concept_id),
  unit_concept_id=as.integer(unit_concept_id),
  visit_occurrence_id=as.integer(visit_occurrence_id),
  measurement_source_value
)%>%distinct()

summary(measurements)

observation<-observation%>%transmute(
  observation_id=as.integer(observation_id),
  person_id=as.integer(person_id),
  observation_concept_id=as.integer(observation_concept_id),
  observation_date=as.Date(observation_date),
  observation_type_concept_id=as.integer(observation_type_concept_id),
  value_as_number,
  value_as_string,
  observation_source_value
)%>%distinct()

summary(observation)

specimen<-specimen%>%transmute(
  specimen_id=as.integer(specimen_id),
  person_id=as.integer(person_id),
  specimen_concept_id=as.integer(specimen_concept_id),
  specimen_type_concept_id=as.integer(specimen_concept_id),
  specimen_date=as.Date(specimen_date),
  quantity,
  specimen_source_value
)

summary(specimen)
