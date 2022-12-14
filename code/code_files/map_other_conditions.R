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
    condition_start_date=substr(recording_time,1,10),
    condition_end_date=substr(recording_time,1,10),
    condition_type_concept_id="32862",
    condition_source_value="symptoms_respiratory_tract_infection"
  )%>%distinct()%>%bind_rows(conditions)

conditions<-psada%>%
  filter(triggers_symptoms_diarrhea=="yes")%>%
  transmute(
    patient_id,
    condition_concept_id="196523",
    condition_start_date=substr(recording_time,1,10),
    condition_end_date=substr(recording_time,1,10),
    condition_type_concept_id="32862",
    condition_source_value="symptoms_diarrhea"
  )%>%distinct()%>%bind_rows(conditions)

conditions<-psada%>%
  filter(triggers_symptoms_abdominal_pain=="yes")%>%
  transmute(
    patient_id,
    condition_concept_id="200219",
    condition_start_date=substr(recording_time,1,10),
    condition_end_date=substr(recording_time,1,10),
    condition_type_concept_id="32862",
    condition_source_value="symptoms_abdominal_pain"
  )%>%distinct()%>%bind_rows(conditions)


conditions<-visits%>%
  filter(menopause_state=="perimenopausal")%>%
  transmute(
    patient_id,
    condition_concept_id="45757505",
    condition_start_date=substr(recording_time,1,10),
    condition_end_date=substr(recording_time,1,10),
    condition_type_concept_id="32879",
    condition_source_value="menopause_state_perimenopausal"
  )%>%distinct()%>%bind_rows(conditions)

conditions<-visits%>%
  filter(menopause_state=="postmenopausal")%>%
  transmute(
    patient_id,
    condition_concept_id="4295261",
    condition_start_date=substr(recording_time,1,10),
    condition_end_date=substr(recording_time,1,10),
    condition_type_concept_id="32879",
    condition_source_value="menopause_state_postmenopausal"
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
    condition_start_date=substr(recording_time,1,10),
    condition_end_date=substr(recording_time,1,10),
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
    condition_start_date=substr(recording_time,1,10),
    condition_end_date=substr(recording_time,1,10),
    condition_type_concept_id="32879",
    condition_source_value="nail_manifestation-oilnail|pitted|onycholysis"
  )%>%distinct()%>%bind_rows(conditions)

conditions<-sf_12%>%
  filter(climbing_several_stairs_sf_36=="yes_limited_a_lot")%>%
  transmute(
    patient_id,
    condition_concept_id="4200822",
    condition_start_date=substr(recording_time,1,10),
    condition_end_date=substr(recording_time,1,10),
    condition_type_concept_id="32879",
    condition_source_value="climbing_several_stairs-limited a lot"
  )%>%distinct()%>%bind_rows(conditions)

conditions<-sf_12%>%
  filter(health_in_general_sf_36%in%c("excellent","very_good"))%>%
  transmute(
    patient_id,
    condition_concept_id="4047207",
    condition_start_date=substr(recording_time,1,10),
    condition_end_date=substr(recording_time,1,10),
    condition_type_concept_id="32879",
    condition_source_value="health_in_general-excellent|very_good"
  )%>%distinct()%>%bind_rows(conditions)

conditions<-sf_12%>%
  filter(health_in_general_sf_36%in%c("less_good"))%>%
  transmute(
    patient_id,
    condition_concept_id="4047208",
    condition_start_date=substr(recording_time,1,10),
    condition_end_date=substr(recording_time,1,10),
    condition_type_concept_id="32879",
    condition_source_value="health_in_general-less_good"
  )%>%distinct()%>%bind_rows(conditions)


conditions<-sf_12%>%
  filter(health_in_general_sf_36%in%c("good"))%>%
  transmute(
    patient_id,
    condition_concept_id="4047705",
    condition_start_date=substr(recording_time,1,10),
    condition_end_date=substr(recording_time,1,10),
    condition_type_concept_id="32879",
    condition_source_value="health_in_general-good"
  )%>%distinct()%>%bind_rows(conditions)

conditions<-sf_12%>%
  filter(health_in_general_sf_36%in%c("bad"))%>%
  transmute(
    patient_id,
    condition_concept_id="4047986",
    condition_start_date=substr(recording_time,1,10),
    condition_end_date=substr(recording_time,1,10),
    condition_type_concept_id="32879",
    condition_source_value="health_in_general-bad"
  )%>%distinct()%>%bind_rows(conditions)

conditions<-sf_12%>%
  filter(emotional_health_could_not_work_as_meticulously_as_usual_sf_36=="yes")%>%
  transmute(
    patient_id,
    condition_concept_id="4328349",
    condition_start_date=substr(recording_time,1,10),
    condition_end_date=substr(recording_time,1,10),
    condition_type_concept_id="32879",
    condition_source_value="emotional_health_could_not_work_as_meticulously_as_usual"
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
      substr(recording_time,1,10))
  )%>%
  filter(!is.na(date))%>%
  transmute(
    patient_id,
    condition_concept_id="439676",
    condition_start_date=date,
    condition_end_date=date,
    condition_type_concept_id="32879",
    condition_source_value="positive_coronavirus_test|coronavirus_test_yes_pcr"
  )%>%distinct()%>%bind_rows(conditions)

conditions<-patients%>%
  filter(ra_crit_rheumatoid_factor=="positive")%>%
  left_join(fvis)%>%
  transmute(
    patient_id,
    condition_concept_id="4013263",
    condition_start_date=substr(visit_date,1,10),
    condition_end_date=condition_start_date,
    condition_type_concept_id="32879",
    condition_source_value="ra_crit_rheumatoid_factor_positive"
  )%>%distinct()%>%bind_rows(conditions)

conditions<-patients%>%
  filter(ra_crit_rheumatoid_factor=="negative")%>%
  left_join(fvis)%>%
  transmute(
    patient_id,
    condition_concept_id="4014120",
    condition_start_date=substr(visit_date,1,10),
    condition_end_date=condition_start_date,
    condition_type_concept_id="32879",
    condition_source_value="ra_crit_rheumatoid_factor_negative"
  )%>%distinct()%>%bind_rows(conditions)

conditions<-patients%>%
  filter(hla_b27=="positive")%>%
  left_join(fvis)%>%
  transmute(
    patient_id,
    condition_concept_id="46274008",
    condition_start_date=substr(visit_date,1,10),
    condition_end_date=condition_start_date,
    condition_type_concept_id="32879",
    condition_source_value="hla_b27_positive"
  )%>%distinct()%>%bind_rows(conditions)

conditions<-patients%>%
  filter(hla_b27=="negative")%>%
  left_join(fvis)%>%
  transmute(
    patient_id,
    condition_concept_id="42537344",
    condition_start_date=substr(visit_date,1,10),
    condition_end_date=condition_start_date,
    condition_type_concept_id="32879",
    condition_source_value="hla_b27_negative"
  )%>%distinct()%>%bind_rows(conditions)

