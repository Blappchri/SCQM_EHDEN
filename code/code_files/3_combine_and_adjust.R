#just some logistics
#makes sure all the names are correct, all the ids are fully replaced etc.

#nrow(person)
person<-person%>%filter(patient_id%in%c(
  conditions$patient_id,device_exposure$patient_id,drug_exposure$patient_id,
  measurements$patient_id,observation$patient_id,procedure_occurence$patient_id
))%>%filter(patient_id%in%observation_period$patient_id)%>%mutate(
  person_id=row_number()
)
#nrow(person)

to_join_p<-person%>%select(patient_id,person_id)

person<-person%>%select(-patient_id)

location<-location%>%filter(institution%in%visit_occurrence$institution)%>%mutate(location_id=1:nrow(location))

to_join_l<-location%>%select(institution,location_id)

location<-location%>%select(-institution)

visit_occurrence<-visit_occurrence%>%inner_join(to_join_p)%>%left_join(to_join_l)

to_join_v<-visit_occurrence%>%select(uid,visit_occurrence_id)%>%filter(!is.na(uid))%>%distinct()

visit_occurrence<-visit_occurrence%>%select(-uid,-patient_id,-institution)

procedure_occurence<-procedure_occurence%>%select(-person_id)%>%inner_join(to_join_p)%>%select(-patient_id)%>%mutate(procedure_occurence_id=row_number())

observation_period<-observation_period%>%inner_join(to_join_p)%>%select(-patient_id)%>%distinct()

observation<-observation%>%select(-person_id)%>%inner_join(to_join_p)%>%select(-patient_id)%>%distinct()%>%mutate(observation_id=row_number())

measurements<-measurements%>%
  select(-person_id)%>%
  inner_join(to_join_p)%>%
  select(-patient_id)%>%
  select(-visit_occurence_ids)%>%
  distinct()%>%
  mutate(measurement_id=row_number())%>%
  left_join(to_join_v,by=c("visit_uid"="uid"))%>%
  select(-visit_uid)

drug_exposure<-drug_exposure%>%
  select(-person_id)%>%
  rename(uid=visit_occurrence_id)%>%
  inner_join(to_join_p)%>%
  select(-patient_id)%>%
  distinct()%>%
  mutate(drug_exposure_id=row_number())%>%
  left_join(to_join_v,by=c("uid"="uid"))%>%
  select(-uid,-medication_id)%>%
  select(-visit_occurence_ids)

device_exposure<-device_exposure%>%select(-person_id)%>%inner_join(to_join_p)%>%select(-patient_id)%>%distinct()%>%mutate(device_exposure_id=row_number())

condition_occurrence<-conditions%>%
  select(-person_id)%>%
  inner_join(to_join_p)%>%
  select(-patient_id,-pat_uid)%>%
  distinct()%>%
  mutate(condition_occurrence_id=row_number())%>%
  select(-condition_id)%>%
  mutate(condition_start_date=impute_incomplete_dates(condition_start_date))

specimen<-specimen%>%select(-person_id)%>%inner_join(to_join_p)%>%distinct()%>%mutate(specimen_id=row_number())
