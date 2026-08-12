-- ============================================================================
-- Supabase PostgreSQL Seed Data: Team GopalSingh App
-- Location Focus: Gram Panchayat Harnawada Gaja, Tehsil Pirawa, District Jhalawar, Rajasthan (PIN: 326034)
-- Assembly Constituency: 198 Jhalrapatan
-- ============================================================================

BEGIN;

-- ----------------------------------------------------------------------------
-- 1. APP SETTINGS
-- ----------------------------------------------------------------------------
INSERT INTO public.app_settings (key, value) VALUES
('app_title', 'Team GopalSingh Public Portal'),
('gram_panchayat', 'Harnawada Gaja'),
('tehsil', 'Pirawa'),
('district', 'Jhalawar'),
('state', 'Rajasthan'),
('pin_code', '326034'),
('assembly_constituency', '198 - Jhalrapatan'),
('parliamentary_constituency', 'Jhalawar-Baran'),
('primary_helpline', '9166377972'),
('secondary_helpline', '9166047972'),
('official_email', 'contact@teamgopalsingh.in'),
('office_address', 'Gram Panchayat Road, Harnawada Gaja, Tehsil Pirawa, District Jhalawar, Rajasthan - 326034'),
('app_version', '1.0.0')
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value, updated_at = now();

-- ----------------------------------------------------------------------------
-- 2. ADMIN ROLES
-- ----------------------------------------------------------------------------
INSERT INTO public.admin_roles (id, role_name, description) VALUES
('a0000000-0000-0000-0000-000000000001', 'Super Admin', 'Full system access and user role management'),
('a0000000-0000-0000-0000-000000000002', 'Complaint Admin', 'Manages and resolves citizen complaints and timelines'),
('a0000000-0000-0000-0000-000000000003', 'Development Admin', 'Tracks and updates local Gram Panchayat infrastructure projects'),
('a0000000-0000-0000-0000-000000000004', 'Election Data Admin', 'Manages ECI election records and polling station data'),
('a0000000-0000-0000-0000-000000000005', 'Verification Admin', 'Verifies official contacts, news, and official documents')
ON CONFLICT (role_name) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 3. USERS & ADMIN MAPPINGS
-- ----------------------------------------------------------------------------
INSERT INTO public.users (id, mobile, name, ward, role) VALUES
('10000000-0000-0000-0000-000000000001', '9166377972', 'Gopal Singh', 'Ward 1', 'admin'),
('10000000-0000-0000-0000-000000000002', '9166047972', 'Team Admin - Complaints', 'Ward 2', 'admin'),
('10000000-0000-0000-0000-000000000003', '9829012345', 'Ramesh Kumar', 'Ward 3', 'user'),
('10000000-0000-0000-0000-000000000004', '9414098765', 'Sunita Devi', 'Ward 4', 'user')
ON CONFLICT (mobile) DO NOTHING;

INSERT INTO public.admins (user_id, role_id) VALUES
('10000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001'), -- Super Admin
('10000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000002'), -- Complaint Admin
('10000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000003'), -- Dev Admin
('10000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000004'), -- Election Data Admin
('10000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000005')  -- Verification Admin
ON CONFLICT (user_id, role_id) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 4. TEAM CONTACTS
-- ----------------------------------------------------------------------------
INSERT INTO public.team_contacts (label, phone, whatsapp_enabled, public_visible, display_order, active) VALUES
('Team GopalSingh Primary Helpline', '9166377972', true, true, 1, true),
('Team GopalSingh Secondary Helpline & WhatsApp', '9166047972', true, true, 2, true),
('Harnawada Gaja Village Public Desk', '9166377972', true, true, 3, true);

