SELECT DISTINCT(o.registration_guid),p.patient_id,p.patient_surname,p.patient_givenname,p.postcode,p.age,p.gender
            FROM observation_table o
            INNER JOIN patient p ON (o.registration_guid = p.registration_guid)
            INNER JOIN clinical_codes c ON (o.emis_code_id = c.code_id)
            WHERE p.registration_guid NOT IN (
            SELECT DISTINCT(o.registration_guid) FROM observation_table o
            JOIN clinical_codes c ON o.emis_code_id = c.code_id
            WHERE c.refset_simple_id IN (999021691000230104,999004211000230104,999011571000230107)
            AND (o.regular_and_current_active_flag = 'true' OR o.non_regular_and_current_active_flag = 'true')) 
            AND (c.refset_simple_id IN (999012891000230104)
            AND (o.regular_and_current_active_flag = 'true' OR o.non_regular_and_current_active_flag = 'true'))
            AND (o.opt_out_9nu0_flag = 'false' AND o.opt_out_9nd19nu09nu4_flag = 'false' AND o.dummy_patient_flag ='false')
            AND p.registration_guid IN (
            SELECT DISTINCT(p.registration_guid) 
            FROM medication_table m
            INNER JOIN clinical_codes c ON (m.emis_code_id = c.code_id)    
            INNER JOIN patient p ON (m.registration_guid = p.registration_guid)
            WHERE (c.parent_code_id IN (591221000033116,717321000033118,1215621000033114,972021000033115,1223821000033118)
            AND DATE(m.recorded_date) > DATE(CURRENT_DATE,'-30 year'))
            AND p.date_of_death IS NULL)