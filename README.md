# EMIS_task

-- Prerequisite:

My Table creation, data research and testing were undertook mainly on ipynb (python notebook), using VSCode. As a result, python code was used to generate the relevant dataframes upon which the SQL task took place (using SQLite inbuilt within python) and the tables will not be vaild through only using the SQL code available in the .sql files. To view my full results that I am covering here, feel free to run the code available on solution_py.ipynb in an environment that will support python.

-- Question 1:

For this task, the patient table was used. An assumption made was that 'Postcode Areas' represented the first two letters of a given postcode, as not to channel in too deeply on specific postcodes. To review by gender, I used CASE to separate the four categories available, whilst also giving a total sum column to rank the postcode areas with the highest overall total. Given this, the LS postcode came out with the highest overall hits (2640), and also had a good dispersion of genders.

It's possible that some external factors may have influenced this result, mainly quality of data in relation to postcodes. For example, Blank Postcode ranked 5th highest, with 105 records, and 'LS99 9ZZ' accounted for 1787 hits in the data (which would've outscored all other postcode areas!). LS99 9ZZ is also not a valid postcode - so in a real world example, this would be removed from the study.

-- Question 2

For this task, all available tables were included to form a complete picture. In Python, all tables were generated and code was written to combine the multiple csv files for medication and obvservation into two main tables for medication and observation respectively.

The connecting columns available for joins were restrictive - I found registration_guid worked as a foreign key between Patient and Observation_table, and also between Patient and Medication_table. With no direct link between Patient and Clinical_codes, clinical_codes linked to Observation_table and medication_table through a link between clinical_codes.code_id and .emis_code_id. Due to the task giving SNOMED_CONCEPT_IDs that didn't always have a direct, single link (child_clinical_codes), patient rows in these tables were operated on from codeid's outside of the table, in clinical_codes. As medication_table and observation_table were representing different stages of the mentioned processes, the retrieval of their data had to be separated within a query. 

In terms of the requirements mentioned, patients required for the study had to have a current asthma diagnosis, have been prescribed one of five medications within the last 30 years, should be excluded if they are currently a smoker, weigh less than 40kg or have a COPD diagnosis, and must have not opted out of research (and must not represent dummy data, or have died). Given this, I chose to prioritise the exclusionary requirements first. The query first removes patients from the study that fail the three exclusion requirements, and then looks at identifying patients that meet the following requirements, rather than the other way around. 

To check whether patients had a current affiliation with these conditions in the databases,  regular_and_current_active_flag and nonregular_and_current_active_flag were passed through the query. This related to diagnoses of asthma, smoking, weighing less than 40kg and COPD.

To check whether patients had opted out, I used opt_out_9nu0_flag and opt_out_9nd19nu09nu4_flag. On researching this, I made the assumption that 9nu0 represented "Type 1 opt out", and 9nd19nu09nu4 as "Type 2". This information may be incorrect, but not much was found online in relation to these codes! dummy_patient_flag and date_of_death were used for checks also.

The medications were retrieved through first finding them with their given SNOMED_concept_id, and codeids - and then using the overal refset_simple_id to retrieve all medicines that contain their ingredients. This was tested within python, and should exist within commits on this repo for more insight into the testing.

The query itself looks for distinct registration IDs (no duplicated patients), accompanied with the patient ID, Full Name, postcode, age and gender. registration_guid is a constant within medication and observation tables to relate back to the patient tables, whilst we use clinical codes to retrieve codes for application with the requirements. 

Chronologically, we eliminate the excluded patients from the study, whilst checking that they are current diagnoses. Then, we check whether the patient has a current asthma diagnosis, with the opt out checks built in here. From this, we check the medication prescriptions from this list of patients, rather than the overall database. Finally, we make sure the prescriptions have occured within the last 30 years, using recorded_date (As many other date columns included too few data entries to provide an accurate reading).

The Query runs in 29.8 seconds, and the resulting table (shown in the XLSX Document) contains only 5 potential participants for the local research study. There is one participant for each of the top 5 postcode areas, however. 




