SELECT
	p.patient_number_ccc patient_number,
	p.dob patient_dob,
	CASE 
		WHEN LOWER(g.name) = 'male' THEN 'male'
		WHEN LOWER(g.name) = 'female' THEN 'female'
		ELSE NULL
	END AS patient_gender,
	p.start_height startheight,
	p.start_weight startweight,
	SQRT((p.start_height * p.start_weight)/3600) startbsa, 
	p.height currentheight,
	p.weight currentweight,
	SQRT((p.height * p.weight)/3600) currentbsa,
	p.date_enrolled enrollmentdate,
	p.start_regimen_date startregimendate,
	p.status_change_date statuschangedate,
	p.facility_code facilitycode,
	sr.regimen_code startregimencode,
	cr.regimen_code currentregimencode,
	rst.name servicename,
	ps.Name statusname
FROM patient p
LEFT JOIN gender g ON g.id = p.gender
LEFT JOIN regimen sr ON sr.id = p.start_regimen
LEFT JOIN regimen cr ON cr.id = p.current_regimen
LEFT JOIN regimen_service_type rst ON sr.id = p.service
LEFT JOIN patient_status ps ON ps.id = p.current_status
GROUP BY p.id