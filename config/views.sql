/*Install List*/
CREATE OR REPLACE VIEW vw_install_list AS
	SELECT 
		f.mflcode, 
		UCASE(f.name) facility_name, 
		UCASE(c.name) county, 
		UCASE(sb.name) subcounty, 
		UCASE(p.name) partner,
		UCASE(f.category) classification,
		IF(i.is_internet = 1, 'YES', 'NO') has_internet,
		i.active_patients,
		UCASE(i.contact_name) contact_name,
		REPLACE(i.contact_phone, '254','0') contact_phone,
		UCASE(u.name) assigned_to,
		i.version adt_version,
		IF(b.id IS NOT NULL, 'YES', 'NO') has_backup
	FROM tbl_install i
	INNER JOIN tbl_facility f ON f.id = i.facility_id
	INNER JOIN tbl_subcounty sb ON sb.id = f.subcounty_id
	INNER JOIN tbl_county c ON c.id = sb.county_id
	INNER JOIN tbl_partner p ON p.id = f.partner_id
	INNER JOIN tbl_user u ON u.id = i.user_id
	LEFT JOIN tbl_backup b ON b.facility_id = f.id
	GROUP BY i.facility_id