#Some very straightforward lab stuff and the das

measurements<-visits%>%transmute(
  patient_id,
  measurement_concept_id="4099154",
  measurement_date=substr(recording_time,1,10),
  measurement_type_concept_id="32879",
  unit_concept_id="9529",
  value_as_number=weight_kg,
  visit_uid=uid,
  measurement_source_value="weight_kg"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-visits%>%transmute(
  patient_id,
  measurement_concept_id="4153000",
  measurement_date=substr(recording_time,1,10),
  measurement_type_concept_id="32879",
  unit_concept_id="8713",
  value_as_number=coalesce(hb,hemoglobin/10),
  visit_uid=uid,
  measurement_source_value="hb"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-visits%>%transmute(
  patient_id,
  measurement_concept_id="37393853",
  measurement_date=substr(recording_time,1,10),
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
  measurement_date=substr(recording_time,1,10),
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
  measurement_date=substr(recording_time,1,10),
  measurement_type_concept_id="32879",
  unit_concept_id="8645",
  value_as_number=gpt_and_or_alat,
  visit_uid=uid,
  measurement_source_value="gpt_and_or_alat"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-visits%>%transmute(
  patient_id,
  measurement_concept_id="4324383",
  measurement_date=substr(recording_time,1,10),
  measurement_type_concept_id="32879",
  unit_concept_id="8749",
  value_as_number=kreatinin_value,
  visit_uid=uid,
  measurement_source_value="kreatinin_value"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-visits%>%transmute(
  patient_id,
  measurement_concept_id="4289475",
  measurement_date=substr(recording_time,1,10),
  measurement_type_concept_id="32879",
  unit_concept_id="8645",
  value_as_number=y_gt,
  visit_uid=uid,
  measurement_source_value="y_gt"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-visits%>%transmute(
  patient_id,
  measurement_concept_id="3036277",
  measurement_date=substr(recording_time,1,10),
  measurement_type_concept_id="32879",
  unit_concept_id="8582",
  value_as_number=height_cm,
  visit_uid=uid,
  measurement_source_value="height_cm"
)%>%distinct()%>%filter(!is.na(value_as_number))%>%bind_rows(measurements)

measurements<-visits%>%transmute(
  patient_id,
  measurement_concept_id="40482839",
  measurement_date=substr(recording_time,1,10),
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


