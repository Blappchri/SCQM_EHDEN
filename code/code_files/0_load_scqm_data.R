# indicates which tables are used

used_tables=c("patients","medications","radai5","haq","psada","euroqol","basfi","basdai","asas","sf_12","covid_19","mnyc_scoring","illness_mastering","socioeco","nsaids","steroids","health_issues","dlqi","diagnostic_image_sets","specimens","aliquots")

con<-connect_rdb(snapshot = snapshot)

# 'loose' consent indicates that consent was given but may not be the latest version of the consent
for (a in used_tables) {
  print(paste0("loading ",a))
  tab_a<-load_sql_table(a,con,consent = "loose")
  assign(a,tab_a)
  rm(tab_a)
}
print(paste0("loading visits"))
visits<-load_sql_table("visits",con = con,consent = "loose",check_visits_for_phys_data = TRUE,to_visit_date = snapshot)

fvis<-visits%>%group_by(patient_id)%>%slice_min(visit_date)%>%ungroup()%>%select(patient_id,visit_date)
