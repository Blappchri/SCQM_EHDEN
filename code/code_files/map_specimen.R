#pretty straightforward

specimen<-aliquots%>%
  mutate(rownum=row_number())%>%#for the later source
  filter(
    patient_id%in%(
      patients%>%filter(
        informed_consent_bio == "yes" & !is.na(informed_consent_bio_date)
        )%>%dplyr::pull(patient_id)
    )
  )%>%
  group_by(patient_id,aliquot_type,collection_date)%>%
  summarize(n=n(),rownum=min(rownum),.groups = "drop")%>%
  transmute(
    specimen_id=NA,
    person_id=NA,
    patient_id,
    specimen_concept_id=case_when(
      aliquot_type=="serum"~"4048854",
      TRUE~"4120355"
    ),
    specimen_date=collection_date,
    specimen_type_concept_id="32879",
    specimen_source_value=paste0(snapshot,"_",rownum),#having an identifier seems useful, but we do not have one so we create one
    quantity=n
  )%>%distinct()
