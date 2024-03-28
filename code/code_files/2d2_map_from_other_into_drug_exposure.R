#maps information that belongs into drug exposure from outside our main system for vital medications. Some of this is PRO information, some doctor-based.

drug_exposure<-nsaids%>%
  filter(nsaid_used=="yes")%>%
  transmute(
    patient_id,
    drug_concept_id="4156857",
    drug_exposure_start_date=substr(date,1,10),
    drug_exposure_end_date=substr(date,1,10),
    drug_type_concept_id="32862",
    drug_source_value="nsaid_used-yes"
  )%>%distinct()%>%bind_rows(drug_exposure)

drug_exposure<-steroids%>%
  filter(steroids_used=="yes")%>%
  transmute(
    patient_id,
    drug_concept_id="4024511",
    drug_exposure_start_date=substr(authored,1,10),
    drug_exposure_end_date=substr(authored,1,10),
    drug_type_concept_id="32862",
    drug_source_value="steroids_used_yes"
  )%>%distinct()%>%bind_rows(drug_exposure)

drug_exposure<-visits%>%
  filter(
    case_when(
      present_medication_arthritis_coxibs=="yes"~TRUE,
      present_medication_arthritis_conventional_nsaid=="yes"~TRUE,
      TRUE~FALSE
    ))%>%
  transmute(
    patient_id,
    drug_concept_id="4156857",
    drug_exposure_start_date=visit_date,
    drug_exposure_end_date=visit_date,
    drug_type_concept_id="32851",
    visit_occurrence_id=uid,
    drug_source_value="coxibs|conventional_nsaids"
  )%>%distinct()%>%bind_rows(drug_exposure)

drug_exposure<-visits%>%
  filter(
    case_when(
      present_medication_arthritis_paracetamol=="yes"~TRUE,
      TRUE~FALSE
    ))%>%
  transmute(
    patient_id,
    drug_concept_id="1125315",
    drug_exposure_start_date=visit_date,
    drug_exposure_end_date=visit_date,
    drug_type_concept_id="32851",
    visit_occurrence_id=uid,
    drug_source_value="paracetamol"
  )%>%distinct()%>%bind_rows(drug_exposure)

drug_exposure<-visits%>%
  filter(
    case_when(
      other_medication_antidepressants=="yes"~TRUE,
      TRUE~FALSE
    ))%>%
  transmute(
    patient_id,
    drug_concept_id="4164065",
    drug_exposure_start_date=visit_date,
    drug_exposure_end_date=visit_date,
    drug_type_concept_id="32851",
    visit_occurrence_id=uid,
    drug_source_value="antidepressants"
  )%>%distinct()%>%bind_rows(drug_exposure)

