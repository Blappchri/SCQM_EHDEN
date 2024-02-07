#This contains some PRO scores which are both plentiful and easy to map. 

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



