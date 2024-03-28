#This concept does not make much sense within a registry, so we just do something minimalist.


# DECISION: Just keep it simple and use visit. Technically not even this should be considered an observation period since we do not track everything.
observation_period <- visits %>% 
  group_by(patient_id) %>% 
  summarise(
    observation_period_start_date=min(visit_date, na.rm = TRUE),
    observation_period_end_date=max(visit_date, na.rm = TRUE),
            .groups = "drop")%>%
  mutate(
    period_type_concept_id="32879"
  )
