# SCQM_EHDEN
This public repository presents the extract transform load (ETL) code, written in R, to change the data from a rheumatology registry (Swiss Clinical Quality Management - SCQM) to a Common Data Model (OMOP structure in the EHDEN project).

The code is generally self-explanatory, if the main structure is understood. 
- First, ETL.R is the main file, and no other files need to be run individually. It calls all the necessary smaller files in the code/code_files folder. This short files indicated the order of each code and which tables are actually mapped.
- Second, within the code_files folder, the different .R files correspond to the target tables of the CDM that was used for the SCQM registry.
- Third, within the help_files folder are four different .csv files that provide vocabulary mapping for specific issues, namely: (1 and 2) the puppets representing joints or entheses, (3) the health issues corresponding to comorbidities or newly developed health issues, (4) medication.

The data folder is not necessary and corresponds to initial results of the mapping, for instance White Rabbit description of initial SCQM data.  

WARNING: the CDM_version and the vocabulary_version are hard code in the 4_finalization.R file in the code_files folder. Future runs of the ETL requires to manually change these parameters.

# brief description of the data sources and SCQM structure
- There are relatively few patient variables, mainly socio-demographics
- Most information is collected from healthcare professionals at specific visits (this includes medication, information on joints and entheses on "puppets", and laboratory data)
- Some information is collected from patients at time points close to visits via app questionnaires
- Additional patient reported outcome information is collected from patients, either weekly or monthly, via app questionnaires. They are separate from any visit
- Medication information is collected on a medication system where, for a selected list of medications, a list per patient exists with start, stop, dosage and frequency
- Health issues, including comorbidities, are collected in a system similar to the medications. Since it does not use a standardised vocabulary, a correspondence table is provided in the help_files folder
- SCQM collects extra informations like biokits or images, but they are currently not mapped
