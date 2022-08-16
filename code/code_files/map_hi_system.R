#handles our HI system as well as main diagnosis


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
        "diagnose_rheumatoid_arthritis",
      diagnose_ankylosing_spondylitis=="yes" ~ 
        "diagnose_ankylosing_spondylitis",
      diagnose_psoriasis_arthritis=="yes" ~ 
        "diagnose_psoriasis_arthritis",
      diagnose_undifferentiated_arthritis=="yes" ~ 
        "diagnose_undifferentiated_arthritis",
      diagnose_giant_cell_arteritis=="yes"&diagnose_polymyalgia_rheumatica=="yes" ~
        "diagnose_giant_cell_arteritis&diagnose_polymyalgia_rheumatica",
      diagnose_giant_cell_arteritis=="yes"&is.na(diagnose_polymyalgia_rheumatica) ~
        "diagnose_giant_cell_arteritis",
      is.na(diagnose_giant_cell_arteritis)&diagnose_polymyalgia_rheumatica=="yes" ~
        "diagnose_polymyalgia_rheumatica",
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
# add information from health_issues
ihi_path <- "help_files/health_issue_system_mapping.csv"
d.ihi_mapped <- read_csv(ihi_path)

d.ihi_data_mapped_joined <- health_issues %>% 
  mutate(sourceName=
           case_when(is.na(health_issue_category_2)~health_issue_category_1,
                     TRUE~health_issue_category_2)
  ) %>% 
  left_join(d.ihi_mapped, by=c("sourceName")) %>% 
  filter(health_issue_present=="yes")  # remove cases if health_issues are not present or unknown!

# get all domains (note that IHI contain conditions, procedures, devices,...)
sort(unique(d.ihi_data_mapped_joined$domainId), na.last = TRUE)
# "Condition"   "Device"      "Observation" "Procedure"   NA 

d.ihi_data_mapped_joined<-d.ihi_data_mapped_joined%>%mutate(
  health_issue_date=case_when(
    !nchar(health_issue_date)%in%c(4,7,10)~NA_character_,
    TRUE~health_issue_date
  ),
  health_issue_date=coalesce(health_issue_date,substr(recording_time,1,10))
  )

ihi_for_co <- d.ihi_data_mapped_joined %>% 
  filter(domainId=="Condition")

ihi_for_de <- d.ihi_data_mapped_joined %>% 
  filter(domainId=="Device")

ihi_for_o <- d.ihi_data_mapped_joined %>% 
  filter(domainId=="Observation")

ihi_for_po <- d.ihi_data_mapped_joined %>% 
  filter(domainId=="Procedure")


# prepare dates for imputation
unique(nchar(ihi_for_co$health_issue_date))

# finalize ihi_for_co
ihi_for_co %<>% 
  mutate(
    condition_start_date=impute_incomplete_dates(health_issue_date),
    #condition_start_date=ymd(condition_start_date),
    condition_type_concept_id = 32879,
    condition_source_value = sourceName)


# combine dataframes
conditions_ihi <- ihi_for_co %>% 
      transmute(
        patient_id, 
        condition_occurrence_id=uid, 
        condition_concept_id=conceptId%>%as.character(),
        condition_start_date, 
        condition_end_date=condition_start_date,
        condition_type_concept_id=as.character(condition_type_concept_id), 
        condition_source_value=sourceName)

# populate condition_occurrence
conditions <- bind_rows(
  conditions,
  conditions_ihi,
  first_cond_chuck
#   data.frame(
#     condition_occurrence_id=as.numeric(
#       as.factor(patients_ihi_for_co$condition_occurrence_id)),
#     patient_id=patients_ihi_for_co$patient_id,
#     condition_concept_id=patients_ihi_for_co$condition_concept_id%>%as.character(),
#     condition_start_date=patients_ihi_for_co$condition_start_date%>%paste(),
#     condition_type_concept_id=patients_ihi_for_co$condition_type_concept_id%>%as.character(),
#     condition_source_value=patients_ihi_for_co$condition_source_value
# )
)
 
device_exposure<-bind_rows(
  device_exposure,
  ihi_for_de%>%
    transmute(
      patient_id,
      device_concept_id=conceptId%>%as.character(),
      device_exposure_start_date=impute_incomplete_dates(health_issue_date),
      device_exposure_end_date=device_exposure_start_date,
      device_type_concept_id="32879"  ,
      device_source_value=sourceName
    )
) 

observation<-bind_rows(
  observation,
  ihi_for_o%>%transmute(
    patient_id,
    observation_concept_id=conceptId%>%as.character(),
    observation_date=impute_incomplete_dates(health_issue_date),
    observation_type_concept_id="32879",
    observation_source_value=sourceName
  )
)

procedure_occurence<-bind_rows(
  procedure_occurence,
  ihi_for_po%>%
    transmute(
      patient_id,
      procedure_concept_id=conceptId%>%as.character(),
      procedure_start_date=impute_incomplete_dates(health_issue_date),
      procedure_end_date=procedure_start_date,
      procedure_type_concept_id="32879",
      procedure_source_value=sourceName
    )
) 