-- ----------------------------------------------------------------------------
-- 5. SOCIAL LINKS
-- ----------------------------------------------------------------------------
INSERT INTO public.social_links (platform, display_name, username_or_id, url, icon, display_order, active, public_visible) VALUES
('Facebook', 'Team GopalSingh Official', 'TeamGopalSinghJhalawar', 'https://facebook.com/TeamGopalSinghJhalawar', 'facebook', 1, true, true),
('WhatsApp', 'Team GopalSingh Public Channel', 'channel_gopalsingh', 'https://wa.me/919166377972', 'whatsapp', 2, true, true),
('X (Twitter)', 'Team GopalSingh', '@TeamGopalSingh', 'https://x.com/TeamGopalSingh', 'twitter', 3, true, true),
('Instagram', 'Team GopalSingh Jhalawar', 'team_gopalsingh_official', 'https://instagram.com/team_gopalsingh_official', 'instagram', 4, true, true),
('YouTube', 'Team GopalSingh Media', 'TeamGopalSinghMedia', 'https://youtube.com/@TeamGopalSinghMedia', 'youtube', 5, true, true);

-- ----------------------------------------------------------------------------
-- 6. OFFICIAL CONTACTS (VERIFIED LOCAL PUBLIC OFFICERS)
-- ----------------------------------------------------------------------------
INSERT INTO public.official_contacts (
    officer_name, designation, department, office, jurisdiction,
    official_phone, office_phone, official_email, office_address,
    latitude, longitude, official_source_url, verified_status, verified_at, public_visible, active
) VALUES
(
    'District Collector & Magistrate', 'District Collector', 'Revenue & District Administration',
    'Collectorate Office Jhalawar', 'Jhalawar District',
    '07432-230401', '07432-230402', 'dm-jha-rj@nic.in',
    'Mini Secretariat, Kota Road, Jhalawar, Rajasthan 326001',
    24.5973000, 76.1601000, 'https://jhalawar.rajasthan.gov.in', 'Verified', now(), true, true
),
(
    'Sub-Divisional Magistrate (SDM)', 'Sub-Divisional Magistrate', 'Sub-Divisional Office',
    'SDM Office Pirawa', 'Tehsil Pirawa & Sunel',
    '07436-240222', '07436-240222', 'sdm.pirawa@rajasthan.gov.in',
    'Sub-Divisional Office Complex, Pirawa, District Jhalawar 326512',
    24.3215000, 76.0342000, 'https://jhalawar.rajasthan.gov.in/contacts', 'Verified', now(), true, true
),
(
    'Tehsildar Pirawa', 'Tehsildar', 'Revenue Department',
    'Tehsil Office Pirawa', 'Tehsil Pirawa',
    '07436-240225', '07436-240225', 'tehsildar.pirawa@rajasthan.gov.in',
    'Tehsil Main Building, Pirawa, District Jhalawar 326512',
    24.3220000, 76.0345000, 'https://jhalawar.rajasthan.gov.in/contacts', 'Verified', now(), true, true
),
(
    'Gram Sevak / VDO', 'Village Development Officer (VDO)', 'Panchayati Raj Department',
    'Gram Panchayat Bhawan Harnawada Gaja', 'Gram Panchayat Harnawada Gaja',
    '9414000000', '07436-240000', 'vdo.harnawadagaja@gmail.com',
    'Gram Panchayat Office, Harnawada Gaja, Tehsil Pirawa, Jhalawar 326034',
    24.2850000, 76.0120000, 'https://jhalawar.rajasthan.gov.in', 'Verified', now(), true, true
),
(
    'Block Development Officer (BDO)', 'Block Development Officer', 'Panchayat Samiti',
    'Panchayat Samiti Office Pirawa', 'Block Pirawa',
    '07436-240230', '07436-240230', 'bdo.pirawa@rajasthan.gov.in',
    'Panchayat Samiti Campus, Pirawa, District Jhalawar 326512',
    24.3225000, 76.0350000, 'https://jhalawar.rajasthan.gov.in', 'Verified', now(), true, true
),
(
    'Station House Officer (SHO)', 'Inspector / Police Officer', 'Rajasthan Police Department',
    'Pirawa Police Station', 'Pirawa Police Jurisdiction',
    '07436-240224', '112', 'sho.pirawa@rajasthanpolice.gov.in',
    'Police Station Road, Pirawa, District Jhalawar 326512',
    24.3210000, 76.0335000, 'https://police.rajasthan.gov.in', 'Verified', now(), true, true
),
(
    'Medical Officer In-Charge', 'Block Chief Medical Officer / Medical Officer', 'Medical, Health & Family Welfare Department',
    'Primary Health Centre (PHC) Harnawada Gaja / CHC Pirawa', 'Harnawada Gaja & Surroundings',
    '07436-240250', '108', 'phc.harnawadagaja@rajasthan.gov.in',
    'PHC Campus, Main Road, Harnawada Gaja, Tehsil Pirawa 326034',
    24.2860000, 76.0130000, 'https://rajswasthya.nic.in', 'Verified', now(), true, true
),
(
    'Assistant Engineer (AEn)', 'Assistant Engineer (O&M)', 'Jaipur Vidyut Vitran Nigam Limited (JVVNL)',
    'JVVNL Sub-Division Office Pirawa', 'Pirawa Rural Sub-Division',
    '07436-240260', '18001806507', 'aen.pirawa@jvvnl.org',
    'Electricity Office Complex, Pirawa, District Jhalawar 326512',
    24.3230000, 76.0360000, 'https://energy.rajasthan.gov.in/jvvnl', 'Verified', now(), true, true
),
(
    'Assistant Engineer (PHED)', 'Assistant Engineer', 'Public Health Engineering Department (PHED)',
    'PHED Sub-Division Office Pirawa', 'Water Supply Pirawa Block',
    '07436-240270', '181', 'aen.phed.pirawa@rajasthan.gov.in',
    'PHED Office Campus, Pirawa, District Jhalawar 326512',
    24.3235000, 76.0365000, 'https://water.rajasthan.gov.in', 'Verified', now(), true, true
);

