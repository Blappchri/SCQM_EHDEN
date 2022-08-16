#some relevant observations from elsewhere
#finish source here
observation<-illness_mastering%>%
  select(-contains("freq"))%>%
  select(-exercise_regularly_no)%>%
  filter(if_any(contains("exercise"),~.x=="yes"))%>%
  transmute(
    patient_id,
    observation_concept_id="4026921",
    observation_date=substr(recording_time,1,10),
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
    observation_date=substr(recording_time,1,10),
    observation_type_concept_id="32862",
    observation_source_value="high_school_university_studies(bad name in original)"
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
    observation_date=substr(recording_time,1,10),
    observation_type_concept_id="32862",
    observation_source_value="higher_school_university|compulsory|vocational"
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
    observation_date=substr(recording_time,1,10),
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
    observation_date=substr(recording_time,1,10),
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
    observation_date=substr(recording_time,1,10),
    observation_type_concept_id="32862",
    observation_source_value="scholar(bad name in original)"
  )%>%distinct()%>%bind_rows(observation)

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
    observation_date=substr(recording_time,1,10),
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
    observation_date=substr(recording_time,1,10),
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
    observation_date=substr(recording_time,1,10),
    observation_type_concept_id="32862",
    observation_source_value="global_patient_estimate_disease_activity"
  )%>%distinct()%>%bind_rows(observation)


derive_smoking_status <- function(
  vis,
  socioeco,
  euroqol,
  timepoints=NULL,
  mapping_distance=Inf
) {
  
  if(!is.null(timepoints)){
    vis<-vis%>%filter(patient_id%in%timepoints$patient_id)
  }
  
  
  vis_rel<-vis%>%
    select(patient_id,visit_date,visit_uid=uid,smoking)#we cannot filter here since this is what we are joining on
  socio_rel<-socioeco%>%
    select(visit_uid,smoker)%>%
    filter(!is.na(smoker))
  euro_rel<-euroqol%>%
    select(visit_uid,are_you_smoker_eq_5d)%>%
    filter(!is.na(are_you_smoker_eq_5d))
  
  all_smoking<-vis_rel%>%#all Q are only asked at visits
    left_join(socio_rel,by="visit_uid")%>%
    left_join(euro_rel,by="visit_uid")%>%
    filter(if_any(
      contains("smok"),
      ~!is.na(.))
    )%>%
    mutate( #I do not check if conflicting answers are a problem, but the order of precedence is current>former>past
      smoking_summary=case_when(
        smoker%in%c(
          "i_am_currently_smoking",
          "smoking_currently"
        )~"current",
        are_you_smoker_eq_5d=="smoking_currently"~"current",
        smoking=="current"~"current",
        smoker%in%c(
          "a_former_smoker",
          "i_am_a_former_smoker_for_more_than_a_year"
        )~"former",
        are_you_smoker_eq_5d=="a_former_smoker"~"former",
        smoking=="past"~"former",
        smoker%in%c(
          "never_been_smoking",
          "i_have_never_smoked"
        )~"never",
        are_you_smoker_eq_5d=="never_been_smoking"~"never",
        smoking=="never"~"never",
        TRUE~NA_character_
      )
    )%>%select(
      -smoking,
      -smoker,
      -are_you_smoker_eq_5d
    )
  
  if (is.null(timepoints)) {
    return(all_smoking)
  }
  
  joined<-all_smoking%>%
    inner_join(timepoints,by="patient_id")%>%
    mutate(key=paste0(patient_id,target))
  
  future<-joined%>%
    filter(target<visit_date)%>%
    group_by(patient_id,target)%>%
    slice_min(visit_date,with_ties = FALSE)%>%
    ungroup()%>%
    mutate(
      never_in_future=smoking_summary=="never"
    )%>%
    select(key,never_in_future)%>%
    filter(never_in_future)
  
  past<-joined%>%
    filter(target>visit_date)%>%
    group_by(key)%>%
    summarize(
      smoked_in_past=any(smoking_summary!="never"),
      .groups = "drop"
    )%>%
    ungroup()%>%
    filter(smoked_in_past)
  
  # We discard conflicting cases and rely on mapping
  past<-past%>%filter(!key%in%future$key)
  future<-future%>%filter(!key%in%past$key)
  
  mapping<-joined%>%
    filter(
      !key%in%future#we stop mapping if future nevers exist
    )%>%
    mutate(
      diff_abs=abs(as.Date(visit_date)-as.Date(target)),
      diff=as.numeric(as.Date(visit_date)-as.Date(target))
    )%>%
    group_by(key)%>%
    slice_min(diff_abs,with_ties = FALSE)%>%
    ungroup()%>%
    select(
      key,
      diff,
      diff_abs,
      mapped=smoking_summary
    )
  
  out<-joined%>%
    left_join(past,by="key")%>%
    left_join(future,by="key")%>%
    left_join(mapping,by="key")%>%
    transmute(
      patient_id=patient_id,
      target=target,
      smoking_summary=case_when(
        !is.na(never_in_future)~"never",
        diff_abs<=mapping_distance~mapped,#mapping trumps past if available
        !is.na(smoked_in_past)~"not never",
        diff_abs>mapping_distance~"no usable information",
        TRUE~"Should not happen since one of the above should always apply"
      ),
      mapped_distance=case_when(
        smoking_summary=="no usable information"~NA_real_,
        smoking_summary=="not never"~-Inf,
        !is.na(never_in_future)~Inf,
        TRUE~diff
      )
    )
  
  if (!is.null(timepoints)) {
    return(as.data.frame(out))
  }
}


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
    observation_date=substr(recording_time,1,10),
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
    observation_date=substr(recording_time,1,10),
    observation_type_concept_id="32862",
    observation_source_value="basdai6"
  )%>%distinct()%>%bind_rows(observation)

