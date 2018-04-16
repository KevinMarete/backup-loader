/*Update dsh_adt_tables*/
DROP PROCEDURE IF EXISTS proc_update_dsh_adt;
DELIMITER //
CREATE PROCEDURE proc_update_dsh_adt()
BEGIN
    /*start_regimen*/
    UPDATE dsh_patient_adt p INNER JOIN vw_regimen_list r ON p.start_regimen LIKE CONCAT(r.code, '%') SET p.start_regimen = r.name;
    /*current_regimen*/
    UPDATE dsh_patient_adt p INNER JOIN vw_regimen_list r ON p.current_regimen LIKE CONCAT(r.code, '%') SET p.current_regimen = r.name;
    /*service*/
    UPDATE dsh_patient_adt p INNER JOIN vw_regimen_list r ON p.current_regimen = r.name SET p.service = r.service;
    /*"OI Only" service*/
    UPDATE dsh_patient_adt p SET p.service = 'OI Only' WHERE p.current_regimen LIKE '%OI%';
    /*status*/
    UPDATE dsh_patient_adt p INNER JOIN tbl_status st ON st.name LIKE CONCAT('%', p.status, '%') SET p.status = st.name;
    /*"Lost_to_followup" status*/
    UPDATE dsh_patient_adt p SET p.status = 'LOST TO FOLLOW-UP' WHERE DATEDIFF(CURDATE(), p.pharmacy_appointment_date) >= 90 AND p.status IS NULL;
    /*"Active" status*/
    UPDATE dsh_patient_adt p SET p.status = 'ACTIVE' WHERE DATEDIFF(CURDATE(), p.pharmacy_appointment_date) < 90 AND p.status IS NULL;
    /*enrollment_date*/
    UPDATE dsh_patient_adt p SET p.enrollment_date = p.start_regimen_date WHERE p.enrollment_date = '0000-00-00';
    /*start_regimen_date*/
    UPDATE dsh_patient_adt p SET p.start_regimen_date= p.enrollment_date WHERE p.start_regimen_date = '0000-00-00';
    /*status_change_date*/
    UPDATE dsh_patient_adt p SET p.status_change_date= p.start_regimen_date WHERE p.status_change_date = '0000-00-00';
    /*patient_adt_id*/
    UPDATE dsh_visit_adt v INNER JOIN dsh_patient_adt p ON CONCAT_WS('_', p.ccc_number, p.facility) = v.patient_adt_id SET v.patient_adt_id = p.id;
    /*last_regimen*/
    UPDATE dsh_visit_adt v INNER JOIN vw_regimen_list r ON v.last_regimen LIKE CONCAT(r.code, '%') SET v.last_regimen = r.name;
    /*current_regimen*/
    UPDATE dsh_visit_adt v INNER JOIN vw_regimen_list r ON v.current_regimen LIKE CONCAT(r.code, '%') SET v.current_regimen = r.name;
    /*purpose*/
    UPDATE dsh_visit_adt v INNER JOIN tbl_purpose p ON p.name LIKE CONCAT('%', v.purpose, '%') SET v.purpose = p.name;
    /*regimen_change_reason*/
    UPDATE dsh_visit_adt v INNER JOIN tbl_change_reason cr ON cr.name LIKE CONCAT('%', v.regimen_change_reason, '%') SET v.regimen_change_reason = cr.name;
    /*drug*/
    UPDATE dsh_visit_adt v INNER JOIN tbl_generic g ON g.name LIKE CONCAT(SUBSTRING_INDEX(SUBSTRING_INDEX(v.drug, ' ', 1), ' ', -1), '%') OR abbreviation LIKE CONCAT(SUBSTRING_INDEX(SUBSTRING_INDEX(v.drug, ' ', 1), ' ', -1), '%') OR CONCAT(name, CONCAT('(', abbreviation, ')')) LIKE CONCAT(SUBSTRING_INDEX(SUBSTRING_INDEX(v.drug, ' ', 1), ' ', -1), '%') INNER JOIN tbl_drug d ON d.generic_id = g.id AND d.packsize = v.pack_size AND v.drug LIKE CONCAT('%', d.strength, '%' ) INNER JOIN vw_drug_list dl ON dl.id = d.id SET v.drug = dl.name;
END//
DELIMITER ;