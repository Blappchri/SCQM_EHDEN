#One big source of information we have are so-called puppet filled out by doctors with detailed information about the respective body parts. It was actually too detailed for OMOP.

j_path <- "code/help_files/joint_puppet_mapping.csv"
j_mapped <- read.csv(j_path,sep = ";")

e_path <- "code/help_files/enth_puppet_mapping.csv"
e_mapped <- read.csv(e_path,sep = ";")

vis_swo<-visits%>%select(
  swollen_joints_body_entire_knee_joint_right:swollen_joints_body_entire_met__langeal_joint_of_fifth_toe_left)

new_cond<-conditions[0,]#just grab the strucutre

for (a in 1:nrow(j_mapped)) {
  affected<-vis_swo[,a]=="affected"
  new_cond<-bind_rows(
    new_cond,
    visits%>%filter(affected)%>%
      select(patient_id,condition_start_date=visit_date)%>%
      mutate(
        condition_type_concept_id="32879",
        condition_concept_id=j_mapped$swollen[a]%>%as.character(),
        condition_end_date=condition_start_date,
        condition_source_value=substr(j_mapped$name[a],28,200)%>%paste0("-swollen")
    )
  )
}

vis_ten<-visits%>%select(
  painfull_joints_body_entire_knee_joint_right:painfull_joints_body_entire_me__langeal_joint_of_fifth_toe_left)

for (a in 1:nrow(j_mapped)) {
  affected<-vis_ten[,a]=="affected"
  new_cond<-bind_rows(
    new_cond,
    visits%>%filter(affected)%>%
      select(patient_id,condition_start_date=visit_date)%>%
      mutate(
        condition_type_concept_id="32879",
        condition_concept_id=j_mapped$tender[a]%>%as.character(),
        condition_end_date=condition_start_date,
        condition_source_value=substr(j_mapped$name[a],28,200)%>%paste0("-tender")
      )
  )
}

vis_syn<-visits%>%select(
  enthesides_body_first_costochondral_junction_right:enthesides_body_tibial_tuberosity_left)

for (a in 1:nrow(e_mapped)) {
  affected<-vis_syn[,a]=="affected"
  new_cond<-bind_rows(
    new_cond,
    visits%>%filter(affected)%>%
      select(patient_id,condition_start_date=visit_date)%>%
      mutate(
        condition_type_concept_id="32879",
        condition_concept_id=e_mapped$enth[a]%>%as.character(),
        condition_end_date=condition_start_date,
        condition_source_value=substr(e_mapped$example.name.in.source[a],17,200)
      )
  )
}

#to fix size limitation

new_cond<-new_cond%>%mutate(
  condition_source_value=case_when(
    condition_source_value=="entire_spinous_process_of_fifth_lumbar_vertebra"~"ent_spinous_proc_5th_lum_vertebra",
    TRUE~condition_source_value
  )
  )

conditions<-bind_rows(conditions,new_cond%>%distinct())
