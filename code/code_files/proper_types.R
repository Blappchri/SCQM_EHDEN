#Could be integrated in the last step, but this also nicely served for checking things

#due to sqlite we use ISO instead of a date tyoe
person<-person%>%transmute(
  person_id=as.integer(person_id),
  gender_concept_id=as.integer(gender_concept_id),
  year_of_birth=as.integer(year_of_birth),
  month_of_birth=as.integer(month_of_birth),
  day_of_birth=NA_integer_,
  birth_datetime=NA_integer_,
  race_concept_id=as.integer(race_concept_id),
  ethnicity_concept_id=as.integer(0),
  location_id=NA_integer_,
  provider_id=NA_integer_,
  care_site_id_=NA_integer_,
  person_source_value,
  gender_source_value=NA_character_,
  gender_source_concept_id=NA_integer_,
  race_source_value=NA_character_,
  race_source_concept_id=NA_integer_,
  ethnicity_source_value=NA_character_,
  ethnicity_source_concept_id=NA_integer_
)%>%distinct()

summary(person)

observation_period<-observation_period%>%transmute(
  observation_period_id=as.integer(row_number()),
  person_id=as.integer(person_id),
  observation_period_start_date=as.character(observation_period_start_date),
  observation_period_end_date=as.character(observation_period_end_date),
  period_type_concept_id=as.integer(period_type_concept_id)
)%>%distinct()

summary(observation_period)

visit_occurrence<-visit_occurrence%>%transmute(
  visit_occurrence_id=as.integer(visit_occurrence_id),
  person_id=as.integer(person_id),
  visit_concept_id=as.integer(visit_concept_id),
  visit_start_date=as.character(visit_start_date),
  visit_start_datetime=NA_integer_,
  visit_end_date=as.character(visit_end_date),
  visit_end_datetime=NA_integer_,
  visit_type_concept_id=as.integer(visit_type_concept_id),
  provider_id=NA_integer_,
  care_site_id=NA_integer_,
  visit_source_value,
  visit_source_concept_id=NA_integer_,
  admitted_from_concept_id=NA_integer_,
  admitted_from_source_value=NA_character_,
  discharged_to_concept_id=NA_integer_,
  discharged_to_source_value=NA_character_,
  preceding_visit_occurrence_id=NA_integer_
)%>%distinct()

summary(visit_occurrence)

condition_occurrence<-condition_occurrence%>%transmute(
  condition_occurrence_id=as.integer(condition_occurrence_id),
  person_id=as.integer(person_id),
  condition_concept_id=as.integer(condition_concept_id),
  condition_start_date=as.character(condition_start_date),
  condition_start_datetime=NA_integer_,
  condition_end_date=as.character(condition_start_date),
  condition_end_datetime=NA_integer_,
  condition_type_concept_id=as.integer(condition_type_concept_id),
  condition_status_sconcept_id=NA_integer_,
  stop_reason=NA_character_,
  provider_id=NA_integer_,
  visit_occurrence_id=NA_integer_,
  visit_detail_id=NA_integer_,
  condition_source_value,
  condition_source_concept_id=NA_integer_,
  condition_status_source_value=NA_integer_
)%>%distinct()

summary(condition_occurrence)

drug_exposure<-drug_exposure%>%transmute(
  drug_exposure_id=as.integer(drug_exposure_id),
  person_id=as.integer(person_id),
  drug_concept_id=as.integer(drug_concept_id),
  drug_exposure_start_date=as.character(drug_exposure_start_date),
  drug_exposure_start_datetime=NA_character_,
  drug_exposure_end_date=as.character(drug_exposure_end_date),
  drug_exposure_end_datetime=NA_character_,
  verbatim_end_date=NA_character_,
  drug_type_concept_id=as.integer(drug_type_concept_id),
  stop_reason=NA_character_,
  refills=NA_integer_,
  quantity=as.numeric(quantity),
  days_supply=NA_integer_,
  sig=NA_character_,
  route_concept_id=as.integer(route_concept_id),
  lot_number=NA_character_,
  provider_id=NA_integer_,
  visit_occurrence_id=as.integer(visit_occurrence_id),
  visit_detail_id=NA_integer_,
  drug_source_value,
  drug_source_concept_id=NA_integer_,
  route_source_value=NA_character_,
  dose_unit_source_value=NA_character_
)%>%distinct()

summary(drug_exposure)

