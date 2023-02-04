# data dictionary


## Data dictionary for `cohort.csv`

`id` : Participant's ID

`redcap_event_name`: Two timepoints of data collection - at baseline and at 6 months follow up.

`wgt_b` : weight(kg) at baseline.

`hgt_b` : height(cm) at baseline.

`age_b` : age(years) at baseline. 

`gender` : gender, 1 =  male, 2 = female.

`race` : race, 1 = Malay, 2 = Chinese,  3 = Indian, 99 =  Others.

`age_b_m` : `age_b` in Malay language questionnaire.

`gender_m` : `gender` in Malay language questionnaire.

`race_m` : `race` in Malay language questionnaire.

`date_taken` : date in ddmmyyyy format where the serum sample for antibody analysis was drawn. 

`snab` : antibody level (U/ml)

`snab_result` : qualitative value of antibody level. 1 = antibody level >= x , 0 = antibody level < x.

## Data dictionary for `df_covid.csv'.

`rt` : was COVID-19 rapid test done? 1 = yes. 0 = no.

`rt_date` : date in ddmmyyyy format where saliva sample was taken for COVID-19 rapid test.

`rt_results`: 1= positive for COVID-19, 2 =  negative for COVID-19.

`symp_yes` : 1= with COVID symptoms, 2 = without COVID symptoms.
