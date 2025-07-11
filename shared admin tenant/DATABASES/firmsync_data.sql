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

--
-- Data for Name: firms; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.firms VALUES (1, 'Test Legal Firm', 'test-legal-firm', NULL, 'professional', 'active', NULL, '2025-06-15 15:11:48.775855', '2025-06-15 15:11:48.775855', true);
INSERT INTO public.firms VALUES (2, 'LegalEdge Partners', 'legaledge-partners', NULL, 'enterprise', 'active', NULL, '2025-06-15 15:11:48.775855', '2025-06-15 15:11:48.775855', false);
INSERT INTO public.firms VALUES (5, 'Test Firm', 'testfirm', NULL, 'Professional', 'active', NULL, '2025-06-16 05:26:59.514296', '2025-06-16 05:26:59.514296', true);
INSERT INTO public.firms VALUES (6, 'Demo Legal Firm', '6da4d5f1-ea5d-4edf-a396-c2c16e58af64-00-2hm05yfgpvj33', NULL, 'professional', 'active', NULL, '2025-06-18 00:43:45.802069', '2025-06-18 00:43:45.802069', false);
INSERT INTO public.firms VALUES (7, 'New Test Firm', 'new-test-firm', NULL, 'professional', 'active', NULL, '2025-06-18 07:35:21.567532', '2025-06-18 07:35:21.567532', false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users VALUES (6, NULL, 'admin@firmsync.com', NULL, '$2b$10$iTZglTId7pARjiQtIdzDWOlq85BsF3iLWVVhO/1HCXpr2SBR8xPl.', 'System', 'Admin', 'admin', 'active', NULL, '2025-06-16 01:35:11.739475', '2025-06-16 01:35:11.739475');
INSERT INTO public.users VALUES (7, 1, 'owner@testfirm.com', NULL, '$2b$10$gYgy6umsQsOIoghTnkl.Pu5K9lxSroEthRjeM7xBNPS/NoQEn/0g6', 'John', 'Owner', 'firm_admin', 'active', NULL, '2025-06-16 01:35:11.810808', '2025-06-16 01:35:11.810808');
INSERT INTO public.users VALUES (8, 2, 'staff@legaledge.com', NULL, '$2b$10$jLAKqo.z/oBCqQ7YFxKTxOGPrx4NrHIyHtUwCNuoKfYhXEbAqyhyy', 'Jane', 'Paralegal', 'paralegal', 'active', NULL, '2025-06-16 01:35:11.879274', '2025-06-16 01:35:11.879274');
INSERT INTO public.users VALUES (9, 6, 'demo@demo.com', NULL, '$2b$10$fdiNTafi2EyN6QlFeVuEkOp4ShwtjIgtxU9CQ3eusSBl8iX6l5K/G', 'Demo', 'User', 'firm_admin', 'active', NULL, '2025-06-18 00:43:52.398798', '2025-06-18 00:43:52.398798');
INSERT INTO public.users VALUES (10, 7, 'admin@newtestfirm.com', NULL, 'temp_password_123', 'John', 'Doe', 'firm_admin', 'active', NULL, '2025-06-18 07:35:21.643951', '2025-06-18 07:35:21.643951');


--
-- Data for Name: admin_ghost_sessions; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: client_intakes; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: folders; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: ai_triage_results; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.audit_logs VALUES (1, 1, 7, 'User', 'LOGIN', 'auth', NULL, NULL, '127.0.0.1', 'curl/8.11.1', '2025-06-16 05:34:31.879351', NULL);
INSERT INTO public.audit_logs VALUES (3, 2, 8, 'User', 'LOGIN', 'auth', NULL, NULL, '172.31.128.24', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.2 Safari/605.1.15', '2025-06-16 05:42:11.147052', NULL);
INSERT INTO public.audit_logs VALUES (4, 2, 8, 'User', 'LOGIN', 'auth', NULL, NULL, '172.31.128.24', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.2 Safari/605.1.15', '2025-06-16 06:32:13.449877', NULL);
INSERT INTO public.audit_logs VALUES (17, 1, 7, 'User', 'SECURITY_TENANT_VIOLATION', 'security', NULL, '{"eventType": "TENANT_VIOLATION", "description": "User attempted to access wrong tenant: default"}', '127.0.0.1', 'curl/8.11.1', '2025-06-16 08: