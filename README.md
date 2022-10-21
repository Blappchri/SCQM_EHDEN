# SCQM_EHDEN
A public repo for the SCQM ETL created as part of EHDEN

Structure:
Code: Contains the actual ETL and the necessary supporting files
    ETL.R is the main file. It calls all the necessary smaller files in the code_files folder
    code_files: See above. Individual smaller chunks. Roughly split by subject, but sometimes also for reasons that no longer matter now that development is finished
    help_files: Sometimes the source data has a structure that allows for very clean mappings using .csv. All of those are in here

Note that the WhiteRabbit report is from last year, but due to how useless that one seems and how much effort manually ensuring all the risky info is removed is, I do not expect that one to ever get reran and updated
  
