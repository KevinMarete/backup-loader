SELECT 
	pv.dispensing_date dispensingdate,
	CASE 
		WHEN pv.dispensing_date = pa.appointment THEN pa.appointment
		WHEN pv.dispensing_date > pa.appointment THEN MAX(pa.appointment)
	END AS appointmentdate,
	REPLACE(pv.adherence, '%', '') appointmentadherence,
	patient_id patient_number,
	vp.name purposename,
	lr.regimen_code lastregimencode,
	cr.regimen_code currentregimencode,
	rcp.name changereasonname,
	pv.quantity visitquantity,
	pv.duration visitduration,
	CASE 
		WHEN pv.pill_count > 0 AND (pv.months_of_stock - pv.pill_count) >= pv.pill_count THEN 0 
		WHEN pv.pill_count > 0 AND (pv.months_of_stock - pv.pill_count) > 0 THEN ROUND((((pv.months_of_stock - pv.pill_count) / pv.pill_count) * 100), 2) 
		WHEN ((NOT((pv.months_of_stock regexp '[0-9]+'))) or ISNULL(pv.months_of_stock)) THEN 0 
		ELSE 100 
	END AS pillcountadh,
	CASE 
		WHEN pv.pill_count > 0 AND (pv.missed_pills - pv.pill_count) >= pv.pill_count THEN 0 
		WHEN pv.pill_count > 0 AND (pv.missed_pills - pv.pill_count) > 0 THEN ROUND((((pv.missed_pills - pv.pill_count) / pv.pill_count) * 100), 2) 
		WHEN ((NOT((pv.missed_pills regexp '[0-9]+'))) OR ISNULL(pv.missed_pills)) THEN 0 
		ELSE 100 
	END AS selfreportingadh,
	REPLACE(pv.dose, ' ', '') dosename,
	d.drug drugname,
	d.pack_size packsizevalue,
	pv.facility facility_code
FROM patient_visit pv
LEFT JOIN visit_purpose vp ON vp.id = pv.visit_purpose
LEFT JOIN regimen lr ON lr.id = pv.last_regimen
LEFT JOIN regimen cr ON cr.id = pv.regimen
LEFT JOIN regimen_change_purpose rcp ON rcp.id = pv.regimen_change_reason
LEFT JOIN drugcode d ON d.id = pv.drug_id
LEFT JOIN patient_appointment pa ON pa.patient = pv.patient_id AND pv.dispensing_date >= pa.appointment 
GROUP BY pv.id