-- ----------------------------------------------------------------------------
-- 7. DEVELOPMENT PROJECTS
-- ----------------------------------------------------------------------------
INSERT INTO public.development_projects (
    project_name, location, village, ward, scheme, department,
    approved_amount, approval_date, start_date, expected_completion,
    current_status, progress_percentage, before_photo_url, work_photo_url, after_photo_url, official_doc_url,
    description, source, verification_date
) VALUES
(
    'Construction of Interlocking CC Road & Drain', 'Main Street near Bus Stand to Govt School', 'Harnawada Gaja', 'Ward 2',
    'Mukhyamantri Gram Path Yojana', 'Public Works Department (PWD) / Panchayati Raj',
    1250000.00, '2025-01-15', '2025-02-01', '2025-06-30',
    'In Progress', 65,
    'https://storage.teamgopalsingh.in/projects/cc_road_before.jpg',
    'https://storage.teamgopalsingh.in/projects/cc_road_work.jpg',
    NULL,
    'https://storage.teamgopalsingh.in/docs/sanction_cc_road_2025.pdf',
    'Construction of durable concrete road and covered drainage system to eliminate waterlogging during monsoon in Ward 2.',
    'Panchayat Samiti Sanction Order 2025', '2025-02-10'
),
(
    'Installation of High-Lumen Solar Street Lights', 'All Village Crossings and Public Places', 'Harnawada Gaja', 'All Wards',
    'Gram Panchayat Vikas Nidhi', 'Panchayati Raj Department',
    450000.00, '2024-11-10', '2024-12-01', '2025-01-15',
    'Completed', 100,
    'https://storage.teamgopalsingh.in/projects/solar_before.jpg',
    'https://storage.teamgopalsingh.in/projects/solar_work.jpg',
    'https://storage.teamgopalsingh.in/projects/solar_after.jpg',
    'https://storage.teamgopalsingh.in/docs/solar_lights_completion.pdf',
    'Installation of 35 solar LED street lights across main roads and public meeting areas in Harnawada Gaja.',
    'Gram Sabha Resolution 2024', '2025-01-20'
),
(
    'Jal Jeevan Mission Household Tap Connection Pipeline', 'Village Habitation & Extension Area', 'Harnawada Gaja', 'Wards 1, 3, 4',
    'Jal Jeevan Mission (JJM)', 'Public Health Engineering Department (PHED)',
    3200000.00, '2024-08-20', '2024-10-01', '2025-08-31',
    'In Progress', 80,
    'https://storage.teamgopalsingh.in/projects/jjm_before.jpg',
    'https://storage.teamgopalsingh.in/projects/jjm_work.jpg',
    NULL,
    'https://storage.teamgopalsingh.in/docs/jjm_approval_harnawada.pdf',
    'Providing functional household tap water connections (FHTC) to 240 households in Gram Panchayat Harnawada Gaja.',
    'PHED Rajasthan JJM Portal', '2025-02-01'
),
(
    'Gram Panchayat Bhawan Modernization & E-Mitra Desk', 'Panchayat Bhawan Campus', 'Harnawada Gaja', 'Ward 1',
    'Rashtriya Gram Swaraj Abhiyan (RGSA)', 'Panchayati Raj Department',
    600000.00, '2025-03-01', '2025-03-15', '2025-09-30',
    'Planned', 15,
    'https://storage.teamgopalsingh.in/projects/bhawan_before.jpg',
    NULL, NULL,
    'https://storage.teamgopalsingh.in/docs/rgsa_panchayat_plan.pdf',
    'Upgradation of Gram Panchayat Bhawan with computer laboratory, internet connectivity, and dedicated e-Mitra help center.',
    'District Collectorate Approval', '2025-03-10'
);

