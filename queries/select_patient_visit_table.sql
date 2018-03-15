SELECT 
	pv.current_height,
	pv.current_weight,
	SQRT((pv.current_height * pv.current_weight)/3600) current_bsa,
	(pv.current_weight/((pv.current_height/100)*(pv.current_height/100))) current_bmi,
	vp.name purpose,
	rcp.name regimen_change_reason,
	pv.dispensing_date,
	CONCAT_WS(' | ', lr.regimen_code, lr.regimen_desc) last_regimen,
	CONCAT_WS(' | ', cr.regimen_code, cr.regimen_desc) current_regimen,
	CASE 
		WHEN pv.dispensing_date = pa.appointment THEN pa.appointment
		WHEN pv.dispensing_date > pa.appointment THEN MAX(pa.appointment)
	END AS appointment_date,
	REPLACE(pv.adherence, '%', '') appointment_adherence,
	ndr.name non_adherence_reason,
	d.drug,
	d.pack_size,
	REPLACE(UPPER(pv.dose), ' ', '') dose,
	pv.quantity,
	pv.duration,
	CASE 
		WHEN pv.pill_count > 0 AND (pv.months_of_stock - pv.pill_count) >= pv.pill_count THEN 0 
		WHEN pv.pill_count > 0 AND (pv.months_of_stock - pv.pill_count) > 0 THEN ROUND((((pv.months_of_stock - pv.pill_count) / pv.pill_count) * 100), 2) 
		WHEN ((NOT((pv.months_of_stock regexp '[0-9]+'))) or ISNULL(pv.months_of_stock)) THEN 0 
		ELSE 100 
	END AS pill_count_adherence,
	CASE 
		WHEN pv.pill_count > 0 AND (pv.missed_pills - pv.pill_count) >= pv.pill_count THEN 0 
		WHEN pv.pill_count > 0 AND (pv.missed_pills - pv.pill_count) > 0 THEN ROUND((((pv.missed_pills - pv.pill_count) / pv.pill_count) * 100), 2) 
		WHEN ((NOT((pv.missed_pills regexp '[0-9]+'))) OR ISNULL(pv.missed_pills)) THEN 0 
		ELSE 100 
	END AS self_reporting_adherence,
	oi.name indication,
	CONCAT_WS('_', pv.patient_id, {}) patient_adt_id
FROM patient_visit pv
LEFT JOIN visit_purpose vp ON vp.id = pv.visit_purpose
LEFT JOIN regimen lr ON lr.id = pv.last_regimen
LEFT JOIN regimen cr ON cr.id = pv.regimen
LEFT JOIN regimen_change_purpose rcp ON rcp.id = pv.regimen_change_reason
LEFT JOIN non_adherence_reasons ndr ON ndr.id = pv.non_adherence_reason
LEFT JOIN drugcode d ON d.id = pv.drug_id
LEFT JOIN patient_appointment pa ON pa.patient = pv.patient_id AND pv.dispensing_date >= pa.appointment 
LEFT JOIN opportunistic_infection oi ON oi.indication = pv.indication
WHERE pv.active = '1'
GROUP BY pv.id
LIMIT {}, {}