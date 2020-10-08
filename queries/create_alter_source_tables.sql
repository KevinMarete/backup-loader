CREATE TABLE IF NOT EXISTS `patient_prep_test` (
  `patient_id` int(11) NOT NULL,
  `prep_reason_id` int(11) DEFAULT NULL,
  `is_tested` tinyint(1) NOT NULL DEFAULT '0',
  `test_date` date DEFAULT NULL,
  `test_result` tinyint(1) DEFAULT '0',
  KEY `patient_id` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1//
CREATE TABLE IF NOT EXISTS `patient_viral_load` (
  `patient_ccc_number` varchar(30) DEFAULT NULL,
  `test_date` date DEFAULT NULL,
  `result` varchar(30) DEFAULT NULL,
  `justification` text,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `test_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1//
CREATE TABLE IF NOT EXISTS `prep_reason` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `active` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1//
CREATE TABLE IF NOT EXISTS `master_list_data` 
(`FACILITY` varchar(10),`active` int(11),
`1MONEMONTH` decimal(23,0), 
`1FONEMONTH` decimal(23,0), `1-4MONEMONTH` decimal(23,0), 
`1-4FONEMONTH` decimal(23,0), `5-9MONEMONTH` decimal(23,0), 
`5-9FONEMONTH` decimal(23,0), `10-14MONEMONTH` decimal(23,0), 
`10-14FONEMONTH` decimal(23,0), `15-19MONEMONTH` decimal(23,0), 
`15-19FONEMONTH` decimal(23,0), `20-24MONEMONTH` decimal(23,0), 
`20-24FONEMONTH` decimal(23,0), `25-29MONEMONTH` decimal(23,0), 
`25-29FONEMONTH` decimal(23,0), `30-34MONEMONTH` decimal(23,0), 
`30-34FONEMONTH` decimal(23,0), `35-39MONEMONTH` decimal(23,0), 
`35-39FONEMONTH` decimal(23,0), `40-44MONEMONTH` decimal(23,0), `
40-44FONEMONTH` decimal(23,0), `45-49MONEMONTH` decimal(23,0), 
`45-49FONEMONTH` decimal(23,0), `50MONEMONTH` decimal(23,0), 
`50FONEMONTH` decimal(23,0), `SUBTOTAL1MONTH` decimal(23,0), 
`1MTWOMONTH` decimal(23,0), `1FTWOMONTH` decimal(23,0), 
`1-4MTWOMONTH` decimal(23,0), `1-4FTWOMONTH` decimal(23,0), 
`5-9MTWOMONTH` decimal(23,0), `5-9FTWOMONTH` decimal(23,0), 
`10-14MTWOMONTH` decimal(23,0), `10-14FTWOMONTH` decimal(23,0), 
`15-19MTWOMONTH` decimal(23,0), `15-19FTWOMONTH` decimal(23,0), 
`20-24MTWOMONTH` decimal(23,0), `20-24FTWOMONTH` decimal(23,0), 
`25-29MTWOMONTH` decimal(23,0), `25-29FTWOMONTH` decimal(23,0), 
`30-34MTWOMONTH` decimal(23,0), `30-34FTWOMONTH` decimal(23,0), 
`35-39MTWOMONTH` decimal(23,0), `35-39FTWOMONTH` decimal(23,0), 
`40-44MTWOMONTH` decimal(23,0), `40-44FTWOMONTH` decimal(23,0), 
`45-49MTWOMONTH` decimal(23,0), `45-49FTWOMONTH` decimal(23,0), 
`50MTWOMONTH` decimal(23,0), `50FTWOMONTH` decimal(23,0), 
`SUBTOTAL2MONTH` decimal(23,0), `1MTHREEMONTH` decimal(23,0), 
`1FTHREEMONTH` decimal(23,0), `1-4MTHREEMONTH` decimal(23,0), 
`1-4FTHREEMONTH` decimal(23,0), `5-9MTHREEMONTH` decimal(23,0), 
`5-9FTHREEMONTH` decimal(23,0), `10-14MTHREEMONTH` decimal(23,0), 
`10-14FTHREEMONTH` decimal(23,0), `15-19MTHREEMONTH` decimal(23,0), 
`15-19FTHREEMONTH` decimal(23,0), `20-24MTHREEMONTH` decimal(23,0), 
`20-24FTHREEMONTH` decimal(23,0), `25-29MTHREEMONTH` decimal(23,0), 
`25-29FTHREEMONTH` decimal(23,0), `30-34MTHREEMONTH` decimal(23,0), 
`30-34FTHREEMONTH` decimal(23,0), `35-39MTHREEMONTH` decimal(23,0), 
`35-39FTHREEMONTH` decimal(23,0), `40-44MTHREEMONTH` decimal(23,0), 
`40-44FTHREEMONTH` decimal(23,0), `45-49MTHREEMONTH` decimal(23,0), 
`45-49FTHREEMONTH` decimal(23,0), `50MTHREEMONTH` decimal(23,0),
 `50FTHREEMONTH` decimal(23,0), `SUBTOTAL3MONTH` decimal(23,0), 
`1MFOURMONTH` decimal(23,0), `1FFOURMONTH` decimal(23,0), 
`1-4MFOURMONTH` decimal(23,0), `1-4FFOURMONTH` decimal(23,0), 
`5-9MFOURMONTH` decimal(23,0), `5-9FFOURMONTH` decimal(23,0), 
`10-14MFOURMONTH` decimal(23,0), `10-14FFOURMONTH` decimal(23,0), 
`15-19MFOURMONTH` decimal(23,0), `15-19FFOURMONTH` decimal(23,0), 
`20-24MFOURMONTH` decimal(23,0), `20-24FFOURMONTH` decimal(23,0), 
`25-29MFOURMONTH` decimal(23,0), `25-29FFOURMONTH` decimal(23,0), 
`30-34MFOURMONTH` decimal(23,0), `30-34FFOURMONTH` decimal(23,0), 
`35-39MFOURMONTH` decimal(23,0), `35-39FFOURMONTH` decimal(23,0), 
`40-44MFOURMONTH` decimal(23,0), `40-44FFOURMONTH` decimal(23,0), 
`45-49MFOURMONTH` decimal(23,0), `45-49FFOURMONTH` decimal(23,0), 
`50MFOURMONTH` decimal(23,0), `50FFOURMONTH` decimal(23,0), 
`SUBTOTAL4MONTH` decimal(23,0), `1MFIVEMONTH` decimal(23,0), 
`1FFIVEMONTH` decimal(23,0), `1-4MFIVEMONTH` decimal(23,0), 
`1-4FFIVEMONTH` decimal(23,0), `5-9MFIVEMONTH` decimal(23,0), 
`5-9FFIVEMONTH` decimal(23,0), `10-14MFIVEMONTH` decimal(23,0), 
`10-14FFIVEMONTH` decimal(23,0), `15-19MFIVEMONTH` decimal(23,0), 
`15-19FFIVEMONTH` decimal(23,0), `20-24MFIVEMONTH` decimal(23,0), 
`20-24FFIVEMONTH` decimal(23,0), `25-29MFIVEMONTH` decimal(23,0), 
`25-29FFIVEMONTH` decimal(23,0), `30-34MFIVEMONTH` decimal(23,0), 
`30-34FFIVEMONTH` decimal(23,0), `35-39MFIVEMONTH` decimal(23,0), 
`35-39FFIVEMONTH` decimal(23,0), `40-44MFIVEMONTH` decimal(23,0), 
`40-44FFIVEMONTH` decimal(23,0), `45-49MFIVEMONTH` decimal(23,0), 
`45-49FFIVEMONTH` decimal(23,0), `50MFIVEMONTH` decimal(23,0), 
`50FFIVEMONTH` decimal(23,0), `SUBTOTAL5MONTH` decimal(23,0), 
`1MSIXMONTH` decimal(23,0), `1FSIXMONTH` decimal(23,0), 
`1-4MSIXMONTH` decimal(23,0), `1-4FSIXMONTH` decimal(23,0), 
`5-9MSIXMONTH` decimal(23,0), `5-9FSIXMONTH` decimal(23,0),
 `10-14MSIXMONTH` decimal(23,0), `10-14FSIXMONTH` decimal(23,0), 
`15-19MSIXMONTH` decimal(23,0), `15-19FSIXMONTH` decimal(23,0), 
`20-24MSIXMONTH` decimal(23,0), `20-24FSIXMONTH` decimal(23,0), 
`25-29MSIXMONTH` decimal(23,0), `25-29FSIXMONTH` decimal(23,0), 
`30-34MSIXMONTH` decimal(23,0), `30-34FSIXMONTH` decimal(23,0), 
`35-39MSIXMONTH` decimal(23,0), `35-39FSIXMONTH` decimal(23,0), 
`40-44MSIXMONTH` decimal(23,0), `40-44FSIXMONTH` decimal(23,0), 
`45-49MSIXMONTH` decimal(23,0), `45-49FSIXMONTH` decimal(23,0), 
`50MSIXMONTH` decimal(23,0), `50FSIXMONTH` decimal(23,0), 
`SUBTOTAL6MONTH` decimal(23,0), `TOTALMONTHS` decimal(23,0), 
`MMSMLESS1YEAR` decimal(23,0), `MMSFLESS1YEAR` decimal(23,0), 
`MMS1-4M` decimal(23,0), `MMS1-4F` decimal(23,0), 
`MMS5-9M` decimal(23,0), `MMS5-9F` decimal(23,0), 
`MMS10-14M` decimal(23,0), `MMS10-14F` decimal(23,0), 
`MMS15-19M` decimal(23,0), `MMS15-19F` decimal(23,0), 
`MMS20-24M` decimal(23,0), `MMS20-24F` decimal(23,0), 
`MMS25-29M` decimal(23,0), `MMS25-29F` decimal(23,0), 
`MMS30-34M` decimal(23,0), `MMS30-34F` decimal(23,0), 
`MMS35-39M` decimal(23,0), `MMS35-39F` decimal(23,0), 
`MMS40-44M` decimal(23,0), `MMS40-44F` decimal(23,0), 
`MMS45-49M` decimal(23,0), `MMS45-49F` decimal(23,0), 
`MMSOVER50M` decimal(23,0), `MMSOVER50F` decimal(23,0), 
`MMSTOTAL` decimal(23,0))//