-- ----------------------------------------------------------------------------
-- 8. NEWS & ANNOUNCEMENTS
-- ----------------------------------------------------------------------------
INSERT INTO public.news (
    title, category, cover_image_url, description, gallery_urls, video_url, source, author, verification_status, published_at
) VALUES
(
    'Special Gram Sabha Convened at Harnawada Gaja for Development Plan Approval',
    'Gram Panchayat',
    'https://storage.teamgopalsingh.in/news/gram_sabha_cover.jpg',
    'A special Gram Sabha was chaired at Gram Panchayat Bhawan Harnawada Gaja to discuss monsoon road repair, clean drinking water supply, and beneficiary list verification under PMAY-G.',
    ARRAY['https://storage.teamgopalsingh.in/news/gram_sabha_1.jpg', 'https://storage.teamgopalsingh.in/news/gram_sabha_2.jpg'],
    'https://youtube.com/watch?v=sample_gram_sabha',
    'Gram Panchayat Notice Board & Official Records', 'Team GopalSingh Media Desk',
    'Verified', now() - INTERVAL '3 days'
),
(
    'Mukhyamantri Kisan Samman Nidhi Additional Installment Released for Jhalawar Farmers',
    'Government Schemes',
    'https://storage.teamgopalsingh.in/news/kisan_scheme_cover.jpg',
    'Under the Mukhyamantri Kisan Samman Nidhi Yojana, state financial assistance has been directly credited to bank accounts of eligible farmers in Pirawa Tehsil.',
    ARRAY['https://storage.teamgopalsingh.in/news/kisan_1.jpg'],
    NULL,
    'Department of Agriculture, Rajasthan', 'Official Press Release',
    'Verified', now() - INTERVAL '7 days'
),
(
    'Free Medical & Eye Checkup Camp Organized at PHC Harnawada Gaja',
    'Health & Welfare',
    'https://storage.teamgopalsingh.in/news/health_camp_cover.jpg',
    'Over 320 villagers received free health screenings, eye checkups, and prescription medicines during the health camp organized at PHC Harnawada Gaja.',
    ARRAY['https://storage.teamgopalsingh.in/news/health_1.jpg', 'https://storage.teamgopalsingh.in/news/health_2.jpg'],
    NULL,
    'Block Chief Medical Office Pirawa', 'Team GopalSingh Health Desk',
    'Verified', now() - INTERVAL '12 days'
);

