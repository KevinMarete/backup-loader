-- Adminer 4.7.0 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DELIMITER ;;

DROP FUNCTION IF EXISTS `AMC`;;
CREATE  FUNCTION `AMC`(pm_drug_id integer,no_of_mos integer, pm_period_date date) RETURNS int(10)
    DETERMINISTIC
BEGIN
    DECLARE amc INT(10);

    SELECT (SUM(total)/no_of_mos) INTO amc 
    FROM tbl_consumption
    WHERE DATE_FORMAT(STR_TO_DATE(CONCAT_WS('-', period_year, period_month), '%Y-%b'), '%Y-%m-01') >= DATE_SUB(pm_period_date, INTERVAL no_of_mos MONTH)
    AND DATE_FORMAT(STR_TO_DATE(CONCAT_WS('-', period_year, period_month), '%Y-%b'), '%Y-%m-01') <= pm_period_date
    AND drug_id = pm_drug_id;

    RETURN (amc);
END;;

DROP FUNCTION IF EXISTS `fn_get_consumption_average`;;
CREATE  FUNCTION `fn_get_consumption_average`(pm_drug_id integer, pm_period_date date) RETURNS int(11)
    DETERMINISTIC
BEGIN
    DECLARE consumption_average INT(11);

    SELECT (SUM(monthly_consumption)/6) INTO consumption_average 
    FROM tbl_procurement
    WHERE DATE_FORMAT(STR_TO_DATE(CONCAT_WS('-', transaction_year, transaction_month), '%Y-%b'), '%Y-%m-01') > DATE_SUB(pm_period_date, INTERVAL 6 MONTH)
    AND DATE_FORMAT(STR_TO_DATE(CONCAT_WS('-', transaction_year, transaction_month), '%Y-%b'), '%Y-%m-01') <= pm_period_date
    AND drug_id = pm_drug_id;

    RETURN (consumption_average);
END;;

DROP FUNCTION IF EXISTS `fn_get_county_amc`;;
CREATE  FUNCTION `fn_get_county_amc`(`pm_drug_id` integer, `no_of_mos` integer, `pm_period_date` date, `pm_criteria` varchar(20)) RETURNS int(10)
    DETERMINISTIC
BEGIN
    DECLARE amc INT(10);
   
    SELECT (SUM(total)/no_of_mos) INTO amc  
    FROM `vw_consumption_list` 
    WHERE county = pm_criteria
    AND `drug_id` = pm_drug_id
    AND cdate >= DATE_SUB(pm_period_date, INTERVAL no_of_mos MONTH)
    AND cdate <= pm_period_date;    

    RETURN (amc);
END;;

DROP FUNCTION IF EXISTS `fn_get_dyn_consumption_average`;;
CREATE  FUNCTION `fn_get_dyn_consumption_average`(pm_drug_id integer, pm_period_date date, no_of_mos integer) RETURNS int(11)
    DETERMINISTIC
BEGIN
    DECLARE consumption_average INT(11);

    SELECT (SUM(monthly_consumption)/no_of_mos) INTO consumption_average 
    FROM tbl_procurement
    WHERE STR_TO_DATE(CONCAT(CONCAT_WS('-', transaction_year, transaction_month), '-01'), '%Y-%b-%d') > DATE_SUB(pm_period_date, INTERVAL no_of_mos MONTH)
    AND STR_TO_DATE(CONCAT(CONCAT_WS('-', transaction_year, transaction_month), '-01'), '%Y-%b-%d') <= pm_period_date
    AND drug_id = pm_drug_id;

    RETURN (consumption_average);
END;;

DROP FUNCTION IF EXISTS `fn_get_dyn_issues_average`;;
CREATE  FUNCTION `fn_get_dyn_issues_average`(pm_drug_id integer, pm_period_date date, no_of_mos integer) RETURNS int(11)
    DETERMINISTIC
BEGIN
    DECLARE issues_average INT(11);

    SELECT (SUM(issues_kemsa)/no_of_mos) INTO issues_average 
    FROM tbl_procurement
    WHERE STR_TO_DATE(CONCAT(CONCAT_WS('-', transaction_year, transaction_month), '-01'), '%Y-%b-%d') > DATE_SUB(pm_period_date, INTERVAL no_of_mos MONTH)
    AND STR_TO_DATE(CONCAT(CONCAT_WS('-', transaction_year, transaction_month), '-01'), '%Y-%b-%d') <= pm_period_date
    AND drug_id = pm_drug_id;

    RETURN (issues_average);
END;;

DROP FUNCTION IF EXISTS `fn_get_facility_amc`;;
CREATE  FUNCTION `fn_get_facility_amc`(pm_drug_id integer, pm_drug_mos integer, pm_period_date date, pm_facility_id integer) RETURNS int(10)
    DETERMINISTIC
BEGIN
    DECLARE amc INT(10);

    SELECT (SUM(total)/pm_drug_mos) INTO amc 
    FROM tbl_consumption
    WHERE STR_TO_DATE(CONCAT(CONCAT_WS('-', period_year, period_month), '-01'), '%Y-%b-%d') >= DATE_SUB(pm_period_date, INTERVAL pm_drug_mos MONTH)
    AND STR_TO_DATE(CONCAT(CONCAT_WS('-', period_year, period_month), '-01'), '%Y-%b-%d') <= pm_period_date
    AND drug_id = pm_drug_id
    AND facility_id = pm_facility_id;

    RETURN (amc);
END;;

DROP FUNCTION IF EXISTS `fn_get_issues_average`;;
CREATE  FUNCTION `fn_get_issues_average`(pm_drug_id integer, pm_period_date date) RETURNS int(11)
    DETERMINISTIC
BEGIN
    DECLARE issues_average INT(11);

    SELECT (SUM(issues_kemsa)/6) INTO issues_average 
    FROM tbl_procurement
    WHERE DATE_FORMAT(STR_TO_DATE(CONCAT_WS('-', transaction_year, transaction_month), '%Y-%b'), '%Y-%m-01') > DATE_SUB(pm_period_date, INTERVAL 6 MONTH)
    AND DATE_FORMAT(STR_TO_DATE(CONCAT_WS('-', transaction_year, transaction_month), '%Y-%b'), '%Y-%m-01') <= pm_period_date
    AND drug_id = pm_drug_id;

    RETURN (issues_average);
END;;

DROP FUNCTION IF EXISTS `fn_get_national_amc`;;
CREATE  FUNCTION `fn_get_national_amc`(pm_drug_id integer, pm_period_date date) RETURNS int(10)
    DETERMINISTIC
BEGIN
    DECLARE amc INT(10);

    SELECT (SUM(total)/6) INTO amc 
    FROM tbl_consumption
    WHERE DATE_FORMAT(STR_TO_DATE(CONCAT_WS('-', period_year, period_month), '%Y-%b'), '%Y-%m-01') >= DATE_SUB(pm_period_date, INTERVAL 6 MONTH)
    AND DATE_FORMAT(STR_TO_DATE(CONCAT_WS('-', period_year, period_month), '%Y-%b'), '%Y-%m-01') <= pm_period_date
    AND drug_id = pm_drug_id;

    RETURN (amc);
END;;

DROP FUNCTION IF EXISTS `fn_get_national_dyn_amc`;;
CREATE  FUNCTION `fn_get_national_dyn_amc`(`pm_drug_id` integer, `no_of_mos` integer, `pm_period_date` date) RETURNS int(10)
    DETERMINISTIC
BEGIN
    DECLARE amc INT(10);
   
    SELECT (SUM(total)/no_of_mos) INTO amc  
    FROM `vw_consumption_list`     
    WHERE `drug_id` = pm_drug_id
    AND cdate >= DATE_SUB(pm_period_date, INTERVAL no_of_mos MONTH)
    AND cdate <= pm_period_date;    

    RETURN (amc);
END;;

DROP FUNCTION IF EXISTS `fn_get_subcounty_amc`;;
CREATE  FUNCTION `fn_get_subcounty_amc`(`pm_drug_id` integer, `no_of_mos` integer, `pm_period_date` date, `pm_criteria` varchar(20)) RETURNS int(10)
    DETERMINISTIC
BEGIN
    DECLARE amc INT(10);
   
    SELECT (SUM(total)/no_of_mos) INTO amc  
    FROM `vw_consumption_list` 
    WHERE subcounty = pm_criteria
    AND `drug_id` = pm_drug_id
    AND cdate >= DATE_SUB(pm_period_date, INTERVAL no_of_mos MONTH)
    AND cdate <= pm_period_date;    

    RETURN (amc);
END;;

DROP FUNCTION IF EXISTS `getDrugIDByName`;;
CREATE  FUNCTION `getDrugIDByName`(param varchar(200)) RETURNS varchar(32) CHARSET latin1
BEGIN

  DECLARE drug_id INT(10);

    SELECT `id`
      INTO drug_id
      FROM `vw_drug_list`
     WHERE `name` = param;

    RETURN (drug_id);

END;;

DROP PROCEDURE IF EXISTS `proc_create_dsh_tables_excel`;;
CREATE  PROCEDURE `proc_create_dsh_tables_excel`()
BEGIN
    SET @@foreign_key_checks = 0;
    
    TRUNCATE dsh_mos;
    INSERT INTO dsh_mos(facility_mos, cms_mos, supplier_mos, data_year, data_month, data_date, drug)
    SELECT 
        IFNULL(ROUND(SUM(fs.total)/fn_get_national_amc(k.drug_id, DATE_FORMAT(str_to_date(CONCAT(k.period_year,k.period_month),'%Y%b%d'),'%Y-%m-01') ),1),0) AS facility_mos,
        IFNULL(ROUND(k.soh_total/fn_get_national_amc(k.drug_id, DATE_FORMAT(str_to_date(CONCAT(k.period_year,k.period_month),'%Y%b%d'),'%Y-%m-01') ),1),0) AS cms_mos,
        IFNULL(ROUND(k.supplier_total/fn_get_national_amc(k.drug_id, DATE_FORMAT(str_to_date(CONCAT(k.period_year,k.period_month),'%Y%b%d'),'%Y-%m-01')),1),0) AS supplier_mos,
        k.period_year,
        k.period_month,
        STR_TO_DATE(CONCAT_WS('-', k.period_year, k.period_month, '01'),'%Y-%b-%d') AS data_date,
        d.name
    FROM tbl_kemsa k
    INNER JOIN tbl_stock fs ON fs.drug_id = k.drug_id AND fs.period_month = k.period_month AND fs.period_year = k.period_year
    INNER JOIN vw_drug_list d ON d.id = k.drug_id
    GROUP BY d.name, k.period_month, k.period_year;
    
    TRUNCATE dsh_consumption;
    INSERT INTO dsh_consumption(total, data_year, data_month, data_date, sub_county, county, facility, drug)
    SELECT 
        SUM(cf.total) AS total,
        cf.period_year AS data_year,
        cf.period_month AS data_month,
        STR_TO_DATE(CONCAT_WS('-', cf.period_year, cf.period_month, '01'),'%Y-%b-%d') AS data_date,
        cs.name AS sub_county,
        c.name AS county,
        f.name AS facility,
        d.name AS drug
    FROM tbl_consumption cf 
    INNER JOIN vw_drug_list d ON cf.drug_id = d.id
    INNER JOIN tbl_facility f ON cf.facility_id = f.id
    INNER JOIN tbl_subcounty cs ON cs.id = f.subcounty_id
    INNER JOIN tbl_county c ON c.id = cs.county_id
    GROUP by drug,facility,county,sub_county,data_month,data_year;
    
    TRUNCATE dsh_patient;
    INSERT INTO dsh_patient(total, data_year, data_month, data_date, sub_county, county, facility, partner, regimen, age_category, regimen_service, regimen_line, nnrti_drug, nrti_drug, regimen_category)
    SELECT
        SUM(rp.total) AS total,
        rp.period_year AS data_year,
        rp.period_month AS data_month,
        STR_TO_DATE(CONCAT_WS('-', rp.period_year, rp.period_month, '01'),'%Y-%b-%d') AS data_date,
        cs.name AS sub_county,
        c.name AS county,
        f.name AS facility,
        p.name AS partner,
        CONCAT_WS(' | ', r.code, r.name) AS regimen,
        CASE 
            WHEN ct.name LIKE '%adult%' OR ct.name LIKE '%mother%' THEN 'adult' 
            WHEN ct.name LIKE '%paediatric%' OR ct.name  LIKE '%child%' THEN 'paed'
            ELSE NULL
        END AS age_category,
        s.name AS regimen_service,
        l.name AS regimen_line,
        nn.name AS nnrti_drug,
        n.name AS nrti_drug,
        ct.name AS regimen_category
    FROM tbl_patient rp
    INNER JOIN tbl_regimen r ON rp.regimen_id = r.id
    INNER JOIN tbl_service s ON s.id = r.service_id
    INNER JOIN tbl_line l ON l.id = r.line_id
    INNER JOIN tbl_category ct ON ct.id = r.category_id
    LEFT JOIN tbl_nrti n ON n.regimen_id = r.id
    LEFT JOIN tbl_nnrti nn ON nn.regimen_id = r.id
    INNER JOIN tbl_facility f ON rp.facility_id = f.id
    LEFT JOIN tbl_partner p ON p.id = f.partner_id
    INNER JOIN tbl_subcounty cs ON cs.id = f.subcounty_id
    INNER JOIN tbl_county c ON c.id = cs.county_id
    GROUP by regimen_category,nrti_drug,nnrti_drug,regimen_line,regimen_service,age_category,regimen,facility,county,sub_county,data_month,data_year;
    SET @@foreign_key_checks = 1;
END;;

