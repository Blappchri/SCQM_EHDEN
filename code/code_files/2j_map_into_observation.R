#some things that belong in the observation table from scattered locations

observation<-illness_mastering%>%
  select(-contains("freq"))%>%
  select(-exercise_regularly_no)%>%
  filter(if_any(contains("exercise"),~.x=="yes"))%>%
  transmute(
    patient_id,
    observation_concept_id="4026921",
    observation_date=substr(authored,1,10),
    observation_type_concept_id="32862",
    observation_source_value="exercise_regularily_no"
  )%>%distinct()%>%bind_rows(observation)

observation<-socioeco%>%
  filter(schooling_high_school_university_studies=="yes")%>%
  group_by(patient_id)%>%
  slice_min(authored)%>%
  ungroup()%>%
  transmute(
    patient_id,
    observation_concept_id="4076230",
    observation_date=substr(authored,1,10),
    observation_type_concept_id="32862",
    observation_source_value="hs_university_studies"
  )%>%distinct()%>%bind_rows(observation)

observation<-socioeco%>%
  filter(schooling_high_school_university_studies=="yes"|
           schooling_compulsory_school=="yes"|
           schooling_vocational_training=="yes"
           )%>%
  group_by(patient_id)%>%
  slice_min(authored)%>%
  ungroup()%>%
  transmute(
    patient_id,
    observation_concept_id="43021808",
    observation_date=substr(authored,1,10),
    observation_type_concept_id="32862",
    observation_source_value="hs_university|compulsory|vocational"
  )%>%distinct()%>%bind_rows(observation)

observation<-socioeco%>%
  filter(
    pensioned=="yes"
  )%>%
  group_by(patient_id)%>%
  slice_min(authored)%>%
  ungroup()%>%
  transmute(
    patient_id,
    observation_concept_id="4022069",
    observation_date=substr(authored,1,10),
    observation_type_concept_id="32862",
    observation_source_value="pensioned"
  )%>%distinct()%>%bind_rows(observation)

observation<-socioeco%>%
  filter(
    house_person=="yes"
  )%>%
  transmute(
    patient_id,
    observation_concept_id="40485425",
    observation_date=substr(authored,1,10),
    observation_type_concept_id="32862",
    observation_source_value="house_person(bad name in original)"
  )%>%distinct()%>%bind_rows(observation)

observation<-socioeco%>%
  filter(
    scholar=="yes"
  )%>%
  transmute(
    patient_id,
    observation_concept_id="4277918",
    observation_date=substr(authored,1,10),
    observation_type_concept_id="32862",
    observation_source_value="scholar(bad name in original)"
  )%>%distinct()%>%bind_rows(observation)


#We have the same Q multiple times due to how diagnoses work
observation<-visits%>%
  filter(
    !is.na(global_patient_estimate_disease_activity)
  )%>%
  transmute(
    patient_id,
    value_as_number=global_patient_estimate_disease_activity,
    observation_concept_id="46235641",
    observation_date=substr(visit_date,1,10),
    observation_type_concept_id="32862",
    observation_source_value="global_patient_estimate_disease_activity"
  )%>%distinct()%>%bind_rows(observation)

observation<-basdai%>%
  filter(
    !is.na(global_patient_estimate_disease_activity)
  )%>%
  transmute(
    patient_id,
    value_as_number=global_patient_estimate_disease_activity,
    observation_concept_id="46235641",
    observation_date=substr(authored,1,10),
    observation_type_concept_id="32862",
    observation_source_value="global_patient_estimate_disease_activity"
  )%>%distinct()%>%bind_rows(observation)

observation<-psada%>%
  filter(
    !is.na(global_patient_estimate_disease_activity)
  )%>%
  transmute(
    patient_id,
    value_as_number=global_patient_estimate_disease_activity,
    observation_concept_id="46235641",
    observation_date=substr(authored,1,10),
    observation_type_concept_id="32862",
    observation_source_value="global_patient_estimate_disease_activity"
  )%>%distinct()%>%bind_rows(observation)

observation<-radai5%>%
  filter(
    !is.na(global_patient_estimate_disease_activity)
  )%>%
  transmute(
    patient_id,
    value_as_number=global_patient_estimate_disease_activity,
    observation_concept_id="46235641",
    observation_date=substr(authored,1,10),
    observation_type_concept_id="32862",
    observation_source_value="global_patient_estimate_disease_activity"
  )%>%distinct()%>%bind_rows(observation)