-- ----------------------------------------------------------------------------
-- 9. EVENTS
-- ----------------------------------------------------------------------------
INSERT INTO public.events (
    event_name, event_date, event_time, location, description, image_url, map_url, share_count
) VALUES
(
    'Jan Sunwai & Grievance Redressal Camp',
    CURRENT_DATE + INTERVAL '5 days', '10:00:00',
    'Gram Panchayat Bhawan, Harnawada Gaja',
    'Public hearing session for local issues including water pipeline, electricity meters, pension documentation, and revenue records.',
    'https://storage.teamgopalsingh.in/events/jan_sunwai.jpg',
    'https://maps.google.com/?q=24.2850,76.0120', 42
),
(
    'Organic Farming & Soil Testing Awareness Workshop',
    CURRENT_DATE + INTERVAL '12 days', '11:00:00',
    'Community Hall, Pirawa',
    'Expert workshop by Agriculture Officers on soil health card scheme, organic fertilizers, and drip irrigation subsidies.',
    'https://storage.teamgopalsingh.in/events/kisan_workshop.jpg',
    'https://maps.google.com/?q=24.3220,76.0345', 28
);

-- ----------------------------------------------------------------------------
-- 10. GOVERNMENT SCHEMES
-- ----------------------------------------------------------------------------
INSERT INTO public.schemes (
    scheme_name, category, eligibility, benefits, documents_required, application_process, department, official_website, source, last_verified
) VALUES
(
    'Mukhyamantri Kisan Samman Nidhi Yojana', 'Agriculture & Farmer Welfare',
    'Small and marginal landholding farmers registered under PM Kisan in Rajasthan.',
    'Additional financial assistance of Rs. 2,000 per year directly into bank account in addition to PM Kisan.',
    'Aadhaar Card, Jan Aadhaar Card, Jamabandi Land Records, Bank Passbook.',
    'Apply via e-Mitra portal or Agriculture Supervisor office with Jan Aadhaar authentication.',
    'Department of Agriculture, Govt of Rajasthan', 'https://agriculture.rajasthan.gov.in',
    'Rajasthan Agriculture Portal', CURRENT_DATE
),
(
    'Ayushman Bharat - Mukhyamantri Chiranjeevi Swasthya Bima Yojana', 'Health Insurance',
    'All resident families of Rajasthan with valid Jan Aadhaar Card.',
    'Cashless medical treatment insurance cover up to Rs. 25 Lakh per family per year in empanelled hospitals.',
    'Jan Aadhaar Card, Aadhaar Card, Ration Card.',
    'Automatic enrolment for NFSA card holders; others can register on Jan Aadhaar Portal or e-Mitra.',
    'Medical, Health & Family Welfare Department, Rajasthan', 'https://chiranjeevi.rajasthan.gov.in',
    'State Health Portal', CURRENT_DATE
),
(
    'Pradhan Mantri Awas Yojana - Gramin (PMAY-G)', 'Rural Housing',
    'Houseless rural families or those living in kutcha/dilapidated houses based on SECC data.',
    'Financial assistance of Rs. 1.20 Lakh in 3 installments + MGNREGA wage assistance + Toilet construction support.',
    'Aadhaar Card, Jan Aadhaar, Bank Account, Land Ownership / House Site Document, Photo.',
    'Selection via Gram Sabha approved priority list. Verification by VDO / Gram Sevak.',
    'Panchayati Raj & Rural Development Department', 'https://pmayg.nic.in',
    'PMAY-G Official Portal', CURRENT_DATE
),
(
    'Indira Gandhi Rashtriya Old Age Pension Yojana (State Pension)', 'Social Security Pension',
    'Elderly citizens aged 58+ (Women) and 60+ (Men) residing in Rajasthan.',
    'Monthly pension of Rs. 1,000 credited directly into bank account.',
    'Jan Aadhaar Card, Aadhaar Card, Income Certificate, Bank Passbook, Age Proof.',
    'Online application via e-Mitra or SSO Portal, verified by Tehsildar / SDM.',
    'Social Justice & Empowerment Department (SJED)', 'https://ssp.rajasthan.gov.in',
    'SJED RajSSP Portal', CURRENT_DATE
);