procedure_occurrence<-procedure_occurence%>%transmute(
  procedure_occurrence_id=as.integer(procedure_occurence_id),
  person_id=as.integer(person_id),
  procedure_concept_id=as.integer(procedure_concept_id),
  procedure_date=as.character(procedure_start_date),
  procedure_datetime=NA_character_,
  procedure_end_date=NA_character_,
  procedure_end_datetime=NA_character_,
  procedure_type_concept_id=as.integer(procedure_type_concept_id),
  modifier_concept_id=NA_integer_,
  quantity=NA_integer_,
  provider_id=NA_integer_,
  visit_occurrence_id=NA_integer_,
  viist_detail_id=NA_integer_,
  procedure_source_value=NA_character_,
  procedure_source_concept_id=NA_character_,
  modifier_source_value=NA_character_
)%>%distinct()

summary(procedure_occurrence)

device_exposure<-device_exposure%>%transmute(
  device_exposure_id=as.integer(device_exposure_id),
  person_id=as.integer(person_id),
  device_concept_id=as.integer(device_concept_id),
  device_exposure_start_date=as.character(device_exposure_start_date),
  device_exposure_start_datetime=NA_character_,
  device_exposure_end_date=as.character(device_exposure_end_date),
  device_exposure_end_datetime=NA_character_,
  device_type_concept_id=as.integer(device_type_concept_id),
  unique_device_id=NA_character_,
  production_id=NA_character_,
  quantitiy=NA_integer_,
  provider_id=NA_integer_,
  visit_occurrence_id=NA_integer_,
  visit_detail_id=NA_integer_,
  device_source_value,
  device_source_concept_id=NA_character_,
  unit_concept_id=NA_integer_,
  unit_source_value=NA_character_,
  unit_source_concept_id=NA_character_
)%>%distinct()

summary(device_exposure)

measurement<-measurements%>%transmute(
  measurement_id=as.integer(measurement_id),
  person_id=as.integer(person_id),
  measurement_concept_id=as.integer(measurement_concept_id),
  measurement_date=as.character(measurement_date),
  measurement_datetime=NA_character_,
  measurement_time=NA_character_,
  measurement_type_concept_id=as.integer(measurement_type_concept_id),
  operator_concept_id=NA_integer_,
  value_as_number,
  value_as_concept_id=as.integer(value_as_concept_id),
  unit_concept_id=as.integer(unit_concept_id),
  range_low=NA_integer_,
  range_high=NA_integer_,
  provider_id=NA_integer_,
  visit_occurrence_id=as.integer(visit_occurrence_id),
  visit_detail_id=NA_integer_,
  measurement_source_value,
  measurement_source_concept_id=NA_character_,
  unit_source_value=NA_character_,
  unit_source_concept_id=NA_integer_,
  value_source_value=NA_character_,
  measurement_event_id=NA_integer_,
  meas_event_field_concept_id=NA_integer_
)%>%distinct()

summary(measurements)

observation<-observation%>%transmute(
  observation_id=as.integer(observation_id),
  person_id=as.integer(person_id),
  observation_concept_id=as.integer(observation_concept_id),
  observation_date=as.character(observation_date),
  observation_datetime=NA_character_,
  observation_type_concept_id=as.integer(observation_type_concept_id),
  value_as_number,
  value_as_string,
  value_as_concept_id=NA_integer_,
  qualifier_concept_id=NA_integer_,
  unit_concept_id=NA_integer_,
  provider_id=NA_integer_,
  visit_occurrence_id=NA_integer_,
  visit_detail_id=NA_integer_,
  observation_source_value,
  observation_source_concept_id=NA_integer_,
  unit_source_value=NA_character_,
  qualifier_source_value=NA_character_,
  value_source_value=NA_character_,
  observation_event_id=NA_integer_,
  obs_event_field_concept_id=NA_integer_
)%>%distinct()

summary(observation)

specimen<-specimen%>%transmute(
  specimen_id=as.integer(specimen_id),
  person_id=as.integer(person_id),
  specimen_concept_id=as.integer(specimen_concept_id),
  specimen_type_concept_id=as.integer(specimen_concept_id),
  specimen_date=as.character(specimen_date),
  specimen_datetime=NA_character_,
  quantity,
  unit_concept_id=NA_integer_,
  anatomic_site_concept_id=NA_integer_,
  disease_status_sconcept_id=NA_integer_,
  specimen_source_id=NA_character_,
  specimen_source_value,
  unit_source_value=NA_character_,
  anatomic_site_source_value=NA_character_,
  disease_Status_source_value=NA_character_
)

summary(specimen)

location<-location%>%transmute(
  location_id<-as.integer(location_id),
  address_1=NA_character_,
  address_2=NA_character_,
  city=NA_character_,
  state=NA_character_,
  zip=NA_character_,
  county=NA_character_,
  location_source_value=location_source_value,
  country_concept_id=as.integer(country_concept_id),
  country_source_value=NA_character_,
  latitude=NA_integer_,
  longitude=NA_integer_
)

