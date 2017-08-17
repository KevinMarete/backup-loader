/*Patients*/
DELIMITER //
CREATE OR REPLACE PROCEDURE proc_save_adt_patient(
    IN patient_number VARCHAR(100),
	IN patient_dob DATE,
	IN patient_gender VARCHAR(6),
	IN startheight INT(3),
	IN startweight INT(3),
	IN startbsa DECIMAL(10,4),
	IN currentheight INT(3),
	IN currentweight INT(3),
	IN currentbsa DECIMAL(10,4),
	IN enrollmentdate DATE,
	IN startregimendate DATE,
	IN statuschangedate DATE,
	IN facilitycode VARCHAR(20),
	IN startregimencode VARCHAR(10),
	IN currentregimencode VARCHAR(10),
	IN servicename VARCHAR(20),
	IN statusname VARCHAR(50)
    )
BEGIN
    DECLARE facility, startregimen, currentregimen, service, status INT DEFAULT NULL;

    SELECT id INTO facility FROM tbl_facility WHERE UPPER(mflcode) = UPPER(facilitycode);
    SELECT id INTO startregimen FROM tbl_regimen WHERE UPPER(code) = UPPER(startregimencode);
    SELECT id INTO currentregimen FROM tbl_regimen WHERE UPPER(code) = UPPER(currentregimencode);
    SELECT id INTO service FROM tbl_service WHERE UPPER(name) = UPPER(servicename);
    SELECT id INTO status FROM tbl_status WHERE UPPER(name) = UPPER(statusname);

    IF NOT EXISTS(SELECT * FROM tbl_patient_adt WHERE ccc_number = patient_number AND facility_id = facility) THEN
        INSERT INTO tbl_patient_adt(ccc_number, birth_date, gender, start_height, start_weight, start_bsa, current_height, current_weight, current_bsa, enrollment_date, start_regimen_date, status_change_date, facility_id, start_regimen_id, current_regimen_id, service_id, status_id) VALUES(patient_number, patient_dob, patient_gender, startheight, startweight, startbsa, currentheight, currentweight, currentbsa, enrollmentdate, startregimendate, statuschangedate, facility, startregimen, currentregimen, service, status);
    ELSE
        UPDATE tbl_patient_adt SET birth_date = patient_dob, gender = patient_gender, start_height = startheight, start_weight = startweight, start_bsa = startbsa, current_height = currentheight, current_weight = currentweight, current_bsa = currentbsa, enrollment_date = enrollmentdate, start_regimen_date = startregimendate, status_change_date = statuschangedate, facility_id = facility, start_regimen_id = startregimen, current_regimen_id = currentregimen, service_id = service, status_id = status  WHERE ccc_number = patient_number AND facility_id = facility;
    END IF;
END//
DELIMITER ;

/*Viral Load Results*/
DELIMITER //
CREATE OR REPLACE PROCEDURE proc_save_adt_viral(
    IN testid INT(11), 
    IN testdate DATE,
    IN testresult VARCHAR(100),
    IN testjustification TEXT,
    IN patient_number VARCHAR(100),
    IN facility_code VARCHAR(20)
    )
BEGIN
    DECLARE adt_id, facility INT DEFAULT NULL;

    SELECT id INTO facility FROM tbl_facility WHERE UPPER(mflcode) = UPPER(facility_code);
    SELECT id INTO adt_id FROM tbl_patient_adt WHERE UPPER(ccc_number) = UPPER(patient_number) AND facility_id = facility;

    IF NOT EXISTS(SELECT * FROM tbl_viral WHERE test_id = testid) THEN
        INSERT INTO tbl_viral(test_id, test_date, test_result, test_justification, patient_adt_id, ccc_number) VALUES(testid, testdate, testresult, testjustification, adt_id, patient_number);
    ELSE
        UPDATE tbl_viral SET test_date = testdate, test_result = testresult, test_justification = testjustification, patient_adt_id = adt_id, ccc_number = patient_number  WHERE test_id = testid;
    END IF;
END//
DELIMITER ;

/*Visits*/
DELIMITER //
CREATE OR REPLACE PROCEDURE proc_save_adt_visit(
    IN dispensingdate DATE, 
    IN appointmentdate DATE,
    IN appointmentadherence DECIMAL,
    IN patient_number VARCHAR(100),
    IN purposename VARCHAR(30),
    IN lastregimencode VARCHAR(10),
    IN currentregimencode VARCHAR(10),
    IN changereasonname VARCHAR(150),
    IN visitquantity INT(11),
    IN visitduration INT(11),
    IN pillcountadh DECIMAL,
    IN selfreportingadh DECIMAL,
    IN dosename VARCHAR(10),
    IN drugname VARCHAR(255),
    IN packsizevalue VARCHAR(20),
    IN facility_code VARCHAR(20)
    )
BEGIN
    DECLARE visit, item, adt_id, facility, purpose, lastregimen, currentregimen, changereason, dose, drug INT DEFAULT NULL;

    SELECT id INTO facility FROM tbl_facility WHERE UPPER(mflcode) = UPPER(facility_code);
    SELECT id INTO adt_id FROM tbl_patient_adt WHERE UPPER(ccc_number) = UPPER(patient_number) AND facility_id = facility;
    SELECT id INTO purpose FROM tbl_purpose WHERE UPPER(name) = UPPER(purposename);
    SELECT id INTO lastregimen FROM tbl_regimen WHERE UPPER(code) = UPPER(lastregimencode);
    SELECT id INTO currentregimen FROM tbl_regimen WHERE UPPER(code) = UPPER(currentregimencode);
    SELECT id INTO changereason FROM tbl_change_reason WHERE UPPER(name) = UPPER(changereasonname);
    SELECT id INTO visit FROM tbl_visit WHERE patient_adt_id = adt_id AND dispensing_date = dispensingdate;

    IF(visit IS NULL) THEN
        INSERT INTO tbl_visit(dispensing_date, appointment_date, appointment_adherence, patient_adt_id, purpose_id, last_regimen_id, current_regimen_id, change_reason_id) VALUES(dispensingdate, appointmentdate, appointmentadherence, adt_id, purpose, lastregimen, currentregimen, changereason);
        SET visit = LAST_INSERT_ID();
    ELSE
        UPDATE tbl_visit SET appointment_date = appointmentdate, appointment_adherence = appointmentadherence, purpose_id = purpose, last_regimen_id = lastregimen, current_regimen_id = currentregimen, change_reason_id = changereason WHERE id = visit;
    END IF;

    SELECT id INTO dose FROM tbl_dose WHERE UPPER(name) = UPPER(dosename);
    SELECT id INTO drug FROM vw_drug_list WHERE UPPER(name) = UPPER(drugname) AND UPPER(pack_size) = UPPER(packsizevalue);
    SELECT id INTO item FROM tbl_visit_item WHERE visit_id = visit AND drug_id = drug AND UPPER(drug_name) = UPPER(drugname);

    IF(item IS NULL) THEN
        INSERT INTO tbl_visit_item(quantity, duration, pill_count_adherence, self_reporting_adherence, visit_id, dose_id, drug_id, drug_name, packsize) VALUES(visitquantity, visitduration, pillcountadh, selfreportingadh, visit, dose, drug, drugname, packsizevalue);
    ELSE
        UPDATE tbl_visit_item SET quantity = visitquantity, duration = visitduration, pill_count_adherence = pillcountadh, self_reporting_adherence = selfreportingadh, visit_id = visit, dose_id = dose, drug_id = drug, drug_name = drugname, packsize = packsizevalue WHERE id = visit;
    END IF;
END//
DELIMITER ;