#creates entries for both visit-visits and occasions where patients answered app questionnaires since those seem to also count.

visit_occurrence <- visits %>% 
  select(uid, patient_id, type_of_visit, type_of_consultation, visit_date, 
         institution) %>% 
  transmute(
    visit_occurrence_id=NA,
    uid,
    visit_concept_id = case_when(
      is.na(type_of_consultation) | type_of_consultation=="personal" ~ as.integer(9202),
      type_of_consultation%in%c("by_phone") ~ as.integer(5083),
    TRUE ~ NA_integer_),
    visit_start_date=visit_date,
    visit_end_date=visit_date,
    visit_concept_id="32879",
    patient_id,
    institution
  ) %>%
  distinct()
  #arrange(person_id, visit_date)

other_visits<-bind_rows(
   basdai%>%anti_join(visits,by=c("patient_id","visit_uid"="uid"))%>%
     transmute(patient_id,date=substr(authored,1,10))%>%
     anti_join(visits,by=c("patient_id","date"="visit_date")),
   asas%>%anti_join(visits,by=c("patient_id","visit_uid"="uid"))%>%
     transmute(patient_id,date=substr(authored,1,10))%>%
     anti_join(visits,by=c("patient_id","date"="visit_date")),
   sf_12%>%anti_join(visits,by=c("patient_id","visit_uid"="uid"))%>%
     transmute(patient_id,date=substr(authored,1,10))%>%
     anti_join(visits,by=c("patient_id","date"="visit_date")),
   basfi%>%anti_join(visits,by=c("patient_id","visit_uid"="uid"))%>%
     transmute(patient_id,date=substr(authored,1,10))%>%
     anti_join(visits,by=c("patient_id","date"="visit_date")),
   covid_19%>%
     transmute(patient_id,date=substr(authored,1,10))%>%
     anti_join(visits,by=c("patient_id","date"="visit_date")),
   psada%>%anti_join(visits,by=c("patient_id","visit_uid"="uid"))%>%
     transmute(patient_id,date=substr(authored,1,10))%>%
     anti_join(visits,by=c("patient_id","date"="visit_date")),
   radai5%>%anti_join(visits,by=c("patient_id","visit_uid"="uid"))%>%
     transmute(patient_id,date=substr(authored,1,10))%>%
     anti_join(visits,by=c("patient_id","date"="visit_date"))
)%>%
  distinct()
  
 visit_occurrence<-bind_rows(
   visit_occurrence,
   other_visits%>%transmute(
     patient_id,
     visit_concept_id="32865",
     visit_start_date=date,
     visit_end_date=date
   )
 )%>%distinct()%>%
   mutate(visit_source_value="concept_not_applicable")

visit_occurrence$visit_occurrence_id<-1:nrow(visit_occurrence)
 
visit_occurrence<-visit_occurrence%>%group_by(
  patient_id
)%>%
  arrange(visit_start_date)%>%
  mutate(
    preceding_visit_occurence_id=lag(visit_occurrence_id)
  )%>%
  ungroup()
