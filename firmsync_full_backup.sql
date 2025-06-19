--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9
-- Dumped by pg_dump version 16.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_ghost_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_ghost_sessions (
    id integer NOT NULL,
    admin_user_id integer NOT NULL,
    target_firm_id integer NOT NULL,
    session_token uuid DEFAULT gen_random_uuid() NOT NULL,
    is_active boolean DEFAULT true,
    permissions jsonb,
    audit_trail jsonb,
    started_at timestamp without time zone DEFAULT now(),
    ended_at timestamp without time zone,
    ip_address text,
    user_agent text
);


--
-- Name: admin_ghost_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admin_ghost_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_ghost_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admin_ghost_sessions_id_seq OWNED BY public.admin_ghost_sessions.id;


--
-- Name: ai_triage_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_triage_results (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    intake_id integer,
    document_id integer,
    resource_type text NOT NULL,
    ai_case_type text NOT NULL,
    ai_urgency_level text NOT NULL,
    ai_recommended_actions text[],
    ai_summary text NOT NULL,
    ai_confidence_score integer NOT NULL,
    suggested_assignee integer,
    flagged_issues text[],
    estimated_complexity text NOT NULL,
    is_human_reviewed boolean DEFAULT false,
    human_override jsonb,
    created_at timestamp without time zone DEFAULT now(),
    reviewed_at timestamp without time zone
);