-- ----------------------------------------------------------------------------
-- 11. PUBLIC DOCUMENTS
-- ----------------------------------------------------------------------------
INSERT INTO public.documents (
    title, category, file_url, description, source, verified_at
) VALUES
(
    'Gram Panchayat Harnawada Gaja Annual Vikas Plan 2025-26', 'Panchayat Orders',
    'https://storage.teamgopalsingh.in/docs/harnawada_gaja_vikas_plan_2025.pdf',
    'Official sanctioned Gram Panchayat Annual Action Plan containing list of approved CC roads, water pipelines, and solar lighting works.',
    'Gram Panchayat Records Office', now()
),
(
    'PMAY-G Beneficiary Priority List - Harnawada Gaja', 'Housing Lists',
    'https://storage.teamgopalsingh.in/docs/pmayg_harnawada_gaja_list.pdf',
    'Gram Sabha verified list of eligible rural housing beneficiaries for Tehsil Pirawa, GP Harnawada Gaja.',
    'Panchayat Samiti Pirawa', now()
),
(
    'Gram Sabha Official Resolution Copy (January 2025)', 'Meeting Minutes',
    'https://storage.teamgopalsingh.in/docs/gram_sabha_resolution_jan2025.pdf',
    'Signed resolution regarding public sanitation, drinking water pipeline expansion, and local grievance monitoring.',
    'Gram Sevak Office', now()
);

-- ----------------------------------------------------------------------------
-- 12. PHOTOS & VIDEOS GALLERY
-- ----------------------------------------------------------------------------
INSERT INTO public.photos (title, category, media_url, media_type, thumbnail_url, source) VALUES
('CC Road Construction Work at Ward 2', 'Development', 'https://storage.teamgopalsingh.in/gallery/cc_road_1.jpg', 'photo', 'https://storage.teamgopalsingh.in/gallery/thumb_cc_road_1.jpg', 'Team GopalSingh Field Team'),
('Gram Sabha Public Discussion at Panchayat Bhawan', 'Events', 'https://storage.teamgopalsingh.in/gallery/gram_sabha_1.jpg', 'photo', 'https://storage.teamgopalsingh.in/gallery/thumb_gram_sabha_1.jpg', 'Team GopalSingh Media'),
('Solar Street Light Installation at Bus Stand', 'Development', 'https://storage.teamgopalsingh.in/gallery/solar_1.jpg', 'photo', 'https://storage.teamgopalsingh.in/gallery/thumb_solar_1.jpg', 'Panchayat Work Photos');

INSERT INTO public.videos (title, category, media_url, media_type, thumbnail_url, source) VALUES
('Jan Sunwai Highlights & Grievance Redressal Overview', 'Public Interaction', 'https://youtube.com/watch?v=sample_video_jansunwai', 'video', 'https://storage.teamgopalsingh.in/gallery/thumb_vid_1.jpg', 'Team GopalSingh YouTube Channel'),
('Jal Jeevan Mission Pipeline Inspection Report', 'Development Progress', 'https://youtube.com/watch?v=sample_video_jjm', 'video', 'https://storage.teamgopalsingh.in/gallery/thumb_vid_2.jpg', 'Field Inspection');

-- ----------------------------------------------------------------------------
-- 13. PUBLIC POLLS & VOTING SYSTEM
-- ----------------------------------------------------------------------------
INSERT INTO public.polls (id, question, category, active, votes_count) VALUES
('p0000000-0000-0000-0000-000000000001', 'Which infrastructure project should be given top priority in Harnawada Gaja for 2026?', 'Development Priority', true, 2);

