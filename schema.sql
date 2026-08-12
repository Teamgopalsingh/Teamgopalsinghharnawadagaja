-- ============================================================================
-- Supabase PostgreSQL Schema DDL: Team GopalSingh App
-- Location Focus: Gram Panchayat Harnawada Gaja, Tehsil Pirawa, District Jhalawar, Rajasthan (PIN: 326034)
-- Assembly Constituency: 198 Jhalrapatan
-- ============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Clean teardown (optional, for idempotent execution)
DROP TRIGGER IF EXISTS trg_complaints_ref_no ON public.complaints;
DROP TRIGGER IF EXISTS trg_poll_vote_count ON public.poll_votes;

DROP FUNCTION IF EXISTS public.generate_complaint_ref_no() CASCADE;
DROP FUNCTION IF EXISTS public.update_poll_vote_counts() CASCADE;
DROP FUNCTION IF EXISTS public.set_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.audit_log_trigger_func() CASCADE;
DROP FUNCTION IF EXISTS public.is_admin(UUID) CASCADE;
DROP FUNCTION IF EXISTS public.has_role(UUID, TEXT) CASCADE;

-- DROP TABLES if exists in reverse dependency order
DROP TABLE IF EXISTS public.audit_logs CASCADE;
DROP TABLE IF EXISTS public.poll_votes CASCADE;
DROP TABLE IF EXISTS public.poll_options CASCADE;
DROP TABLE IF EXISTS public.polls CASCADE;
DROP TABLE IF EXISTS public.volunteers CASCADE;
DROP TABLE IF EXISTS public.suggestions CASCADE;
DROP TABLE IF EXISTS public.videos CASCADE;
DROP TABLE IF EXISTS public.photos CASCADE;
DROP TABLE IF EXISTS public.documents CASCADE;
DROP TABLE IF EXISTS public.schemes CASCADE;
DROP TABLE IF EXISTS public.events CASCADE;
DROP TABLE IF EXISTS public.news CASCADE;
DROP TABLE IF EXISTS public.development_projects CASCADE;
DROP TABLE IF EXISTS public.complaint_timeline CASCADE;
DROP TABLE IF EXISTS public.complaints CASCADE;
DROP TABLE IF EXISTS public.official_contacts CASCADE;
DROP TABLE IF EXISTS public.social_links CASCADE;
DROP TABLE IF EXISTS public.team_contacts CASCADE;
DROP TABLE IF EXISTS public.polling_stations CASCADE;
DROP TABLE IF EXISTS public.election_results CASCADE;
DROP TABLE IF EXISTS public.elector_statistics CASCADE;
DROP TABLE IF EXISTS public.election_data_versions CASCADE;
DROP TABLE IF EXISTS public.government_services CASCADE;
DROP TABLE IF EXISTS public.useful_links CASCADE;
DROP TABLE IF EXISTS public.app_settings CASCADE;
DROP TABLE IF EXISTS public.admins CASCADE;
DROP TABLE IF EXISTS public.admin_roles CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;

DROP SEQUENCE IF EXISTS public.complaint_ref_seq CASCADE;

-- ============================================================================
-- 1. CORE USER & ADMIN MANAGEMENT TABLES
-- ============================================================================

-- Users Table
CREATE TABLE public.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    mobile TEXT UNIQUE NOT NULL,
    name TEXT,
    ward TEXT,
    role TEXT NOT NULL DEFAULT 'user',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Admin Roles Table
CREATE TABLE public.admin_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_name TEXT UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Admins Mapping Table
CREATE TABLE public.admins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES public.admin_roles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(user_id, role_id)
);

-- ============================================================================
-- 2. TEAM CONTACTS & SOCIAL LINKS
-- ============================================================================

-- Team GopalSingh Contacts
CREATE TABLE public.team_contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    label TEXT NOT NULL,
    phone TEXT NOT NULL,
    whatsapp_enabled BOOLEAN NOT NULL DEFAULT true,
    public_visible BOOLEAN NOT NULL DEFAULT true,
    display_order INT NOT NULL DEFAULT 0,
    active BOOLEAN NOT NULL DEFAULT true,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Social Links
