# SCQM_EHDEN
This public repository presents the extract transform load (ETL) code, written in R, to change the data from a rheumatology registry (Swiss Clinical Quality Management - SCQM) to a Common Data Model (OMOP structure in the EHDEN project).

The code is generally self-explanatory, if the main structure is understood. 
- First, ETL.R is the main file, and no other files need to be run individually. It calls all the necessary smaller files in the code/code_files folder.
- Second, within the code_files folder, the different .R files correspond to the target tables of the CDM that was used for the SCQM registry.
- Third, within the help_files folder are four different .csv files that provide vocabulary mapping for specific issues, namely: (1 and 2) the puppets representing joints or entheses, (3) the health issues corresponding to comorbidities or newly developed health issues, (4) medication.

The data folder is not necessary and corresponds to initial results of the mapping, for instance White Rabbit description of initial SCQM data.  