INSERT INTO public.poll_options (id, poll_id, option_text, votes_count) VALUES
('o0000000-0000-0000-0000-000000000001', 'p0000000-0000-0000-0000-000000000001', 'Complete Concrete Drainage & CC Road Network', 1),
('o0000000-0000-0000-0000-000000000002', 'p0000000-0000-0000-0000-000000000001', 'Augmentation of Drinking Water Pipeline (JJM)', 1),
('o0000000-0000-0000-0000-000000000003', 'p0000000-0000-0000-0000-000000000001', 'Upgrade Primary Health Centre Facilities', 0),
('o0000000-0000-0000-0000-000000000004', 'p0000000-0000-0000-0000-000000000001', 'Strengthen Secondary School Infrastructure & Computers', 0);

INSERT INTO public.poll_votes (poll_id, option_id, user_id, voter_mobile) VALUES
('p0000000-0000-0000-0000-000000000001', 'o0000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000003', '9829012345'),
('p0000000-0000-0000-0000-000000000001', 'o0000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000004', '9414098765');

-- ----------------------------------------------------------------------------
-- 14. SUGGESTIONS & VOLUNTEERS
-- ----------------------------------------------------------------------------
INSERT INTO public.suggestions (category, suggestion, photo_url, mobile, name, status) VALUES
('Cleanliness & Sanitation', 'Regular cleaning of the main market drain before monsoon to prevent overflow near the bus stand.', NULL, '9829012345', 'Ramesh Kumar', 'Under Review'),
('Street Lighting', 'Add two additional solar street light poles near the cremation ground approach road.', NULL, '9414098765', 'Sunita Devi', 'Accepted');

INSERT INTO public.volunteers (name, mobile, ward, interest, availability, status) VALUES
('Vikram Singh', '9829555111', 'Ward 2', 'Digital Literacy & e-Mitra Help Desk', 'Weekends (Saturday/Sunday)', 'Approved'),
('Pooja Rathore', '9414222333', 'Ward 4', 'Health Camps & Women Welfare Awareness', 'Evenings (4 PM - 7 PM)', 'Approved');

-- ----------------------------------------------------------------------------
-- 15. ECI VERIFIED ELECTION RECORDS (AC-198 Jhalrapatan)
-- ----------------------------------------------------------------------------
-- Election Data Version
INSERT INTO public.election_data_versions (version_name, description, source_eci_url, published_date, is_current) VALUES
('AC-198 Jhalrapatan Electoral Summary v2023.1', 'Verified Election Commission of India aggregated electoral statistics and constituency result records for Assembly Constituency 198 Jhalrapatan.', 'https://results.eci.gov.in', '2023-12-04', true);

-- Polling Stations in/around Gram Panchayat Harnawada Gaja & Pirawa
INSERT INTO public.polling_stations (station_number, station_name, location, village, ward, latitude, longitude, total_voters, source) VALUES
(142, 'Government Upper Primary School (East Wing)', 'Harnawada Gaja', 'Harnawada Gaja', 'Ward 1-3', 24.2852000, 76.0122000, 845, 'ECI Polling Station List AC-198 Jhalrapatan'),
(143, 'Government Senior Secondary School (West Wing)', 'Harnawada Gaja', 'Harnawada Gaja', 'Ward 4-6', 24.2858000, 76.0128000, 912, 'ECI Polling Station List AC-198 Jhalrapatan'),
(144, 'Government Primary School Gaja', 'Gaja Habitation', 'Gaja', 'Gaja Area', 24.2820000, 76.0090000, 620, 'ECI Polling Station List AC-198 Jhalrapatan'),
(145, 'Government Senior Secondary School Main Building', 'Pirawa Town', 'Pirawa', 'Ward 5', 24.3218000, 76.0340000, 1150, 'ECI Polling Station List AC-198 Jhalrapatan');

