CREATE TABLE IF NOT EXISTS `patient_prep_test` (
  `patient_id` int(11) NOT NULL,
  `prep_reason_id` int(11) DEFAULT NULL,
  `is_tested` tinyint(1) NOT NULL DEFAULT '0',
  `test_date` date DEFAULT NULL,
  `test_result` tinyint(1) DEFAULT '0',
  KEY `patient_id` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `patient_viral_load` (
  `patient_ccc_number` varchar(30) DEFAULT NULL,
  `test_date` date DEFAULT NULL,
  `result` varchar(30) DEFAULT NULL,
  `justification` text,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `test_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `prep_reason` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `active` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

IF NOT EXISTS(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'patient' AND table_schema = '{db_name}' AND column_name = 'breastfeeding')  THEN
  ALTER TABLE `patient` ADD `breastfeeding` tinyint(2) NOT NULL DEFAULT '0' AFTER `pregnant`;
END IF;

IF NOT EXISTS(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'patient' AND table_schema = '{db_name}' AND column_name = 'clinicalappointment')  THEN
  ALTER TABLE `patient` ADD `clinicalappointment` varchar(20) NOT NULL AFTER `nextappointment`;
END IF;

IF NOT EXISTS(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'patient' AND table_schema = '{db_name}' AND column_name = 'differentiated_care')  THEN
  ALTER TABLE `patient` ADD `differentiated_care` tinyint(1) NOT NULL AFTER `clinicalappointment`;
END IF;