CREATE TABLE public.social_links (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    platform TEXT NOT NULL,
    display_name TEXT NOT NULL,
    username_or_id TEXT NOT NULL,
    url TEXT NOT NULL,
    icon TEXT,
    display_order INT NOT NULL DEFAULT 0,
    active BOOLEAN NOT NULL DEFAULT true,
    public_visible BOOLEAN NOT NULL DEFAULT true,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================================
-- 3. OFFICIAL CONTACTS (VERIFIED PUBLIC OFFICERS)
-- ============================================================================

CREATE TABLE public.official_contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    officer_name TEXT NOT NULL,
    designation TEXT NOT NULL,
    department TEXT NOT NULL,
    office TEXT,
    jurisdiction TEXT,
    official_phone TEXT,
    office_phone TEXT,
    official_email TEXT,
    office_address TEXT,
    latitude NUMERIC(10, 7),
    longitude NUMERIC(10, 7),
    official_source_url TEXT,
    verified_status TEXT NOT NULL DEFAULT 'Pending' CHECK (verified_status IN ('Pending', 'Verified', 'Rejected')),
    verified_by UUID REFERENCES public.users(id),
    verified_at TIMESTAMPTZ,
    public_visible BOOLEAN NOT NULL DEFAULT true,
    active BOOLEAN NOT NULL DEFAULT true,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================================
-- 4. COMPLAINTS & COMPLAINT TIMELINE
-- ============================================================================

CREATE SEQUENCE public.complaint_ref_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE public.complaints (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reference_no TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    mobile TEXT NOT NULL,
    category TEXT NOT NULL,
    subcategory TEXT,
    description TEXT NOT NULL,
    photo_url TEXT,
    video_url TEXT,
    doc_url TEXT,
    latitude NUMERIC(10, 7),
    longitude NUMERIC(10, 7),
    address TEXT,
    ward TEXT,
    priority TEXT NOT NULL DEFAULT 'Medium' CHECK (priority IN ('Low', 'Medium', 'High', 'Urgent')),
    status TEXT NOT NULL DEFAULT 'Submitted' CHECK (status IN ('Submitted', 'In Progress', 'Resolved', 'Rejected')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.complaint_timeline (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    complaint_id UUID NOT NULL REFERENCES public.complaints(id) ON DELETE CASCADE,
    status TEXT NOT NULL,
    remark TEXT,
    updated_by UUID REFERENCES public.users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================================
-- 5. DEVELOPMENT PROJECTS
-- ============================================================================

CREATE TABLE public.development_projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_name TEXT NOT NULL,
    location TEXT,
    village TEXT NOT NULL,
    ward TEXT,
    scheme TEXT,
    department TEXT,
    approved_amount NUMERIC(15, 2),
    approval_date DATE,
    start_date DATE,
    expected_completion DATE,
    current_status TEXT NOT NULL DEFAULT 'Planned' CHECK (current_status IN ('Planned', 'In Progress', 'Completed', 'On Hold')),
    progress_percentage INT NOT NULL DEFAULT 0 CHECK (progress_percentage BETWEEN 0 AND 100),
    before_photo_url TEXT,
    work_photo_url TEXT,
    after_photo_url TEXT,
    official_doc_url TEXT,
    description TEXT,
    source TEXT,
    verification_date DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================================
-- 6. NEWS & ANNOUNCEMENTS
-- ============================================================================

CREATE TABLE public.news (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    category TEXT NOT NULL,
    cover_image_url TEXT,
    description TEXT NOT NULL,
    gallery_urls TEXT[],
    video_url TEXT,
    source TEXT,
    author TEXT,
    verification_status TEXT NOT NULL DEFAULT 'Verified' CHECK (verification_status IN ('Pending', 'Verified', 'Rejected')),
    published_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================================
-- 7. EVENTS
-- ============================================================================

CREATE TABLE public.events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_name TEXT NOT NULL,
    event_date DATE NOT NULL,
    event_time TIME,
    location TEXT NOT NULL,
    description TEXT,
    image_url TEXT,
    map_url TEXT,
    share_count INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================================
-- 8. GOVERNMENT SCHEMES & PUBLIC DOCUMENTS
-- ============================================================================

CREATE TABLE public.schemes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    scheme_name TEXT NOT NULL,
    category TEXT NOT NULL,
    eligibility TEXT,
    benefits TEXT,
    documents_required TEXT,
    application_process TEXT,
    department TEXT,
    official_website TEXT,
    source TEXT,
    last_verified DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    category TEXT NOT NULL,
    file_url TEXT NOT NULL,
    description TEXT,
    source TEXT,
    verified_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================================
-- 9. PHOTOS & VIDEOS MEDIA GALLERY
-- ============================================================================

CREATE TABLE public.photos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    category TEXT NOT NULL,
    media_url TEXT NOT NULL,
    media_type TEXT NOT NULL DEFAULT 'photo',
    thumbnail_url TEXT,
    source TEXT,
    permission_metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.videos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    category TEXT NOT NULL,
    media_url TEXT NOT NULL,
    media_type TEXT NOT NULL DEFAULT 'video',
    thumbnail_url TEXT,
    source TEXT,
    permission_metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================================
-- 10. PUBLIC POLLS & VOTING SYSTEM
-- ============================================================================

CREATE TABLE public.polls (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question TEXT NOT NULL,
    category TEXT,
    active BOOLEAN NOT NULL DEFAULT true,
    votes_count INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.poll_options (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    poll_id UUID NOT NULL REFERENCES public.polls(id) ON DELETE CASCADE,
    option_text TEXT NOT NULL,
    votes_count INT NOT NULL DEFAULT 0
);

CREATE TABLE public.poll_votes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    poll_id UUID NOT NULL REFERENCES public.polls(id) ON DELETE CASCADE,
    option_id UUID NOT NULL REFERENCES public.poll_options(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    voter_mobile TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(poll_id, user_id)
);

-- ============================================================================
-- 11. SUGGESTIONS & VOLUNTEERS
-- ============================================================================

CREATE TABLE public.suggestions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category TEXT NOT NULL,
    suggestion TEXT NOT NULL,
    photo_url TEXT,
    mobile TEXT,
    name TEXT,
    status TEXT NOT NULL DEFAULT 'Received' CHECK (status IN ('Received', 'Under Review', 'Accepted', 'Archived')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.volunteers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    mobile TEXT NOT NULL,
    ward TEXT,
    interest TEXT,
    availability TEXT,
    status TEXT NOT NULL DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================================
-- 12. ELECTION RECORDS & ECI VERIFIED DATA (AC-198 Jhalrapatan)
-- ============================================================================

CREATE TABLE public.polling_stations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    station_number INT NOT NULL,
    station_name TEXT NOT NULL,
    location TEXT,
    village TEXT,
    ward TEXT,
    latitude NUMERIC(10, 7),
    longitude NUMERIC(10, 7),
    total_voters INT,
    source TEXT,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.election_results (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    election_year INT NOT NULL,
    constituency_no INT NOT NULL DEFAULT 198,
    constituency_name TEXT NOT NULL DEFAULT 'Jhalrapatan',
    candidate_name TEXT NOT NULL,
    party TEXT NOT NULL,
    votes_polled INT NOT NULL,
    vote_percentage NUMERIC(5, 2),
    result_status TEXT CHECK (result_status IN ('Won', 'Runner-up', 'Lost')),
    source TEXT,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.elector_statistics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    election_year INT NOT NULL,
    constituency_no INT NOT NULL DEFAULT 198,
    total_electors INT NOT NULL,
    male_electors INT,
    female_electors INT,
    third_gender_electors INT DEFAULT 0,
    total_votes_cast INT,
    voter_turnout_percentage NUMERIC(5, 2),
    source TEXT,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.election_data_versions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    version_name TEXT NOT NULL,
    description TEXT,
    source_eci_url TEXT,
    published_date DATE,
    is_current BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================================
-- 13. GOVERNMENT SERVICES, USEFUL LINKS & APP SETTINGS
-- ============================================================================

CREATE TABLE public.government_services (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    service_name TEXT NOT NULL,
    category TEXT NOT NULL,
    official_url TEXT NOT NULL,
    description TEXT,
    active BOOLEAN NOT NULL DEFAULT true,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.useful_links (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    category TEXT NOT NULL,
    official_url TEXT NOT NULL,
    description TEXT,
    active BOOLEAN NOT NULL DEFAULT true,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.app_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    key TEXT UNIQUE NOT NULL,
    value TEXT NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================================
-- 14. AUDIT LOGS
-- ============================================================================

CREATE TABLE public.audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    admin_id UUID REFERENCES public.users(id),
    action TEXT NOT NULL,
    target_table TEXT NOT NULL,
    record_id UUID,
    old_values JSONB,
    new_values JSONB,
    ip_address TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================================
-- 15. FUNCTIONS & TRIGGERS
-- ============================================================================

-- Function: Complaint Reference Number Generator (TGS-YYYY-000001)
CREATE OR REPLACE FUNCTION public.generate_complaint_ref_no()
RETURNS TRIGGER AS $$
DECLARE
    v_year TEXT;
    v_seq INT;
BEGIN
    IF NEW.reference_no IS NULL OR NEW.reference_no = '' THEN
        v_year := TO_CHAR(NOW(), 'YYYY');
        v_seq := NEXTVAL('public.complaint_ref_seq');
        NEW.reference_no := 'TGS-' || v_year || '-' || LPAD(v_seq::TEXT, 6, '0');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_complaints_ref_no
BEFORE INSERT ON public.complaints
FOR EACH ROW
EXECUTE FUNCTION public.generate_complaint_ref_no();

-- Function: Automatic updated_at Timestamps
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
CREATE TRIGGER trg_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_team_contacts_updated_at BEFORE UPDATE ON public.team_contacts FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_social_links_updated_at BEFORE UPDATE ON public.social_links FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_official_contacts_updated_at BEFORE UPDATE ON public.official_contacts FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_complaints_updated_at BEFORE UPDATE ON public.complaints FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_dev_projects_updated_at BEFORE UPDATE ON public.development_projects FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_news_updated_at BEFORE UPDATE ON public.news FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_events_updated_at BEFORE UPDATE ON public.events FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_schemes_updated_at BEFORE UPDATE ON public.schemes FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_documents_updated_at BEFORE UPDATE ON public.documents FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_photos_updated_at BEFORE UPDATE ON public.photos FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_videos_updated_at BEFORE UPDATE ON public.videos FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_polls_updated_at BEFORE UPDATE ON public.polls FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_suggestions_updated_at BEFORE UPDATE ON public.suggestions FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_volunteers_updated_at BEFORE UPDATE ON public.volunteers FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_polling_stations_updated_at BEFORE UPDATE ON public.polling_stations FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_election_results_updated_at BEFORE UPDATE ON public.election_results FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_elector_stats_updated_at BEFORE UPDATE ON public.elector_statistics FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_gov_services_updated_at BEFORE UPDATE ON public.government_services FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_useful_links_updated_at BEFORE UPDATE ON public.useful_links FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_app_settings_updated_at BEFORE UPDATE ON public.app_settings FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- Function: Poll Vote Incrementor & Decrementor
CREATE OR REPLACE FUNCTION public.update_poll_vote_counts()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        UPDATE public.polls SET votes_count = votes_count + 1 WHERE id = NEW.poll_id;
        UPDATE public.poll_options SET votes_count = votes_count + 1 WHERE id = NEW.option_id;
    ELSIF (TG_OP = 'DELETE') THEN
        UPDATE public.polls SET votes_count = GREATEST(0, votes_count - 1) WHERE id = OLD.poll_id;
        UPDATE public.poll_options SET votes_count = GREATEST(0, votes_count - 1) WHERE id = OLD.option_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_poll_vote_count
AFTER INSERT OR DELETE ON public.poll_votes
FOR EACH ROW
EXECUTE FUNCTION public.update_poll_vote_counts();

-- Function: Automatic Audit Logging
CREATE OR REPLACE FUNCTION public.audit_log_trigger_func()
RETURNS TRIGGER AS $$
DECLARE
    v_admin_id UUID := NULL;
    v_record_id UUID;
    v_old JSONB := NULL;
    v_new JSONB := NULL;
BEGIN
    BEGIN
        v_admin_id := auth.uid();
    EXCEPTION WHEN OTHERS THEN
        v_admin_id := NULL;
    END;

    IF (TG_OP = 'DELETE') THEN
        v_record_id := OLD.id;
        v_old := to_jsonb(OLD);
    ELSIF (TG_OP = 'UPDATE') THEN
        v_record_id := NEW.id;
        v_old := to_jsonb(OLD);
        v_new := to_jsonb(NEW);
    ELSIF (TG_OP = 'INSERT') THEN
        v_record_id := NEW.id;
        v_new := to_jsonb(NEW);
    END IF;

    INSERT INTO public.audit_logs (admin_id, action, target_table, record_id, old_values, new_values)
    VALUES (v_admin_id, TG_OP, TG_TABLE_NAME, v_record_id, v_old, v_new);

    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Attach Audit Log triggers to critical tables
CREATE TRIGGER trg_audit_official_contacts AFTER INSERT OR UPDATE OR DELETE ON public.official_contacts FOR EACH ROW EXECUTE FUNCTION public.audit_log_trigger_func();
CREATE TRIGGER trg_audit_development_projects AFTER INSERT OR UPDATE OR DELETE ON public.development_projects FOR EACH ROW EXECUTE FUNCTION public.audit_log_trigger_func();
CREATE TRIGGER trg_audit_news AFTER INSERT OR UPDATE OR DELETE ON public.news FOR EACH ROW EXECUTE FUNCTION public.audit_log_trigger_func();
CREATE TRIGGER trg_audit_schemes AFTER INSERT OR UPDATE OR DELETE ON public.schemes FOR EACH ROW EXECUTE FUNCTION public.audit_log_trigger_func();
CREATE TRIGGER trg_audit_documents AFTER INSERT OR UPDATE OR DELETE ON public.documents FOR EACH ROW EXECUTE FUNCTION public.audit_log_trigger_func();
CREATE TRIGGER trg_audit_app_settings AFTER INSERT OR UPDATE OR DELETE ON public.app_settings FOR EACH ROW EXECUTE FUNCTION public.audit_log_trigger_func();

-- ============================================================================
-- 16. HELPER FUNCTIONS FOR ROLE-BASED ACCESS CONTROL (RBAC)
-- ============================================================================

CREATE OR REPLACE FUNCTION public.is_admin(p_user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    IF p_user_id IS NULL THEN
        RETURN FALSE;
    END IF;
    RETURN EXISTS (
        SELECT 1 FROM public.admins a WHERE a.user_id = p_user_id
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.has_role(p_user_id UUID, p_role_name TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    IF p_user_id IS NULL THEN
        RETURN FALSE;
    END IF;
    RETURN EXISTS (
        SELECT 1 
        FROM public.admins a
        JOIN public.admin_roles r ON a.role_id = r.id
        WHERE a.user_id = p_user_id 
          AND (r.role_name = p_role_name OR r.role_name = 'Super Admin')
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- 17. ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS on all public tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admins ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.team_contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.social_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.official_contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.complaints ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.complaint_timeline ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.development_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.news ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.schemes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.videos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.polls ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.poll_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.poll_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.suggestions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.volunteers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.polling_stations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.election_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.elector_statistics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.election_data_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.government_services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.useful_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- RLS POLICIES: users
-- ----------------------------------------------------------------------------
CREATE POLICY "users_select_policy" ON public.users
    FOR SELECT USING (id = auth.uid() OR public.is_admin(auth.uid()));

CREATE POLICY "users_insert_policy" ON public.users
    FOR INSERT WITH CHECK (true);

CREATE POLICY "users_update_policy" ON public.users
    FOR UPDATE USING (id = auth.uid() OR public.is_admin(auth.uid()));

CREATE POLICY "users_delete_policy" ON public.users
    FOR DELETE USING (public.has_role(auth.uid(), 'Super Admin'));

-- ----------------------------------------------------------------------------
-- RLS POLICIES: admin_roles & admins
-- ----------------------------------------------------------------------------
CREATE POLICY "admin_roles_select" ON public.admin_roles
    FOR SELECT USING (public.is_admin(auth.uid()));

CREATE POLICY "admin_roles_write" ON public.admin_roles
    FOR ALL USING (public.has_role(auth.uid(), 'Super Admin'));

CREATE POLICY "admins_select" ON public.admins
    FOR SELECT USING (public.is_admin(auth.uid()));

CREATE POLICY "admins_write" ON public.admins
    FOR ALL USING (public.has_role(auth.uid(), 'Super Admin'));

-- ----------------------------------------------------------------------------
-- RLS POLICIES: team_contacts & social_links
-- ----------------------------------------------------------------------------
CREATE POLICY "team_contacts_public_select" ON public.team_contacts
    FOR SELECT USING (active = true AND public_visible = true OR public.is_admin(auth.uid()));

CREATE POLICY "team_contacts_admin_write" ON public.team_contacts
    FOR ALL USING (public.has_role(auth.uid(), 'Super Admin'));

CREATE POLICY "social_links_public_select" ON public.social_links
    FOR SELECT USING (active = true AND public_visible = true OR public.is_admin(auth.uid()));

CREATE POLICY "social_links_admin_write" ON public.social_links
    FOR ALL USING (public.has_role(auth.uid(), 'Super Admin'));

-- ----------------------------------------------------------------------------
-- RLS POLICIES: official_contacts
-- ----------------------------------------------------------------------------
CREATE POLICY "official_contacts_public_select" ON public.official_contacts
    FOR SELECT USING (verified_status = 'Verified' AND active = true AND public_visible = true OR public.is_admin(auth.uid()));

CREATE POLICY "official_contacts_admin_write" ON public.official_contacts
    FOR ALL USING (public.has_role(auth.uid(), 'Verification Admin') OR public.has_role(auth.uid(), 'Super Admin'));

-- ----------------------------------------------------------------------------
-- RLS POLICIES: complaints & complaint_timeline
-- ----------------------------------------------------------------------------
CREATE POLICY "complaints_public_insert" ON public.complaints
    FOR INSERT WITH CHECK (true);

CREATE POLICY "complaints_user_or_admin_select" ON public.complaints
    FOR SELECT USING (
        mobile = (SELECT mobile FROM public.users WHERE id = auth.uid())
        OR public.has_role(auth.uid(), 'Complaint Admin')
        OR public.has_role(auth.uid(), 'Super Admin')
    );

CREATE POLICY "complaints_admin_update" ON public.complaints
    FOR UPDATE USING (
        public.has_role(auth.uid(), 'Complaint Admin')
        OR public.has_role(auth.uid(), 'Super Admin')
    );

CREATE POLICY "complaint_timeline_select" ON public.complaint_timeline
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.complaints c 
            WHERE c.id = complaint_id 
              AND (
                c.mobile = (SELECT mobile FROM public.users WHERE id = auth.uid())
                OR public.has_role(auth.uid(), 'Complaint Admin')
                OR public.has_role(auth.uid(), 'Super Admin')
              )
        )
    );

CREATE POLICY "complaint_timeline_admin_insert" ON public.complaint_timeline
    FOR INSERT WITH CHECK (
        public.has_role(auth.uid(), 'Complaint Admin')
        OR public.has_role(auth.uid(), 'Super Admin')
    );

-- ----------------------------------------------------------------------------
-- RLS POLICIES: development_projects
-- ----------------------------------------------------------------------------
CREATE POLICY "development_projects_public_select" ON public.development_projects
    FOR SELECT USING (true);

CREATE POLICY "development_projects_admin_write" ON public.development_projects
    FOR ALL USING (
        public.has_role(auth.uid(), 'Development Admin')
        OR public.has_role(auth.uid(), 'Super Admin')
    );

-- ----------------------------------------------------------------------------
-- RLS POLICIES: news, events, schemes, documents
-- ----------------------------------------------------------------------------
CREATE POLICY "news_public_select" ON public.news
    FOR SELECT USING (verification_status = 'Verified' OR public.is_admin(auth.uid()));

CREATE POLICY "news_admin_write" ON public.news
    FOR ALL USING (
        public.has_role(auth.uid(), 'Verification Admin')
        OR public.has_role(auth.uid(), 'Super Admin')
    );

CREATE POLICY "events_public_select" ON public.events
    FOR SELECT USING (true);

CREATE POLICY "events_admin_write" ON public.events
    FOR ALL USING (public.is_admin(auth.uid()));

CREATE POLICY "schemes_public_select" ON public.schemes
    FOR SELECT USING (true);

CREATE POLICY "schemes_admin_write" ON public.schemes
    FOR ALL USING (public.is_admin(auth.uid()));

CREATE POLICY "documents_public_select" ON public.documents
    FOR SELECT USING (verified_at IS NOT NULL OR public.is_admin(auth.uid()));

CREATE POLICY "documents_admin_write" ON public.documents
    FOR ALL USING (
        public.has_role(auth.uid(), 'Verification Admin')
        OR public.has_role(auth.uid(), 'Super Admin')
    );

-- ----------------------------------------------------------------------------
-- RLS POLICIES: photos & videos
-- ----------------------------------------------------------------------------
CREATE POLICY "photos_public_select" ON public.photos FOR SELECT USING (true);
CREATE POLICY "photos_admin_write" ON public.photos FOR ALL USING (public.is_admin(auth.uid()));

CREATE POLICY "videos_public_select" ON public.videos FOR SELECT USING (true);
CREATE POLICY "videos_admin_write" ON public.videos FOR ALL USING (public.is_admin(auth.uid()));

-- ----------------------------------------------------------------------------
-- RLS POLICIES: polls, poll_options, poll_votes
-- ----------------------------------------------------------------------------
CREATE POLICY "polls_public_select" ON public.polls FOR SELECT USING (active = true OR public.is_admin(auth.uid()));
CREATE POLICY "polls_admin_write" ON public.polls FOR ALL USING (public.is_admin(auth.uid()));

CREATE POLICY "poll_options_public_select" ON public.poll_options FOR SELECT USING (true);
CREATE POLICY "poll_options_admin_write" ON public.poll_options FOR ALL USING (public.is_admin(auth.uid()));

CREATE POLICY "poll_votes_public_insert" ON public.poll_votes FOR INSERT WITH CHECK (true);
CREATE POLICY "poll_votes_select" ON public.poll_votes FOR SELECT USING (user_id = auth.uid() OR public.is_admin(auth.uid()));

-- ----------------------------------------------------------------------------
-- RLS POLICIES: suggestions & volunteers
-- ----------------------------------------------------------------------------
CREATE POLICY "suggestions_public_insert" ON public.suggestions FOR INSERT WITH CHECK (true);
CREATE POLICY "suggestions_admin_select_write" ON public.suggestions FOR ALL USING (public.is_admin(auth.uid()));

CREATE POLICY "volunteers_public_insert" ON public.volunteers FOR INSERT WITH CHECK (true);
CREATE POLICY "volunteers_admin_select_write" ON public.volunteers FOR ALL USING (public.is_admin(auth.uid()));

-- ----------------------------------------------------------------------------
-- RLS POLICIES: election records (AC-198 Jhalrapatan ECI Verified Data)
-- ----------------------------------------------------------------------------
CREATE POLICY "polling_stations_public_select" ON public.polling_stations FOR SELECT USING (true);
CREATE POLICY "polling_stations_admin_write" ON public.polling_stations FOR ALL USING (
    public.has_role(auth.uid(), 'Election Data Admin') OR public.has_role(auth.uid(), 'Super Admin')
);

CREATE POLICY "election_results_public_select" ON public.election_results FOR SELECT USING (true);
CREATE POLICY "election_results_admin_write" ON public.election_results FOR ALL USING (
    public.has_role(auth.uid(), 'Election Data Admin') OR public.has_role(auth.uid(), 'Super Admin')
);

CREATE POLICY "elector_stats_public_select" ON public.elector_statistics FOR SELECT USING (true);
CREATE POLICY "elector_stats_admin_write" ON public.elector_statistics FOR ALL USING (
    public.has_role(auth.uid(), 'Election Data Admin') OR public.has_role(auth.uid(), 'Super Admin')
);

CREATE POLICY "election_data_versions_public_select" ON public.election_data_versions FOR SELECT USING (true);
CREATE POLICY "election_data_versions_admin_write" ON public.election_data_versions FOR ALL USING (
    public.has_role(auth.uid(), 'Election Data Admin') OR public.has_role(auth.uid(), 'Super Admin')
);

-- ----------------------------------------------------------------------------
-- RLS POLICIES: government_services, useful_links, app_settings, audit_logs
-- ----------------------------------------------------------------------------
CREATE POLICY "gov_services_public_select" ON public.government_services FOR SELECT USING (active = true OR public.is_admin(auth.uid()));
CREATE POLICY "gov_services_admin_write" ON public.government_services FOR ALL USING (public.is_admin(auth.uid()));

CREATE POLICY "useful_links_public_select" ON public.useful_links FOR SELECT USING (active = true OR public.is_admin(auth.uid()));
CREATE POLICY "useful_links_admin_write" ON public.useful_links FOR ALL USING (public.is_admin(auth.uid()));

CREATE POLICY "app_settings_public_select" ON public.app_settings FOR SELECT USING (true);
CREATE POLICY "app_settings_admin_write" ON public.app_settings FOR ALL USING (public.has_role(auth.uid(), 'Super Admin'));

CREATE POLICY "audit_logs_admin_select" ON public.audit_logs FOR SELECT USING (public.has_role(auth.uid(), 'Super Admin'));