smoke_stuff<-derive_smoking_status(visits,socioeco,euroqol)

observation<-smoke_stuff%>%
  transmute(
    patient_id,
    observation_concept_id=case_when(
      smoking_summary=="current"~"4298794",
      smoking_summary=="former"~"4310250",
      smoking_summary=="never"~"4144272",
    ),
    observation_date=substr(visit_date,1,10),
    observation_type_concept_id="32862",
    observation_source_value="complex derivation"
  )%>%distinct()%>%bind_rows(observation)

observation<-radai5%>%
  filter(
    !is.na(morning_stiffness_duration_radai)
  )%>%
  transmute(
    patient_id,
    value_as_string=morning_stiffness_duration_radai,
    observation_concept_id="40483597",
    observation_date=substr(authored,1,10),
    observation_type_concept_id="32862",
    observation_source_value="morning_stiffness_duration"
  )%>%distinct()%>%bind_rows(observation)

observation<-basdai%>%
  filter(
    !is.na(basdai_6)
  )%>%
  transmute(
    patient_id,
    value_as_string=case_when(
      basdai_6==1~"no_morning_stiffness",
      basdai_6<5~"less_than_1_hours",
      basdai_6<10~"1_to_2_hours",
      basdai_6==10~"more_than_2_hours"
    ),
    observation_concept_id="40483597",
    observation_date=substr(authored,1,10),
    observation_type_concept_id="32862",
    observation_source_value="basdai6"
  )%>%distinct()%>%bind_rows(observation)

observation<-visits%>%
  filter(menopause_state=="perimenopausal")%>%
  transmute(
    patient_id,
    observation_concept_id="45757505",
    observation_date=substr(visit_date,1,10),
    observation_type_concept_id="32879",
    observation_source_value="menopause_state_perimenopausal"
  )%>%distinct()%>%bind_rows(observation)

observation<-sf_12%>%
  filter(emotional_health_could_not_work_as_meticulously_as_usual_sf_36=="yes")%>%
  transmute(
    patient_id,
    observation_concept_id="4328349",
    observation_date=substr(authored,1,10),
    observation_type_concept_id="32879",
    observation_source_value="emotional_h_not_as_meticulous_as_usual"
  )%>%distinct()%>%bind_rows(observation)

observation<-visits%>%
  filter(menopause_state=="postmenopausal")%>%
  transmute(
    patient_id,
    observation_concept_id="4295261",
    observation_date=substr(visit_date,1,10),
    observation_type_concept_id="32879",
    observation_source_value="menopause_state_postmenopausal"
  )%>%distinct()%>%bind_rows(observation)

observation<-sf_12%>%
  filter(climbing_several_stairs_sf_36=="yes_limited_a_lot")%>%
  transmute(
    patient_id,
    observation_concept_id="4200822",
    observation_date=substr(authored,1,10),
    observation_type_concept_id="32879",
    observation_source_value="climbing_several_stairs-limited a lot"
  )%>%distinct()%>%bind_rows(observation)

observation<-sf_12%>%
  filter(health_in_general_sf_36%in%c("bad"))%>%
  transmute(
    patient_id,
    observation_concept_id="4047986",
    observation_date=substr(authored,1,10),
    observation_type_concept_id="32879",
    observation_source_value="health_in_general-bad"
  )%>%distinct()%>%bind_rows(observation)

observation<-sf_12%>%
  filter(health_in_general_sf_36%in%c("good"))%>%
  transmute(
    patient_id,
    observation_concept_id="4047705",
    observation_date=substr(authored,1,10),
    observation_type_concept_id="32879",
    observation_source_value="health_in_general-good"
  )%>%distinct()%>%bind_rows(observation)

observation<-sf_12%>%
  filter(health_in_general_sf_36%in%c("less_good"))%>%
  transmute(
    patient_id,
    observation_concept_id="4047208",
    observation_date=substr(authored,1,10),
    observation_type_concept_id="32879",
    observation_source_value="health_in_general-less_good"
  )%>%distinct()%>%bind_rows(observation)

observation<-sf_12%>%
  filter(health_in_general_sf_36%in%c("excellent","very_good"))%>%
  transmute(
    patient_id,
    observation_concept_id="4047207",
    observation_date=substr(authored,1,10),
    observation_type_concept_id="32879",
    observation_source_value="health_in_general-excellent|very_good"
  )%>%distinct()%>%bind_rows(observation)