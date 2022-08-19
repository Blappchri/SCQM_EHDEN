# Map our system for drugs of vital relevance

mapping_original_drugs <- "help_files/medication_system_mapping.csv"
d.drugs <- read_csv(mapping_original_drugs)

not_freetext<-medications%>%filter(!is.na(medication_drug_classification))%>%select(medication_id)%>%distinct()

medications<-medications%>%filter(medication_id%in%not_freetext$medication_id)

#to standardise things a bit
d.drugs$conceptId[grepl("90",d.drugs$conceptName)]<-"42925112"

# correct missing values in sourceName (caused by adoption of DB2)
d.drugs<-d.drugs %>% 
  mutate(sourceName = case_when(
    is.na(sourceName) ~ `ADD_INFO:drug`,
    sourceName == 'solumedrol' ~ 'solu_medrol',
    TRUE ~ sourceName),
    `ADD_INFO:drug` = case_when(
      is.na(`ADD_INFO:drug`) & sourceName == 'salazopyrin' ~ 'sulfasalazine',
      is.na(`ADD_INFO:drug`) & sourceName == 'prednisolone' ~ 'prednisolone',
      TRUE ~ `ADD_INFO:drug`
    ))


### update drugs ----
# harmonise to DB3 format
medications_for_me <- medications %>% 
  filter(!is.na(medication_start_date))%>%
  mutate(
    medication_dose = case_when(
      medication_dose_unit=="g"~as.numeric(medication_dose)*1000,
      TRUE~as.numeric(medication_dose)
    ),
    id_check=row_number()
    ) %>% 
  inner_join(d.drugs%>%select("sourceName","ADD_INFO:route", "ADD_INFO:drug","conceptId")%>%distinct(), 
            by=c("medication_drug"="sourceName", 
                 "medication_generic_drug"="ADD_INFO:drug", 
                 "medication_route"="ADD_INFO:route"))

# get number of missing entries
n_missing <- d.drugs %>% 
  filter(is.na(mappingStatus)) %>% 
  nrow

last_change<-bind_rows(
  visits%>%select(date=visit_date,patient_id),
  medications%>%transmute(date=substr(last_medication_change,1,10),patient_id)
)%>%group_by(patient_id)%>%summarize(
  last_date=max(date,na.rm = T),.groups = "drop"
)

med_prepped<-medications_for_me%>%
  left_join(last_change)%>%
  distinct()%>%
  filter(!last_date<medication_start_date)%>%
  mutate(
    medication_end_date=impute_incomplete_dates(substr(medication_end_date,1,10)),
    medication_start_date=impute_incomplete_dates(medication_start_date),
    medication_end_date=case_when(
      is.na(medication_end_date)~last_date,
      is.na(last_date)~medication_end_date,
      medication_end_date>last_date~last_date,
      TRUE~medication_end_date
    ),
    route=case_when(
      medication_route=="buccal"~"4181897",
      medication_route=="intramuscular"~"4302612",
      medication_route=="intravenous_infusion"~"4171047",
      medication_route=="oral"~"4132161",
      medication_route=="subcutaneous"~"4142048"
    ),
    #source=paste(medication_id,adjustment_nr,snapshot,sep="_")
    source=medication_generic_drug
    )%>%
  filter(!medication_end_date<medication_start_date)%>%
  filter(!as.numeric(medication_dose)==0)

medication_ritu<-med_prepped%>%filter(medication_generic_drug=="rituximab")%>%
  transmute(
    medication_id,
    uid,
    patient_id,
    drug_concept_id=conceptId,
    quantity=medication_dose,
    drug_exposure_start_date=medication_start_date,
    drug_exposure_end_date=medication_start_date,
    drug_type_concept_id="32879",
    drug_source_value=source,
    route_concept_id=route
  )%>%distinct()%>%filter(!is.na(drug_exposure_start_date))

medication_missing_dosage<-med_prepped%>%
  filter(is.na(medication_dose)|is.na(medication_frequency))%>%
  filter(!uid%in%medication_ritu$uid)%>%
  transmute(
    medication_id,
    uid,
    patient_id,
    drug_concept_id=conceptId,
    drug_exposure_start_date=medication_start_date,
    drug_exposure_end_date=medication_end_date,
    drug_type_concept_id="32879",
    drug_source_value=source,
    route_concept_id=route
  )%>%distinct()%>%filter(!is.na(drug_exposure_start_date))

medication_normal<-med_prepped%>%
  filter(
    !uid%in%c(medication_missing_dosage$uid,medication_ritu$uid))%>%
  filter(!as.numeric(medication_frequency)==0)%>%
  mutate(
    freq_in_days=case_when(
      medication_frequency_unit=="wk"~as.numeric(medication_frequency)*7,
      medication_frequency_unit=="mo"~as.numeric(medication_frequency)*30,
      medication_frequency_unit=="h"~as.numeric(medication_frequency)/24,
      TRUE~as.numeric(medication_frequency)
    ),
    duration=1+as.numeric(as.Date(medication_end_date)-as.Date(medication_start_date))
    )%>%
  transmute(
    medication_id,
    uid,
    patient_id,
    drug_concept_id=conceptId,
    drug_exposure_start_date=medication_start_date,
    drug_exposure_end_date=medication_end_date,
    quantity=freq_in_days*medication_dose*duration,
    drug_type_concept_id="32879",
    drug_source_value=source,
    route_concept_id=route
  )%>%distinct()%>%filter(!is.na(drug_exposure_start_date))

drug_exposure<-bind_rows(
  drug_exposure,
  medication_missing_dosage,
  medication_ritu,
  medication_normal
)%>%arrange(medication_id)%>%distinct()%>%select(-uid)