DROP PROCEDURE IF EXISTS `proc_save_adt_patient`;;
CREATE  PROCEDURE `proc_save_adt_patient`(
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
END;;

DROP PROCEDURE IF EXISTS `proc_save_adt_viral`;;
CREATE  PROCEDURE `proc_save_adt_viral`(
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
END;;

DROP PROCEDURE IF EXISTS `proc_save_adt_visit`;;
CREATE  PROCEDURE `proc_save_adt_visit`(
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
END;;

DROP PROCEDURE IF EXISTS `proc_save_cdrr`;;
CREATE  PROCEDURE `proc_save_cdrr`(
	IN ordcode VARCHAR(15)
	)
BEGIN
	IF (ordcode = 'F-CDRR') THEN
		
		UPDATE tbl_order o INNER JOIN tbl_facility f ON f.dhiscode = o.facility SET o.facility = f.id;

		
		UPDATE tbl_order o SET o.period = STR_TO_DATE(CONCAT_WS('-', o.period,'01'),'%Y%m-%e');

		
		DELETE FROM tbl_order WHERE (facility, period) IN (SELECT c.facility_id, c.period_begin FROM tbl_cdrr c WHERE c.code = ordcode AND c.status IN ('rejected', 'allocated', 'approved', 'reviewed'));

		
		REPLACE INTO tbl_order(facility, period, dimension, category, value) SELECT c.facility_id, c.period_begin, ci.drug_id, 'qty_allocated', ci.qty_allocated FROM tbl_cdrr_item ci INNER JOIN tbl_cdrr c ON c.id = ci.cdrr_id WHERE c.code = ordcode AND c.status IN ('prepared') AND ci.qty_allocated IS NOT NULL;

		
		REPLACE INTO tbl_order(facility, period, dimension, category, value) SELECT c.facility_id, c.period_begin, ci.drug_id, 'qty_allocated_mos', ci.qty_allocated_mos FROM tbl_cdrr_item ci INNER JOIN tbl_cdrr c ON c.id = ci.cdrr_id WHERE c.code = ordcode AND c.status IN ('prepared') AND ci.qty_allocated_mos IS NOT NULL;

		
		REPLACE INTO tbl_cdrr(status, created, updated, code, period_begin, period_end, non_arv, facility_id) SELECT 'pending' status, NOW() created, NOW() updated, ordcode code, o.period period_begin, LAST_DAY(o.period) period_end, 0 non_arv, o.facility facility_id FROM tbl_order o INNER JOIN tbl_facility f ON f.id = o.facility GROUP BY o.facility, o.period;

		
		UPDATE tbl_order o INNER JOIN tbl_cdrr c ON c.facility_id = o.facility AND o.period = c.period_begin AND c.code = ordcode SET o.report_id = c.id;

		
		REPLACE INTO tbl_cdrr_log(description, created, user_id, cdrr_id) SELECT 'pending' status, NOW() created, '1' user_id, o.report_id cdrr_id FROM tbl_order o INNER JOIN tbl_facility f ON f.id = o.facility GROUP BY o.facility, o.period;

		
		UPDATE tbl_order o INNER JOIN tbl_dhis_elements de ON de.dhis_code = o.dimension SET o.dimension = de.target_id;
	ELSE
		
		ALTER TABLE tbl_order DROP INDEX facility_period_dimension_category;

		
		UPDATE tbl_order o INNER JOIN tbl_facility f ON f.dhiscode = o.facility SET o.facility = f.parent_id WHERE o.category IN ('dispensed_packs', 'count') AND dimension IN (SELECT dhis_code FROM tbl_dhis_elements WHERE target_report = 'unknown');

		
		UPDATE tbl_order o INNER JOIN tbl_facility f ON f.dhiscode = o.facility SET o.facility = f.id;

		
		INSERT INTO tbl_order(facility, period, dimension, category, value) SELECT o.facility, o.period, o.dimension, 'aggr_consumed' category, SUM(o.value) value FROM tbl_order o WHERE category = 'dispensed_packs' AND dimension IN (SELECT dhis_code FROM tbl_dhis_elements WHERE target_report = 'unknown') GROUP BY o.facility, o.period, o.dimension;
		INSERT INTO tbl_order(facility, period, dimension, category, value) SELECT o.facility, o.period, o.dimension, 'aggr_on_hand' category, SUM(o.value) value FROM tbl_order o WHERE category = 'count' AND dimension IN (SELECT dhis_code FROM tbl_dhis_elements WHERE target_report = 'unknown') GROUP BY o.facility, o.period, o.dimension;

		
		DELETE FROM tbl_order WHERE dimension IN (SELECT dhis_code FROM tbl_dhis_elements WHERE target_report = 'unknown') AND category NOT IN ('aggr_consumed', 'aggr_on_hand');

		
		ALTER TABLE tbl_order ADD UNIQUE facility_period_dimension_category (facility, period, dimension, category);

		
		UPDATE tbl_order o SET o.period = STR_TO_DATE(CONCAT_WS('-', o.period,'01'),'%Y%m-%e');

		
		DELETE FROM tbl_order WHERE (facility, period) IN (SELECT c.facility_id, c.period_begin FROM tbl_cdrr c WHERE c.code = ordcode AND c.status IN ('rejected', 'allocated', 'approved', 'reviewed'));
		
		
		REPLACE INTO tbl_order(facility, period, dimension, category, value) SELECT c.facility_id, c.period_begin, ci.drug_id, 'qty_allocated', ci.qty_allocated FROM tbl_cdrr_item ci INNER JOIN tbl_cdrr c ON c.id = ci.cdrr_id WHERE c.code = ordcode AND c.status IN ('prepared') AND ci.qty_allocated IS NOT NULL;

		
		REPLACE INTO tbl_order(facility, period, dimension, category, value) SELECT c.facility_id, c.period_begin, ci.drug_id, 'qty_allocated_mos', ci.qty_allocated_mos FROM tbl_cdrr_item ci INNER JOIN tbl_cdrr c ON c.id = ci.cdrr_id WHERE c.code = ordcode AND c.status IN ('prepared') AND ci.qty_allocated_mos IS NOT NULL;

		
		REPLACE INTO tbl_cdrr(status, created, updated, code, period_begin, period_end, non_arv, facility_id) SELECT 'pending' status, NOW() created, NOW() updated, ordcode code, o.period period_begin, LAST_DAY(o.period) period_end, 0 non_arv, o.facility facility_id FROM tbl_order o INNER JOIN tbl_facility f ON f.id = o.facility GROUP BY o.facility, o.period;

		
		UPDATE tbl_order o INNER JOIN tbl_cdrr c ON c.facility_id = o.facility AND o.period = c.period_begin AND c.code = ordcode SET o.report_id = c.id;

		
		REPLACE INTO tbl_cdrr_log(description, created, user_id, cdrr_id) SELECT 'pending' status, NOW() created, '1' user_id, o.report_id cdrr_id FROM tbl_order o INNER JOIN tbl_facility f ON f.id = o.facility GROUP BY o.facility, o.period;

		
		UPDATE tbl_order o INNER JOIN tbl_dhis_elements de ON de.dhis_code = o.dimension SET o.dimension = de.target_id;
    END IF;
END;;

DROP PROCEDURE IF EXISTS `proc_save_cdrr_item`;;
CREATE  PROCEDURE `proc_save_cdrr_item`()
BEGIN
	DECLARE bDone INT;
	DECLARE k VARCHAR(255);
	DECLARE v VARCHAR(255);

	
	DECLARE curs CURSOR FOR  SELECT CONCAT_WS(',', GROUP_CONCAT(o.category SEPARATOR ','), 'cdrr_id', 'drug_id'), CONCAT_WS(',', GROUP_CONCAT(o.value SEPARATOR ','), report_id, dimension) FROM tbl_order o INNER JOIN tbl_facility f ON f.id = o.facility GROUP BY o.report_id, o.dimension;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = 1;

	OPEN curs;

	SET bDone = 0;
	REPEAT
		FETCH curs INTO k,v;

		SET @sqlv=CONCAT('REPLACE INTO tbl_cdrr_item (', k, ') VALUES (', v, ')');
		PREPARE stmt FROM @sqlv;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	UNTIL bDone END REPEAT;

	CLOSE curs;

	TRUNCATE tbl_order;
END;;

DROP PROCEDURE IF EXISTS `proc_save_consumption`;;
CREATE  PROCEDURE `proc_save_consumption`(
    IN facility_code VARCHAR(20),
    IN drug_name VARCHAR(255), 
    IN packsize VARCHAR(20),
    IN p_year INT(4),
    IN p_month VARCHAR(3),
    IN consumption_total INT(11)
    )
BEGIN
    DECLARE facility,drug INT DEFAULT NULL;
    SET facility_code = REPLACE(facility_code, "'", "");
    SET drug_name = REPLACE(drug_name, "'", "");

    SELECT id INTO facility FROM tbl_facility WHERE UPPER(mflcode) = UPPER(facility_code);
    SELECT id INTO drug FROM vw_drug_list WHERE UPPER(name) = UPPER(drug_name) AND UPPER(pack_size) = UPPER(packsize);

    IF NOT EXISTS(SELECT * FROM tbl_consumption WHERE period_year = p_year AND period_month = p_month AND facility_id = facility AND drug_id = drug) THEN
        INSERT INTO tbl_consumption(total, period_year, period_month, facility_id, drug_id) VALUES(consumption_total, p_year, p_month, facility, drug);
    ELSE
        UPDATE tbl_consumption SET total = consumption_total WHERE period_year = p_year AND period_month = p_month AND facility_id = facility AND drug_id = drug; 
    END IF;
END;;

DROP PROCEDURE IF EXISTS `proc_save_dsh_tables`;;
CREATE  PROCEDURE `proc_save_dsh_tables`(
    IN p_begin DATE
    )
BEGIN
	SET @@foreign_key_checks = 0;
    
    REPLACE INTO tbl_consumption(total, allocated, period_year, period_month, facility_id, drug_id) 
    SELECT SUM(ci.dispensed_packs) dispensed, SUM(ci.qty_allocated) allocated, YEAR(c.period_begin) period_year, MONTHNAME(c.period_begin) period_month, c.facility_id, ci.drug_id 
    FROM tbl_cdrr_item ci 
    INNER JOIN tbl_cdrr c ON c.id = ci.cdrr_id 
    WHERE c.period_begin = p_begin 
    AND c.code = 'F-CDRR' 
    GROUP BY c.facility_id, ci.drug_id, c.period_begin; 

    
    REPLACE INTO tbl_patient (total, period_year, period_month, regimen_id, facility_id) 
    SELECT SUM(mi.total) total, YEAR(m.period_begin) period_year, MONTHNAME(m.period_begin) period_month, mi.regimen_id, m.facility_id 
    FROM tbl_maps_item mi 
    INNER JOIN tbl_maps m ON m.id = mi.maps_id 
    WHERE m.period_begin = p_begin 
    AND m.code = 'F-MAPS' 
    GROUP BY m.facility_id, mi.regimen_id, m.period_begin; 

    
    REPLACE INTO tbl_stock(total, period_year, period_month, facility_id, drug_id) 
    SELECT SUM(ci.count) soh, YEAR(c.period_begin) period_year, MONTHNAME(c.period_begin) period_month, c.facility_id, ci.drug_id 
    FROM tbl_cdrr_item ci 
    INNER JOIN tbl_cdrr c ON c.id = ci.cdrr_id 
    WHERE c.period_begin = p_begin 
    GROUP BY c.facility_id, ci.drug_id, c.period_begin; 

    
    REPLACE INTO tbl_kemsa(issue_total, soh_total, supplier_total, received_total, period_year, period_month, drug_id) 
    SELECT SUM(p.issues_kemsa) issues, s.supplier, SUM(p.receipts_kemsa) receipts, SUM(p.close_kemsa) close_bal, p.transaction_year, p.transaction_month, p.drug_id 
    FROM tbl_procurement p 
    INNER JOIN (
        SELECT p.drug_id, SUM(quantity) supplier 
        FROM tbl_procurement p  
        INNER JOIN tbl_procurement_item pi ON pi.procurement_id = p.id 
        WHERE STR_TO_DATE(CONCAT(CONCAT_WS('-', p.transaction_year, p.transaction_month), '-01'), '%Y-%b-%d') > p_begin 
        GROUP BY p.drug_id
    ) s ON s.drug_id = p.drug_id 
    WHERE STR_TO_DATE(CONCAT(CONCAT_WS('-', p.transaction_year, p.transaction_month), '-01'), '%Y-%b-%d') = p_begin 
    GROUP BY p.drug_id, p.transaction_year, p.transaction_month;

    
    UPDATE tbl_procurement p 
    INNER JOIN (
        SELECT SUM(ci.dispensed_packs) consumed, YEAR(c.period_begin) transaction_year, DATE_FORMAT(c.period_begin, '%b') transaction_month, ci.drug_id  
        FROM tbl_cdrr_item ci 
        INNER JOIN tbl_cdrr c ON c.id = ci.cdrr_id 
        WHERE c.period_begin = p_begin 
        AND c.code = 'F-CDRR' 
        GROUP BY ci.drug_id, c.period_begin
    ) t  ON t.drug_id = p.drug_id AND t.transaction_year = p.transaction_year AND t.transaction_month = p.transaction_month SET p.monthly_consumption = t.consumed;

    
    UPDATE tbl_procurement_item pi 
    INNER JOIN tbl_procurement p ON p.id = pi.procurement_id 
    SET pi.procurement_status_id = '2' 
    WHERE pi.procurement_status_id = '3' 
    AND STR_TO_DATE(CONCAT(CONCAT_WS('-', p.transaction_year, p.transaction_month), '-01'), '%Y-%b-%d') > p_begin;

    
    REPLACE INTO dsh_mos(facility_mos, cms_mos, supplier_mos, data_year, data_month, data_date, drug)
    SELECT 
        IFNULL(ROUND(SUM(fs.total)/fn_get_national_amc(k.drug_id, STR_TO_DATE(CONCAT(CONCAT_WS('-', k.period_year, k.period_month), '-01'),'%Y-%b-%d')),1),0) AS facility_mos,
        IFNULL(ROUND(k.soh_total/fn_get_national_amc(k.drug_id, STR_TO_DATE(CONCAT(CONCAT_WS('-', k.period_year, k.period_month), '-01'),'%Y-%b-%d')),1),0) AS cms_mos,
        IFNULL(ROUND(k.supplier_total/fn_get_national_amc(k.drug_id, STR_TO_DATE(CONCAT(CONCAT_WS('-', k.period_year, k.period_month), '-01'),'%Y-%b-%d')),1),0) AS supplier_mos,
        k.period_year,
        k.period_month,
        STR_TO_DATE(CONCAT_WS('-', k.period_year, k.period_month, '01'),'%Y-%b-%d') AS data_date,
        d.name
    FROM tbl_kemsa k
    INNER JOIN tbl_stock fs ON fs.drug_id = k.drug_id AND fs.period_month = k.period_month AND fs.period_year = k.period_year
    INNER JOIN vw_drug_list d ON d.id = k.drug_id
    WHERE STR_TO_DATE(CONCAT_WS('-', k.period_year, k.period_month, '01'),'%Y-%b-%d') = p_begin
    GROUP BY d.name, k.period_month, k.period_year;

    
    REPLACE INTO dsh_consumption(total, allocated, data_year, data_month, data_date, sub_county, county, facility, drug)
    SELECT 
        SUM(cf.total) AS total,
        SUM(cf.allocated) AS allocated,
        cf.period_year AS data_year,
        cf.period_month AS data_month,
        STR_TO_DATE(CONCAT_WS('-', cf.period_year, cf.period_month, '01'),'%Y-%b-%d') AS data_date,
        cs.name AS sub_county,
        c.name AS county,
        f.name AS facility,
        d.name AS drug
    FROM tbl_consumption cf 
    INNER JOIN vw_drug_list d ON cf.drug_id = d.id
    INNER JOIN tbl_facility f ON cf.facility_id = f.id
    INNER JOIN tbl_subcounty cs ON cs.id = f.subcounty_id
    INNER JOIN tbl_county c ON c.id = cs.county_id
    WHERE STR_TO_DATE(CONCAT_WS('-', cf.period_year, cf.period_month, '01'),'%Y-%b-%d') = p_begin
    GROUP by drug, facility, county, sub_county, data_month, data_year;

    
    REPLACE INTO dsh_patient(total, data_year, data_month, data_date, sub_county, county, facility, partner, regimen, age_category, regimen_service, regimen_line, nnrti_drug, nrti_drug, regimen_category)
    SELECT
        SUM(rp.total) AS total,
        rp.period_year AS data_year,
        rp.period_month AS data_month,
        STR_TO_DATE(CONCAT_WS('-', rp.period_year, rp.period_month, '01'),'%Y-%b-%d') AS data_date,
        cs.name AS sub_county,
        c.name AS county,
        f.name AS facility,
        p.name AS partner,
        CONCAT_WS(' | ', r.code, r.name) AS regimen,
        CASE 
            WHEN ct.name LIKE '%adult%' OR ct.name LIKE '%mother%' THEN 'adult' 
            WHEN ct.name LIKE '%paediatric%' OR ct.name  LIKE '%child%' THEN 'paed'
            ELSE NULL
        END AS age_category,
        s.name AS regimen_service,
        l.name AS regimen_line,
        nn.name AS nnrti_drug,
        n.name AS nrti_drug,
        ct.name AS regimen_category
    FROM tbl_patient rp
    INNER JOIN tbl_regimen r ON rp.regimen_id = r.id
    INNER JOIN tbl_service s ON s.id = r.service_id
    INNER JOIN tbl_line l ON l.id = r.line_id
    INNER JOIN tbl_category ct ON ct.id = r.category_id
    LEFT JOIN tbl_nrti n ON n.regimen_id = r.id
    LEFT JOIN tbl_nnrti nn ON nn.regimen_id = r.id
    INNER JOIN tbl_facility f ON rp.facility_id = f.id
    LEFT JOIN tbl_partner p ON p.id = f.partner_id
    INNER JOIN tbl_subcounty cs ON cs.id = f.subcounty_id
    INNER JOIN tbl_county c ON c.id = cs.county_id
    WHERE STR_TO_DATE(CONCAT_WS('-', rp.period_year, rp.period_month, '01'),'%Y-%b-%d') = p_begin
    GROUP by regimen_category, nrti_drug, nnrti_drug, regimen_line, regimen_service, age_category, regimen, facility, county, sub_county, data_month, data_year;

    
    REPLACE INTO dsh_stock(total, amc_total, data_year, data_month, data_date, sub_county, county, facility, drug)
    SELECT 
        SUM(st.total) AS total,
        fn_get_facility_amc(st.drug_id, d.amc_months, STR_TO_DATE(CONCAT(CONCAT_WS('-', st.period_year, st.period_month), '-01'),'%Y-%b-%d'), st.facility_id),
        st.period_year AS data_year,
        st.period_month AS data_month,
        STR_TO_DATE(CONCAT_WS('-', st.period_year, st.period_month, '01'),'%Y-%b-%d') AS data_date,
        cs.name AS sub_county,
        c.name AS county,
        f.name AS facility,
        d.name AS drug
    FROM tbl_stock st 
    INNER JOIN vw_drug_list d ON st.drug_id = d.id
    INNER JOIN tbl_facility f ON st.facility_id = f.id
    INNER JOIN tbl_subcounty cs ON cs.id = f.subcounty_id
    INNER JOIN tbl_county c ON c.id = cs.county_id
    WHERE STR_TO_DATE(CONCAT_WS('-', st.period_year, st.period_month, '01'),'%Y-%b-%d') = p_begin
    GROUP by drug, facility, county, sub_county, data_month, data_year;

    
    REPLACE INTO dsh_order(data_year, data_month, data_date, sub_county, county, facility, facility_category)
    SELECT
        YEAR(c.period_begin) data_year,
        MONTHNAME(c.period_begin) data_month,
        c.period_begin data_date,
        cs.name AS sub_county,
        co.name AS county,
        f.name AS facility,
        CASE 
            WHEN c.code = 'D-CDRR' THEN 'central'
            WHEN c.code = 'F-CDRR' AND f.category = 'standalone' THEN 'standalone'
            ELSE 'satellite'
        END AS facility_category
    FROM tbl_cdrr c 
    INNER JOIN tbl_maps m ON m.facility_id = c.facility_id AND c.period_begin = m.period_begin AND SUBSTRING(c.code, 1, 1) = SUBSTRING(m.code, 1, 1)
    INNER JOIN tbl_facility f ON c.facility_id = f.id
    INNER JOIN tbl_subcounty cs ON cs.id = f.subcounty_id
    INNER JOIN tbl_county co ON co.id = cs.county_id
    WHERE c.period_begin = p_begin
    GROUP by facility_category, facility, county, sub_county, data_month, data_year;

    
    REPLACE INTO dsh_order_item(opening_bal_qty, received_qty, consumed_qty, losses_qty, adjustment_qty, closing_bal_qty, data_year, data_month, data_date, sub_county, county, facility, facility_category, drug)
    SELECT
        ci.balance opening_bal_qty,
        ci.received received_qty,
        ci.dispensed_packs consumed_qty,
        ci.losses losses_qty,
        (ci.adjustments - ci.adjustments_neg) adjustment_qty,
        ci.count closing_bal_qty,
        YEAR(c.period_begin) data_year,
        MONTHNAME(c.period_begin) data_month,
        c.period_begin data_date,
        cs.name AS sub_county,
        co.name AS county,
        f.name AS facility,
        CASE 
            WHEN c.code = 'D-CDRR' THEN 'central'
            WHEN c.code = 'F-CDRR' AND f.category = 'standalone' THEN 'standalone'
            ELSE 'satellite'
        END AS facility_category,
        d.name AS drug
    FROM tbl_cdrr_item ci 
    INNER JOIN tbl_cdrr c ON c.id = ci.cdrr_id
    INNER JOIN vw_drug_list d ON ci.drug_id = d.id
    INNER JOIN tbl_maps m ON m.facility_id = c.facility_id AND c.period_begin = m.period_begin AND SUBSTRING(c.code, 1, 1) = SUBSTRING(m.code, 1, 1)
    INNER JOIN tbl_facility f ON c.facility_id = f.id
    INNER JOIN tbl_subcounty cs ON cs.id = f.subcounty_id
    INNER JOIN tbl_county co ON co.id = cs.county_id
    WHERE c.period_begin = p_begin
    GROUP by drug, facility_category, facility, county, sub_county, data_month, data_year;
    SET @@foreign_key_checks = 1;
END;;

DROP PROCEDURE IF EXISTS `proc_save_facility`;;
CREATE  PROCEDURE `proc_save_facility`(
    IN facility_code VARCHAR(20), 
    IN facility_name VARCHAR(150),
    IN county_name VARCHAR(30)
    )
BEGIN
    DECLARE county,master,subcounty,facility INT DEFAULT NULL;
    SET facility_name = REPLACE(facility_name, "'", "");
    SET facility_code = REPLACE(facility_code, "'", "");
    SET county_name = REPLACE(county_name, "'", "");

    SELECT id INTO facility FROM tbl_facility WHERE UPPER(mflcode) = UPPER(facility_code);
    IF (facility IS NULL) THEN
        SELECT id INTO county FROM tbl_county WHERE LOWER(name) = LOWER(county_name);
        SELECT id INTO subcounty FROM tbl_subcounty WHERE county_id = county LIMIT 1;
        INSERT INTO tbl_facility(name, mflcode, subcounty_id) VALUES(facility_name, facility_code, subcounty);
    END IF;
END;;

DROP PROCEDURE IF EXISTS `proc_save_facility_dhis`;;
CREATE  PROCEDURE `proc_save_facility_dhis`(
    IN f_code VARCHAR(20),
    IN f_name VARCHAR(150), 
    IN f_category VARCHAR(20),
    IN f_dhiscode VARCHAR(50),
    IN f_longitude VARCHAR(200),
    IN f_latitude VARCHAR(200),
    IN f_parent_mfl VARCHAR(20)
    )
BEGIN
    DECLARE parent INT DEFAULT NULL;
    SET f_name = LOWER(f_name);

    SELECT id INTO parent FROM tbl_facility WHERE mflcode = f_parent_mfl;

    IF NOT EXISTS(SELECT * FROM tbl_facility WHERE mflcode = f_code) THEN
        INSERT INTO tbl_facility(name, mflcode, category, dhiscode, longitude, latitude, parent_id) VALUES(f_name, f_code, f_category, f_dhiscode, f_longitude, f_latitude, parent);
    ELSE
        UPDATE tbl_facility SET dhiscode = f_dhiscode, longitude = f_longitude, latitude = f_latitude, parent_id = parent WHERE mflcode = f_code; 
    END IF;
END;;

DROP PROCEDURE IF EXISTS `proc_save_kemsa`;;
CREATE  PROCEDURE `proc_save_kemsa`(
    IN drug_name VARCHAR(255), 
    IN packsize VARCHAR(20),
    IN p_year INT(4),
    IN p_month VARCHAR(3),
    IN issue INT(11),
    IN soh INT(11),
    IN supplier INT(11),
    IN received INT(11)
    )
BEGIN
    DECLARE drug INT DEFAULT NULL;
    SET drug_name = REPLACE(drug_name, "'", "");

    SELECT id INTO drug FROM vw_drug_list WHERE UPPER(name) = UPPER(drug_name) AND UPPER(pack_size) = UPPER(packsize);

    IF NOT EXISTS(SELECT * FROM tbl_kemsa WHERE period_year = p_year AND period_month = p_month AND drug_id = drug) THEN
        INSERT INTO tbl_kemsa(issue_total, soh_total, supplier_total, received_total, period_year, period_month, drug_id) VALUES(issue, soh, supplier, received, p_year, p_month, drug);
    ELSE
        UPDATE tbl_kemsa SET issue_total = issue, soh_total = soh, supplier_total = supplier, received_total = received WHERE period_year = p_year AND period_month = p_month AND drug_id = drug; 
    END IF;
END;;

DROP PROCEDURE IF EXISTS `proc_save_maps`;;
CREATE  PROCEDURE `proc_save_maps`(
	IN ordcode VARCHAR(15)
	)
BEGIN
	IF (ordcode = 'F-MAPS') THEN
		
		UPDATE tbl_order o INNER JOIN tbl_facility f ON f.dhiscode = o.facility SET o.facility = f.id;

		
		UPDATE tbl_order o SET o.period = STR_TO_DATE(CONCAT_WS('-', o.period,'01'),'%Y%m-%e');

		
		DELETE FROM tbl_order WHERE (facility, period) IN (SELECT m.facility_id, m.period_begin FROM tbl_maps m WHERE m.code = ordcode AND m.status IN ('rejected', 'allocated', 'approved', 'reviewed'));
		
		
		REPLACE INTO tbl_maps(status, created, updated, code, period_begin, period_end, facility_id) SELECT 'pending' status, NOW() created, NOW() updated, ordcode code, o.period period_begin, LAST_DAY(o.period) period_end, o.facility facility_id FROM tbl_order o INNER JOIN tbl_facility f ON f.id = o.facility GROUP BY o.facility, o.period;

		
		UPDATE tbl_order o INNER JOIN tbl_maps m ON m.facility_id = o.facility AND o.period = m.period_begin AND m.code = ordcode SET o.report_id = m.id;

		
		REPLACE INTO tbl_maps_log(description, created, user_id, maps_id) SELECT 'pending' status, NOW() created, '1' user_id, o.report_id maps_id FROM tbl_order o INNER JOIN tbl_facility f ON f.id = o.facility GROUP BY o.facility, o.period;

		
		UPDATE tbl_order o INNER JOIN tbl_dhis_elements de ON de.dhis_code = o.dimension SET o.dimension = de.target_id;
    ELSE
    	
		ALTER TABLE tbl_order DROP INDEX facility_period_dimension_category;

		
		UPDATE tbl_order o INNER JOIN tbl_facility f ON f.dhiscode = o.facility SET o.facility = f.parent_id;

		
		INSERT INTO tbl_order(facility, period, dimension, category, value) SELECT o.facility, o.period, o.dimension, 'aggr_total' category, SUM(o.value) value FROM tbl_order o WHERE category = 'total' GROUP BY o.facility, o.period, o.dimension;

		
		DELETE FROM tbl_order WHERE category IN ('total');

		
		ALTER TABLE tbl_order ADD UNIQUE facility_period_dimension_category (facility, period, dimension, category);

		
		UPDATE tbl_order SET category = 'total' WHERE category = 'aggr_total';

		
		UPDATE tbl_order o SET o.period = STR_TO_DATE(CONCAT_WS('-', o.period,'01'),'%Y%m-%e');

		
		DELETE FROM tbl_order WHERE (facility, period) IN (SELECT m.facility_id, m.period_begin FROM tbl_maps m WHERE m.code = ordcode AND m.status IN ('rejected', 'allocated', 'approved', 'reviewed'));

		
		REPLACE INTO tbl_maps(status, created, updated, code, period_begin, period_end, facility_id) SELECT 'pending' status, NOW() created, NOW() updated, ordcode code, o.period period_begin, LAST_DAY(o.period) period_end, o.facility facility_id FROM tbl_order o INNER JOIN tbl_facility f ON f.id = o.facility GROUP BY o.facility, o.period;

		
		UPDATE tbl_order o INNER JOIN tbl_maps m ON m.facility_id = o.facility AND o.period = m.period_begin AND m.code = ordcode SET o.report_id = m.id;

		
		REPLACE INTO tbl_maps_log(description, created, user_id, maps_id) SELECT 'pending' status, NOW() created, '1' user_id, o.report_id maps_id FROM tbl_order o INNER JOIN tbl_facility f ON f.id = o.facility GROUP BY o.facility, o.period;

		
		UPDATE tbl_order o INNER JOIN tbl_dhis_elements de ON de.dhis_code = o.dimension SET o.dimension = de.target_id;

    END IF;
END;;

DROP PROCEDURE IF EXISTS `proc_save_maps_item`;;
CREATE  PROCEDURE `proc_save_maps_item`()
BEGIN
	DECLARE bDone INT;
	DECLARE k VARCHAR(255);
	DECLARE v VARCHAR(255);

	
	DECLARE curs CURSOR FOR  SELECT CONCAT_WS(',', GROUP_CONCAT(o.category SEPARATOR ','), 'maps_id', 'regimen_id'), CONCAT_WS(',', GROUP_CONCAT(o.value SEPARATOR ','), report_id, dimension) FROM tbl_order o INNER JOIN tbl_facility f ON f.id = o.facility GROUP BY o.report_id, o.dimension;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = 1;

	OPEN curs;

	SET bDone = 0;
	REPEAT
		FETCH curs INTO k,v;

		SET @sqlv=CONCAT('REPLACE INTO tbl_maps_item (', k, ') VALUES (', v, ')');
		PREPARE stmt FROM @sqlv;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	UNTIL bDone END REPEAT;

	CLOSE curs;

	TRUNCATE tbl_order;
END;;

DROP PROCEDURE IF EXISTS `proc_save_patient`;;
CREATE  PROCEDURE `proc_save_patient`(
    IN facility_code VARCHAR(20), 
    IN regimen_code VARCHAR(6),
    IN patient_total INT(11),
    IN p_month VARCHAR(3),
    IN p_year INT(4)
    )
BEGIN
    DECLARE facility,regimen INT DEFAULT NULL;
    SET facility_code = REPLACE(facility_code, "'", "");
    SET regimen_code = REPLACE(regimen_code, "'", "");

    SELECT id INTO facility FROM tbl_facility WHERE UPPER(mflcode) = UPPER(facility_code);
    SELECT id INTO regimen FROM tbl_regimen WHERE UPPER(code) = UPPER(regimen_code);

    IF NOT EXISTS(SELECT * FROM tbl_patient WHERE period_year = p_year AND period_month = p_month AND regimen_id = regimen AND facility_id = facility) THEN
        INSERT INTO tbl_patient(total, period_year, period_month, regimen_id, facility_id) VALUES(patient_total, p_year, p_month, regimen, facility);
    ELSE
        UPDATE tbl_patient SET total = patient_total WHERE period_year = p_year AND period_month = p_month AND regimen_id = regimen AND facility_id = facility;
    END IF;
END;;

DROP PROCEDURE IF EXISTS `proc_save_stock`;;
CREATE  PROCEDURE `proc_save_stock`(
    IN facility_code VARCHAR(20),
    IN drug_name VARCHAR(255), 
    IN packsize VARCHAR(20),
    IN p_year INT(4),
    IN p_month VARCHAR(3),
    IN soh_total INT(11)
    )
BEGIN
    DECLARE facility,drug INT DEFAULT NULL;
    SET facility_code = REPLACE(facility_code, "'", "");
    SET drug_name = REPLACE(drug_name, "'", "");

    SELECT id INTO facility FROM tbl_facility WHERE UPPER(mflcode) = UPPER(facility_code);
    SELECT id INTO drug FROM vw_drug_list WHERE UPPER(name) = UPPER(drug_name) AND UPPER(pack_size) = UPPER(packsize);

    IF NOT EXISTS(SELECT * FROM tbl_stock WHERE period_year = p_year AND period_month = p_month AND facility_id = facility AND drug_id = drug) THEN
        INSERT INTO tbl_stock(total, period_year, period_month, facility_id, drug_id) VALUES(soh_total, p_year, p_month, facility, drug);
    ELSE
        UPDATE tbl_stock SET total = soh_total WHERE period_year = p_year AND period_month = p_month AND facility_id = facility AND drug_id = drug; 
    END IF;
END;;

DROP PROCEDURE IF EXISTS `proc_save_tracker`;;
CREATE PROCEDURE `proc_save_tracker`(IN `p_year` int(4), IN `p_month` varchar(3), IN `p_drug` int(11), IN `p_qty` int(11), IN `p_fund` int(11), IN `p_supply` int(11), IN `p_status` int(11), IN `p_user` int(11), IN `p_comments` longtext)
BEGIN
    DECLARE p_id INT DEFAULT NULL;
    DECLARE open_bal,close_bal INT DEFAULT 0;
    DECLARE log_msg VARCHAR(255) DEFAULT 'updated';

    IF NOT EXISTS(SELECT * FROM tbl_procurement WHERE transaction_year = p_year AND transaction_month = p_month AND drug_id = p_drug) THEN
        SET close_bal = (open_bal + p_qty);
        INSERT INTO tbl_procurement(open_kemsa, transaction_year, transaction_month, drug_id, close_kemsa) VALUES(open_bal, p_year, p_month, p_drug, close_bal);
        SET log_msg = 'created';
    END IF;

    SELECT id INTO p_id FROM tbl_procurement WHERE transaction_year = p_year AND transaction_month = p_month AND drug_id = p_drug;

    REPLACE INTO tbl_procurement_item(quantity, funding_agent_id, supplier_id, procurement_status_id, procurement_id,comments) VALUES(p_qty, p_fund, p_supply, p_status, p_id,p_comments);
    REPLACE INTO tbl_procurement_log(description, created, user_id, procurement_id) VALUES(log_msg, NOW(), p_user, p_id);

END;;

DROP PROCEDURE IF EXISTS `proc_save_tracker_history`;;
CREATE PROCEDURE `proc_save_tracker_history`(IN `p_year` int(4), IN `p_month` varchar(3), IN `p_drug` int(11), IN `p_qty` int(11), IN `p_fund` int(11), IN `p_supply` int(11), IN `p_status` int(11), IN `p_user` int(11), IN `p_comments` longtext, IN `p_drug_id` int)
BEGIN
    DECLARE p_id INT DEFAULT NULL;
    DECLARE open_bal,close_bal INT DEFAULT 0;
    DECLARE log_msg VARCHAR(255) DEFAULT 'updated';

    IF NOT EXISTS(SELECT * FROM tbl_procurement WHERE transaction_year = p_year AND transaction_month = p_month AND drug_id = p_drug) THEN
        SET close_bal = (open_bal + p_qty);
        INSERT INTO tbl_procurement(open_kemsa, transaction_year, transaction_month, drug_id, close_kemsa) VALUES(open_bal, p_year, p_month, p_drug, close_bal);
        SET log_msg = 'created';
    END IF;

    SELECT id INTO p_id FROM tbl_procurement WHERE transaction_year = p_year AND transaction_month = p_month AND drug_id = p_drug;

    REPLACE INTO tbl_procurement_history(year,month,quantity, funding_agent_id, supplier_id, procurement_status_id, procurement_id,comments,drug_id) VALUES(p_year,p_month,p_qty, p_fund, p_supply, p_status, p_id,p_comments,p_drug_id);
    REPLACE INTO tbl_procurement_log(description, created, user_id, procurement_id) VALUES(log_msg, NOW(), p_user, p_id);

END;;

DROP PROCEDURE IF EXISTS `proc_update_central_cdrr`;;
CREATE  PROCEDURE `proc_update_central_cdrr`()
BEGIN
    REPLACE INTO tbl_cdrr_item (balance, received, dispensed_packs, losses, adjustments, adjustments_neg, count, expiry_quant, expiry_date, out_of_stock, resupply, aggr_consumed, aggr_on_hand, cdrr_id, drug_id, qty_allocated, feedback)
	SELECT ci.balance, ci.received, ci.dispensed_packs, ci.losses, ci.adjustments, ci.adjustments_neg, ci.count, ci.expiry_quant, ci.expiry_date, ci.out_of_stock, ci.resupply, t.aggr_consumed, t.aggr_on_hand, t.cdrr_id, t.drug_id, ci.qty_allocated, ci.feedback
	FROM tbl_cdrr_item ci 
	INNER JOIN tbl_cdrr c ON c.id = ci.cdrr_id
	RIGHT JOIN (
		SELECT
			dc.id cdrr_id,			
			f.parent_id facility_id,
			c.period_begin, 
			c.period_end, 
			ci.drug_id,
			SUM(ci.dispensed_packs) aggr_consumed,
			SUM(ci.count) aggr_on_hand
		FROM tbl_cdrr_item ci
		INNER JOIN tbl_cdrr c ON c.id = ci.cdrr_id
		INNER JOIN tbl_facility f ON f.id = c.facility_id
		INNER JOIN tbl_cdrr dc ON dc.facility_id = f.parent_id AND dc.period_begin = c.period_begin AND dc.period_end = c.period_end AND dc.code = 'D-CDRR'
		WHERE c.code = 'F-CDRR'
		AND (c.period_begin, c.period_end, f.parent_id) IN (
			SELECT c.period_begin, c.period_end, c.facility_id 
			FROM tbl_cdrr c
			WHERE c.code = 'D-CDRR'
			GROUP BY c.period_begin, c.period_end, c.facility_id
		)
		GROUP BY f.parent_id, c.period_begin, c.period_end, ci.drug_id
		ORDER BY f.parent_id, c.period_begin, c.period_end, ci.drug_id
	) t ON t.facility_id = c.facility_id AND t.period_begin = c.period_begin AND t.period_end = c.period_end AND c.code = 'D-CDRR' AND ci.drug_id = t.drug_id
	GROUP BY t.cdrr_id, t.drug_id
	ORDER BY t.cdrr_id, t.drug_id;
END;;

DROP PROCEDURE IF EXISTS `proc_update_central_maps`;;
CREATE  PROCEDURE `proc_update_central_maps`()
BEGIN
    REPLACE INTO tbl_maps_item (total, maps_id, regimen_id)
	SELECT t.total, m.id, t.regimen_id
	FROM tbl_maps_item mi 
	INNER JOIN tbl_maps m ON m.id = mi.maps_id
	RIGHT JOIN (
		SELECT
			f.parent_id facility_id,
			m.period_begin, 
			m.period_end, 
			mi.regimen_id,
			SUM(mi.total) total
		FROM tbl_maps_item mi
		INNER JOIN tbl_maps m ON m.id = mi.maps_id
		INNER JOIN tbl_facility f ON f.id = m.facility_id
		WHERE m.code = 'F-MAPS'
		AND (m.period_begin, m.period_end, f.parent_id) IN (
			SELECT m.period_begin, m.period_end, m.facility_id 
			FROM tbl_maps m
			WHERE m.code = 'D-MAPS'
			GROUP BY m.period_begin, m.period_end, m.facility_id
		)
		GROUP BY f.parent_id, m.period_begin, m.period_end, mi.regimen_id
		ORDER BY f.parent_id, m.period_begin, m.period_end, mi.regimen_id
	) t ON t.facility_id = m.facility_id AND t.period_begin = m.period_begin AND t.period_end = m.period_end AND m.code = 'D-MAPS'
	GROUP BY t.total, m.id, t.regimen_id
	ORDER BY m.id, t.regimen_id;
END;;

DROP PROCEDURE IF EXISTS `proc_update_dhis`;;
CREATE  PROCEDURE `proc_update_dhis`(
    IN f_code VARCHAR(20),
    IN f_name VARCHAR(150), 
    IN f_category VARCHAR(20),
    IN f_dhiscode VARCHAR(50),
    IN f_longitude VARCHAR(200),
    IN f_latitude VARCHAR(200),
    IN f_parent_mfl VARCHAR(20)
    )
BEGIN
    DECLARE parent INT DEFAULT NULL;
    SET f_name = LOWER(f_name);

    SELECT id INTO parent FROM tbl_facility WHERE mflcode = f_parent_mfl;

    IF NOT EXISTS(SELECT * FROM tbl_facility WHERE mflcode = f_code) THEN
        INSERT INTO tbl_facility(name, mflcode, category, dhiscode, longitude, latitude, parent_id) VALUES(f_name, f_code, f_category, f_dhiscode, f_longitude, f_latitude, parent);
    ELSE
        UPDATE tbl_facility SET category = f_category, dhiscode = f_dhiscode, longitude = f_longitude, latitude = f_latitude, parent_id = parent WHERE mflcode = f_code; 
    END IF;
END;;

DROP PROCEDURE IF EXISTS `proc_update_dsh_adt`;;
CREATE  PROCEDURE `proc_update_dsh_adt`()
BEGIN
    
    UPDATE dsh_patient_adt p INNER JOIN vw_regimen_list r ON p.start_regimen LIKE CONCAT(r.code, '%') SET p.start_regimen = r.name;
    
    UPDATE dsh_patient_adt p INNER JOIN vw_regimen_list r ON p.current_regimen LIKE CONCAT(r.code, '%') SET p.current_regimen = r.name;
    
    UPDATE dsh_patient_adt p INNER JOIN vw_regimen_list r ON p.current_regimen = r.name SET p.service = r.service;
    
    UPDATE dsh_patient_adt p SET p.service = 'OI Only' WHERE p.current_regimen LIKE '%OI%';
    
    UPDATE dsh_patient_adt p INNER JOIN tbl_status st ON st.name LIKE CONCAT('%', p.status, '%') SET p.status = st.name;
    
    UPDATE dsh_patient_adt p SET p.status = 'LOST TO FOLLOW-UP' WHERE DATEDIFF(CURDATE(), p.pharmacy_appointment_date) >= 90 AND p.status IS NULL;
    
    UPDATE dsh_patient_adt p SET p.status = 'ACTIVE' WHERE DATEDIFF(CURDATE(), p.pharmacy_appointment_date) < 90 AND p.status IS NULL;
    
    UPDATE dsh_patient_adt p SET p.enrollment_date = p.start_regimen_date WHERE p.enrollment_date = '0000-00-00';
    
    UPDATE dsh_patient_adt p SET p.start_regimen_date= p.enrollment_date WHERE p.start_regimen_date = '0000-00-00';
    
    UPDATE dsh_patient_adt p SET p.status_change_date= p.start_regimen_date WHERE p.status_change_date = '0000-00-00';
    
    UPDATE dsh_visit_adt v INNER JOIN dsh_patient_adt p ON CONCAT_WS('_', p.ccc_number, p.facility) = v.patient_adt_id SET v.patient_adt_id = p.id;
    
    UPDATE dsh_visit_adt v INNER JOIN vw_regimen_list r ON v.last_regimen LIKE CONCAT(r.code, '%') SET v.last_regimen = r.name;
    
    UPDATE dsh_visit_adt v INNER JOIN vw_regimen_list r ON v.current_regimen LIKE CONCAT(r.code, '%') SET v.current_regimen = r.name;
    
    UPDATE dsh_visit_adt v INNER JOIN tbl_purpose p ON p.name LIKE CONCAT('%', v.purpose, '%') SET v.purpose = p.name;
    
    UPDATE dsh_visit_adt v INNER JOIN tbl_change_reason cr ON cr.name LIKE CONCAT('%', v.regimen_change_reason, '%') SET v.regimen_change_reason = cr.name;
    
    UPDATE dsh_visit_adt v INNER JOIN tbl_generic g ON g.name LIKE CONCAT(SUBSTRING_INDEX(SUBSTRING_INDEX(v.drug, ' ', 1), ' ', -1), '%') OR abbreviation LIKE CONCAT(SUBSTRING_INDEX(SUBSTRING_INDEX(v.drug, ' ', 1), ' ', -1), '%') OR CONCAT(name, CONCAT('(', abbreviation, ')')) LIKE CONCAT(SUBSTRING_INDEX(SUBSTRING_INDEX(v.drug, ' ', 1), ' ', -1), '%') INNER JOIN tbl_drug d ON d.generic_id = g.id AND d.packsize = v.pack_size AND v.drug LIKE CONCAT('%', d.strength, '%' ) INNER JOIN vw_drug_list dl ON dl.id = d.id SET v.drug = dl.name;
END;;

DELIMITER ;

DROP TABLE IF EXISTS `dsh_consumption`;
CREATE TABLE `dsh_consumption` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `total` decimal(10,0) NOT NULL,
  `allocated` decimal(10,0) NOT NULL,
  `data_year` int(4) NOT NULL,
  `data_month` varchar(3) NOT NULL,
  `data_date` date NOT NULL,
  `sub_county` varchar(255) NOT NULL,
  `county` varchar(255) NOT NULL,
  `facility` varchar(255) NOT NULL,
  `drug` varchar(255) NOT NULL,
  `partner` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `data_year_data_month_facility_drug` (`data_year`,`data_month`,`facility`,`drug`),
  KEY `data_year` (`data_year`),
  KEY `data_month` (`data_month`),
  KEY `sub_county` (`sub_county`),
  KEY `county` (`county`),
  KEY `facility` (`facility`),
  KEY `drug` (`drug`),
  KEY `data_date` (`data_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `dsh_mos`;
CREATE TABLE `dsh_mos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `facility_mos` decimal(10,1) NOT NULL,
  `cms_mos` decimal(10,1) NOT NULL,
  `supplier_mos` decimal(10,1) NOT NULL,
  `data_year` int(4) NOT NULL,
  `data_month` varchar(3) NOT NULL,
  `data_date` date NOT NULL,
  `drug` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `data_year_data_month_drug` (`data_year`,`data_month`,`drug`),
  KEY `data_year` (`data_year`),
  KEY `data_month` (`data_month`),
  KEY `drug` (`drug`),
  KEY `data_date` (`data_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `dsh_order`;
CREATE TABLE `dsh_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_year` int(4) NOT NULL,
  `data_month` varchar(3) NOT NULL,
  `data_date` date NOT NULL,
  `sub_county` varchar(255) NOT NULL,
  `county` varchar(255) NOT NULL,
  `facility` varchar(255) NOT NULL,
  `facility_category` varchar(50) NOT NULL,
  `partner` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `data_year_data_month_facility_facility_category` (`data_year`,`data_month`,`facility`,`facility_category`),
  KEY `data_year` (`data_year`),
  KEY `data_month` (`data_month`),
  KEY `data_date` (`data_date`),
  KEY `sub_county` (`sub_county`),
  KEY `county` (`county`),
  KEY `facility` (`facility`),
  KEY `facility_category` (`facility_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `dsh_order_item`;
CREATE TABLE `dsh_order_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `opening_bal_qty` decimal(10,0) NOT NULL,
  `received_qty` decimal(10,0) NOT NULL,
  `consumed_qty` decimal(10,0) NOT NULL,
  `losses_qty` decimal(10,0) NOT NULL,
  `adjustment_qty` decimal(10,0) NOT NULL,
  `closing_bal_qty` decimal(10,0) NOT NULL,
  `data_year` int(4) NOT NULL,
  `data_month` varchar(3) NOT NULL,
  `data_date` date NOT NULL,
  `sub_county` varchar(255) NOT NULL,
  `county` varchar(255) NOT NULL,
  `facility` varchar(255) NOT NULL,
  `facility_category` varchar(50) NOT NULL,
  `drug` varchar(255) NOT NULL,
  `partner` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `data_year_data_month_facility_facility_category_drug` (`data_year`,`data_month`,`facility`,`facility_category`,`drug`),
  KEY `data_year` (`data_year`),
  KEY `data_month` (`data_month`),
  KEY `data_date` (`data_date`),
  KEY `sub_county` (`sub_county`),
  KEY `county` (`county`),
  KEY `facility` (`facility`),
  KEY `facility_category` (`facility_category`),
  KEY `drug` (`drug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `dsh_patient`;
CREATE TABLE `dsh_patient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `total` decimal(10,0) NOT NULL,
  `data_year` int(4) NOT NULL,
  `data_month` varchar(3) NOT NULL,
  `data_date` date NOT NULL,
  `sub_county` varchar(255) NOT NULL,
  `county` varchar(255) NOT NULL,
  `facility` varchar(255) NOT NULL,
  `partner` varchar(255) NOT NULL,
  `regimen` varchar(255) NOT NULL,
  `age_category` varchar(255) NOT NULL,
  `regimen_service` varchar(255) NOT NULL,
  `regimen_line` varchar(255) NOT NULL,
  `nnrti_drug` varchar(255) NOT NULL,
  `nrti_drug` varchar(255) NOT NULL,
  `regimen_category` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `data_year_data_month_facility_regimen` (`data_year`,`data_month`,`facility`,`regimen`),
  KEY `data_year` (`data_year`),
  KEY `data_month` (`data_month`),
  KEY `sub_county` (`sub_county`),
  KEY `county` (`county`),
  KEY `facility` (`facility`),
  KEY `regimen` (`regimen`),
  KEY `age_category` (`age_category`),
  KEY `regimen_service` (`regimen_service`),
  KEY `nnrti_drug` (`nnrti_drug`),
  KEY `nrti_drug` (`nrti_drug`),
  KEY `regimen_category` (`regimen_category`),
  KEY `data_date` (`data_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `dsh_patient_adt`;
CREATE TABLE `dsh_patient_adt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ccc_number` varchar(100) NOT NULL,
  `birth_date` date DEFAULT NULL,
  `place_of_birth` varchar(255) DEFAULT NULL,
  `gender` enum('male','female') DEFAULT NULL,
  `is_pregnant` tinyint(1) NOT NULL DEFAULT '0',
  `is_breastfeeding` tinyint(1) NOT NULL DEFAULT '0',
  `parent_ccc_number` varchar(100) DEFAULT NULL,
  `start_height` int(3) NOT NULL DEFAULT '0',
  `start_weight` int(3) NOT NULL DEFAULT '0',
  `start_bsa` decimal(10,4) DEFAULT '0.0000',
  `start_bmi` decimal(10,4) DEFAULT '0.0000',
  `current_height` int(3) NOT NULL DEFAULT '0',
  `current_weight` int(3) NOT NULL DEFAULT '0',
  `current_bsa` decimal(10,4) DEFAULT '0.0000',
  `current_bmi` decimal(10,4) DEFAULT '0.0000',
  `partner_status` varchar(255) DEFAULT NULL,
  `is_disclosure` tinyint(1) DEFAULT NULL,
  `partner_ccc_number` varchar(100) DEFAULT NULL,
  `is_smoke` tinyint(1) NOT NULL DEFAULT '0',
  `is_alcohol` tinyint(1) NOT NULL DEFAULT '0',
  `is_tb_tested` tinyint(1) NOT NULL DEFAULT '0',
  `is_tb` tinyint(1) NOT NULL DEFAULT '0',
  `tb_category` varchar(20) DEFAULT NULL,
  `tb_phase` varchar(20) DEFAULT NULL,
  `tb_start_date` date DEFAULT NULL,
  `tb_end_date` date DEFAULT NULL,
  `enrollment_date` date DEFAULT NULL,
  `start_regimen_date` date DEFAULT NULL,
  `status_change_date` date DEFAULT NULL,
  `facility` varchar(255) NOT NULL,
  `start_regimen` varchar(255) DEFAULT NULL,
  `current_regimen` varchar(255) DEFAULT NULL,
  `service` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `transfer_from` varchar(255) DEFAULT NULL,
  `who_stage` tinyint(1) DEFAULT NULL,
  `is_cotrimoxazole` tinyint(1) DEFAULT '0',
  `is_dapsone` tinyint(1) DEFAULT '0',
  `is_fluconazole` tinyint(1) DEFAULT '0',
  `is_isoniazid` tinyint(1) DEFAULT '0',
  `isoniazid_start_date` date DEFAULT NULL,
  `isoniazid_end_date` date DEFAULT NULL,
  `sms_consent` tinyint(1) DEFAULT NULL,
  `prep_reason` varchar(255) DEFAULT NULL,
  `is_prep_tested` tinyint(1) DEFAULT NULL,
  `prep_test_date` date DEFAULT NULL,
  `prep_test_result` tinyint(1) DEFAULT NULL,
  `pep_reason` varchar(255) DEFAULT NULL,
  `is_differentiated_care` tinyint(1) DEFAULT NULL,
  `pharmacy_appointment_date` date DEFAULT NULL,
  `clinical_appointment_date` date DEFAULT NULL,
  `last_viral_test_date` date DEFAULT NULL,
  `last_viral_test_result` varchar(255) DEFAULT NULL,
  `last_viral_test_justification` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ccc_number_facility` (`ccc_number`,`facility`),
  KEY `ccc_number` (`ccc_number`),
  KEY `birth_date` (`birth_date`),
  KEY `gender` (`gender`),
  KEY `start_weight` (`start_weight`),
  KEY `current_weight` (`current_weight`),
  KEY `place_of_birth` (`place_of_birth`),
  KEY `parent_ccc_number` (`parent_ccc_number`),
  KEY `start_height` (`start_height`),
  KEY `start_bsa` (`start_bsa`),
  KEY `start_bmi` (`start_bmi`),
  KEY `current_height` (`current_height`),
  KEY `current_bsa` (`current_bsa`),
  KEY `current_bmi` (`current_bmi`),
  KEY `partner_status` (`partner_status`),
  KEY `partner_ccc_number` (`partner_ccc_number`),
  KEY `tb_category` (`tb_category`),
  KEY `tb_phase` (`tb_phase`),
  KEY `tb_start_date` (`tb_start_date`),
  KEY `tb_end_date` (`tb_end_date`),
  KEY `enrollment_date` (`enrollment_date`),
  KEY `start_regimen_date` (`start_regimen_date`),
  KEY `status_change_date` (`status_change_date`),
  KEY `facility` (`facility`),
  KEY `start_regimen` (`start_regimen`),
  KEY `current_regimen` (`current_regimen`),
  KEY `service` (`service`),
  KEY `status` (`status`),
  KEY `source` (`source`),
  KEY `transfer_from` (`transfer_from`),
  KEY `who_stage` (`who_stage`),
  KEY `prophylaxis` (`is_cotrimoxazole`),
  KEY `isoniazid_start_date` (`isoniazid_start_date`),
  KEY `isoniazid_end_date` (`isoniazid_end_date`),
  KEY `sms_consent` (`sms_consent`),
  KEY `prep_reason` (`prep_reason`),
  KEY `is_prep_tested` (`is_prep_tested`),
  KEY `prep_test_date` (`prep_test_date`),
  KEY `prep_test_result` (`prep_test_result`),
  KEY `pep_reason` (`pep_reason`),
  KEY `pharmacy_appointment_date` (`pharmacy_appointment_date`),
  KEY `clinical_appointment_date` (`clinical_appointment_date`),
  KEY `last_viral_test_date` (`last_viral_test_date`),
  KEY `last_viral_test_result` (`last_viral_test_result`),
  KEY `last_viral_test_justification` (`last_viral_test_justification`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `dsh_stock`;
CREATE TABLE `dsh_stock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `total` decimal(10,0) NOT NULL,
  `amc_total` decimal(10,0) NOT NULL,
  `data_year` int(4) NOT NULL,
  `data_month` varchar(3) NOT NULL,
  `data_date` date NOT NULL,
  `sub_county` varchar(255) NOT NULL,
  `county` varchar(255) NOT NULL,
  `facility` varchar(255) NOT NULL,
  `drug` varchar(255) NOT NULL,
  `partner` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `data_year_data_month_facility_drug` (`data_year`,`data_month`,`facility`,`drug`),
  KEY `data_year` (`data_year`),
  KEY `data_month` (`data_month`),
  KEY `data_date` (`data_date`),
  KEY `sub_county` (`sub_county`),
  KEY `county` (`county`),
  KEY `facility` (`facility`),
  KEY `drug` (`drug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `dsh_visit_adt`;
CREATE TABLE `dsh_visit_adt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `current_height` int(3) NOT NULL DEFAULT '0',
  `current_weight` int(3) NOT NULL DEFAULT '0',
  `current_bsa` decimal(10,4) DEFAULT '0.0000',
  `current_bmi` decimal(10,4) DEFAULT '0.0000',
  `purpose` varchar(255) DEFAULT NULL,
  `last_regimen` varchar(255) DEFAULT NULL,
  `current_regimen` varchar(255) DEFAULT NULL,
  `regimen_change_reason` varchar(255) DEFAULT NULL,
  `dispensing_date` date NOT NULL,
  `appointment_date` date DEFAULT NULL,
  `appointment_adherence` decimal(5,2) NOT NULL DEFAULT '0.00',
  `non_adherence_reason` varchar(255) DEFAULT NULL,
  `drug` varchar(255) DEFAULT NULL,
  `pack_size` varchar(10) DEFAULT NULL,
  `dose` varchar(20) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT '0',
  `duration` int(11) NOT NULL DEFAULT '0',
  `pill_count_adherence` decimal(5,2) NOT NULL DEFAULT '0.00',
  `self_reporting_adherence` decimal(5,2) NOT NULL DEFAULT '0.00',
  `indication` varchar(255) DEFAULT NULL,
  `patient_adt_id` varchar(255) NOT NULL,
  `patient_adt` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `patient_adt_id_dispensing_date_drug` (`patient_adt_id`,`dispensing_date`,`drug`),
  KEY `current_height` (`current_height`),
  KEY `current_weight` (`current_weight`),
  KEY `current_bsa` (`current_bsa`),
  KEY `current_bmi` (`current_bmi`),
  KEY `purpose` (`purpose`),
  KEY `last_regimen` (`last_regimen`),
  KEY `current_regimen` (`current_regimen`),
  KEY `regimen_change_reason` (`regimen_change_reason`),
  KEY `dispensing_date` (`dispensing_date`),
  KEY `appointment_date` (`appointment_date`),
  KEY `appointment_adherence` (`appointment_adherence`),
  KEY `non_adherence_reason` (`non_adherence_reason`),
  KEY `drug` (`drug`),
  KEY `packsize` (`pack_size`),
  KEY `dose` (`dose`),
  KEY `quantity` (`quantity`),
  KEY `duration` (`duration`),
  KEY `pill_count_adherence` (`pill_count_adherence`),
  KEY `self_reporting_adherence` (`self_reporting_adherence`),
  KEY `indication` (`indication`),
  KEY `patient_adt_id` (`patient_adt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_backup`;
CREATE TABLE `tbl_backup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` varchar(150) NOT NULL,
  `foldername` varchar(50) NOT NULL,
  `adt_version` varchar(20) NOT NULL,
  `run_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `facility_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `filename` (`filename`),
  KEY `facility_id` (`facility_id`),
  CONSTRAINT `tbl_backup_ibfk_1` FOREIGN KEY (`facility_id`) REFERENCES `tbl_facility` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_category`;
CREATE TABLE `tbl_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_cdrr`;
CREATE TABLE `tbl_cdrr` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `status` varchar(20) NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  `code` varchar(15) DEFAULT NULL,
  `period_begin` date DEFAULT NULL,
  `period_end` date DEFAULT NULL,
  `comments` text,
  `reports_expected` int(11) DEFAULT NULL,
  `reports_actual` int(11) DEFAULT NULL,
  `services` varchar(255) DEFAULT NULL,
  `sponsors` varchar(255) DEFAULT NULL,
  `non_arv` int(11) NOT NULL,
  `delivery_note` varchar(255) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `facility_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_period_begin_period_end_facility_id` (`code`,`period_begin`,`period_end`,`facility_id`),
  KEY `period_begin` (`period_begin`),
  KEY `period_end` (`period_end`),
  KEY `code` (`code`),
  KEY `status` (`status`),
  KEY `facility_id` (`facility_id`),
  CONSTRAINT `tbl_cdrr_ibfk_1` FOREIGN KEY (`facility_id`) REFERENCES `tbl_facility` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `tbl_cdrr_item`;
CREATE TABLE `tbl_cdrr_item` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `balance` int(11) DEFAULT NULL,
  `received` int(11) DEFAULT NULL,
  `dispensed_units` int(11) DEFAULT NULL,
  `dispensed_packs` int(11) DEFAULT NULL,
  `losses` int(11) DEFAULT NULL,
  `adjustments` int(11) DEFAULT NULL,
  `adjustments_neg` int(11) DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  `expiry_quant` int(11) DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `out_of_stock` int(11) DEFAULT NULL,
  `resupply` int(11) DEFAULT NULL,
  `aggr_consumed` int(11) DEFAULT NULL,
  `aggr_on_hand` int(11) DEFAULT NULL,
  `publish` tinyint(1) NOT NULL DEFAULT '0',
  `cdrr_id` int(11) unsigned NOT NULL,
  `drug_id` int(11) NOT NULL,
  `qty_allocated` int(11) unsigned DEFAULT NULL,
  `feedback` text,
  `qty_allocate_mos` int(11) DEFAULT NULL,
  `qty_allocated_mos` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `drug_id_cdrr_id` (`drug_id`,`cdrr_id`),
  KEY `cdrr_id` (`cdrr_id`),
  KEY `drug_id` (`drug_id`),
  CONSTRAINT `tbl_cdrr_item_ibfk_1` FOREIGN KEY (`cdrr_id`) REFERENCES `tbl_cdrr` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_cdrr_item_ibfk_2` FOREIGN KEY (`drug_id`) REFERENCES `tbl_drug` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `tbl_cdrr_log`;
CREATE TABLE `tbl_cdrr_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  `cdrr_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_user_id_cdrr_id` (`description`,`user_id`,`cdrr_id`),
  KEY `cdrr_id` (`cdrr_id`),
  KEY `description` (`description`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `tbl_cdrr_log_ibfk_1` FOREIGN KEY (`cdrr_id`) REFERENCES `tbl_cdrr` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_cdrr_log_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `tbl_cdrr_log_temp`;
CREATE TABLE `tbl_cdrr_log_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(15) NOT NULL,
  `period_begin` date NOT NULL,
  `period_end` date NOT NULL,
  `facility_id` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_period_begin_facility_id_description_user_id` (`code`,`period_begin`,`facility_id`,`description`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_change_reason`;
CREATE TABLE `tbl_change_reason` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_commodity_status`;
CREATE TABLE `tbl_commodity_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `drug_id` int(11) DEFAULT NULL,
  `funding_agent` int(11) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `date` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `comment` varchar(100) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `month` varchar(10) DEFAULT NULL,
  `log_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_consumption`;
CREATE TABLE `tbl_consumption` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `total` int(11) NOT NULL DEFAULT '0',
  `allocated` int(11) NOT NULL DEFAULT '0',
  `period_year` int(4) NOT NULL,
  `period_month` varchar(3) NOT NULL,
  `facility_id` int(11) NOT NULL,
  `drug_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `period_year_period_month_facility_id_drug_id` (`period_year`,`period_month`,`facility_id`,`drug_id`),
  KEY `period_year` (`period_year`),
  KEY `period_month` (`period_month`),
  KEY `facility_id` (`facility_id`),
  KEY `drug_id` (`drug_id`),
  CONSTRAINT `tbl_consumption_ibfk_1` FOREIGN KEY (`facility_id`) REFERENCES `tbl_facility` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_consumption_ibfk_2` FOREIGN KEY (`drug_id`) REFERENCES `tbl_drug` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_county`;
CREATE TABLE `tbl_county` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_decision`;
CREATE TABLE `tbl_decision` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `discussion` longtext NOT NULL,
  `recommendation` longtext NOT NULL,
  `decision_date` date NOT NULL,
  `drug_id` int(11) NOT NULL,
  `meeting_id` int(11) NOT NULL,
  `deleted` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `drug_id_decision_date` (`drug_id`,`decision_date`),
  KEY `decision_date` (`decision_date`),
  CONSTRAINT `tbl_decision_ibfk_1` FOREIGN KEY (`drug_id`) REFERENCES `tbl_drug` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_decision_log`;
CREATE TABLE `tbl_decision_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  `decision_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `created_user_id_decision_id` (`created`,`user_id`,`decision_id`),
  KEY `description` (`description`),
  KEY `user_id` (`user_id`),
  KEY `decision_id` (`decision_id`),
  CONSTRAINT `tbl_decision_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_decision_log_ibfk_2` FOREIGN KEY (`decision_id`) REFERENCES `tbl_decision` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_dhis_elements`;
CREATE TABLE `tbl_dhis_elements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dhis_code` varchar(50) NOT NULL,
  `dhis_name` varchar(150) NOT NULL,
  `dhis_report` varchar(20) NOT NULL,
  `target_report` varchar(20) NOT NULL,
  `target_name` varchar(100) NOT NULL,
  `target_category` varchar(10) NOT NULL,
  `target_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_dose`;
CREATE TABLE `tbl_dose` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL,
  `value` decimal(2,1) DEFAULT NULL,
  `frequency` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `value` (`value`),
  KEY `frequency` (`frequency`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_drug`;
CREATE TABLE `tbl_drug` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `strength` varchar(50) NOT NULL,
  `packsize` varchar(20) NOT NULL,
  `generic_id` int(11) NOT NULL,
  `formulation_id` int(11) DEFAULT NULL,
  `drug_category` int(11) NOT NULL DEFAULT '1',
  `min_mos` int(11) NOT NULL DEFAULT '0',
  `max_mos` int(11) NOT NULL DEFAULT '3',
  `amc_months` int(11) NOT NULL DEFAULT '6' COMMENT 'used for procurement',
  `facility_amc` int(11) NOT NULL COMMENT 'used for orders',
  `stock_status` int(11) NOT NULL DEFAULT '1',
  `kemsa_code` varchar(50) DEFAULT NULL,
  `short_expiry` char(3) DEFAULT NULL,
  `regimen_category` char(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `strength_2` (`strength`,`packsize`,`generic_id`,`formulation_id`),
  KEY `strength` (`strength`),
  KEY `generic_id` (`generic_id`),
  KEY `formulation_id` (`formulation_id`),
  KEY `packsize` (`packsize`),
  KEY `dcat` (`drug_category`),
  CONSTRAINT `tbl_drug_ibfk_1` FOREIGN KEY (`generic_id`) REFERENCES `tbl_generic` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_drug_ibfk_2` FOREIGN KEY (`formulation_id`) REFERENCES `tbl_formulation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_drug_ibfk_3` FOREIGN KEY (`drug_category`) REFERENCES `tbl_drug_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_drug_category`;
CREATE TABLE `tbl_drug_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_email_category`;
CREATE TABLE `tbl_email_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_facility`;
CREATE TABLE `tbl_facility` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `mflcode` varchar(20) NOT NULL,
  `category` varchar(20) DEFAULT 'satellite',
  `dhiscode` varchar(50) DEFAULT NULL,
  `longitude` varchar(200) DEFAULT NULL,
  `latitude` varchar(200) DEFAULT NULL,
  `subcounty_id` int(11) DEFAULT NULL,
  `partner_id` int(11) NOT NULL DEFAULT '1',
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mflcode` (`mflcode`),
  UNIQUE KEY `dhiscode` (`dhiscode`),
  KEY `subcounty_id` (`subcounty_id`),
  KEY `name` (`name`),
  KEY `partner_id` (`partner_id`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `tbl_facility_ibfk_1` FOREIGN KEY (`subcounty_id`) REFERENCES `tbl_subcounty` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_facility_ibfk_2` FOREIGN KEY (`partner_id`) REFERENCES `tbl_partner` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_facility_ibfk_3` FOREIGN KEY (`parent_id`) REFERENCES `tbl_facility` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_formulation`;
CREATE TABLE `tbl_formulation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_funding_agent`;
CREATE TABLE `tbl_funding_agent` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_funding_agent_amount`;
CREATE TABLE `tbl_funding_agent_amount` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `proc_id` int(11) NOT NULL,
  `agent` varchar(20) NOT NULL,
  `amount` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_generic`;
CREATE TABLE `tbl_generic` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `abbreviation` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_abbreviation` (`name`,`abbreviation`),
  KEY `abbreviation` (`abbreviation`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_install`;
CREATE TABLE `tbl_install` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` varchar(10) NOT NULL,
  `setup_date` date DEFAULT NULL,
  `upgrade_date` date DEFAULT NULL,
  `comments` text NOT NULL,
  `contact_name` varchar(50) DEFAULT NULL,
  `contact_phone` varchar(12) DEFAULT NULL,
  `emrs_used` enum('IQCare','KenyaEMR','OpenMRS','CPAD','MARPS') DEFAULT NULL,
  `active_patients` int(6) DEFAULT NULL,
  `is_internet` tinyint(1) DEFAULT NULL,
  `is_usage` tinyint(1) DEFAULT NULL,
  `facility_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `facility_id` (`facility_id`),
  KEY `version` (`version`),
  KEY `setup_date` (`setup_date`),
  KEY `upgrade_date` (`upgrade_date`),
  KEY `emrs_used` (`emrs_used`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `tbl_install_ibfk_1` FOREIGN KEY (`facility_id`) REFERENCES `tbl_facility` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_install_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_kemsa`;
CREATE TABLE `tbl_kemsa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `issue_total` int(11) NOT NULL DEFAULT '0',
  `soh_total` int(11) NOT NULL DEFAULT '0',
  `supplier_total` int(11) NOT NULL DEFAULT '0',
  `received_total` int(11) NOT NULL DEFAULT '0',
  `period_year` int(4) NOT NULL,
  `period_month` varchar(3) NOT NULL,
  `drug_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `period_year_period_month_drug_id` (`period_year`,`period_month`,`drug_id`),
  KEY `period_year` (`period_year`),
  KEY `period_month` (`period_month`),
  KEY `drug_id` (`drug_id`),
  CONSTRAINT `tbl_kemsa_ibfk_1` FOREIGN KEY (`drug_id`) REFERENCES `tbl_drug` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_line`;
CREATE TABLE `tbl_line` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_log`;
CREATE TABLE `tbl_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `log_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `action` text NOT NULL,
  `status` varchar(30) NOT NULL,
  `submodule_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `status` (`status`),
  KEY `submodule_id` (`submodule_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `tbl_log_ibfk_1` FOREIGN KEY (`submodule_id`) REFERENCES `tbl_submodule` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_log_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_mailing_list`;
CREATE TABLE `tbl_mailing_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(50) NOT NULL,
  `email_type` int(11) NOT NULL,
  `sent_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` int(11) NOT NULL DEFAULT '2',
  `present` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `etype` (`email_type`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_maps`;
CREATE TABLE `tbl_maps` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `status` varchar(20) NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  `code` varchar(15) NOT NULL,
  `period_begin` date NOT NULL,
  `period_end` date NOT NULL,
  `reports_expected` int(11) DEFAULT NULL,
  `reports_actual` int(11) DEFAULT NULL,
  `services` varchar(255) DEFAULT NULL,
  `sponsors` varchar(255) DEFAULT NULL,
  `art_adult` int(11) DEFAULT NULL COMMENT '		',
  `art_child` int(11) DEFAULT NULL,
  `new_male` int(11) DEFAULT NULL,
  `revisit_male` int(11) DEFAULT NULL,
  `new_female` int(11) DEFAULT NULL,
  `revisit_female` int(11) DEFAULT NULL,
  `new_pmtct` int(11) DEFAULT NULL,
  `revisit_pmtct` int(11) DEFAULT NULL,
  `total_infant` int(11) DEFAULT NULL,
  `pep_adult` int(11) DEFAULT NULL,
  `pep_child` int(11) DEFAULT NULL,
  `total_adult` int(11) DEFAULT NULL,
  `total_child` int(11) DEFAULT NULL,
  `diflucan_adult` int(11) DEFAULT NULL,
  `diflucan_child` int(11) DEFAULT NULL,
  `new_cm` int(11) DEFAULT NULL,
  `revisit_cm` int(11) DEFAULT NULL,
  `new_oc` int(11) DEFAULT NULL,
  `revisit_oc` int(11) DEFAULT NULL,
  `comments` text,
  `report_id` int(11) DEFAULT NULL,
  `facility_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_period_begin_period_end_facility_id` (`code`,`period_begin`,`period_end`,`facility_id`),
  KEY `code` (`code`),
  KEY `status` (`status`),
  KEY `period_begin` (`period_begin`),
  KEY `period_end` (`period_end`),
  KEY `facility_id` (`facility_id`),
  CONSTRAINT `tbl_maps_ibfk_1` FOREIGN KEY (`facility_id`) REFERENCES `tbl_facility` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `tbl_maps_item`;
CREATE TABLE `tbl_maps_item` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `total` int(11) NOT NULL,
  `regimen_id` int(11) NOT NULL,
  `maps_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `maps_id_regimen_id` (`maps_id`,`regimen_id`),
  KEY `maps_id` (`maps_id`),
  KEY `regimen_id` (`regimen_id`),
  CONSTRAINT `tbl_maps_item_ibfk_1` FOREIGN KEY (`regimen_id`) REFERENCES `tbl_regimen` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_maps_item_ibfk_2` FOREIGN KEY (`maps_id`) REFERENCES `tbl_maps` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `tbl_maps_log`;
CREATE TABLE `tbl_maps_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  `maps_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_user_id_maps_id` (`description`,`user_id`,`maps_id`),
  KEY `maps_id` (`maps_id`),
  KEY `user_id` (`user_id`),
  KEY `description` (`description`),
  CONSTRAINT `tbl_maps_log_ibfk_2` FOREIGN KEY (`maps_id`) REFERENCES `tbl_maps` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_maps_log_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `tbl_maps_log_temp`;
CREATE TABLE `tbl_maps_log_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(15) NOT NULL,
  `period_begin` date NOT NULL,
  `period_end` date NOT NULL,
  `facility_id` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_period_begin_facility_id_description_user_id` (`code`,`period_begin`,`facility_id`,`description`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_meeting`;
CREATE TABLE `tbl_meeting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `meeting_date` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_meetings`;
CREATE TABLE `tbl_meetings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `start_event` datetime NOT NULL,
  `end_event` datetime NOT NULL,
  `venue` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


SET NAMES utf8mb4;

DROP TABLE IF EXISTS `tbl_minutes`;
CREATE TABLE `tbl_minutes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `meeting_id` int(11) NOT NULL,
  `minute` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `start` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `aob` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_module`;
CREATE TABLE `tbl_module` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `icon` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_nnrti`;
CREATE TABLE `tbl_nnrti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `regimen_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `regimen_id_name` (`regimen_id`,`name`),
  KEY `name` (`name`),
  CONSTRAINT `tbl_nnrti_ibfk_1` FOREIGN KEY (`regimen_id`) REFERENCES `tbl_regimen` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_nrti`;
CREATE TABLE `tbl_nrti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `regimen_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `regimen_id_name` (`regimen_id`,`name`),
  KEY `name` (`name`),
  CONSTRAINT `tbl_nrti_ibfk_1` FOREIGN KEY (`regimen_id`) REFERENCES `tbl_regimen` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_order`;
CREATE TABLE `tbl_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `facility` varchar(100) NOT NULL,
  `period` varchar(10) NOT NULL,
  `dimension` varchar(100) NOT NULL,
  `category` varchar(100) NOT NULL,
  `value` int(11) NOT NULL,
  `report_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `facility` (`facility`),
  KEY `period` (`period`),
  KEY `dimension` (`dimension`),
  KEY `category` (`category`),
  KEY `report_id` (`report_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_partner`;
CREATE TABLE `tbl_partner` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_patient`;
CREATE TABLE `tbl_patient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `total` int(10) NOT NULL DEFAULT '0',
  `period_year` int(4) NOT NULL,
  `period_month` varchar(3) NOT NULL,
  `regimen_id` int(11) NOT NULL,
  `facility_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `period_year_period_month_facility_id_regimen_id` (`period_year`,`period_month`,`facility_id`,`regimen_id`),
  KEY `period_year` (`period_year`),
  KEY `period_month` (`period_month`),
  KEY `regimen_id` (`regimen_id`),
  KEY `facility_id` (`facility_id`),
  CONSTRAINT `tbl_patient_ibfk_1` FOREIGN KEY (`regimen_id`) REFERENCES `tbl_regimen` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_patient_ibfk_2` FOREIGN KEY (`facility_id`) REFERENCES `tbl_facility` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_procurement`;
CREATE TABLE `tbl_procurement` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `open_kemsa` int(11) NOT NULL DEFAULT '0',
  `receipts_kemsa` int(11) NOT NULL DEFAULT '0',
  `receipts_usaid` int(11) NOT NULL DEFAULT '0',
  `receipts_gf` int(11) NOT NULL DEFAULT '0',
  `receipts_cpf` int(11) NOT NULL DEFAULT '0',
  `issues_kemsa` int(11) NOT NULL DEFAULT '0',
  `close_kemsa` int(11) NOT NULL DEFAULT '0',
  `monthly_consumption` int(11) NOT NULL DEFAULT '0',
  `transaction_year` int(4) NOT NULL,
  `transaction_month` varchar(3) NOT NULL,
  `drug_id` int(11) NOT NULL,
  `adj_losses` int(11) NOT NULL DEFAULT '0',
  `kemsa_code` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `drug_id_transaction_year_transaction_month` (`drug_id`,`transaction_year`,`transaction_month`),
  KEY `transaction_year` (`transaction_year`),
  KEY `transaction_month` (`transaction_month`),
  CONSTRAINT `tbl_procurement_ibfk_1` FOREIGN KEY (`drug_id`) REFERENCES `tbl_drug` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `tbl_procurement_history`;
CREATE TABLE `tbl_procurement_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `year` int(11) DEFAULT NULL,
  `month` varchar(10) DEFAULT NULL,
  `quantity` int(11) DEFAULT '0',
  `funding_agent_id` int(11) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `procurement_status_id` int(11) DEFAULT NULL,
  `procurement_id` int(11) DEFAULT NULL,
  `date_added` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `comments` mediumtext,
  `funding_agent` mediumtext,
  `drug_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `procurement_id_procurement_status_id_quantity` (`procurement_id`,`procurement_status_id`,`quantity`),
  KEY `supplier_id` (`supplier_id`),
  KEY `procurement_status_id` (`procurement_status_id`),
  KEY `funding_agent_id` (`funding_agent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_procurement_item`;
CREATE TABLE `tbl_procurement_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quantity` int(11) NOT NULL DEFAULT '0',
  `funding_agent_id` int(11) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `procurement_status_id` int(11) NOT NULL,
  `procurement_id` int(11) NOT NULL,
  `date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `comments` mediumtext,
  `funding_agent` mediumtext,
  `drug_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `procurement_id_procurement_status_id_quantity` (`procurement_id`,`procurement_status_id`,`quantity`),
  KEY `supplier_id` (`supplier_id`),
  KEY `procurement_status_id` (`procurement_status_id`),
  KEY `funding_agent_id` (`funding_agent_id`),
  CONSTRAINT `tbl_procurement_item_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `tbl_supplier` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_procurement_item_ibfk_2` FOREIGN KEY (`procurement_status_id`) REFERENCES `tbl_procurement_status` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_procurement_item_ibfk_3` FOREIGN KEY (`funding_agent_id`) REFERENCES `tbl_funding_agent` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_procurement_item_ibfk_4` FOREIGN KEY (`procurement_id`) REFERENCES `tbl_procurement` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_procurement_log`;
CREATE TABLE `tbl_procurement_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  `procurement_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `created_user_id_procurement_id` (`created`,`user_id`,`procurement_id`),
  KEY `user_id` (`user_id`),
  KEY `procurement_id` (`procurement_id`),
  KEY `description` (`description`),
  CONSTRAINT `tbl_procurement_log_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_procurement_log_ibfk_4` FOREIGN KEY (`procurement_id`) REFERENCES `tbl_procurement` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_procurement_status`;
CREATE TABLE `tbl_procurement_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_purpose`;
CREATE TABLE `tbl_purpose` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_regimen`;
CREATE TABLE `tbl_regimen` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` text NOT NULL,
  `category_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `line_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `category_id` (`category_id`),
  KEY `service_id` (`service_id`),
  KEY `line_id` (`line_id`),
  KEY `name` (`name`),
  CONSTRAINT `tbl_regimen_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `tbl_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_regimen_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `tbl_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_regimen_ibfk_3` FOREIGN KEY (`line_id`) REFERENCES `tbl_line` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_regimen_category`;
CREATE TABLE `tbl_regimen_category` (
  `id` int(2) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_regimen_drug`;
CREATE TABLE `tbl_regimen_drug` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `regimen_id` int(11) NOT NULL,
  `drug_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `regimen_id_drug_id` (`regimen_id`,`drug_id`),
  KEY `drug_id` (`drug_id`),
  KEY `regimen_id` (`regimen_id`),
  CONSTRAINT `tbl_regimen_drug_ibfk_2` FOREIGN KEY (`drug_id`) REFERENCES `tbl_drug` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_regimen_drug_ibfk_3` FOREIGN KEY (`regimen_id`) REFERENCES `tbl_regimen` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_role`;
CREATE TABLE `tbl_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_role_submodule`;
CREATE TABLE `tbl_role_submodule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `submodule_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_id_submodule_id` (`role_id`,`submodule_id`),
  KEY `role_id` (`role_id`),
  KEY `submodule_id` (`submodule_id`),
  CONSTRAINT `tbl_role_submodule_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `tbl_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_role_submodule_ibfk_3` FOREIGN KEY (`submodule_id`) REFERENCES `tbl_submodule` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_service`;
CREATE TABLE `tbl_service` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_status`;
CREATE TABLE `tbl_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_stock`;
CREATE TABLE `tbl_stock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `total` int(11) NOT NULL DEFAULT '0',
  `period_year` int(4) NOT NULL,
  `period_month` varchar(3) NOT NULL,
  `facility_id` int(11) NOT NULL,
  `drug_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `period_year_period_month_facility_id_drug_id` (`period_year`,`period_month`,`facility_id`,`drug_id`),
  KEY `period_year` (`period_year`),
  KEY `period_month` (`period_month`),
  KEY `facility_id` (`facility_id`),
  KEY `drug_id` (`drug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_stock_status`;
CREATE TABLE `tbl_stock_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_subcounty`;
CREATE TABLE `tbl_subcounty` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `county_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `county_id` (`county_id`),
  CONSTRAINT `tbl_subcounty_ibfk_2` FOREIGN KEY (`county_id`) REFERENCES `tbl_county` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_submodule`;
CREATE TABLE `tbl_submodule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `module_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_module_id` (`name`,`module_id`),
  KEY `module_id` (`module_id`),
  CONSTRAINT `tbl_submodule_ibfk_1` FOREIGN KEY (`module_id`) REFERENCES `tbl_submodule` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_supplier`;
CREATE TABLE `tbl_supplier` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_supplier_contracted`;
CREATE TABLE `tbl_supplier_contracted` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `proc_id` int(11) NOT NULL,
  `supplier` varchar(20) NOT NULL,
  `amount` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_syslogs`;
CREATE TABLE `tbl_syslogs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `log_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `action` varchar(150) NOT NULL,
  `module` varchar(50) NOT NULL,
  `user` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_user`;
CREATE TABLE `tbl_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `email_address` varchar(50) NOT NULL,
  `phone_number` varchar(30) NOT NULL,
  `password` varchar(128) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_address` (`email_address`),
  UNIQUE KEY `phone_number` (`phone_number`),
  KEY `password` (`password`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `tbl_user_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `tbl_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbl_user_scope`;
CREATE TABLE `tbl_user_scope` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `scope_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `role_id` (`role_id`),
  KEY `scope_id` (`scope_id`),
  CONSTRAINT `tbl_user_scope_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_user_scope_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `tbl_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP VIEW IF EXISTS `vw_cdrr_list`;
CREATE TABLE `vw_cdrr_list` (`facility` varchar(150), `category` varchar(20), `code` varchar(12), `county` varchar(50), `subcounty` varchar(50), `partner` varchar(150), `data_year` int(4), `data_month` varchar(32), `data_date` date, `drug_id` int(11), `drug` varchar(255), `consumed` int(11), `allocated` int(11) unsigned, `opening_bal` int(11), `closing_bal` int(11), `mos` bigint(13));


DROP VIEW IF EXISTS `vw_central_site_list`;
CREATE TABLE `vw_central_site_list` (`facility` varchar(150), `county` varchar(50), `sub_county` varchar(50), `partner` varchar(150), `has_install` varchar(3), `adt_version` varchar(10), `has_internet` varchar(3), `has_backup` varchar(3), `active_patients` int(6), `coordinator` varchar(101));


DROP VIEW IF EXISTS `vw_consumption_list`;
CREATE TABLE `vw_consumption_list` (`id` int(11), `total` int(11), `period_year` int(4), `period_month` varchar(3), `facility_id` int(11), `subcounty` varchar(50), `county` varchar(50), `drug_id` int(11), `drug` varchar(255), `cdate` date);


DROP VIEW IF EXISTS `vw_countyrep_list`;
CREATE TABLE `vw_countyrep_list` (`id` int(11), `firstname` varchar(50), `lastname` varchar(50), `email_address` varchar(50), `phone_number` varchar(30), `password` varchar(128), `role_id` int(11), `county_id` int(11));


DROP VIEW IF EXISTS `vw_county_pharmacists`;
CREATE TABLE `vw_county_pharmacists` (`pharmacist` varchar(101), `email_address` varchar(50), `scope` varchar(50), `role` varchar(30));


DROP VIEW IF EXISTS `vw_csf_list`;
CREATE TABLE `vw_csf_list` (`county` varchar(50), `subcounty` varchar(50), `facility` varchar(150));


DROP VIEW IF EXISTS `vw_drug_list`;
CREATE TABLE `vw_drug_list` (`id` int(11), `name` varchar(255), `pack_size` varchar(20), `drug_category` varchar(50), `min_mos` int(11), `max_mos` int(11), `amc_months` int(11), `stock_status` int(11), `kemsa_code` varchar(50), `facility_amc` int(11), `short_expiry` char(3), `regimen_category` varchar(50));


DROP VIEW IF EXISTS `vw_install_list`;
CREATE TABLE `vw_install_list` (`mflcode` varchar(20), `facility` varchar(150), `county` varchar(50), `subcounty` varchar(50), `partner` varchar(150), `classification` varchar(20), `has_internet` varchar(3), `adt_version` varchar(10), `has_backup` varchar(3), `active_patients` int(6), `contact_name` varchar(50), `contact_phone` varchar(12), `assigned_to` varchar(101));


DROP VIEW IF EXISTS `vw_lastmonth_bal`;
CREATE TABLE `vw_lastmonth_bal` (`id` int(11) unsigned, `period_end` date, `balance` int(11), `drug_name` varchar(255), `facility` varchar(150), `subcounty` varchar(50), `county` varchar(50));


DROP VIEW IF EXISTS `vw_maps_list`;
CREATE TABLE `vw_maps_list` (`facility` varchar(150), `category` varchar(20), `code` varchar(15), `county` varchar(50), `subcounty` varchar(50), `partner` varchar(150), `data_year` int(4), `data_month` varchar(32), `data_date` date, `regimen` varchar(163), `regimen_service` varchar(20), `regimen_category` varchar(100), `total` int(11));



DROP VIEW IF EXISTS `vw_regimen_drug_list`;
CREATE TABLE `vw_regimen_drug_list` (`id` int(11), `drug_id` int(11), `regimen` varchar(163), `drug` varchar(255));


DROP VIEW IF EXISTS `vw_regimen_list`;
CREATE TABLE `vw_regimen_list` (`id` int(11), `code` varchar(10), `name` varchar(163), `description` text, `category` varchar(100), `service` varchar(20), `line` varchar(10));


DROP TABLE IF EXISTS `vw_cdrr_list`;
CREATE  VIEW `vw_cdrr_list` AS select `f`.`name` AS `facility`,`f`.`category` AS `category`,(case when ((`f`.`category` = 'central') and (`c`.`code` = 'D-CDRR')) then 'D-CDRR' when ((`f`.`category` = 'standalone') and (`c`.`code` = 'F-CDRR')) then 'F-CDRR_packs' else 'F-CDRR_units' end) AS `code`,`co`.`name` AS `county`,`sb`.`name` AS `subcounty`,`p`.`name` AS `partner`,year(`c`.`period_begin`) AS `data_year`,date_format(`c`.`period_begin`,'%b') AS `data_month`,`c`.`period_begin` AS `data_date`,`d`.`id` AS `drug_id`,`d`.`name` AS `drug`,`ci`.`dispensed_packs` AS `consumed`,`ci`.`qty_allocated` AS `allocated`,`ci`.`balance` AS `opening_bal`,`ci`.`count` AS `closing_bal`,floor((`ci`.`count` / 3)) AS `mos` from (((((((`tbl_cdrr` `c` join `tbl_maps` `m` on(((`m`.`facility_id` = `c`.`facility_id`) and (`m`.`period_begin` = `c`.`period_begin`) and (`m`.`period_end` = `c`.`period_end`) and (substr(`m`.`code`,1,1) = substr(`c`.`code`,1,1))))) join `tbl_cdrr_item` `ci` on((`ci`.`cdrr_id` = `c`.`id`))) join `tbl_facility` `f` on((`f`.`id` = `c`.`facility_id`))) join `tbl_subcounty` `sb` on((`sb`.`id` = `f`.`subcounty_id`))) join `tbl_county` `co` on((`co`.`id` = `sb`.`county_id`))) join `tbl_partner` `p` on((`p`.`id` = `f`.`partner_id`))) join `vw_drug_list` `d` on((`d`.`id` = `ci`.`drug_id`))) group by `ci`.`id`;

DROP TABLE IF EXISTS `vw_central_site_list`;
CREATE  VIEW `vw_central_site_list` AS select `f`.`name` AS `facility`,`c`.`name` AS `county`,`sb`.`name` AS `sub_county`,`p`.`name` AS `partner`,if((`i`.`id` is not null),'Yes','No') AS `has_install`,`i`.`version` AS `adt_version`,if((`i`.`is_internet` = 1),'Yes','No') AS `has_internet`,if((`b`.`id` is not null),'Yes','No') AS `has_backup`,`i`.`active_patients` AS `active_patients`,concat_ws(' ',`u`.`firstname`,`u`.`lastname`) AS `coordinator` from ((((((`tbl_facility` `f` join `tbl_subcounty` `sb` on((`sb`.`id` = `f`.`subcounty_id`))) join `tbl_county` `c` on((`c`.`id` = `sb`.`county_id`))) join `tbl_partner` `p` on((`p`.`id` = `f`.`partner_id`))) left join `tbl_install` `i` on((`f`.`id` = `i`.`facility_id`))) left join `tbl_backup` `b` on((`b`.`facility_id` = `i`.`facility_id`))) left join `tbl_user` `u` on((`u`.`id` = `i`.`user_id`))) where (`f`.`category` like '%central%') group by `f`.`id`;

DROP TABLE IF EXISTS `vw_consumption_list`;
CREATE  VIEW `vw_consumption_list` AS select `c`.`id` AS `id`,`c`.`total` AS `total`,`c`.`period_year` AS `period_year`,`c`.`period_month` AS `period_month`,`c`.`facility_id` AS `facility_id`,`sb`.`name` AS `subcounty`,`co`.`name` AS `county`,`c`.`drug_id` AS `drug_id`,`d`.`name` AS `drug`,str_to_date(concat_ws('-',`c`.`period_year`,`c`.`period_month`,'01'),'%Y-%b-%e') AS `cdate` from ((((`tbl_consumption` `c` left join `vw_drug_list` `d` on((`d`.`id` = `c`.`drug_id`))) left join `tbl_facility` `f` on((`f`.`id` = `c`.`facility_id`))) left join `tbl_subcounty` `sb` on((`sb`.`id` = `f`.`subcounty_id`))) left join `tbl_county` `co` on((`co`.`id` = `sb`.`county_id`)));

DROP TABLE IF EXISTS `vw_countyrep_list`;
CREATE  VIEW `vw_countyrep_list` AS select `u`.`id` AS `id`,`u`.`firstname` AS `firstname`,`u`.`lastname` AS `lastname`,`u`.`email_address` AS `email_address`,`u`.`phone_number` AS `phone_number`,`u`.`password` AS `password`,`u`.`role_id` AS `role_id`,`us`.`scope_id` AS `county_id` from (`tbl_user` `u` left join `tbl_user_scope` `us` on((`u`.`id` = `us`.`id`)));

DROP TABLE IF EXISTS `vw_county_pharmacists`;
CREATE  VIEW `vw_county_pharmacists` AS select concat_ws(' ',`u`.`firstname`,`u`.`lastname`) AS `pharmacist`,`u`.`email_address` AS `email_address`,`c`.`name` AS `scope`,`r`.`name` AS `role` from (((`tbl_user` `u` left join `tbl_user_scope` `us` on((`u`.`id` = `us`.`user_id`))) left join `tbl_county` `c` on((`us`.`scope_id` = `c`.`id`))) left join `tbl_role` `r` on((`us`.`role_id` = `r`.`id`))) where (`r`.`name` = 'county');

DROP TABLE IF EXISTS `vw_csf_list`;
CREATE  VIEW `vw_csf_list` AS select `c`.`name` AS `county`,`sc`.`name` AS `subcounty`,`f`.`name` AS `facility` from ((`tbl_county` `c` left join `tbl_subcounty` `sc` on((`c`.`id` = `sc`.`county_id`))) left join `tbl_facility` `f` on((`sc`.`id` = `f`.`subcounty_id`))) order by `c`.`name`;

DROP TABLE IF EXISTS `vw_drug_list`;
CREATE  VIEW `vw_drug_list` AS select `d`.`id` AS `id`,if((`g`.`abbreviation` = ''),concat_ws(' ',`g`.`name`,concat_ws(' ',`d`.`strength`,`f`.`name`)),concat_ws(') ',concat_ws(' (',`g`.`name`,`g`.`abbreviation`),concat_ws(' ',`d`.`strength`,`f`.`name`))) AS `name`,`d`.`packsize` AS `pack_size`,`dc`.`name` AS `drug_category`,`d`.`min_mos` AS `min_mos`,`d`.`max_mos` AS `max_mos`,`d`.`amc_months` AS `amc_months`,`d`.`stock_status` AS `stock_status`,`d`.`kemsa_code` AS `kemsa_code`,`d`.`facility_amc` AS `facility_amc`,`d`.`short_expiry` AS `short_expiry`,`r`.`Name` AS `regimen_category` from ((((`tbl_drug` `d` join `tbl_generic` `g` on((`g`.`id` = `d`.`generic_id`))) join `tbl_formulation` `f` on((`f`.`id` = `d`.`formulation_id`))) join `tbl_drug_category` `dc` on((`dc`.`id` = `d`.`drug_category`))) join `tbl_regimen_category` `r` on((`r`.`id` = `d`.`regimen_category`))) order by `d`.`id`;

DROP TABLE IF EXISTS `vw_install_list`;
CREATE  VIEW `vw_install_list` AS select `f`.`mflcode` AS `mflcode`,`f`.`name` AS `facility`,`c`.`name` AS `county`,`sb`.`name` AS `subcounty`,`p`.`name` AS `partner`,`f`.`category` AS `classification`,if((`i`.`is_internet` = 1),'Yes','No') AS `has_internet`,`i`.`version` AS `adt_version`,if((`b`.`id` is not null),'Yes','No') AS `has_backup`,`i`.`active_patients` AS `active_patients`,`i`.`contact_name` AS `contact_name`,replace(`i`.`contact_phone`,'254','0') AS `contact_phone`,concat_ws(' ',`u`.`firstname`,`u`.`lastname`) AS `assigned_to` from ((((((`tbl_install` `i` join `tbl_facility` `f` on((`f`.`id` = `i`.`facility_id`))) join `tbl_subcounty` `sb` on((`sb`.`id` = `f`.`subcounty_id`))) join `tbl_county` `c` on((`c`.`id` = `sb`.`county_id`))) join `tbl_partner` `p` on((`p`.`id` = `f`.`partner_id`))) join `tbl_user` `u` on((`u`.`id` = `i`.`user_id`))) left join `tbl_backup` `b` on((`b`.`facility_id` = `i`.`facility_id`))) group by `i`.`facility_id`;

DROP TABLE IF EXISTS `vw_lastmonth_bal`;
CREATE  VIEW `vw_lastmonth_bal` AS select `c`.`id` AS `id`,`c`.`period_end` AS `period_end`,`ci`.`balance` AS `balance`,`d`.`name` AS `drug_name`,`f`.`name` AS `facility`,`sc`.`name` AS `subcounty`,`co`.`name` AS `county` from (((((`tbl_cdrr` `c` join `tbl_cdrr_item` `ci` on((`ci`.`cdrr_id` = `c`.`id`))) join `vw_drug_list` `d` on((`d`.`id` = `ci`.`drug_id`))) join `tbl_facility` `f` on((`f`.`id` = `c`.`facility_id`))) join `tbl_subcounty` `sc` on((`sc`.`id` = `f`.`subcounty_id`))) join `tbl_county` `co` on((`co`.`id` = `sc`.`county_id`))) where ((year(`c`.`period_end`) = year(curdate())) and (month(`c`.`period_end`) = month((curdate() - interval 1 month))));

DROP TABLE IF EXISTS `vw_maps_list`;
CREATE  VIEW `vw_maps_list` AS select `f`.`name` AS `facility`,`f`.`category` AS `category`,`m`.`code` AS `code`,`co`.`name` AS `county`,`sb`.`name` AS `subcounty`,`p`.`name` AS `partner`,year(`m`.`period_begin`) AS `data_year`,date_format(`m`.`period_begin`,'%b') AS `data_month`,`m`.`period_begin` AS `data_date`,`r`.`name` AS `regimen`,`r`.`service` AS `regimen_service`,`r`.`category` AS `regimen_category`,`mi`.`total` AS `total` from (((((((`tbl_maps` `m` join `tbl_cdrr` `c` on(((`c`.`facility_id` = `m`.`facility_id`) and (`c`.`period_begin` = `m`.`period_begin`) and (`c`.`period_end` = `m`.`period_end`) and (substr(`c`.`code`,1,1) = substr(`m`.`code`,1,1))))) join `tbl_maps_item` `mi` on((`mi`.`maps_id` = `m`.`id`))) join `tbl_facility` `f` on((`f`.`id` = `m`.`facility_id`))) join `tbl_subcounty` `sb` on((`sb`.`id` = `f`.`subcounty_id`))) join `tbl_county` `co` on((`co`.`id` = `sb`.`county_id`))) join `tbl_partner` `p` on((`p`.`id` = `f`.`partner_id`))) join `vw_regimen_list` `r` on((`r`.`id` = `mi`.`regimen_id`))) group by `mi`.`id`;

DROP TABLE IF EXISTS `vw_regimen_drug_list`;
CREATE  VIEW `vw_regimen_drug_list` AS select `r`.`id` AS `id`,`dl`.`id` AS `drug_id`,concat_ws(' | ',`r`.`code`,`r`.`name`) AS `regimen`,`dl`.`name` AS `drug` from ((`tbl_regimen_drug` `rd` join `tbl_regimen` `r` on((`r`.`id` = `rd`.`regimen_id`))) join `vw_drug_list` `dl` on((`dl`.`id` = `rd`.`drug_id`)));

DROP TABLE IF EXISTS `vw_regimen_list`;
CREATE  VIEW `vw_regimen_list` AS select `r`.`id` AS `id`,`r`.`code` AS `code`,concat_ws(' | ',`r`.`code`,`r`.`name`) AS `name`,`r`.`description` AS `description`,`c`.`name` AS `category`,`s`.`name` AS `service`,`l`.`name` AS `line` from (((`tbl_regimen` `r` join `tbl_category` `c` on((`c`.`id` = `r`.`category_id`))) join `tbl_service` `s` on((`s`.`id` = `r`.`service_id`))) join `tbl_line` `l` on((`l`.`id` = `r`.`line_id`))) order by `r`.`id`;

-- 2019-04-02 05:51:22
