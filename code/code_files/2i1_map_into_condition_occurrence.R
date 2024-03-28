#Things that belong in the conditions table but are neither tracked in the HI system nor part of the puppets in script 2i2
#Some are per-visit, some are PRO
#Probably the most 'Why didn't you create a function file?'-file, but there is special stuff and exceptions everywhere.

# derive condition_occurrence from patients
patients_for_co <- patients %>% 
  select(patient_id, starts_with("diagnose_"), starts_with("date_first")&!
           ends_with("_unknown"), uid) %>% left_join(fvis)%>%
  mutate(
    condition_occurrence_id=NA,
    pat_uid=uid,
    patient_id,
    condition_concept_id = case_when(
      diagnose_rheumatoid_arthritis=="yes" ~ as.integer(80809),
      diagnose_ankylosing_spondylitis=="yes" ~ as.integer(437082),
      diagnose_psoriasis_arthritis=="yes" ~ as.integer(40319772),
      diagnose_undifferentiated_arthritis=="yes" ~ as.integer(4220761),
      diagnose_giant_cell_arteritis=="yes"&diagnose_polymyalgia_rheumatica=="yes" ~
        as.integer(4343935),
      diagnose_giant_cell_arteritis=="yes"&is.na(diagnose_polymyalgia_rheumatica) ~
        as.integer(4347064),
      is.na(diagnose_giant_cell_arteritis)&diagnose_polymyalgia_rheumatica=="yes" ~
        as.integer(255348),
      TRUE ~ NA_integer_
    ),
    condition_source_value = case_when(
      diagnose_rheumatoid_arthritis=="yes" ~ 
        "diag_rheumatoid_arthritis",
      diagnose_ankylosing_spondylitis=="yes" ~ 
        "diag_ankylosing_spondylitis",
      diagnose_psoriasis_arthritis=="yes" ~ 
        "diag_psoriasis_arthritis",
      diagnose_undifferentiated_arthritis=="yes" ~ 
        "diag_undifferentiated_arthritis",
      diagnose_giant_cell_arteritis=="yes"&diagnose_polymyalgia_rheumatica=="yes" ~
        "diag_GCA&polymyalgia_rheumatica",
      diagnose_giant_cell_arteritis=="yes"&is.na(diagnose_polymyalgia_rheumatica) ~
        "diag_giant_cell_arteritis",
      is.na(diagnose_giant_cell_arteritis)&diagnose_polymyalgia_rheumatica=="yes" ~
        "diag_polymyalgia_rheumatica",
      TRUE ~ NA_character_
    )) %>% 
  filter(!is.na(condition_concept_id))

# define condition_start_date
patients_for_co %<>% 
  mutate(
    condition_start_date = case_when(
      condition_concept_id%in%c(80809,437082,40319772,4220761)~
        ymd(date_first_symptoms,truncated = 2),
      condition_concept_id==4343935 ~ min(ymd(date_first_symptoms_gca,truncated = 2),
                                          ymd(date_first_symptoms_pmr,truncated = 2),
                                          na.rm = TRUE),
      condition_concept_id==4347064 ~ ymd(date_first_symptoms_gca,truncated = 2),
      condition_concept_id==255348 ~ ymd(date_first_symptoms_pmr,truncated = 2),
      TRUE ~ ymd(visit_date)),
    condition_start_date=case_when(
      is.na(condition_start_date)~ymd(visit_date),
      TRUE~condition_start_date
    ),
    condition_type_concept_id = 32879
  )

first_cond_chuck<-patients_for_co%>%
  select(patient_id,condition_occurrence_id:condition_type_concept_id)%>%
  distinct()%>%
  mutate(
    condition_concept_id=as.character(condition_concept_id),
    condition_type_concept_id=as.character(condition_type_concept_id),
    condition_start_date=as.character(condition_start_date)
  )

# populate condition_occurrence
conditions <- bind_rows(
  conditions,
  first_cond_chuck)

#rest follows regular structure

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






