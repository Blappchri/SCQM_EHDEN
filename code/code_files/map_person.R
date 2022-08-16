person<-patients%>%
  transmute(
    person_id=1:nrow(patients),
    patient_id,
    gender_concept_id=case_when(
      gender == "male" ~ 8507,
      gender == "female" ~ 8532
      ),
    year_of_birth=substr(date_of_birth,1,4),
    month_of_birth=as.integer(substr(date_of_birth,6,7)),
    race_concept_id=0,
    person_source_value=paste0(patient_id,"_",snapshot)
  )