-- Aggregated Election Results (2023 & 2018 Rajasthan Legislative Assembly)
INSERT INTO public.election_results (election_year, constituency_no, constituency_name, candidate_name, party, votes_polled, vote_percentage, result_status, source) VALUES
(2023, 198, 'Jhalrapatan', 'Vasundhara Raje', 'Bharatiya Janata Party (BJP)', 138831, 60.12, 'Won', 'Election Commission of India (https://results.eci.gov.in)'),
(2023, 198, 'Jhalrapatan', 'Ramlal Chouhan', 'Indian National Congress (INC)', 85638, 37.08, 'Runner-up', 'Election Commission of India (https://results.eci.gov.in)'),
(2023, 198, 'Jhalrapatan', 'NOTA', 'None of the Above', 2145, 0.93, 'Lost', 'Election Commission of India (https://results.eci.gov.in)'),

(2018, 198, 'Jhalrapatan', 'Vasundhara Raje', 'Bharatiya Janata Party (BJP)', 116484, 54.14, 'Won', 'Election Commission of India (https://eci.gov.in)'),
(2018, 198, 'Jhalrapatan', 'Manvendra Singh', 'Indian National Congress (INC)', 81587, 37.92, 'Runner-up', 'Election Commission of India (https://eci.gov.in)'),
(2018, 198, 'Jhalrapatan', 'NOTA', 'None of the Above', 2953, 1.37, 'Lost', 'Election Commission of India (https://eci.gov.in)');

-- Elector Statistics (2023 & 2018 AC-198 Jhalrapatan)
INSERT INTO public.elector_statistics (
    election_year, constituency_no, total_electors, male_electors, female_electors, third_gender_electors, total_votes_cast, voter_turnout_percentage, source
) VALUES
(2023, 198, 298450, 153120, 145328, 2, 232338, 77.85, 'ECI Statistical Report 2023 (https://eci.gov.in)'),
(2018, 198, 272390, 141020, 131370, 0, 213596, 78.42, 'ECI Statistical Report 2018 (https://eci.gov.in)');

-- ----------------------------------------------------------------------------
-- 16. GOVERNMENT SERVICES & USEFUL LINKS
-- ----------------------------------------------------------------------------
INSERT INTO public.government_services (service_name, category, official_url, description, active) VALUES
('Rajasthan Sampark Portal (181)', 'Grievance Redressal', 'https://sampark.rajasthan.gov.in', 'Official centralized grievance registration portal and toll-free helpline 181 for citizens.', true),
('Jan Aadhaar Rajasthan Portal', 'Citizen Identity & Welfare', 'https://janaadhaar.rajasthan.gov.in', 'Unified single identity card portal for accessing state welfare schemes and direct benefit transfer (DBT).', true),
('Jan Suchna Portal Rajasthan', 'Right to Information & Transparency', 'https://jansuchna.rajasthan.gov.in', 'Proactive public information portal providing direct access to scheme beneficiary status, MGNREGA muster rolls, and ration distribution.', true),
('e-Mitra Rajasthan Portal', 'Citizen Services Desk', 'https://emitra.rajasthan.gov.in', 'One-stop electronic service delivery platform for revenue certificates, bill payments, and government forms.', true),
('E-Dharti Rajasthan Land Records (Apna Khata)', 'Revenue & Land Records', 'https://apnakhata.rajasthan.gov.in', 'Online portal for viewing Jamabandi land records, Khasra maps, and mutation status.', true);

INSERT INTO public.useful_links (title, category, official_url, description, active) VALUES
('Jhalawar District Administration Official Portal', 'District Portal', 'https://jhalawar.rajasthan.gov.in', 'Official website of District Administration Jhalawar containing contacts, notifications, and tenders.', true),
('Chief Electoral Officer (CEO) Rajasthan', 'Election Portal', 'https://ceorajasthan.nic.in', 'Electoral roll search, polling station locator, and voter ID registration services.', true),
('Election Commission of India (ECI)', 'National Election Portal', 'https://eci.gov.in', 'National portal for election schedules, candidate affidavits, and election results.', true),
('State Election Commission Rajasthan', 'Panchayat & Urban Local Body Elections', 'https://sec.rajasthan.gov.in', 'Panchayat Samiti, Gram Panchayat, and Zila Parishad election information.', true);

COMMIT;
