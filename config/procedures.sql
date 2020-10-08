/*Update dsh_adt_tables*/
DROP PROCEDURE IF EXISTS proc_update_dsh_adt;
DELIMITER //
CREATE PROCEDURE proc_update_dsh_adt()
BEGIN
    /***patient_visit_table***/
    /*last_regimen*/
    UPDATE dsh_visit_adt v INNER JOIN vw_regimen_list r ON r.name = v.last_regimen SET v.last_regimen = r.name;
    /*current_regimen*/
    UPDATE dsh_visit_adt v INNER JOIN vw_regimen_list r ON r.name = v.current_regimen SET v.current_regimen = r.name;
    /*regimen_change_reason*/
    UPDATE dsh_visit_adt v INNER JOIN tbl_change_reason cr ON cr.name LIKE CONCAT('%', v.regimen_change_reason, '%') SET v.regimen_change_reason = cr.name;
    /*drug*/
    UPDATE dsh_visit_adt v INNER JOIN vw_drug_list d ON d.name LIKE CONCAT('%', v.drug, '%') AND d.pack_size = v.pack_size  SET v.drug = d.name;
    /*patient_adt_id*/
    UPDATE dsh_visit_adt v INNER JOIN dsh_patient_adt p ON CONCAT_WS('_', p.ccc_number, p.facility) = v.patient_adt_id SET v.patient_adt_id = p.id;
    
    /***patient_table***/
    /*facility*/
    UPDATE dsh_patient_adt p INNER JOIN tbl_facility f ON f.mflcode = p.facility SET p.facility = f.name;
    /*start_regimen*/
    UPDATE dsh_patient_adt p INNER JOIN vw_regimen_list r ON r.name = p.start_regimen SET p.start_regimen = r.name;
    /*current_regimen*/
    UPDATE dsh_patient_adt p INNER JOIN vw_regimen_list r ON r.name = p.current_regimen SET p.current_regimen = r.name;
    /*service*/
    UPDATE dsh_patient_adt p INNER JOIN tbl_service se ON se.name LIKE CONCAT('%', p.service, '%') SET p.service = se.name;
    /*status*/
    UPDATE dsh_patient_adt p INNER JOIN tbl_status st ON st.name LIKE CONCAT('%', p.status, '%') SET p.status = st.name;
    /*transfer_from*/
     UPDATE dsh_patient_adt p INNER JOIN tbl_facility f ON f.mflcode = p.transfer_from SET p.transfer_from = f.name;

END//
DELIMITER ;
