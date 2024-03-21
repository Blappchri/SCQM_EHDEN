#Things that belong in the conditions table but are not tracked in the HI system
#Some are per-visit, some are PRO
#Probably the most 'Why didn't you create a function file?'-file, but there is special stuff and exceptions everywhere.


conditions<-mnyc_scoring%>%
  transmute(
    patient_id,
    diagnostic_image_set_uid,
    result=mnyc_score=="positive"
    )%>%
  distinct()%>%
  filter(result)%>%
  left_join(
    diagnostic_image_sets%>%
      select(
        diagnostic_image_set_uid=uid,
        date=diagnostic_image_set_date)
  )%>%
  transmute(
  patient_id,
  condition_concept_id="4052955",
  condition_start_date=substr(date,1,10),
  condition_end_date=substr(date,1,10),
  condition_type_concept_id="32879",#registry,
  condition_source_value="mnyc_score"
)%>%distinct()%>%bind_rows(conditions)

conditions<-psada%>%
  filter(triggers_symptoms_respiratory_tract_infection=="yes")%>%
  transmute(
    patient_id,
    condition_concept_id="4170143",
    condition_start_date=substr(authored,1,10),
    condition_end_date=substr(authored,1,10),
    condition_type_concept_id="32862",
    condition_source_value="symptoms_respiratory_tract_infection"
  )%>%distinct()%>%bind_rows(conditions)

conditions<-psada%>%
  filter(triggers_symptoms_diarrhea=="yes")%>%
  transmute(
    patient_id,
    condition_concept_id="196523",
    condition_start_date=substr(authored,1,10),
    condition_end_date=substr(authored,1,10),
    condition_type_concept_id="32862",
    condition_source_value="symptoms_diarrhea"
  )%>%distinct()%>%bind_rows(conditions)

conditions<-psada%>%
  filter(triggers_symptoms_abdominal_pain=="yes")%>%
  transmute(
    patient_id,
    condition_concept_id="200219",
    condition_start_date=substr(authored,1,10),
    condition_end_date=substr(authored,1,10),
    condition_type_concept_id="32862",
    condition_source_value="symptoms_abdominal_pain"
  )%>%distinct()%>%bind_rows(conditions)


conditions<-visits%>%
  filter(physician_global_skin_manifestation%in%c(
    "medium_infestation",
    "medium_to_strong_infestation",
    "small_infestation",
    "small_to_medium_infestation",
    "strong_infestation"
  ))%>%
  transmute(
    patient_id,
    condition_concept_id="4063431",
    condition_start_date=substr(visit_date,1,10),
    condition_end_date=substr(visit_date,1,10),
    condition_type_concept_id="32879",
    condition_source_value="physician_global_skin_manifestation"
  )%>%distinct()%>%bind_rows(conditions)

conditions<-visits%>%
  filter(
    nail_manifestation_oilnails=="yes"|
      nail_manifestation_pitted_nails=="yes"|
      nail_manifestation_onycholysis=="yes"
  )%>%
  transmute(
    patient_id,
    condition_concept_id="4031649",
    condition_start_date=substr(visit_date,1,10),
    condition_end_date=substr(visit_date,1,10),
    condition_type_concept_id="32879",
    condition_source_value="nail_manifestation-oilnail|pitted|onycholysis"
  )%>%distinct()%>%bind_rows(conditions)

conditions<-covid_19%>%
  filter(
    (
      positive_coronavirus_test=="yes"&
        positive_coronavirus_test_type=="pcr"
    )|(
      flu_like_coronavirus_test_result=="yes"&
        flu_like_coronavirus_test_type=="pcr"
    )
  )%>%
  mutate(
    date=coalesce(
      positive_coronavirus_test_date,
      flu_like_coronavirus_test_date,
      substr(authored,1,10))
  )%>%
  filter(!is.na(date))%>%
  transmute(
    patient_id,
    condition_concept_id="439676",
    condition_start_date=date,
    condition_end_date=date,
    condition_type_concept_id="32879",
    condition_source_value="pos_coronavirus_test|yes_pcr"
  )%>%distinct()%>%bind_rows(conditions)






