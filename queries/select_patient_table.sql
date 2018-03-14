SELECT
	p.patient_number_ccc patient_number,
	{} facility,
	p.dob birth_date,
	LOWER(ds.name) place_of_birth,
	CASE 
		WHEN LOWER(g.name) = 'male' THEN 'male'
		WHEN LOWER(g.name) = 'female' THEN 'female'
		ELSE NULL
	END AS gender,
	p.pregnant is_pregnant,
	p.breastfeeding is_breastfeeding,
	d.parent parent_ccc_number,
	p.start_height,
	p.start_weight,
	SQRT((p.start_height * p.start_weight)/3600) start_bsa, 
	(p.start_height/((p.start_weight/100)*(p.start_weight/100))) start_bmi,
	p.height current_height,
	p.weight current_weight,
	SQRT((p.height * p.weight)/3600) current_bsa,
	(p.weight/((p.height/100)*(p.height/100))) current_bmi,
	CASE 
		WHEN p.partner_status = 0 THEN 'No Partner'
		WHEN p.partner_status = 1 THEN 'Concordant'
		WHEN p.partner_status = 2 THEN 'Discordant'
		WHEN p.partner_status = 3 THEN 'Unknown' 
		ELSE NULL
	END AS partner_status,
	p.disclosure is_disclosure,
	s.secondary_spouse partner_ccc_number,
	p.smoke is_smoke,
	p.alcohol is_alcohol,
	p.tb_test is_tb_tested,
	p.tb is_tb,
	p.tb_category,
	p.tbphase tb_phase,
	p.startphase tb_start_date,
	p.endphase tb_end_date,
	p.date_enrolled enrollment_date,
	p.start_regimen_date,
	p.status_change_date,
	CONCAT_WS(' | ', sr.regimen_code, sr.regimen_desc) start_regimen,
	CONCAT_WS(' | ', cr.regimen_code, cr.regimen_desc) current_regimen,
	rst.name service,
	ps.Name status,
	pso.name source,
	p.transfer_from,
	p.who_stage,
	IF(drug_prophylaxis LIKE '%1%' , 1, 0) is_cotrimoxazole,
	IF(drug_prophylaxis LIKE '%2%' , 1, 0) is_dapsone,
	IF(drug_prophylaxis LIKE '%4%' , 1, 0) is_fluconazole,
	IF(drug_prophylaxis LIKE '%3%' , 1, 0) is_isoniazid,
	p.isoniazid_start_date,
	p.isoniazid_end_date,
	p.sms_consent,
	pr.name prep_reason,
	ppt.is_tested is_prep_tested,
    ppt.test_date prep_test_date,
    ppt.test_result prep_test_result,
	p.pep_reason,
	p.differentiated_care is_differentiated_care,
	p.nextappointment pharmacy_appointment_date,
	p.clinicalappointment clinical_appointment_date,
	pvl.test_date last_viral_test_date,
	pvl.result last_viral_test_result,
	pvl.justification last_viral_test_justification
FROM patient p
LEFT JOIN district ds ON ds.id = p.pob
LEFT JOIN gender g ON g.id = p.gender
LEFT JOIN dependants d ON d.child = p.patient_number_ccc
LEFT JOIN spouses s ON s.primary_spouse = p.patient_number_ccc
LEFT JOIN regimen sr ON sr.id = p.start_regimen
LEFT JOIN regimen cr ON cr.id = p.current_regimen
LEFT JOIN regimen_service_type rst ON sr.id = p.service
LEFT JOIN patient_status ps ON ps.id = p.current_status
LEFT JOIN patient_source pso ON pso.id = p.source
LEFT JOIN (
	SELECT *
	FROM patient_prep_test
	GROUP BY patient_id
	HAVING MAX(test_date)
) ppt ON ppt.patient_id = p.id
LEFT JOIN prep_reason pr ON pr.id = ppt.prep_reason_id
LEFT JOIN (
	SELECT*
	FROM patient_viral_load
	GROUP BY patient_ccc_number
	HAVING MAX(test_date)
) pvl ON pvl.patient_ccc_number = p.patient_number_ccc
WHERE p.active = '1'
GROUP BY p.id
LIMIT {}, {}