--
-- Name: ai_triage_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ai_triage_results_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ai_triage_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ai_triage_results_id_seq OWNED BY public.ai_triage_results.id;


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_logs (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    actor_id integer NOT NULL,
    actor_name text NOT NULL,
    action text NOT NULL,
    resource_type text NOT NULL,
    resource_id text,
    details jsonb,
    ip_address text,
    user_agent text,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL,
    user_id integer
);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: available_integrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.available_integrations (
    id integer NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    description text,
    oauth_config jsonb,
    is_active boolean DEFAULT true,
    requires_setup boolean DEFAULT true,
    icon_url text,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: available_integrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.available_integrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: available_integrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.available_integrations_id_seq OWNED BY public.available_integrations.id;


--
-- Name: billing_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.billing_permissions (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    user_id integer NOT NULL,
    can_view_billing boolean DEFAULT false,
    can_edit_billing boolean DEFAULT false,
    can_create_invoices boolean DEFAULT false,
    can_view_reports boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: billing_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.billing_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: billing_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.billing_permissions_id_seq OWNED BY public.billing_permissions.id;


--
-- Name: calendar_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.calendar_events (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    case_id integer,
    client_id integer,
    document_id integer,
    title text NOT NULL,
    description text,
    event_type text NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    location text,
    is_all_day boolean DEFAULT false,
    is_ai_suggested boolean DEFAULT false,
    ai_confidence integer,
    status text DEFAULT 'scheduled'::text NOT NULL,
    reminder_minutes integer DEFAULT 60,
    google_calendar_id text,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: calendar_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.calendar_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calendar_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.calendar_events_id_seq OWNED BY public.calendar_events.id;


--
-- Name: cases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cases (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    client_id integer NOT NULL,
    name text NOT NULL,
    description text,
    case_number text,
    status text DEFAULT 'active'::text NOT NULL,
    billing_type text DEFAULT 'hourly'::text NOT NULL,
    hourly_rate integer,
    flat_fee integer,
    contingency_rate integer,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: cases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cases_id_seq OWNED BY public.cases.id;


--
-- Name: client_intakes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_intakes (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    intake_number text NOT NULL,
    client_name text NOT NULL,
    client_email text NOT NULL,
    client_phone text,
    region text NOT NULL,
    matter_type text NOT NULL,
    case_type text NOT NULL,
    urgency_level text NOT NULL,
    case_description text NOT NULL,
    preferred_contact_method text DEFAULT 'email'::text NOT NULL,
    available_time_slots text[],
    document_ids text[],
    status text DEFAULT 'received'::text NOT NULL,
    assigned_to integer,
    ai_triage_data jsonb,
    follow_up_date timestamp without time zone,
    is_portal_enabled boolean DEFAULT true,
    submitted_at timestamp without time zone DEFAULT now(),
    processed_at timestamp without time zone,
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: client_intakes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.client_intakes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: client_intakes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.client_intakes_id_seq OWNED BY public.client_intakes.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    name text NOT NULL,
    email text,
    phone text,
    address text,
    status text DEFAULT 'active'::text NOT NULL,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: communication_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.communication_logs (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    client_id integer NOT NULL,
    case_id integer,
    user_id integer NOT NULL,
    type text NOT NULL,
    direction text,
    subject text,
    content text NOT NULL,
    attachments jsonb,
    metadata jsonb,
    is_private boolean DEFAULT true,
    tags text[],
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: communication_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.communication_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: communication_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.communication_logs_id_seq OWNED BY public.communication_logs.id;


--
-- Name: document_analyses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.document_analyses (
    id integer NOT NULL,
    document_id integer NOT NULL,
    analysis_type text NOT NULL,
    result jsonb NOT NULL,
    confidence integer,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: document_analyses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.document_analyses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: document_analyses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.document_analyses_id_seq OWNED BY public.document_analyses.id;


--
-- Name: document_type_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.document_type_templates (
    id integer NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    category text NOT NULL,
    vertical text DEFAULT 'firmsync'::text NOT NULL,
    default_config jsonb NOT NULL,
    prompt_override text,
    keywords text[],
    is_active boolean DEFAULT true,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: document_type_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.document_type_templates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: document_type_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.document_type_templates_id_seq OWNED BY public.document_type_templates.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.documents (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    folder_id integer,
    user_id integer NOT NULL,
    filename text NOT NULL,
    original_name text NOT NULL,
    file_size integer NOT NULL,
    mime_type text NOT NULL,
    document_type text,
    content text,
    tags text[],
    status text DEFAULT 'uploaded'::text NOT NULL,
    uploaded_at timestamp without time zone DEFAULT now(),
    analyzed_at timestamp without time zone,
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- Name: firm_analysis_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.firm_analysis_settings (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    summarization boolean DEFAULT true,
    risk_analysis boolean DEFAULT true,
    clause_extraction boolean DEFAULT true,
    cross_reference boolean DEFAULT false,
    formatting boolean DEFAULT true,
    auto_analysis boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: firm_analysis_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.firm_analysis_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: firm_analysis_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.firm_analysis_settings_id_seq OWNED BY public.firm_analysis_settings.id;


--
-- Name: firm_billing_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.firm_billing_settings (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    default_hourly_rate integer DEFAULT 25000,
    default_flat_rate integer DEFAULT 500000,
    default_contingency_rate integer DEFAULT 3300,
    invoice_terms text DEFAULT 'Payment due within 30 days'::text,
    logo_url text,
    billing_platform text,
    billing_platform_url text,
    lock_time_logs_after_days integer DEFAULT 30,
    hide_analytics_tab boolean DEFAULT false,
    billing_enabled boolean DEFAULT false,
    stripe_enabled boolean DEFAULT false,
    stripe_publishable_key text,
    stripe_secret_key text,
    stripe_webhook_secret text,
    lawpay_enabled boolean DEFAULT false,
    lawpay_api_key text,
    lawpay_merchant_id text,
    client_portal_enabled boolean DEFAULT false,
    require_client_login boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: firm_billing_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.firm_billing_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: firm_billing_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.firm_billing_settings_id_seq OWNED BY public.firm_billing_settings.id;


--
-- Name: firm_form_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.firm_form_templates (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    name text NOT NULL,
    document_type text NOT NULL,
    template_content text NOT NULL,
    file_name text NOT NULL,
    file_size integer NOT NULL,
    mime_type text NOT NULL,
    is_active boolean DEFAULT true,
    uploaded_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: firm_form_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.firm_form_templates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: firm_form_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.firm_form_templates_id_seq OWNED BY public.firm_form_templates.id;


--
-- Name: firm_integrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.firm_integrations (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    integration_id integer NOT NULL,
    enabled_by integer NOT NULL,
    is_enabled boolean DEFAULT true,
    configuration jsonb,
    api_credentials text,
    webhook_secret character varying(255),
    last_sync_at timestamp without time zone,
    sync_status character varying(50) DEFAULT 'pending'::character varying,
    error_message text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: firm_integrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.firm_integrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: firm_integrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.firm_integrations_id_seq OWNED BY public.firm_integrations.id;


--
-- Name: firms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.firms (
    id integer NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    domain text,
    plan text DEFAULT 'starter'::text NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    settings jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    onboarded boolean DEFAULT false NOT NULL
);


--
-- Name: firms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.firms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: firms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.firms_id_seq OWNED BY public.firms.id;


--
-- Name: folders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.folders (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    parent_id integer,
    name text NOT NULL,
    description text,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: folders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.folders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.folders_id_seq OWNED BY public.folders.id;


--
-- Name: generated_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.generated_documents (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    user_id integer NOT NULL,
    document_type text NOT NULL,
    county text NOT NULL,
    template_id integer,
    form_data jsonb NOT NULL,
    generated_content text NOT NULL,
    ai_prompt text,
    status text DEFAULT 'generated'::text NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: generated_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.generated_documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: generated_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.generated_documents_id_seq OWNED BY public.generated_documents.id;


--
-- Name: integration_audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.integration_audit_logs (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    integration_id integer NOT NULL,
    user_id integer NOT NULL,
    action character varying(100) NOT NULL,
    details jsonb,
    ip_address inet,
    user_agent text,
    success boolean DEFAULT true,
    error_message text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: integration_audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.integration_audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: integration_audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.integration_audit_logs_id_seq OWNED BY public.integration_audit_logs.id;


--
-- Name: integration_rate_limits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.integration_rate_limits (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    integration_id integer NOT NULL,
    requests_per_hour integer,
    requests_per_day integer,
    current_hourly_usage integer DEFAULT 0,
    current_daily_usage integer DEFAULT 0,
    last_reset_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_blocked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: integration_rate_limits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.integration_rate_limits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: integration_rate_limits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.integration_rate_limits_id_seq OWNED BY public.integration_rate_limits.id;


--
-- Name: invoice_line_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoice_line_items (
    id integer NOT NULL,
    invoice_id integer NOT NULL,
    time_log_id integer,
    description text NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    rate integer NOT NULL,
    amount integer NOT NULL,
    sort_order integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: invoice_line_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invoice_line_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_line_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invoice_line_items_id_seq OWNED BY public.invoice_line_items.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoices (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    client_id integer NOT NULL,
    case_id integer,
    invoice_number text NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    subtotal integer NOT NULL,
    tax_amount integer DEFAULT 0,
    total integer NOT NULL,
    due_date timestamp without time zone,
    paid_date timestamp without time zone,
    notes text,
    terms text,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invoices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invoices_id_seq OWNED BY public.invoices.id;


--
-- Name: message_threads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.message_threads (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    thread_id text NOT NULL,
    title text NOT NULL,
    document_id integer,
    filename text,
    is_resolved boolean DEFAULT false,
    resolved_by integer,
    resolved_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: message_threads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.message_threads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: message_threads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.message_threads_id_seq OWNED BY public.message_threads.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id integer NOT NULL,
    thread_id text NOT NULL,
    firm_id integer NOT NULL,
    sender_id integer,
    sender_role text NOT NULL,
    sender_name text NOT NULL,
    recipient_role text,
    content text NOT NULL,
    is_system_message boolean DEFAULT false,
    read_by jsonb DEFAULT '[]'::jsonb,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    user_id integer NOT NULL,
    type text NOT NULL,
    title text NOT NULL,
    message text NOT NULL,
    resource_type text,
    resource_id text,
    is_read boolean DEFAULT false,
    is_email_sent boolean DEFAULT false,
    priority text DEFAULT 'normal'::text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    read_at timestamp without time zone
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: platform_integrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.platform_integrations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    category character varying(100) NOT NULL,
    provider character varying(255) NOT NULL,
    auth_type character varying(50) NOT NULL,
    status character varying(20) DEFAULT 'active'::character varying,
    version character varying(50),
    settings jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    slug text,
    logo_url text,
    webhook_url text,
    api_base_url text,
    is_active boolean DEFAULT true,
    requires_approval boolean DEFAULT false,
    plan_restrictions text[],
    config_schema jsonb,
    CONSTRAINT platform_integrations_auth_type_check CHECK (((auth_type)::text = ANY ((ARRAY['API_KEY'::character varying, 'OAUTH2'::character varying, 'BASIC_AUTH'::character varying])::text[]))),
    CONSTRAINT platform_integrations_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'inactive'::character varying, 'deprecated'::character varying])::text[])))
);


--
-- Name: platform_integrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.platform_integrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: platform_integrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.platform_integrations_id_seq OWNED BY public.platform_integrations.id;


--
-- Name: platform_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.platform_settings (
    id integer NOT NULL,
    key text NOT NULL,
    value jsonb NOT NULL,
    description text,
    category text NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: platform_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.platform_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: platform_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.platform_settings_id_seq OWNED BY public.platform_settings.id;


--
-- Name: session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session (
    sid character varying NOT NULL,
    sess json NOT NULL,
    expire timestamp(6) without time zone NOT NULL
);


--
-- Name: system_admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.system_admins (
    id integer NOT NULL,
    email text NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    role text DEFAULT 'admin'::text NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: system_admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.system_admins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.system_admins_id_seq OWNED BY public.system_admins.id;


--
-- Name: time_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.time_logs (
    id integer NOT NULL,
    firm_id integer NOT NULL,
    user_id integer NOT NULL,
    client_id integer,
    case_id integer,
    description text NOT NULL,
    hours integer NOT NULL,
    custom_field text,
    billable_rate integer,
    is_locked boolean DEFAULT false,
    locked_at timestamp without time zone,
    invoice_id integer,
    logged_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: time_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.time_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: time_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.time_logs_id_seq OWNED BY public.time_logs.id;


--
-- Name: user_integration_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_integration_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    firm_integration_id integer NOT NULL,
    granted_by integer NOT NULL,
    can_read boolean DEFAULT true,
    can_write boolean DEFAULT false,
    can_configure boolean DEFAULT false,
    can_disable boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: user_integration_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_integration_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_integration_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_integration_permissions_id_seq OWNED BY public.user_integration_permissions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    firm_id integer,
    email text NOT NULL,
    username text,
    password text NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    role text DEFAULT 'viewer'::text NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    last_login_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: admin_ghost_sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_ghost_sessions ALTER COLUMN id SET DEFAULT nextval('public.admin_ghost_sessions_id_seq'::regclass);


--
-- Name: ai_triage_results id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_triage_results ALTER COLUMN id SET DEFAULT nextval('public.ai_triage_results_id_seq'::regclass);


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: available_integrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.available_integrations ALTER COLUMN id SET DEFAULT nextval('public.available_integrations_id_seq'::regclass);


--
-- Name: billing_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing_permissions ALTER COLUMN id SET DEFAULT nextval('public.billing_permissions_id_seq'::regclass);


--
-- Name: calendar_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendar_events ALTER COLUMN id SET DEFAULT nextval('public.calendar_events_id_seq'::regclass);


--
-- Name: cases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cases ALTER COLUMN id SET DEFAULT nextval('public.cases_id_seq'::regclass);


--
-- Name: client_intakes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_intakes ALTER COLUMN id SET DEFAULT nextval('public.client_intakes_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: communication_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communication_logs ALTER COLUMN id SET DEFAULT nextval('public.communication_logs_id_seq'::regclass);


--
-- Name: document_analyses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_analyses ALTER COLUMN id SET DEFAULT nextval('public.document_analyses_id_seq'::regclass);


--
-- Name: document_type_templates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_type_templates ALTER COLUMN id SET DEFAULT nextval('public.document_type_templates_id_seq'::regclass);


--
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- Name: firm_analysis_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firm_analysis_settings ALTER COLUMN id SET DEFAULT nextval('public.firm_analysis_settings_id_seq'::regclass);


--
-- Name: firm_billing_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firm_billing_settings ALTER COLUMN id SET DEFAULT nextval('public.firm_billing_settings_id_seq'::regclass);


--
-- Name: firm_form_templates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firm_form_templates ALTER COLUMN id SET DEFAULT nextval('public.firm_form_templates_id_seq'::regclass);


--
-- Name: firm_integrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firm_integrations ALTER COLUMN id SET DEFAULT nextval('public.firm_integrations_id_seq'::regclass);


--
-- Name: firms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firms ALTER COLUMN id SET DEFAULT nextval('public.firms_id_seq'::regclass);


--
-- Name: folders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.folders ALTER COLUMN id SET DEFAULT nextval('public.folders_id_seq'::regclass);


--
-- Name: generated_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generated_documents ALTER COLUMN id SET DEFAULT nextval('public.generated_documents_id_seq'::regclass);


--
-- Name: integration_audit_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integration_audit_logs ALTER COLUMN id SET DEFAULT nextval('public.integration_audit_logs_id_seq'::regclass);


--
-- Name: integration_rate_limits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integration_rate_limits ALTER COLUMN id SET DEFAULT nextval('public.integration_rate_limits_id_seq'::regclass);


--
-- Name: invoice_line_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_line_items ALTER COLUMN id SET DEFAULT nextval('public.invoice_line_items_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- Name: message_threads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_threads ALTER COLUMN id SET DEFAULT nextval('public.message_threads_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: platform_integrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_integrations ALTER COLUMN id SET DEFAULT nextval('public.platform_integrations_id_seq'::regclass);


--
-- Name: platform_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_settings ALTER COLUMN id SET DEFAULT nextval('public.platform_settings_id_seq'::regclass);


--
-- Name: system_admins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_admins ALTER COLUMN id SET DEFAULT nextval('public.system_admins_id_seq'::regclass);


--
-- Name: time_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_logs ALTER COLUMN id SET DEFAULT nextval('public.time_logs_id_seq'::regclass);


--
-- Name: user_integration_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_integration_permissions ALTER COLUMN id SET DEFAULT nextval('public.user_integration_permissions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: admin_ghost_sessions admin_ghost_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_ghost_sessions
    ADD CONSTRAINT admin_ghost_sessions_pkey PRIMARY KEY (id);


--
-- Name: admin_ghost_sessions admin_ghost_sessions_session_token_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_ghost_sessions
    ADD CONSTRAINT admin_ghost_sessions_session_token_unique UNIQUE (session_token);


--
-- Name: ai_triage_results ai_triage_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_triage_results
    ADD CONSTRAINT ai_triage_results_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: available_integrations available_integrations_name_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.available_integrations
    ADD CONSTRAINT available_integrations_name_unique UNIQUE (name);


--
-- Name: available_integrations available_integrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.available_integrations
    ADD CONSTRAINT available_integrations_pkey PRIMARY KEY (id);


--
-- Name: billing_permissions billing_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing_permissions
    ADD CONSTRAINT billing_permissions_pkey PRIMARY KEY (id);


--
-- Name: calendar_events calendar_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendar_events
    ADD CONSTRAINT calendar_events_pkey PRIMARY KEY (id);


--
-- Name: cases cases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_pkey PRIMARY KEY (id);


--
-- Name: client_intakes client_intakes_intake_number_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_intakes
    ADD CONSTRAINT client_intakes_intake_number_unique UNIQUE (intake_number);


--
-- Name: client_intakes client_intakes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_intakes
    ADD CONSTRAINT client_intakes_pkey PRIMARY KEY (id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: communication_logs communication_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communication_logs
    ADD CONSTRAINT communication_logs_pkey PRIMARY KEY (id);


--
-- Name: document_analyses document_analyses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_analyses
    ADD CONSTRAINT document_analyses_pkey PRIMARY KEY (id);


--
-- Name: document_type_templates document_type_templates_name_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_type_templates
    ADD CONSTRAINT document_type_templates_name_unique UNIQUE (name);


--
-- Name: document_type_templates document_type_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_type_templates
    ADD CONSTRAINT document_type_templates_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: firm_analysis_settings firm_analysis_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firm_analysis_settings
    ADD CONSTRAINT firm_analysis_settings_pkey PRIMARY KEY (id);


--
-- Name: firm_billing_settings firm_billing_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firm_billing_settings
    ADD CONSTRAINT firm_billing_settings_pkey PRIMARY KEY (id);


--
-- Name: firm_form_templates firm_form_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firm_form_templates
    ADD CONSTRAINT firm_form_templates_pkey PRIMARY KEY (id);


--
-- Name: firm_integrations firm_integrations_firm_id_integration_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firm_integrations
    ADD CONSTRAINT firm_integrations_firm_id_integration_id_key UNIQUE (firm_id, integration_id);


--
-- Name: firm_integrations firm_integrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firm_integrations
    ADD CONSTRAINT firm_integrations_pkey PRIMARY KEY (id);


--
-- Name: firms firms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firms
    ADD CONSTRAINT firms_pkey PRIMARY KEY (id);


--
-- Name: firms firms_slug_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firms
    ADD CONSTRAINT firms_slug_unique UNIQUE (slug);


--
-- Name: folders folders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.folders
    ADD CONSTRAINT folders_pkey PRIMARY KEY (id);


--
-- Name: generated_documents generated_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generated_documents
    ADD CONSTRAINT generated_documents_pkey PRIMARY KEY (id);


--
-- Name: integration_audit_logs integration_audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integration_audit_logs
    ADD CONSTRAINT integration_audit_logs_pkey PRIMARY KEY (id);


--
-- Name: integration_rate_limits integration_rate_limits_firm_id_integration_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integration_rate_limits
    ADD CONSTRAINT integration_rate_limits_firm_id_integration_id_key UNIQUE (firm_id, integration_id);


--
-- Name: integration_rate_limits integration_rate_limits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integration_rate_limits
    ADD CONSTRAINT integration_rate_limits_pkey PRIMARY KEY (id);


--
-- Name: invoice_line_items invoice_line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_line_items
    ADD CONSTRAINT invoice_line_items_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: message_threads message_threads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_threads
    ADD CONSTRAINT message_threads_pkey PRIMARY KEY (id);


--
-- Name: message_threads message_threads_thread_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_threads
    ADD CONSTRAINT message_threads_thread_id_unique UNIQUE (thread_id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: platform_integrations platform_integrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_integrations
    ADD CONSTRAINT platform_integrations_pkey PRIMARY KEY (id);


--
-- Name: platform_integrations platform_integrations_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_integrations
    ADD CONSTRAINT platform_integrations_slug_key UNIQUE (slug);


--
-- Name: platform_settings platform_settings_key_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_settings
    ADD CONSTRAINT platform_settings_key_unique UNIQUE (key);


--
-- Name: platform_settings platform_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_settings
    ADD CONSTRAINT platform_settings_pkey PRIMARY KEY (id);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (sid);


--
-- Name: system_admins system_admins_email_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_admins
    ADD CONSTRAINT system_admins_email_unique UNIQUE (email);


--
-- Name: system_admins system_admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_admins
    ADD CONSTRAINT system_admins_pkey PRIMARY KEY (id);


--
-- Name: time_logs time_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_logs
    ADD CONSTRAINT time_logs_pkey PRIMARY KEY (id);


--
-- Name: user_integration_permissions user_integration_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_integration_permissions
    ADD CONSTRAINT user_integration_permissions_pkey PRIMARY KEY (id);


--
-- Name: user_integration_permissions user_integration_permissions_user_id_firm_integration_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_integration_permissions
    ADD CONSTRAINT user_integration_permissions_user_id_firm_integration_id_key UNIQUE (user_id, firm_integration_id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: IDX_session_expire; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_session_expire" ON public.session USING btree (expire);


--
-- Name: admin_ghost_sessions admin_ghost_sessions_admin_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_ghost_sessions
    ADD CONSTRAINT admin_ghost_sessions_admin_user_id_users_id_fk FOREIGN KEY (admin_user_id) REFERENCES public.users(id);


--
-- Name: admin_ghost_sessions admin_ghost_sessions_target_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_ghost_sessions
    ADD CONSTRAINT admin_ghost_sessions_target_firm_id_firms_id_fk FOREIGN KEY (target_firm_id) REFERENCES public.firms(id);


--
-- Name: ai_triage_results ai_triage_results_document_id_documents_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_triage_results
    ADD CONSTRAINT ai_triage_results_document_id_documents_id_fk FOREIGN KEY (document_id) REFERENCES public.documents(id);


--
-- Name: ai_triage_results ai_triage_results_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_triage_results
    ADD CONSTRAINT ai_triage_results_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: ai_triage_results ai_triage_results_intake_id_client_intakes_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_triage_results
    ADD CONSTRAINT ai_triage_results_intake_id_client_intakes_id_fk FOREIGN KEY (intake_id) REFERENCES public.client_intakes(id);


--
-- Name: ai_triage_results ai_triage_results_suggested_assignee_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_triage_results
    ADD CONSTRAINT ai_triage_results_suggested_assignee_users_id_fk FOREIGN KEY (suggested_assignee) REFERENCES public.users(id);


--
-- Name: audit_logs audit_logs_actor_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_actor_id_users_id_fk FOREIGN KEY (actor_id) REFERENCES public.users(id);


--
-- Name: audit_logs audit_logs_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: audit_logs audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: billing_permissions billing_permissions_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing_permissions
    ADD CONSTRAINT billing_permissions_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: billing_permissions billing_permissions_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing_permissions
    ADD CONSTRAINT billing_permissions_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: calendar_events calendar_events_case_id_cases_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendar_events
    ADD CONSTRAINT calendar_events_case_id_cases_id_fk FOREIGN KEY (case_id) REFERENCES public.cases(id);


--
-- Name: calendar_events calendar_events_client_id_clients_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendar_events
    ADD CONSTRAINT calendar_events_client_id_clients_id_fk FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: calendar_events calendar_events_created_by_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendar_events
    ADD CONSTRAINT calendar_events_created_by_users_id_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: calendar_events calendar_events_document_id_documents_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendar_events
    ADD CONSTRAINT calendar_events_document_id_documents_id_fk FOREIGN KEY (document_id) REFERENCES public.documents(id);


--
-- Name: calendar_events calendar_events_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendar_events
    ADD CONSTRAINT calendar_events_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: cases cases_client_id_clients_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_client_id_clients_id_fk FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: cases cases_created_by_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_created_by_users_id_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: cases cases_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: client_intakes client_intakes_assigned_to_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_intakes
    ADD CONSTRAINT client_intakes_assigned_to_users_id_fk FOREIGN KEY (assigned_to) REFERENCES public.users(id);


--
-- Name: client_intakes client_intakes_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_intakes
    ADD CONSTRAINT client_intakes_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: clients clients_created_by_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_created_by_users_id_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: clients clients_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: communication_logs communication_logs_case_id_cases_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communication_logs
    ADD CONSTRAINT communication_logs_case_id_cases_id_fk FOREIGN KEY (case_id) REFERENCES public.cases(id);


--
-- Name: communication_logs communication_logs_client_id_client_intakes_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communication_logs
    ADD CONSTRAINT communication_logs_client_id_client_intakes_id_fk FOREIGN KEY (client_id) REFERENCES public.client_intakes(id);


--
-- Name: communication_logs communication_logs_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communication_logs
    ADD CONSTRAINT communication_logs_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: communication_logs communication_logs_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communication_logs
    ADD CONSTRAINT communication_logs_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: document_analyses document_analyses_document_id_documents_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_analyses
    ADD CONSTRAINT document_analyses_document_id_documents_id_fk FOREIGN KEY (document_id) REFERENCES public.documents(id);


--
-- Name: document_type_templates document_type_templates_created_by_system_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_type_templates
    ADD CONSTRAINT document_type_templates_created_by_system_admins_id_fk FOREIGN KEY (created_by) REFERENCES public.system_admins(id);


--
-- Name: documents documents_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: documents documents_folder_id_folders_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_folder_id_folders_id_fk FOREIGN KEY (folder_id) REFERENCES public.folders(id);


--
-- Name: documents documents_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: firm_analysis_settings firm_analysis_settings_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firm_analysis_settings
    ADD CONSTRAINT firm_analysis_settings_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: firm_billing_settings firm_billing_settings_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firm_billing_settings
    ADD CONSTRAINT firm_billing_settings_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: firm_form_templates firm_form_templates_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firm_form_templates
    ADD CONSTRAINT firm_form_templates_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: firm_form_templates firm_form_templates_uploaded_by_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firm_form_templates
    ADD CONSTRAINT firm_form_templates_uploaded_by_users_id_fk FOREIGN KEY (uploaded_by) REFERENCES public.users(id);


--
-- Name: firm_integrations firm_integrations_enabled_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firm_integrations
    ADD CONSTRAINT firm_integrations_enabled_by_fkey FOREIGN KEY (enabled_by) REFERENCES public.users(id);


--
-- Name: firm_integrations firm_integrations_firm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firm_integrations
    ADD CONSTRAINT firm_integrations_firm_id_fkey FOREIGN KEY (firm_id) REFERENCES public.firms(id) ON DELETE CASCADE;


--
-- Name: firm_integrations firm_integrations_integration_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.firm_integrations
    ADD CONSTRAINT firm_integrations_integration_id_fkey FOREIGN KEY (integration_id) REFERENCES public.platform_integrations(id) ON DELETE CASCADE;


--
-- Name: folders folders_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.folders
    ADD CONSTRAINT folders_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: generated_documents generated_documents_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generated_documents
    ADD CONSTRAINT generated_documents_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: generated_documents generated_documents_template_id_firm_form_templates_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generated_documents
    ADD CONSTRAINT generated_documents_template_id_firm_form_templates_id_fk FOREIGN KEY (template_id) REFERENCES public.firm_form_templates(id);


--
-- Name: generated_documents generated_documents_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generated_documents
    ADD CONSTRAINT generated_documents_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: integration_audit_logs integration_audit_logs_firm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integration_audit_logs
    ADD CONSTRAINT integration_audit_logs_firm_id_fkey FOREIGN KEY (firm_id) REFERENCES public.firms(id) ON DELETE CASCADE;


--
-- Name: integration_audit_logs integration_audit_logs_integration_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integration_audit_logs
    ADD CONSTRAINT integration_audit_logs_integration_id_fkey FOREIGN KEY (integration_id) REFERENCES public.platform_integrations(id) ON DELETE CASCADE;


--
-- Name: integration_audit_logs integration_audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integration_audit_logs
    ADD CONSTRAINT integration_audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: integration_rate_limits integration_rate_limits_firm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integration_rate_limits
    ADD CONSTRAINT integration_rate_limits_firm_id_fkey FOREIGN KEY (firm_id) REFERENCES public.firms(id) ON DELETE CASCADE;


--
-- Name: integration_rate_limits integration_rate_limits_integration_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integration_rate_limits
    ADD CONSTRAINT integration_rate_limits_integration_id_fkey FOREIGN KEY (integration_id) REFERENCES public.platform_integrations(id) ON DELETE CASCADE;


--
-- Name: invoice_line_items invoice_line_items_invoice_id_invoices_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_line_items
    ADD CONSTRAINT invoice_line_items_invoice_id_invoices_id_fk FOREIGN KEY (invoice_id) REFERENCES public.invoices(id);


--
-- Name: invoice_line_items invoice_line_items_time_log_id_time_logs_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_line_items
    ADD CONSTRAINT invoice_line_items_time_log_id_time_logs_id_fk FOREIGN KEY (time_log_id) REFERENCES public.time_logs(id);


--
-- Name: invoices invoices_case_id_cases_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_case_id_cases_id_fk FOREIGN KEY (case_id) REFERENCES public.cases(id);


--
-- Name: invoices invoices_client_id_clients_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_client_id_clients_id_fk FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: invoices invoices_created_by_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_created_by_users_id_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: invoices invoices_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: message_threads message_threads_created_by_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_threads
    ADD CONSTRAINT message_threads_created_by_users_id_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: message_threads message_threads_document_id_documents_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_threads
    ADD CONSTRAINT message_threads_document_id_documents_id_fk FOREIGN KEY (document_id) REFERENCES public.documents(id);


--
-- Name: message_threads message_threads_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_threads
    ADD CONSTRAINT message_threads_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: message_threads message_threads_resolved_by_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_threads
    ADD CONSTRAINT message_threads_resolved_by_users_id_fk FOREIGN KEY (resolved_by) REFERENCES public.users(id);


--
-- Name: messages messages_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: messages messages_sender_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_id_users_id_fk FOREIGN KEY (sender_id) REFERENCES public.users(id);


--
-- Name: messages messages_thread_id_message_threads_thread_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_thread_id_message_threads_thread_id_fk FOREIGN KEY (thread_id) REFERENCES public.message_threads(thread_id);


--
-- Name: notifications notifications_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: notifications notifications_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: platform_settings platform_settings_updated_by_system_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_settings
    ADD CONSTRAINT platform_settings_updated_by_system_admins_id_fk FOREIGN KEY (updated_by) REFERENCES public.system_admins(id);


--
-- Name: time_logs time_logs_case_id_cases_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_logs
    ADD CONSTRAINT time_logs_case_id_cases_id_fk FOREIGN KEY (case_id) REFERENCES public.cases(id);


--
-- Name: time_logs time_logs_client_id_clients_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_logs
    ADD CONSTRAINT time_logs_client_id_clients_id_fk FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: time_logs time_logs_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_logs
    ADD CONSTRAINT time_logs_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- Name: time_logs time_logs_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_logs
    ADD CONSTRAINT time_logs_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_integration_permissions user_integration_permissions_firm_integration_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_integration_permissions
    ADD CONSTRAINT user_integration_permissions_firm_integration_id_fkey FOREIGN KEY (firm_integration_id) REFERENCES public.firm_integrations(id) ON DELETE CASCADE;


--
-- Name: user_integration_permissions user_integration_permissions_granted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_integration_permissions
    ADD CONSTRAINT user_integration_permissions_granted_by_fkey FOREIGN KEY (granted_by) REFERENCES public.users(id);


--
-- Name: user_integration_permissions user_integration_permissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_integration_permissions
    ADD CONSTRAINT user_integration_permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_firm_id_firms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_firm_id_firms_id_fk FOREIGN KEY (firm_id) REFERENCES public.firms(id);


--
-- PostgreSQL database dump complete
--

