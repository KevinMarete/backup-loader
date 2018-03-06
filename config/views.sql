/*Install List*/
CREATE OR REPLACE VIEW vw_install_list AS
	SELECT 
		f.mflcode, 
		f.name facility, 
		c.name county, 
		sb.name subcounty, 
		p.name partner,
		f.category classification,
		IF(i.is_internet = 1, 'Yes', 'No') has_internet,
		i.version adt_version,
		IF(b.id IS NOT NULL, 'Yes', 'No') has_backup,
		i.active_patients,
		i.contact_name contact_name,
		REPLACE(i.contact_phone, '254','0') contact_phone,
		u.name assigned_to
	FROM tbl_install i
	INNER JOIN tbl_facility f ON f.id = i.facility_id
	INNER JOIN tbl_subcounty sb ON sb.id = f.subcounty_id
	INNER JOIN tbl_county c ON c.id = sb.county_id
	INNER JOIN tbl_partner p ON p.id = f.partner_id
	INNER JOIN tbl_user u ON u.id = i.user_id
	LEFT JOIN tbl_backup b ON b.facility_id = f.id
	GROUP BY i.facility_id;

/*Central Site List*/
CREATE OR REPLACE VIEW vw_central_site_list AS
	SELECT 
	    f.name facility,
	    c.name county,
	    sb.name sub_county,
	    p.name partner,
	    IF(i.id IS NOT NULL, 'Yes', 'No') has_install,
	    i.version adt_version,
	    IF(i.is_internet = 1, 'Yes', 'No') has_internet,
	    IF(b.id IS NOT NULL, 'Yes', 'No') has_backup,
	    i.active_patients,
	    u.name coordinator
	FROM tbl_facility f 
	INNER JOIN tbl_subcounty sb ON sb.id = f.subcounty_id
	INNER JOIN tbl_county c ON c.id = sb.county_id
	INNER JOIN tbl_partner p ON p.id = f.partner_id
	LEFT JOIN tbl_install i ON f.id = i.facility_id
	LEFT JOIN tbl_backup b ON b.facility_id = f.id
	LEFT JOIN tbl_user u ON u.id = i.user_id
	WHERE f.category LIKE '%central%'
	GROUP BY f.id;