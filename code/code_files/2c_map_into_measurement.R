#Maps some very straightforward lab stuff, the DAS and other easy clinical stuff as well as PRO
# This file introduces the pattern that most of the rest of this code will have. At the time I felt that there were enough idiosyncrasies to everything that a function would be awkward. Surprisingly I have not *not* ended up regretting this decision during development, but it means that this code is a bit 'copy-paste'-ish.
#Dates are mostly complete, but we apply a mid imputation everywhere just to be sure 

measurements<-visits%>%transmute(
  patient_id,
  measurement_concept_id="4099154",
  measurement_date=substr(visit_date,1,10),
  measurement_type_concept_id="32879",
  unit_concept_id="9529",
  value_as_number=weight_kg,
  visit_uid=uid,
  measurement_source_value="weight_kg"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-visits%>%transmute(
  patient_id,
  measurement_concept_id="4153000",
  measurement_date=substr(visit_date,1,10),
  measurement_type_concept_id="32879",
  unit_concept_id="8713",
  value_as_number=coalesce(hb,hemoglobin/10),
  visit_uid=uid,
  measurement_source_value="hb"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-visits%>%transmute(
  patient_id,
  measurement_concept_id="37393853",
  measurement_date=substr(visit_date,1,10),
  measurement_type_concept_id="32879",
  unit_concept_id="8752",
  value_as_number=bsr,
  visit_uid=uid,
  measurement_source_value="bsr"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-visits%>%
  filter(!grepl("<",crp))%>%
  transmute(
  patient_id,
  measurement_concept_id="4208414",
  measurement_date=substr(visit_date,1,10),
  measurement_type_concept_id="32879",
  unit_concept_id="8751",
  value_as_number=crp,
  visit_uid=uid,
  measurement_source_value="crp"
)%>%distinct()%>%
  filter(!is.na(value_as_number))%>%
  mutate(value_as_number=as.double(value_as_number))%>%
  bind_rows(measurements)

measurements<-visits%>%transmute(
  patient_id,
  measurement_concept_id="4146380",
  measurement_date=substr(visit_date,1,10),
  measurement_type_concept_id="32879",
  unit_concept_id="8645",
  value_as_number=gpt_and_or_alat,
  visit_uid=uid,
  measurement_source_value="gpt_and_or_alat"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-visits%>%transmute(
  patient_id,
  measurement_concept_id="4324383",
  measurement_date=substr(visit_date,1,10),
  measurement_type_concept_id="32879",
  unit_concept_id="8749",
  value_as_number=kreatinin_value,
  visit_uid=uid,
  measurement_source_value="kreatinin_value"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-visits%>%transmute(
  patient_id,
  measurement_concept_id="4289475",
  measurement_date=substr(visit_date,1,10),
  measurement_type_concept_id="32879",
  unit_concept_id="8645",
  value_as_number=y_gt,
  visit_uid=uid,
  measurement_source_value="y_gt"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-visits%>%transmute(
  patient_id,
  measurement_concept_id="4209078",
  measurement_date=coalesce(impute_incomplete_dates(osteodensitometrie_date),visit_date),
  measurement_type_concept_id="32879",
  value_as_number=osteodensitometry_femoral_neck,
  visit_uid=uid,
  measurement_source_value="osteodensitometry_femoral_neck"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-visits%>%transmute(
  patient_id,
  measurement_concept_id="37174518",
  measurement_date=coalesce(impute_incomplete_dates(osteodensitometrie_date),visit_date),
  measurement_type_concept_id="32879",
  value_as_number=osteodensitometry_lumbar_spine,
  visit_uid=uid,
  measurement_source_value="osteodensitometry_lumbar_spine"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-visits%>%transmute(
  patient_id,
  measurement_concept_id="3036277",
  measurement_date=substr(visit_date,1,10),
  measurement_type_concept_id="32879",
  unit_concept_id="8582",
  value_as_number=height_cm,
  visit_uid=uid,
  measurement_source_value="height_cm"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-visits%>%transmute(
  patient_id,
  measurement_concept_id="40482839",
  measurement_date=substr(visit_date,1,10),
  measurement_type_concept_id="32879",
  value_as_number=coalesce(das283crp_score,das283bsr_score),
  visit_uid=uid,
  measurement_source_value="das283crp_score|das283bsr_score"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)


measurements<-patients%>%left_join(fvis)%>%transmute(
  patient_id,
  measurement_concept_id="3041391",
  measurement_date=substr(visit_date,1,10),
  measurement_type_concept_id="32879",
  value_as_concept_id=case_when(
    anti_ccp=="positive"~	"45878584",
    anti_ccp=="negative"~	"45878583"
  ),
  visit_uid=uid,
  measurement_source_value="anti_ccp"
)%>%distinct()%>%filter(!is.na(value_as_concept_id))%>%bind_rows(measurements)

measurements<-patients%>%
  filter(hla_b27=="negative")%>%
  left_join(fvis)%>%
  transmute(
    patient_id,
    measurement_concept_id="4192945",
    measurement_date=substr(visit_date,1,10),
    measurement_type_concept_id="32879",
    measurement_source_value="hla_b27_negative",
    value_as_concept_id="9189"
  )%>%distinct()%>%bind_rows(measurements)

measurements<-patients%>%
  filter(hla_b27=="positive")%>%
  left_join(fvis)%>%
  transmute(
    patient_id,
    measurement_concept_id="4192945",
    measurement_date=substr(visit_date,1,10),
    measurement_type_concept_id="32879",
    measurement_source_value="hla_b27_positive",
    value_as_concept_id="9191"
  )%>%distinct()%>%bind_rows(measurements)

measurements<-patients%>%
  filter(ra_crit_rheumatoid_factor=="positive")%>%
  left_join(fvis)%>%
  transmute(
    patient_id,
    measurement_concept_id="4204380",
    measurement_date=substr(visit_date,1,10),
    measurement_type_concept_id="32879",
    measurement_source_value="ra_crit_rheumatoid_factor_positive",
    value_as_concept_id="9191"
  )%>%distinct()%>%bind_rows(measurements)

measurements<-patients%>%
  filter(ra_crit_rheumatoid_factor=="negative")%>%
  left_join(fvis)%>%
  transmute(
    patient_id,
    measurement_concept_id="4204380",
    measurement_date=substr(visit_date,1,10),
    measurement_type_concept_id="32879",
    measurement_source_value="ra_crit_rheumatoid_factor_negative",
    value_as_concept_id="9189"
  )%>%distinct()%>%bind_rows(measurements)


measurements<-visits%>%transmute(
  patient_id,
  measurement_concept_id="44811520",
  measurement_date=substr(visit_date,1,10),
  measurement_type_concept_id="4161183",
  value_as_number=basmi_score,
  visit_uid=uid,
  measurement_source_value="basmi_score"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-radai5%>%transmute(
  patient_id,
  measurement_concept_id="40481048",
  measurement_date=substr(authored,1,10),
  measurement_type_concept_id="32862",
  value_as_number=radai5_score,
  visit_uid,
  measurement_source_value="radai5_score"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-haq%>%transmute(
  patient_id,
  measurement_concept_id="4164977",
  measurement_date=substr(authored,1,10),
  measurement_type_concept_id="32862",
  value_as_number=haq_score,
  visit_uid,
  measurement_source_value="haq_score"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-euroqol%>%transmute(
  patient_id,
  measurement_concept_id="44807984",
  measurement_date=substr(authored,1,10),
  measurement_type_concept_id="32862",
  value_as_number=euroqol_score,
  visit_uid,
  measurement_source_value="euroqol_score"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-dlqi%>%transmute(
  patient_id,
  measurement_concept_id="4167755",
  measurement_date=substr(authored,1,10),
  measurement_type_concept_id="32862",
  value_as_number=dlqi_score,
  visit_uid,
  measurement_source_value="dlqi_score"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-basfi%>%transmute(
  patient_id,
  measurement_concept_id="44811513",
  measurement_date=substr(authored,1,10),
  measurement_type_concept_id="32862",
  value_as_number=basfi_score,
  visit_uid,
  measurement_source_value="basfi_score"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-basdai%>%transmute(
  patient_id,
  measurement_concept_id="4179958",
  measurement_date=substr(authored,1,10),
  measurement_type_concept_id="32862",
  value_as_number=basdai_score,
  visit_uid,
  measurement_source_value="basdai_score"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)


