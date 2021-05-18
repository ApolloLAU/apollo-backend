--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2 (Debian 13.2-1.pgdg100+1)
-- Dumped by pg_dump version 13.2 (Debian 13.2-1.pgdg100+1)

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
-- Name: frs; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE frs WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE frs OWNER TO postgres;

\connect frs

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
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: array_add(jsonb, jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.array_add("array" jsonb, "values" jsonb) RETURNS jsonb
    LANGUAGE sql IMMUTABLE STRICT
    AS $$ SELECT array_to_json(ARRAY(SELECT unnest(ARRAY(SELECT DISTINCT jsonb_array_elements("array")) || ARRAY(SELECT jsonb_array_elements("values")))))::jsonb; $$;


ALTER FUNCTION public.array_add("array" jsonb, "values" jsonb) OWNER TO postgres;

--
-- Name: array_add_unique(jsonb, jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.array_add_unique("array" jsonb, "values" jsonb) RETURNS jsonb
    LANGUAGE sql IMMUTABLE STRICT
    AS $$ SELECT array_to_json(ARRAY(SELECT DISTINCT unnest(ARRAY(SELECT DISTINCT jsonb_array_elements("array")) || ARRAY(SELECT DISTINCT jsonb_array_elements("values")))))::jsonb; $$;


ALTER FUNCTION public.array_add_unique("array" jsonb, "values" jsonb) OWNER TO postgres;

--
-- Name: array_contains(jsonb, jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.array_contains("array" jsonb, "values" jsonb) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $$ SELECT RES.CNT >= 1 FROM (SELECT COUNT(*) as CNT FROM jsonb_array_elements("array") as elt WHERE elt IN (SELECT jsonb_array_elements("values"))) as RES; $$;


ALTER FUNCTION public.array_contains("array" jsonb, "values" jsonb) OWNER TO postgres;

--
-- Name: array_contains_all(jsonb, jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.array_contains_all("array" jsonb, "values" jsonb) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $$ SELECT CASE WHEN 0 = jsonb_array_length("values") THEN true = false ELSE (SELECT RES.CNT = jsonb_array_length("values") FROM (SELECT COUNT(*) as CNT FROM jsonb_array_elements_text("array") as elt WHERE elt IN (SELECT jsonb_array_elements_text("values"))) as RES) END; $$;


ALTER FUNCTION public.array_contains_all("array" jsonb, "values" jsonb) OWNER TO postgres;

--
-- Name: array_contains_all_regex(jsonb, jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.array_contains_all_regex("array" jsonb, "values" jsonb) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $$ SELECT CASE WHEN 0 = jsonb_array_length("values") THEN true = false ELSE (SELECT RES.CNT = jsonb_array_length("values") FROM (SELECT COUNT(*) as CNT FROM jsonb_array_elements_text("array") as elt WHERE elt LIKE ANY (SELECT jsonb_array_elements_text("values"))) as RES) END; $$;


ALTER FUNCTION public.array_contains_all_regex("array" jsonb, "values" jsonb) OWNER TO postgres;

--
-- Name: array_remove(jsonb, jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.array_remove("array" jsonb, "values" jsonb) RETURNS jsonb
    LANGUAGE sql IMMUTABLE STRICT
    AS $$ SELECT array_to_json(ARRAY(SELECT * FROM jsonb_array_elements("array") as elt WHERE elt NOT IN (SELECT * FROM (SELECT jsonb_array_elements("values")) AS sub)))::jsonb; $$;


ALTER FUNCTION public.array_remove("array" jsonb, "values" jsonb) OWNER TO postgres;

--
-- Name: json_object_set_key(jsonb, text, anyelement); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.json_object_set_key(json jsonb, key_to_set text, value_to_set anyelement) RETURNS jsonb
    LANGUAGE sql IMMUTABLE STRICT
    AS $$ SELECT concat('{', string_agg(to_json("key") || ':' || "value", ','), '}')::jsonb FROM (SELECT * FROM jsonb_each("json") WHERE key <> key_to_set UNION ALL SELECT key_to_set, to_json("value_to_set")::jsonb) AS fields $$;


ALTER FUNCTION public.json_object_set_key(json jsonb, key_to_set text, value_to_set anyelement) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ChatMessage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ChatMessage" (
    "objectId" text NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    _rperm text[],
    _wperm text[],
    message text,
    for_mission text,
    sender text,
    image text
);


ALTER TABLE public."ChatMessage" OWNER TO postgres;

--
-- Name: MedicalData; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."MedicalData" (
    "objectId" text NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    _rperm text[],
    _wperm text[],
    datatype text,
    value text,
    patient text,
    mission_record text
);


ALTER TABLE public."MedicalData" OWNER TO postgres;

--
-- Name: Mission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Mission" (
    "objectId" text NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    _rperm text[],
    _wperm text[],
    location point,
    status text,
    description text,
    location_string text
);


ALTER TABLE public."Mission" OWNER TO postgres;

--
-- Name: MissionLog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."MissionLog" (
    "objectId" text NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    _rperm text[],
    _wperm text[],
    update text,
    related_to_mission text
);


ALTER TABLE public."MissionLog" OWNER TO postgres;

--
-- Name: Patient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Patient" (
    "objectId" text NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    _rperm text[],
    _wperm text[],
    firstname text,
    lastname text,
    home_address text,
    dob timestamp with time zone,
    gender text,
    blood_type text,
    fathers_name text,
    emergency_nbr text,
    mothers_name text,
    phone_nbr text
);


ALTER TABLE public."Patient" OWNER TO postgres;

--
-- Name: Worker; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Worker" (
    "objectId" text NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    _rperm text[],
    _wperm text[],
    user_id text,
    firstname text,
    lastname text,
    "phoneNb" text,
    status text,
    image_file text,
    distrct text
);


ALTER TABLE public."Worker" OWNER TO postgres;

--
-- Name: _Audience; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_Audience" (
    "objectId" text NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    name text,
    query text,
    "lastUsed" timestamp with time zone,
    "timesUsed" double precision,
    _rperm text[],
    _wperm text[]
);


ALTER TABLE public."_Audience" OWNER TO postgres;

--
-- Name: _GlobalConfig; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_GlobalConfig" (
    "objectId" text NOT NULL,
    params jsonb,
    "masterKeyOnly" jsonb
);


ALTER TABLE public."_GlobalConfig" OWNER TO postgres;

--
-- Name: _GraphQLConfig; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_GraphQLConfig" (
    "objectId" text NOT NULL,
    config jsonb
);


ALTER TABLE public."_GraphQLConfig" OWNER TO postgres;

--
-- Name: _Hooks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_Hooks" (
    "functionName" text,
    "className" text,
    "triggerName" text,
    url text
);


ALTER TABLE public."_Hooks" OWNER TO postgres;

--
-- Name: _Idempotency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_Idempotency" (
    "objectId" text NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "reqId" text,
    expire timestamp with time zone,
    _rperm text[],
    _wperm text[]
);


ALTER TABLE public."_Idempotency" OWNER TO postgres;

--
-- Name: _JobSchedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_JobSchedule" (
    "objectId" text NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "jobName" text,
    description text,
    params text,
    "startAfter" text,
    "daysOfWeek" jsonb,
    "timeOfDay" text,
    "lastRun" double precision,
    "repeatMinutes" double precision,
    _rperm text[],
    _wperm text[]
);


ALTER TABLE public."_JobSchedule" OWNER TO postgres;

--
-- Name: _JobStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_JobStatus" (
    "objectId" text NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "jobName" text,
    source text,
    status text,
    message text,
    params jsonb,
    "finishedAt" timestamp with time zone,
    _rperm text[],
    _wperm text[]
);


ALTER TABLE public."_JobStatus" OWNER TO postgres;

--
-- Name: _Join:base_workers:Mission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_Join:base_workers:Mission" (
    "relatedId" character varying(120) NOT NULL,
    "owningId" character varying(120) NOT NULL
);


ALTER TABLE public."_Join:base_workers:Mission" OWNER TO postgres;

--
-- Name: _Join:field_workers:Mission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_Join:field_workers:Mission" (
    "relatedId" character varying(120) NOT NULL,
    "owningId" character varying(120) NOT NULL
);


ALTER TABLE public."_Join:field_workers:Mission" OWNER TO postgres;

--
-- Name: _Join:patients:Mission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_Join:patients:Mission" (
    "relatedId" character varying(120) NOT NULL,
    "owningId" character varying(120) NOT NULL
);


ALTER TABLE public."_Join:patients:Mission" OWNER TO postgres;

--
-- Name: _Join:roles:_Role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_Join:roles:_Role" (
    "relatedId" character varying(120) NOT NULL,
    "owningId" character varying(120) NOT NULL
);


ALTER TABLE public."_Join:roles:_Role" OWNER TO postgres;

--
-- Name: _Join:users:_Role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_Join:users:_Role" (
    "relatedId" character varying(120) NOT NULL,
    "owningId" character varying(120) NOT NULL
);


ALTER TABLE public."_Join:users:_Role" OWNER TO postgres;

--
-- Name: _PushStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_PushStatus" (
    "objectId" text NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "pushTime" text,
    source text,
    query text,
    payload text,
    title text,
    expiry double precision,
    expiration_interval double precision,
    status text,
    "numSent" double precision,
    "numFailed" double precision,
    "pushHash" text,
    "errorMessage" jsonb,
    "sentPerType" jsonb,
    "failedPerType" jsonb,
    "sentPerUTCOffset" jsonb,
    "failedPerUTCOffset" jsonb,
    count double precision,
    _rperm text[],
    _wperm text[]
);


ALTER TABLE public."_PushStatus" OWNER TO postgres;

--
-- Name: _Role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_Role" (
    "objectId" text NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    name text,
    _rperm text[],
    _wperm text[]
);


ALTER TABLE public."_Role" OWNER TO postgres;

--
-- Name: _SCHEMA; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_SCHEMA" (
    "className" character varying(120) NOT NULL,
    schema jsonb,
    "isParseClass" boolean
);


ALTER TABLE public."_SCHEMA" OWNER TO postgres;

--
-- Name: _Session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_Session" (
    "objectId" text NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    restricted boolean,
    "user" text,
    "installationId" text,
    "sessionToken" text,
    "expiresAt" timestamp with time zone,
    "createdWith" jsonb,
    _rperm text[],
    _wperm text[]
);


ALTER TABLE public."_Session" OWNER TO postgres;

--
-- Name: _User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_User" (
    "objectId" text NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    username text,
    email text,
    "emailVerified" boolean,
    "authData" jsonb,
    _rperm text[],
    _wperm text[],
    _hashed_password text,
    _email_verify_token_expires_at timestamp with time zone,
    _email_verify_token text,
    _account_lockout_expires_at timestamp with time zone,
    _failed_login_count double precision,
    _perishable_token text,
    _perishable_token_expires_at timestamp with time zone,
    _password_changed_at timestamp with time zone,
    _password_history jsonb
);


ALTER TABLE public."_User" OWNER TO postgres;

--
-- Data for Name: ChatMessage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ChatMessage" ("objectId", "createdAt", "updatedAt", _rperm, _wperm, message, for_mission, sender, image) FROM stdin;
QWXKtU48Lb	2021-04-26 14:12:49.446+00	2021-04-26 14:29:24.605+00	\N	\N	Just arrived. We see the patient. They are bleeding profusely	j8qruAaqh3	y2u2BXLlnK	\N
vMVK3ZEMyh	2021-04-26 14:11:28.874+00	2021-04-26 14:29:45.521+00	\N	\N	Hi. Arriving Soon	j8qruAaqh3	y2u2BXLlnK	\N
zLVPJufPCx	2021-04-26 14:12:10.794+00	2021-04-26 14:29:59.24+00	\N	\N	Great. Keep me posted	j8qruAaqh3	lLDj2PUmaL	\N
N7t38zf92Y	2021-04-26 14:13:34.868+00	2021-04-26 14:30:17.306+00	\N	\N	Disinfected and bandaged all visible wounds. Whats next?	j8qruAaqh3	y2u2BXLlnK	\N
jF2ufrBKRx	2021-04-26 14:14:48.765+00	2021-04-26 14:30:28.656+00	\N	\N	Get patient ready for transport I am looking for the closest hospital	j8qruAaqh3	lLDj2PUmaL	\N
EXEOIFCyvr	2021-04-26 14:15:22.392+00	2021-04-26 14:30:40.933+00	\N	\N	The nearest hospital is LAUMC	j8qruAaqh3	lLDj2PUmaL	\N
2vla0BslKt	2021-04-26 14:15:49.466+00	2021-04-26 14:30:51.129+00	\N	\N	Just arrived at hospital. Patient taken by staff	j8qruAaqh3	y2u2BXLlnK	\N
nx7VRr7WGP	2021-05-09 14:23:28.449+00	2021-05-09 14:23:28.449+00	\N	\N	Hello	XOGFrhqD2k	lLDj2PUmaL	\N
cdHxEbOXkU	2021-05-09 14:23:58.769+00	2021-05-09 14:23:58.769+00	\N	\N	REQUESTED ECG READING UPDATE	XOGFrhqD2k	lLDj2PUmaL	\N
xTZAH2ZX2D	2021-05-09 14:24:00.639+00	2021-05-09 14:24:00.639+00	\N	\N	REQUESTED BPM READING UPDATE	XOGFrhqD2k	lLDj2PUmaL	\N
wFHQ8sOerC	2021-05-09 14:24:01.819+00	2021-05-09 14:24:01.819+00	\N	\N	REQUESTED BP READING UPDATE	XOGFrhqD2k	lLDj2PUmaL	\N
iT0EwRiLdt	2021-05-09 14:24:09.41+00	2021-05-09 14:24:09.41+00	\N	\N	REQUESTED SPO2 READING UPDATE	XOGFrhqD2k	lLDj2PUmaL	\N
LtbhjUrO0d	2021-05-09 14:24:10.185+00	2021-05-09 14:24:10.185+00	\N	\N	REQUESTED GLUCOSE READING UPDATE	XOGFrhqD2k	lLDj2PUmaL	\N
jGTH2fyWhK	2021-05-09 15:04:06.64+00	2021-05-09 15:04:06.64+00	\N	\N	fdfgd	XOGFrhqD2k	lLDj2PUmaL	\N
7yZ8CNpBLR	2021-05-09 15:04:07.841+00	2021-05-09 15:04:07.841+00	\N	\N	REQUESTED SPO2 READING UPDATE	XOGFrhqD2k	lLDj2PUmaL	\N
fQ8zqZePg5	2021-05-14 18:29:42.878+00	2021-05-14 18:29:42.878+00	\N	\N	hi	R7loxcvNpX	lLDj2PUmaL	\N
i8rbna6qbx	2021-05-14 18:30:05.537+00	2021-05-14 18:30:05.537+00	\N	\N	hello	R7loxcvNpX	lLDj2PUmaL	\N
CtoyzXy4ZO	2021-05-14 18:30:47.819+00	2021-05-14 18:30:47.819+00	\N	\N	hi	R7loxcvNpX	lLDj2PUmaL	\N
5mVdknUXBZ	2021-05-14 18:31:37.818+00	2021-05-14 18:31:37.818+00	\N	\N	bonsoir	R7loxcvNpX	lLDj2PUmaL	\N
YtEsDfUndb	2021-05-14 18:31:47.599+00	2021-05-14 18:31:47.599+00	\N	\N	weeee	R7loxcvNpX	lLDj2PUmaL	\N
j6bMgzDxL9	2021-05-14 18:33:11.722+00	2021-05-14 18:33:11.722+00	\N	\N	pee	R7loxcvNpX	lLDj2PUmaL	\N
coKYiDF2s0	2021-05-14 18:38:17.839+00	2021-05-14 18:38:17.839+00	\N	\N	KAREN	R7loxcvNpX	lLDj2PUmaL	\N
7kJ20iTtq5	2021-05-14 18:41:32.05+00	2021-05-14 18:41:32.05+00	\N	\N	hi	R7loxcvNpX	lLDj2PUmaL	\N
PzqqpayxSt	2021-05-14 18:45:35.729+00	2021-05-14 18:45:35.729+00	\N	\N	What's up	R7loxcvNpX	y2u2BXLlnK	\N
dt1ikHRFkU	2021-05-14 18:47:35.36+00	2021-05-14 18:47:35.36+00	\N	\N	How's life	R7loxcvNpX	y2u2BXLlnK	\N
A6qVVdCRD2	2021-05-14 18:47:39.491+00	2021-05-14 18:47:39.491+00	\N	\N	all good	R7loxcvNpX	lLDj2PUmaL	\N
OffkedNhww	2021-05-16 14:22:47.301+00	2021-05-16 14:22:47.301+00	\N	\N	Hi	fBO3ReRqIt	y2u2BXLlnK	\N
voLc7QcJYX	2021-05-16 14:22:51.839+00	2021-05-16 14:22:51.839+00	\N	\N	REQUESTED GLUCOSE READING UPDATE	fBO3ReRqIt	lLDj2PUmaL	\N
5ZY3oAlMny	2021-05-16 14:23:07.228+00	2021-05-16 14:23:07.228+00	\N	\N	\N	fBO3ReRqIt	y2u2BXLlnK	e37562e60ab60ca1123d04ddf0e835b9_chat_image.png
MVmLxJ2JsX	2021-05-16 15:08:16.049+00	2021-05-16 15:08:16.049+00	\N	\N	\N	fBO3ReRqIt	y2u2BXLlnK	c9ff69d9f6626cdfc8c5c4c56100eb96_chat_image.png
8hvZgVzqc4	2021-05-16 15:08:35.04+00	2021-05-16 15:08:35.04+00	\N	\N	Hi	fBO3ReRqIt	y2u2BXLlnK	\N
tYPsix0M2T	2021-05-16 15:08:57.283+00	2021-05-16 15:08:57.283+00	\N	\N	Hey	fBO3ReRqIt	y2u2BXLlnK	\N
k6xBCDGv6W	2021-05-16 15:14:07.994+00	2021-05-16 15:14:07.994+00	\N	\N	Hey	fBO3ReRqIt	y2u2BXLlnK	\N
8qIOyo9iNp	2021-05-16 15:14:16.049+00	2021-05-16 15:14:16.049+00	\N	\N	\N	fBO3ReRqIt	y2u2BXLlnK	9fad3d0324babb95585ab9883db38ffd_chat_image.png
eSDcsrH4Yr	2021-05-16 15:14:24.415+00	2021-05-16 15:14:24.415+00	\N	\N	Hi	fBO3ReRqIt	y2u2BXLlnK	\N
KoCEWB2H9i	2021-05-16 15:17:41.5+00	2021-05-16 15:17:41.5+00	\N	\N	\N	fBO3ReRqIt	y2u2BXLlnK	df77206659ed5552f921fc3ced75b86b_chat_image.png
vGzOnwt6oq	2021-05-16 15:23:09.266+00	2021-05-16 15:23:09.266+00	\N	\N	\N	fBO3ReRqIt	y2u2BXLlnK	067219e95960235e218bbc0637b77524_chat_image.png
cn8JoIlha2	2021-05-16 15:25:41.4+00	2021-05-16 15:25:41.4+00	\N	\N	\N	fBO3ReRqIt	y2u2BXLlnK	55553ef8769171927e535507666a2cc1_chat_image.png
6p2JUcFDzU	2021-05-16 15:27:18.663+00	2021-05-16 15:27:18.663+00	\N	\N	\N	fBO3ReRqIt	y2u2BXLlnK	f9d887f89b2f3d6b8d2ce4ae387f3108_chat_image.png
yNzbonJGHb	2021-05-16 16:24:35.755+00	2021-05-16 16:24:35.755+00	\N	\N	Hi	DTbwfPk9OE	y2u2BXLlnK	\N
5hfi78DbLG	2021-05-16 16:24:44.047+00	2021-05-16 16:24:44.047+00	\N	\N	REQUESTED BPM READING UPDATE	DTbwfPk9OE	lLDj2PUmaL	\N
U43dkucVpJ	2021-05-16 16:25:06.601+00	2021-05-16 16:25:06.601+00	\N	\N	\N	DTbwfPk9OE	y2u2BXLlnK	e6fc73eb8b160fc60133fa22dc7284e9_chat_image.png
AYsvotNb4Q	2021-05-16 16:27:21.152+00	2021-05-16 16:27:21.152+00	\N	\N	\N	DTbwfPk9OE	y2u2BXLlnK	a51f4d1f18209fc77594caf7d8f351ea_chat_image.png
FnqnJzNfbn	2021-05-16 16:33:45.37+00	2021-05-16 16:33:45.37+00	\N	\N	\N	DTbwfPk9OE	y2u2BXLlnK	ae012169a3a9a99d3e66718a78488cd5_chat_image.png
9NHszQRNpz	2021-05-16 16:33:51.766+00	2021-05-16 16:33:51.766+00	\N	\N	\N	DTbwfPk9OE	y2u2BXLlnK	5b87e3f3e3408630d9da6c2914011594_chat_image.png
VNHHdxskby	2021-05-17 14:50:39.316+00	2021-05-17 14:50:39.316+00	\N	\N	Hi	FEuHlBgcyE	y2u2BXLlnK	\N
Y78eVx29AW	2021-05-17 14:57:58.747+00	2021-05-17 14:57:58.747+00	\N	\N	Hi	FEuHlBgcyE	y2u2BXLlnK	\N
Qckdu1fsC0	2021-05-17 14:58:22.782+00	2021-05-17 14:58:22.782+00	\N	\N	Hey	FEuHlBgcyE	y2u2BXLlnK	\N
1RR00vbmlB	2021-05-17 14:59:52.16+00	2021-05-17 14:59:52.16+00	\N	\N	Hi	FEuHlBgcyE	y2u2BXLlnK	\N
jj8ozGpLgJ	2021-05-17 15:06:08.736+00	2021-05-17 15:06:08.736+00	\N	\N	\N	FEuHlBgcyE	y2u2BXLlnK	621b0fbd16e1e68f15a95c20e4a8ee1f_chat_image.png
ZI3oYPzRBK	2021-05-17 15:09:23.864+00	2021-05-17 15:09:23.864+00	\N	\N	\N	FEuHlBgcyE	y2u2BXLlnK	50fce911aae74a6a34837fc79c11e072_chat_image.png
LcsF9pBsOg	2021-05-17 15:12:51.691+00	2021-05-17 15:12:51.691+00	\N	\N	\N	FEuHlBgcyE	y2u2BXLlnK	aeb1dfd2444c3ee3960266e9a6d38afb_chat_image.png
xrzkdPbP76	2021-05-17 15:14:00.848+00	2021-05-17 15:14:00.848+00	\N	\N	\N	FEuHlBgcyE	y2u2BXLlnK	f224bdbd8f13c158c3b3dc45f2bbba55_chat_image.png
l5paA2FY90	2021-05-17 15:22:02.605+00	2021-05-17 15:22:02.605+00	\N	\N	\N	FEuHlBgcyE	y2u2BXLlnK	893e707d55df8595165304394f122641_chat_image.png
Is00j4Shni	2021-05-17 15:23:52.819+00	2021-05-17 15:23:52.819+00	\N	\N	\N	FEuHlBgcyE	y2u2BXLlnK	20070aee5ccdc05c949d5f4152096d0a_chat_image.png
OJoHOXCnHN	2021-05-17 15:32:05.424+00	2021-05-17 15:32:05.424+00	\N	\N	\N	FEuHlBgcyE	y2u2BXLlnK	baf02cf6da8051f07e3168ae386ae82b_chat_image.png
p0Bysiw3ro	2021-05-18 15:00:45.181+00	2021-05-18 15:00:45.181+00	\N	\N	REQUESTED SPO2 READING UPDATE	FEuHlBgcyE	lLDj2PUmaL	\N
\.


--
-- Data for Name: MedicalData; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."MedicalData" ("objectId", "createdAt", "updatedAt", _rperm, _wperm, datatype, value, patient, mission_record) FROM stdin;
QK3MViQqla	2021-05-18 16:04:18.223+00	2021-05-18 16:04:18.223+00	\N	\N	ecg	0.390625,-0.046991675110333	fGQobjreD6	FEuHlBgcyE
flVoH73lWF	2021-05-18 16:04:18.429+00	2021-05-18 16:04:18.429+00	\N	\N	ecg	0.39453125,-0.00947655728589637	fGQobjreD6	FEuHlBgcyE
3tEkNV6ylB	2021-05-18 16:04:18.627+00	2021-05-18 16:04:18.627+00	\N	\N	ecg	0.3984375,-0.117730609031758	fGQobjreD6	FEuHlBgcyE
6nXzHeVHx5	2021-05-18 16:04:18.827+00	2021-05-18 16:04:18.827+00	\N	\N	ecg	0.40234375,-0.120381648711539	fGQobjreD6	FEuHlBgcyE
HuthtW2NSk	2021-05-18 16:04:19.027+00	2021-05-18 16:04:19.027+00	\N	\N	ecg	0.40625,0.0452457250836829	fGQobjreD6	FEuHlBgcyE
R1x5ecpv7C	2021-05-18 16:04:19.228+00	2021-05-18 16:04:19.228+00	\N	\N	ecg	0.41015625,-0.13803790404141	fGQobjreD6	FEuHlBgcyE
rSuXshYwqm	2021-05-18 16:04:19.428+00	2021-05-18 16:04:19.428+00	\N	\N	ecg	0.4140625,0.022700142726962	fGQobjreD6	FEuHlBgcyE
JNPC2bP0l6	2021-05-18 16:04:19.629+00	2021-05-18 16:04:19.629+00	\N	\N	ecg	0.41796875,-0.121632858316668	fGQobjreD6	FEuHlBgcyE
bSKPOctu5H	2021-05-18 16:04:19.83+00	2021-05-18 16:04:19.83+00	\N	\N	ecg	0.421875,-0.0877866607033838	fGQobjreD6	FEuHlBgcyE
C8exfA2JGS	2021-05-18 16:04:20.03+00	2021-05-18 16:04:20.03+00	\N	\N	ecg	0.42578125,-0.142284280941236	fGQobjreD6	FEuHlBgcyE
1xi9rlVKoP	2021-05-18 16:04:20.231+00	2021-05-18 16:04:20.231+00	\N	\N	ecg	0.4296875,-0.0438381338450631	fGQobjreD6	FEuHlBgcyE
8ab2BWWrYq	2021-05-18 16:04:20.432+00	2021-05-18 16:04:20.432+00	\N	\N	ecg	0.43359375,0.021509645885696	fGQobjreD6	FEuHlBgcyE
N5aFvicdJk	2021-05-18 16:04:20.634+00	2021-05-18 16:04:20.634+00	\N	\N	ecg	0.4375,-0.027263162496985	fGQobjreD6	FEuHlBgcyE
AaLI2ECsmv	2021-05-18 16:04:20.834+00	2021-05-18 16:04:20.834+00	\N	\N	ecg	0.44140625,-0.0585229040973365	fGQobjreD6	FEuHlBgcyE
ZzyPOIqNLZ	2021-05-18 16:04:21.035+00	2021-05-18 16:04:21.035+00	\N	\N	ecg	0.4453125,0.0528362007139422	fGQobjreD6	FEuHlBgcyE
sQbrjLhJfy	2021-05-18 16:04:21.235+00	2021-05-18 16:04:21.235+00	\N	\N	ecg	0.44921875,-0.0415359512716529	fGQobjreD6	FEuHlBgcyE
41mZEit6Zd	2021-05-18 16:04:21.436+00	2021-05-18 16:04:21.436+00	\N	\N	ecg	0.453125,-0.0664070847931159	fGQobjreD6	FEuHlBgcyE
Ex9uwslwvJ	2021-05-18 16:04:21.636+00	2021-05-18 16:04:21.636+00	\N	\N	ecg	0.45703125,-0.085265913616269	fGQobjreD6	FEuHlBgcyE
98kQ44er3Z	2021-05-18 16:04:21.837+00	2021-05-18 16:04:21.837+00	\N	\N	ecg	0.4609375,0.0170288687324424	fGQobjreD6	FEuHlBgcyE
2hh1yk86cT	2021-05-18 16:04:22.039+00	2021-05-18 16:04:22.039+00	\N	\N	ecg	0.46484375,-0.0994135063240511	fGQobjreD6	FEuHlBgcyE
LT8wzAiL3w	2021-05-18 16:04:22.24+00	2021-05-18 16:04:22.24+00	\N	\N	ecg	0.46875,-0.0914474894169695	fGQobjreD6	FEuHlBgcyE
G8dtFejHDq	2021-05-18 16:04:22.44+00	2021-05-18 16:04:22.44+00	\N	\N	ecg	0.47265625,0.0573887084220024	fGQobjreD6	FEuHlBgcyE
JnlduEeUHz	2021-05-18 16:04:22.642+00	2021-05-18 16:04:22.642+00	\N	\N	ecg	0.4765625,-0.139721554462703	fGQobjreD6	FEuHlBgcyE
qzmqVRe9hG	2021-05-18 16:04:22.841+00	2021-05-18 16:04:22.841+00	\N	\N	ecg	0.48046875,-0.103318531963274	fGQobjreD6	FEuHlBgcyE
b8OIn5C96d	2021-05-18 16:04:23.042+00	2021-05-18 16:04:23.042+00	\N	\N	ecg	0.484375,0.059615075962462	fGQobjreD6	FEuHlBgcyE
KlK02mZbwv	2021-05-18 16:04:23.242+00	2021-05-18 16:04:23.242+00	\N	\N	ecg	0.48828125,-0.0937670038975264	fGQobjreD6	FEuHlBgcyE
JE3LzKssPH	2021-05-18 16:04:23.445+00	2021-05-18 16:04:23.445+00	\N	\N	ecg	0.4921875,0.0444557533055442	fGQobjreD6	FEuHlBgcyE
UBAHWN1xV8	2021-05-18 16:04:23.643+00	2021-05-18 16:04:23.643+00	\N	\N	ecg	0.49609375,-0.0555677239651816	fGQobjreD6	FEuHlBgcyE
pmHXiUGNs6	2021-05-18 16:04:23.843+00	2021-05-18 16:04:23.843+00	\N	\N	ecg	0.5,-0.0158356480141744	fGQobjreD6	FEuHlBgcyE
X3Jg6RBwDu	2021-05-18 16:04:24.043+00	2021-05-18 16:04:24.043+00	\N	\N	ecg	0.50390625,0.0452806581720361	fGQobjreD6	FEuHlBgcyE
X4t5o9FJRo	2021-05-18 16:04:24.245+00	2021-05-18 16:04:24.245+00	\N	\N	ecg	0.5078125,-0.0971565334284623	fGQobjreD6	FEuHlBgcyE
tJc8Lnvi1H	2021-05-18 16:04:24.445+00	2021-05-18 16:04:24.445+00	\N	\N	ecg	0.51171875,-0.0951167169061745	fGQobjreD6	FEuHlBgcyE
0W3HQ1n2eu	2021-05-18 16:04:24.645+00	2021-05-18 16:04:24.645+00	\N	\N	ecg	0.515625,-0.124630870192969	fGQobjreD6	FEuHlBgcyE
c6On2w9uyE	2021-05-18 16:04:24.846+00	2021-05-18 16:04:24.846+00	\N	\N	ecg	0.51953125,0.0558887387699032	fGQobjreD6	FEuHlBgcyE
E0nCDfZJy0	2021-05-18 16:04:25.046+00	2021-05-18 16:04:25.046+00	\N	\N	ecg	0.5234375,-0.115493469465828	fGQobjreD6	FEuHlBgcyE
M2A1H3UICM	2021-05-18 16:04:25.247+00	2021-05-18 16:04:25.247+00	\N	\N	ecg	0.52734375,-0.0677631915313475	fGQobjreD6	FEuHlBgcyE
t9P0cAykGi	2021-05-18 16:04:25.448+00	2021-05-18 16:04:25.448+00	\N	\N	ecg	0.53125,-0.0858273237588429	fGQobjreD6	FEuHlBgcyE
nyHybZdIT7	2021-05-18 16:04:25.648+00	2021-05-18 16:04:25.648+00	\N	\N	ecg	0.53515625,-0.0131629912193893	fGQobjreD6	FEuHlBgcyE
bL1NAGoaoF	2021-05-18 16:04:25.849+00	2021-05-18 16:04:25.849+00	\N	\N	ecg	0.5390625,-0.0441037763206974	fGQobjreD6	FEuHlBgcyE
vgHfZGgCna	2021-05-18 16:04:26.049+00	2021-05-18 16:04:26.049+00	\N	\N	ecg	0.54296875,-0.0898557529407844	fGQobjreD6	FEuHlBgcyE
AFFOJsJGLW	2021-05-18 16:04:26.25+00	2021-05-18 16:04:26.25+00	\N	\N	ecg	0.546875,-0.0363553080942667	fGQobjreD6	FEuHlBgcyE
Sk5xsivFPN	2021-05-18 16:04:26.45+00	2021-05-18 16:04:26.45+00	\N	\N	ecg	0.55078125,-0.0771366935216973	fGQobjreD6	FEuHlBgcyE
FBSAES2uqC	2021-05-18 16:04:26.652+00	2021-05-18 16:04:26.652+00	\N	\N	ecg	0.5546875,0.0559029316290867	fGQobjreD6	FEuHlBgcyE
KJeyLmdIdO	2021-05-18 16:04:26.852+00	2021-05-18 16:04:26.852+00	\N	\N	ecg	0.55859375,0.0231597739768244	fGQobjreD6	FEuHlBgcyE
v9lhp6IOUf	2021-05-18 16:04:27.053+00	2021-05-18 16:04:27.053+00	\N	\N	ecg	0.5625,-0.0807222722533805	fGQobjreD6	FEuHlBgcyE
VKrb9sc39H	2021-05-18 16:04:27.254+00	2021-05-18 16:04:27.254+00	\N	\N	ecg	0.56640625,-0.0101844006197011	fGQobjreD6	FEuHlBgcyE
VhhaBFufpH	2021-05-18 16:04:27.453+00	2021-05-18 16:04:27.453+00	\N	\N	ecg	0.5703125,0.0237084093192928	fGQobjreD6	FEuHlBgcyE
JpJLDaIlKC	2021-05-18 16:04:27.654+00	2021-05-18 16:04:27.654+00	\N	\N	ecg	0.57421875,-0.0907511717619149	fGQobjreD6	FEuHlBgcyE
iA2B8gMQxa	2021-05-18 16:04:27.854+00	2021-05-18 16:04:27.854+00	\N	\N	ecg	0.578125,-0.0911970637256693	fGQobjreD6	FEuHlBgcyE
3kE1yQqABG	2021-05-18 16:04:28.055+00	2021-05-18 16:04:28.055+00	\N	\N	ecg	0.58203125,-0.0589254128710708	fGQobjreD6	FEuHlBgcyE
uXVNHQ4xGn	2021-05-18 16:04:28.256+00	2021-05-18 16:04:28.256+00	\N	\N	ecg	0.5859375,-0.0665505101506306	fGQobjreD6	FEuHlBgcyE
mTKleKojst	2021-05-18 16:04:28.46+00	2021-05-18 16:04:28.46+00	\N	\N	ecg	0.58984375,-0.00681759073876825	fGQobjreD6	FEuHlBgcyE
Mk5bmsSMHB	2021-05-18 16:04:28.656+00	2021-05-18 16:04:28.656+00	\N	\N	ecg	0.59375,-0.0997773010278427	fGQobjreD6	FEuHlBgcyE
N8UMbsO7bK	2021-05-18 16:04:28.857+00	2021-05-18 16:04:28.857+00	\N	\N	ecg	0.59765625,0.0829647143113702	fGQobjreD6	FEuHlBgcyE
BQYS7IhTNB	2021-05-18 16:04:29.057+00	2021-05-18 16:04:29.057+00	\N	\N	ecg	0.6015625,0.0603826463996578	fGQobjreD6	FEuHlBgcyE
8R9fM5GHSH	2021-05-18 16:04:29.258+00	2021-05-18 16:04:29.258+00	\N	\N	ecg	0.60546875,-0.0453164990299239	fGQobjreD6	FEuHlBgcyE
QROiPOf4cz	2021-05-18 16:04:29.46+00	2021-05-18 16:04:29.46+00	\N	\N	ecg	0.609375,0.044699166943504	fGQobjreD6	FEuHlBgcyE
pNBlnawb7W	2021-05-18 16:04:29.659+00	2021-05-18 16:04:29.659+00	\N	\N	ecg	0.61328125,-0.0630556407049914	fGQobjreD6	FEuHlBgcyE
FhWWFYveYI	2021-05-18 16:04:29.859+00	2021-05-18 16:04:29.859+00	\N	\N	ecg	0.6171875,-0.0621335284475862	fGQobjreD6	FEuHlBgcyE
ekBCmHdSk6	2021-05-18 16:04:30.06+00	2021-05-18 16:04:30.06+00	\N	\N	ecg	0.62109375,-0.0488954905998347	fGQobjreD6	FEuHlBgcyE
nAv1OUozQm	2021-05-18 16:04:30.261+00	2021-05-18 16:04:30.261+00	\N	\N	ecg	0.625,0.0751324462188925	fGQobjreD6	FEuHlBgcyE
LkFVjDGimJ	2021-05-18 16:04:30.463+00	2021-05-18 16:04:30.463+00	\N	\N	ecg	0.62890625,-0.00188934887938398	fGQobjreD6	FEuHlBgcyE
UlcRoSaFdD	2021-05-18 16:04:30.662+00	2021-05-18 16:04:30.662+00	\N	\N	ecg	0.6328125,-0.0265907425432962	fGQobjreD6	FEuHlBgcyE
DAMhICL3Np	2021-05-18 16:04:30.863+00	2021-05-18 16:04:30.863+00	\N	\N	ecg	0.63671875,0.0638525097770323	fGQobjreD6	FEuHlBgcyE
QB92d0Qhi6	2021-05-18 16:04:31.065+00	2021-05-18 16:04:31.065+00	\N	\N	ecg	0.640625,-0.0298996422801941	fGQobjreD6	FEuHlBgcyE
VrBOiGJMky	2021-05-18 16:04:31.264+00	2021-05-18 16:04:31.264+00	\N	\N	ecg	0.64453125,0.0392370740443337	fGQobjreD6	FEuHlBgcyE
TzU8XlyEA9	2021-05-18 16:04:31.467+00	2021-05-18 16:04:31.467+00	\N	\N	ecg	0.6484375,-0.0371911865037357	fGQobjreD6	FEuHlBgcyE
gvye2cUe92	2021-05-18 16:04:31.666+00	2021-05-18 16:04:31.666+00	\N	\N	ecg	0.65234375,0.0275619973003453	fGQobjreD6	FEuHlBgcyE
a2VBMr03h4	2021-05-18 16:04:31.868+00	2021-05-18 16:04:31.868+00	\N	\N	ecg	0.65625,-0.0536530681139482	fGQobjreD6	FEuHlBgcyE
D8YGmNHJ66	2021-05-18 16:04:32.067+00	2021-05-18 16:04:32.067+00	\N	\N	ecg	0.66015625,-0.0192728154324219	fGQobjreD6	FEuHlBgcyE
JXGgvDiTwc	2021-05-18 16:04:32.268+00	2021-05-18 16:04:32.268+00	\N	\N	ecg	0.6640625,-0.0208584609344444	fGQobjreD6	FEuHlBgcyE
uOQfqIvtav	2021-05-18 16:04:32.467+00	2021-05-18 16:04:32.467+00	\N	\N	ecg	0.66796875,-0.0505181087801421	fGQobjreD6	FEuHlBgcyE
pAg1FynUF2	2021-05-18 16:04:32.667+00	2021-05-18 16:04:32.667+00	\N	\N	ecg	0.671875,-0.0198608211300341	fGQobjreD6	FEuHlBgcyE
s2lZAeKv5f	2021-05-18 16:04:32.868+00	2021-05-18 16:04:32.868+00	\N	\N	ecg	0.67578125,-0.00536604985980523	fGQobjreD6	FEuHlBgcyE
Basn6ZWYAR	2021-05-18 16:04:33.07+00	2021-05-18 16:04:33.07+00	\N	\N	ecg	0.6796875,-0.00678395331308003	fGQobjreD6	FEuHlBgcyE
qQhzC4Q2T9	2021-05-18 16:04:33.27+00	2021-05-18 16:04:33.27+00	\N	\N	ecg	0.68359375,-0.0153865043130764	fGQobjreD6	FEuHlBgcyE
uE4cpfBXvo	2021-05-18 16:04:33.476+00	2021-05-18 16:04:33.476+00	\N	\N	ecg	0.6875,0.0826131786726928	fGQobjreD6	FEuHlBgcyE
J0E9XEuBcj	2021-05-18 16:04:33.671+00	2021-05-18 16:04:33.671+00	\N	\N	ecg	0.69140625,-0.0657794922748262	fGQobjreD6	FEuHlBgcyE
ur5vLpocAA	2021-05-18 16:04:33.871+00	2021-05-18 16:04:33.871+00	\N	\N	ecg	0.6953125,0.0144229548256896	fGQobjreD6	FEuHlBgcyE
EEQMSuLT4U	2021-05-18 16:04:34.072+00	2021-05-18 16:04:34.072+00	\N	\N	ecg	0.69921875,0.0964051724313587	fGQobjreD6	FEuHlBgcyE
PrEh3OlM36	2021-05-18 16:04:34.275+00	2021-05-18 16:04:34.275+00	\N	\N	ecg	0.703125,-0.0259311850083524	fGQobjreD6	FEuHlBgcyE
wXDbozFRrN	2021-05-18 16:04:34.474+00	2021-05-18 16:04:34.474+00	\N	\N	ecg	0.70703125,-0.0861710658390892	fGQobjreD6	FEuHlBgcyE
F6Lc27sh52	2021-05-18 16:04:34.677+00	2021-05-18 16:04:34.677+00	\N	\N	ecg	0.7109375,0.10873990519859	fGQobjreD6	FEuHlBgcyE
83kpcVt8A2	2021-05-18 16:04:34.874+00	2021-05-18 16:04:34.874+00	\N	\N	ecg	0.71484375,-0.0354368880739339	fGQobjreD6	FEuHlBgcyE
eeULvf8yqL	2021-05-18 16:04:35.075+00	2021-05-18 16:04:35.075+00	\N	\N	ecg	0.71875,0.0111402285344782	fGQobjreD6	FEuHlBgcyE
uvaV4he75m	2021-05-18 16:04:35.281+00	2021-05-18 16:04:35.281+00	\N	\N	ecg	0.72265625,-0.0454891613525848	fGQobjreD6	FEuHlBgcyE
1XE55DqmGa	2021-05-18 16:04:35.479+00	2021-05-18 16:04:35.479+00	\N	\N	ecg	0.7265625,-0.00912257595545842	fGQobjreD6	FEuHlBgcyE
s8avT5Tc46	2021-05-18 16:04:35.679+00	2021-05-18 16:04:35.679+00	\N	\N	ecg	0.73046875,-0.0680615864745478	fGQobjreD6	FEuHlBgcyE
EauFWh2zI7	2021-05-18 16:04:35.892+00	2021-05-18 16:04:35.892+00	\N	\N	ecg	0.734375,0.127996753394931	fGQobjreD6	FEuHlBgcyE
2ZUOHpAXp0	2021-05-18 16:04:36.087+00	2021-05-18 16:04:36.087+00	\N	\N	ecg	0.73828125,0.0997070419554419	fGQobjreD6	FEuHlBgcyE
QcxpNPa4KA	2021-05-18 16:04:36.285+00	2021-05-18 16:04:36.285+00	\N	\N	ecg	0.7421875,0.123127027347168	fGQobjreD6	FEuHlBgcyE
jaIdOBYuTl	2021-05-18 16:04:36.486+00	2021-05-18 16:04:36.486+00	\N	\N	ecg	0.74609375,0.136732783765027	fGQobjreD6	FEuHlBgcyE
hKvSg3pdip	2021-05-18 16:04:36.686+00	2021-05-18 16:04:36.686+00	\N	\N	ecg	0.75,0.0407842622533523	fGQobjreD6	FEuHlBgcyE
mFjG8Ux72c	2021-05-18 16:04:36.887+00	2021-05-18 16:04:36.887+00	\N	\N	ecg	0.75390625,0.0864737790014718	fGQobjreD6	FEuHlBgcyE
I03tQnYCwU	2021-05-18 16:04:37.087+00	2021-05-18 16:04:37.087+00	\N	\N	ecg	0.7578125,0.096544835028964	fGQobjreD6	FEuHlBgcyE
M3OQwJENHf	2021-05-18 16:04:37.288+00	2021-05-18 16:04:37.288+00	\N	\N	ecg	0.76171875,0.119136770566511	fGQobjreD6	FEuHlBgcyE
1s6tu4ogBV	2021-05-18 16:04:37.489+00	2021-05-18 16:04:37.489+00	\N	\N	ecg	0.765625,0.101442564498996	fGQobjreD6	FEuHlBgcyE
IDYtDhYLFG	2021-05-18 16:04:37.689+00	2021-05-18 16:04:37.689+00	\N	\N	ecg	0.76953125,0.167309437052069	fGQobjreD6	FEuHlBgcyE
24yEhyyMeM	2021-05-18 16:04:37.891+00	2021-05-18 16:04:37.891+00	\N	\N	ecg	0.7734375,0.0377353079026451	fGQobjreD6	FEuHlBgcyE
Fjt19OCt9A	2021-05-18 16:04:38.09+00	2021-05-18 16:04:38.09+00	\N	\N	ecg	0.77734375,0.124293133501512	fGQobjreD6	FEuHlBgcyE
Y4n58GOgwc	2021-05-18 16:04:38.292+00	2021-05-18 16:04:38.292+00	\N	\N	ecg	0.78125,0.134544307493096	fGQobjreD6	FEuHlBgcyE
M0gCpKBCyG	2021-05-18 16:04:38.495+00	2021-05-18 16:04:38.495+00	\N	\N	ecg	0.78515625,0.178707155894595	fGQobjreD6	FEuHlBgcyE
rMhTDCgJmT	2021-05-18 16:04:38.693+00	2021-05-18 16:04:38.693+00	\N	\N	ecg	0.7890625,0.142802478724873	fGQobjreD6	FEuHlBgcyE
xcDuKBOTDy	2021-05-18 16:04:38.893+00	2021-05-18 16:04:38.893+00	\N	\N	ecg	0.79296875,0.156542060673886	fGQobjreD6	FEuHlBgcyE
jifWeagYr8	2021-05-18 16:04:39.095+00	2021-05-18 16:04:39.095+00	\N	\N	ecg	0.796875,0.295925466495326	fGQobjreD6	FEuHlBgcyE
xBTuSByoPa	2021-05-18 16:04:39.294+00	2021-05-18 16:04:39.294+00	\N	\N	ecg	0.80078125,0.203004111730433	fGQobjreD6	FEuHlBgcyE
1WxEcWG7cb	2021-05-18 16:04:39.495+00	2021-05-18 16:04:39.495+00	\N	\N	ecg	0.8046875,0.285204581463664	fGQobjreD6	FEuHlBgcyE
DVbsVCKaXK	2021-05-18 16:04:39.695+00	2021-05-18 16:04:39.695+00	\N	\N	ecg	0.80859375,0.277974916147161	fGQobjreD6	FEuHlBgcyE
pdYzaVh1Kv	2021-05-18 16:04:39.897+00	2021-05-18 16:04:39.897+00	\N	\N	ecg	0.8125,0.334666544429197	fGQobjreD6	FEuHlBgcyE
1mocjNmyCv	2021-05-18 16:04:40.097+00	2021-05-18 16:04:40.097+00	\N	\N	ecg	0.81640625,0.33902974647277	fGQobjreD6	FEuHlBgcyE
eh6BfkzXsH	2021-05-18 16:04:40.297+00	2021-05-18 16:04:40.297+00	\N	\N	ecg	0.8203125,0.204161476587801	fGQobjreD6	FEuHlBgcyE
a5UI1igMX3	2021-05-18 16:04:40.498+00	2021-05-18 16:04:40.498+00	\N	\N	ecg	0.82421875,0.319574367497006	fGQobjreD6	FEuHlBgcyE
SqCbKkAzwB	2021-05-18 16:04:40.698+00	2021-05-18 16:04:40.698+00	\N	\N	ecg	0.828125,0.389379361899809	fGQobjreD6	FEuHlBgcyE
RGXD64GMTQ	2021-05-18 16:04:40.899+00	2021-05-18 16:04:40.899+00	\N	\N	ecg	0.83203125,0.386061647726	fGQobjreD6	FEuHlBgcyE
b0ptCpGRFG	2021-05-18 16:04:41.1+00	2021-05-18 16:04:41.1+00	\N	\N	ecg	0.8359375,0.261831010039264	fGQobjreD6	FEuHlBgcyE
cgDEKhapC2	2021-05-18 16:04:41.299+00	2021-05-18 16:04:41.299+00	\N	\N	ecg	0.83984375,0.333939310083479	fGQobjreD6	FEuHlBgcyE
4w6NaaPFyN	2021-05-18 16:04:41.501+00	2021-05-18 16:04:41.501+00	\N	\N	ecg	0.84375,0.182305701008605	fGQobjreD6	FEuHlBgcyE
G9L9Wj5POi	2021-05-18 16:04:41.7+00	2021-05-18 16:04:41.7+00	\N	\N	ecg	0.84765625,0.292685051987256	fGQobjreD6	FEuHlBgcyE
DoByX7ltdb	2021-05-18 16:04:41.902+00	2021-05-18 16:04:41.902+00	\N	\N	ecg	0.8515625,0.213812050542015	fGQobjreD6	FEuHlBgcyE
wURn0hTT8o	2021-05-18 16:04:42.103+00	2021-05-18 16:04:42.103+00	\N	\N	ecg	0.85546875,0.285746439122494	fGQobjreD6	FEuHlBgcyE
AyQveK3LGq	2021-05-18 16:04:42.302+00	2021-05-18 16:04:42.302+00	\N	\N	ecg	0.859375,0.229004321668699	fGQobjreD6	FEuHlBgcyE
2FKnYl5RRd	2021-05-18 16:04:42.503+00	2021-05-18 16:04:42.503+00	\N	\N	ecg	0.86328125,0.250698118914564	fGQobjreD6	FEuHlBgcyE
w4d9NZzwVS	2021-05-18 16:04:42.703+00	2021-05-18 16:04:42.703+00	\N	\N	ecg	0.8671875,0.28438780443771	fGQobjreD6	FEuHlBgcyE
EAeBVQqhD2	2021-05-18 16:04:42.905+00	2021-05-18 16:04:42.905+00	\N	\N	ecg	0.87109375,0.133227654191309	fGQobjreD6	FEuHlBgcyE
a6G6oBUmG8	2021-05-18 16:04:43.105+00	2021-05-18 16:04:43.105+00	\N	\N	ecg	0.875,0.227394325819718	fGQobjreD6	FEuHlBgcyE
cIE4aX0jNM	2021-05-18 16:04:43.306+00	2021-05-18 16:04:43.306+00	\N	\N	ecg	0.87890625,0.138843107469857	fGQobjreD6	FEuHlBgcyE
IM0odidZI7	2021-05-18 16:04:43.51+00	2021-05-18 16:04:43.51+00	\N	\N	ecg	0.8828125,0.120521307047579	fGQobjreD6	FEuHlBgcyE
BiE8GlhPoR	2021-05-18 16:04:43.707+00	2021-05-18 16:04:43.707+00	\N	\N	ecg	0.88671875,0.162405386679642	fGQobjreD6	FEuHlBgcyE
sviDUBWOMS	2021-05-18 16:04:43.909+00	2021-05-18 16:04:43.909+00	\N	\N	ecg	0.890625,0.102135385367308	fGQobjreD6	FEuHlBgcyE
rzQI20godK	2021-05-18 16:04:44.109+00	2021-05-18 16:04:44.109+00	\N	\N	ecg	0.89453125,0.033475768741972	fGQobjreD6	FEuHlBgcyE
O8tPWcXbA1	2021-05-18 16:04:44.308+00	2021-05-18 16:04:44.308+00	\N	\N	ecg	0.8984375,0.132676146304381	fGQobjreD6	FEuHlBgcyE
epEB9hAd55	2021-05-18 16:04:44.509+00	2021-05-18 16:04:44.509+00	\N	\N	ecg	0.90234375,-0.00705801161508589	fGQobjreD6	FEuHlBgcyE
JKUL31tkPk	2021-05-18 16:04:44.709+00	2021-05-18 16:04:44.709+00	\N	\N	ecg	0.90625,0.0380674905553353	fGQobjreD6	FEuHlBgcyE
BiWYTKeCRD	2021-05-18 16:04:44.909+00	2021-05-18 16:04:44.909+00	\N	\N	ecg	0.91015625,0.0954089623089891	fGQobjreD6	FEuHlBgcyE
wxPaQbMoym	2021-05-18 16:04:45.11+00	2021-05-18 16:04:45.11+00	\N	\N	ecg	0.9140625,0.0685272779988416	fGQobjreD6	FEuHlBgcyE
ISaQwMHe6r	2021-05-18 16:04:45.311+00	2021-05-18 16:04:45.311+00	\N	\N	ecg	0.91796875,-0.0131143574994507	fGQobjreD6	FEuHlBgcyE
kBoWavgiXM	2021-05-18 16:04:45.511+00	2021-05-18 16:04:45.511+00	\N	\N	ecg	0.921875,0.0845656473768603	fGQobjreD6	FEuHlBgcyE
4yGTPLBJGM	2021-05-18 16:04:45.712+00	2021-05-18 16:04:45.712+00	\N	\N	ecg	0.92578125,0.0762124643422892	fGQobjreD6	FEuHlBgcyE
B9oZngG1QI	2021-05-18 16:04:45.912+00	2021-05-18 16:04:45.912+00	\N	\N	ecg	0.9296875,-0.0724664569693898	fGQobjreD6	FEuHlBgcyE
yWrnofiwFc	2021-05-18 16:04:46.113+00	2021-05-18 16:04:46.113+00	\N	\N	ecg	0.93359375,-0.161498432952839	fGQobjreD6	FEuHlBgcyE
Bt3Tuph6TM	2021-05-18 16:04:46.314+00	2021-05-18 16:04:46.314+00	\N	\N	ecg	0.9375,-0.079727714046906	fGQobjreD6	FEuHlBgcyE
9nApqq6mLP	2021-05-18 16:04:46.514+00	2021-05-18 16:04:46.514+00	\N	\N	ecg	0.94140625,-0.183467751182479	fGQobjreD6	FEuHlBgcyE
zsLdH7uXxU	2021-05-18 16:04:46.714+00	2021-05-18 16:04:46.714+00	\N	\N	ecg	0.9453125,-0.144304425275969	fGQobjreD6	FEuHlBgcyE
l4Y4B0hdn8	2021-05-18 16:04:46.915+00	2021-05-18 16:04:46.915+00	\N	\N	ecg	0.94921875,-0.163458658403001	fGQobjreD6	FEuHlBgcyE
c5CGGKX2bo	2021-05-18 16:04:47.115+00	2021-05-18 16:04:47.115+00	\N	\N	ecg	0.953125,-0.0711002446953886	fGQobjreD6	FEuHlBgcyE
cCU2CNf3Fw	2021-05-18 16:04:47.316+00	2021-05-18 16:04:47.316+00	\N	\N	ecg	0.95703125,-0.140922149572985	fGQobjreD6	FEuHlBgcyE
8wlIaiYVML	2021-05-18 16:04:47.516+00	2021-05-18 16:04:47.516+00	\N	\N	ecg	0.9609375,0.0844452792869589	fGQobjreD6	FEuHlBgcyE
C3x2y9I2t3	2021-05-18 16:04:47.718+00	2021-05-18 16:04:47.718+00	\N	\N	ecg	0.96484375,0.106514860005852	fGQobjreD6	FEuHlBgcyE
TBT6ZqGyCS	2021-05-18 16:04:47.918+00	2021-05-18 16:04:47.918+00	\N	\N	ecg	0.96875,0.232933385838573	fGQobjreD6	FEuHlBgcyE
HRuq8Y6lu0	2021-05-18 16:04:48.118+00	2021-05-18 16:04:48.118+00	\N	\N	ecg	0.97265625,0.399347566621186	fGQobjreD6	FEuHlBgcyE
BuT9GCbHIm	2021-05-18 16:04:48.319+00	2021-05-18 16:04:48.319+00	\N	\N	ecg	0.9765625,0.648487264644577	fGQobjreD6	FEuHlBgcyE
HcvN09GlEb	2021-05-18 16:04:48.524+00	2021-05-18 16:04:48.524+00	\N	\N	ecg	0.98046875,0.788939387361108	fGQobjreD6	FEuHlBgcyE
2bnax5URVM	2021-05-18 16:04:48.72+00	2021-05-18 16:04:48.72+00	\N	\N	ecg	0.984375,1.06321073401698	fGQobjreD6	FEuHlBgcyE
mFI877hPL7	2021-05-18 16:04:48.921+00	2021-05-18 16:04:48.921+00	\N	\N	ecg	0.98828125,1.15679534283234	fGQobjreD6	FEuHlBgcyE
LXyYggm26v	2021-05-18 16:04:49.121+00	2021-05-18 16:04:49.121+00	\N	\N	ecg	0.9921875,1.08560398945084	fGQobjreD6	FEuHlBgcyE
tE3v37YAAG	2021-05-18 16:04:49.321+00	2021-05-18 16:04:49.321+00	\N	\N	ecg	0.99609375,1.06583785466464	fGQobjreD6	FEuHlBgcyE
nw1ezZcCxk	2021-05-18 16:04:49.522+00	2021-05-18 16:04:49.522+00	\N	\N	ecg	1.0,1.12705852985289	fGQobjreD6	FEuHlBgcyE
TkfQj58nCt	2021-05-18 16:04:49.723+00	2021-05-18 16:04:49.723+00	\N	\N	ecg	1.00390625,1.06244793594112	fGQobjreD6	FEuHlBgcyE
NvBOArJVLC	2021-05-18 16:04:49.925+00	2021-05-18 16:04:49.925+00	\N	\N	ecg	1.0078125,0.875759757505777	fGQobjreD6	FEuHlBgcyE
4Al9kj7bbL	2021-05-18 16:04:50.123+00	2021-05-18 16:04:50.123+00	\N	\N	ecg	1.01171875,0.823738951746154	fGQobjreD6	FEuHlBgcyE
Y4uL9k8x84	2021-05-18 16:04:50.324+00	2021-05-18 16:04:50.324+00	\N	\N	ecg	1.015625,0.604728179158279	fGQobjreD6	FEuHlBgcyE
Dyvv1xMzGZ	2021-05-18 16:04:50.525+00	2021-05-18 16:04:50.525+00	\N	\N	ecg	1.01953125,0.450252045996394	fGQobjreD6	FEuHlBgcyE
N0TjEiW5uc	2021-05-18 16:04:50.726+00	2021-05-18 16:04:50.726+00	\N	\N	ecg	1.0234375,0.187966012385694	fGQobjreD6	FEuHlBgcyE
xCPkxQFSO1	2021-05-18 16:04:50.926+00	2021-05-18 16:04:50.926+00	\N	\N	ecg	1.02734375,-0.0592836927927862	fGQobjreD6	FEuHlBgcyE
ElUvNYST0u	2021-05-18 16:04:51.126+00	2021-05-18 16:04:51.126+00	\N	\N	ecg	1.03125,-0.233386801821144	fGQobjreD6	FEuHlBgcyE
nGrNJpKTcu	2021-05-18 16:04:51.332+00	2021-05-18 16:04:51.332+00	\N	\N	ecg	1.03515625,-0.206492786527422	fGQobjreD6	FEuHlBgcyE
D4bAif6SKa	2021-05-18 16:04:51.528+00	2021-05-18 16:04:51.528+00	\N	\N	ecg	1.0390625,-0.387907012645616	fGQobjreD6	FEuHlBgcyE
yTbUnKsCwB	2021-05-18 16:04:51.729+00	2021-05-18 16:04:51.729+00	\N	\N	ecg	1.04296875,-0.35693074990372	fGQobjreD6	FEuHlBgcyE
0ycPUbTE4Y	2021-05-18 16:04:51.931+00	2021-05-18 16:04:51.931+00	\N	\N	ecg	1.046875,-0.290222265475376	fGQobjreD6	FEuHlBgcyE
cmyEHxhJHM	2021-05-18 16:04:52.131+00	2021-05-18 16:04:52.131+00	\N	\N	ecg	1.05078125,-0.192017903885469	fGQobjreD6	FEuHlBgcyE
hXsxpqlDkp	2021-05-18 16:04:52.331+00	2021-05-18 16:04:52.331+00	\N	\N	ecg	1.0546875,-0.277527170112164	fGQobjreD6	FEuHlBgcyE
GNF4BIOOgc	2021-05-18 16:04:52.531+00	2021-05-18 16:04:52.531+00	\N	\N	ecg	1.05859375,-0.250093220451493	fGQobjreD6	FEuHlBgcyE
lqPpiZrHA7	2021-05-18 16:04:52.733+00	2021-05-18 16:04:52.733+00	\N	\N	ecg	1.0625,-0.235729070324845	fGQobjreD6	FEuHlBgcyE
2o47ubocdt	2021-05-18 16:04:52.934+00	2021-05-18 16:04:52.934+00	\N	\N	ecg	1.06640625,-0.059024185306969	fGQobjreD6	FEuHlBgcyE
FxMPtymYlz	2021-05-18 16:04:53.135+00	2021-05-18 16:04:53.135+00	\N	\N	ecg	1.0703125,-0.0428235239163977	fGQobjreD6	FEuHlBgcyE
PRUyncqGGd	2021-05-18 16:04:53.335+00	2021-05-18 16:04:53.335+00	\N	\N	ecg	1.07421875,0.0194783311918042	fGQobjreD6	FEuHlBgcyE
FOtWWhqT9G	2021-05-18 16:04:53.539+00	2021-05-18 16:04:53.539+00	\N	\N	ecg	1.078125,-0.131853851051741	fGQobjreD6	FEuHlBgcyE
2zIQnwBkGx	2021-05-18 16:04:53.736+00	2021-05-18 16:04:53.736+00	\N	\N	ecg	1.08203125,-0.0806966713945835	fGQobjreD6	FEuHlBgcyE
o7gDDtdH6S	2021-05-18 16:04:53.936+00	2021-05-18 16:04:53.936+00	\N	\N	ecg	1.0859375,-0.045575810958973	fGQobjreD6	FEuHlBgcyE
CTufUY4CE6	2021-05-18 16:04:54.137+00	2021-05-18 16:04:54.137+00	\N	\N	ecg	1.08984375,-0.0498133966754605	fGQobjreD6	FEuHlBgcyE
lawa2gtYLr	2021-05-18 16:04:54.338+00	2021-05-18 16:04:54.338+00	\N	\N	ecg	1.09375,0.0286909842798259	fGQobjreD6	FEuHlBgcyE
oId5fQTXgP	2021-05-18 16:04:54.538+00	2021-05-18 16:04:54.538+00	\N	\N	ecg	1.09765625,-0.101691429951695	fGQobjreD6	FEuHlBgcyE
E3JO9Q8H5g	2021-05-18 16:04:54.739+00	2021-05-18 16:04:54.739+00	\N	\N	ecg	1.1015625,0.0688875623691073	fGQobjreD6	FEuHlBgcyE
gxJgEGvtEN	2021-05-18 16:04:54.939+00	2021-05-18 16:04:54.939+00	\N	\N	ecg	1.10546875,-0.0341086571432948	fGQobjreD6	FEuHlBgcyE
RTkVEKyl7Y	2021-05-18 16:04:55.139+00	2021-05-18 16:04:55.139+00	\N	\N	ecg	1.109375,-0.00354894593836948	fGQobjreD6	FEuHlBgcyE
0Tr0R4TE0V	2021-05-18 16:04:55.34+00	2021-05-18 16:04:55.34+00	\N	\N	ecg	1.11328125,0.0292451353128132	fGQobjreD6	FEuHlBgcyE
gjjn76Lt3t	2021-05-18 16:04:55.54+00	2021-05-18 16:04:55.54+00	\N	\N	ecg	1.1171875,-0.00373658554987735	fGQobjreD6	FEuHlBgcyE
Z0XJT7Lojx	2021-05-18 16:04:55.74+00	2021-05-18 16:04:55.74+00	\N	\N	ecg	1.12109375,-0.0450412238007426	fGQobjreD6	FEuHlBgcyE
Cz06NH7104	2021-05-18 16:04:55.941+00	2021-05-18 16:04:55.941+00	\N	\N	ecg	1.125,0.0992968646039004	fGQobjreD6	FEuHlBgcyE
tASxWYPfPU	2021-05-18 16:04:56.143+00	2021-05-18 16:04:56.143+00	\N	\N	ecg	1.12890625,-0.0210341503077046	fGQobjreD6	FEuHlBgcyE
Ed7pfXmmkN	2021-05-18 16:04:56.344+00	2021-05-18 16:04:56.344+00	\N	\N	ecg	1.1328125,0.0671065812014678	fGQobjreD6	FEuHlBgcyE
4yEhohEllu	2021-05-18 16:04:56.544+00	2021-05-18 16:04:56.544+00	\N	\N	ecg	1.13671875,0.11481088862095	fGQobjreD6	FEuHlBgcyE
tQipC7o5AH	2021-05-18 16:04:56.744+00	2021-05-18 16:04:56.744+00	\N	\N	ecg	1.140625,0.0343380699276404	fGQobjreD6	FEuHlBgcyE
cHja6uBmud	2021-05-18 16:04:56.947+00	2021-05-18 16:04:56.947+00	\N	\N	ecg	1.14453125,0.171373661560386	fGQobjreD6	FEuHlBgcyE
3Avf1IRSKR	2021-05-18 16:04:57.146+00	2021-05-18 16:04:57.146+00	\N	\N	ecg	1.1484375,0.0218884515978358	fGQobjreD6	FEuHlBgcyE
zqP1DpG8ev	2021-05-18 16:04:57.347+00	2021-05-18 16:04:57.347+00	\N	\N	ecg	1.15234375,0.135763401042889	fGQobjreD6	FEuHlBgcyE
Ez61DfDvIV	2021-05-18 16:04:57.547+00	2021-05-18 16:04:57.547+00	\N	\N	ecg	1.15625,0.178347881143365	fGQobjreD6	FEuHlBgcyE
YzMBTRZcDj	2021-05-18 16:04:57.749+00	2021-05-18 16:04:57.749+00	\N	\N	ecg	1.16015625,0.0700744935663874	fGQobjreD6	FEuHlBgcyE
mvvX6cEHxx	2021-05-18 16:04:57.948+00	2021-05-18 16:04:57.948+00	\N	\N	ecg	1.1640625,0.126583310783601	fGQobjreD6	FEuHlBgcyE
uw3FDpRc7J	2021-05-18 16:04:58.149+00	2021-05-18 16:04:58.149+00	\N	\N	ecg	1.16796875,0.250651516668627	fGQobjreD6	FEuHlBgcyE
eo4CIfC9E0	2021-05-18 16:04:58.349+00	2021-05-18 16:04:58.349+00	\N	\N	ecg	1.171875,0.11405003651	fGQobjreD6	FEuHlBgcyE
rEOEmLEtco	2021-05-18 16:04:58.553+00	2021-05-18 16:04:58.553+00	\N	\N	ecg	1.17578125,0.239882169940308	fGQobjreD6	FEuHlBgcyE
LeAKqVJlaW	2021-05-18 16:04:58.751+00	2021-05-18 16:04:58.751+00	\N	\N	ecg	1.1796875,0.159191582015438	fGQobjreD6	FEuHlBgcyE
6pOosrKec1	2021-05-18 16:04:58.951+00	2021-05-18 16:04:58.951+00	\N	\N	ecg	1.18359375,0.145765935143261	fGQobjreD6	FEuHlBgcyE
aWngPeXAmj	2021-05-18 16:04:59.152+00	2021-05-18 16:04:59.152+00	\N	\N	ecg	1.1875,0.204971215889314	fGQobjreD6	FEuHlBgcyE
LRzSDOJaFu	2021-05-18 16:04:59.351+00	2021-05-18 16:04:59.351+00	\N	\N	ecg	1.19140625,0.247349096907832	fGQobjreD6	FEuHlBgcyE
G13h9AAUEi	2021-05-18 16:04:59.552+00	2021-05-18 16:04:59.552+00	\N	\N	ecg	1.1953125,0.37358488367951	fGQobjreD6	FEuHlBgcyE
qgo08MTUk6	2021-05-18 16:04:59.753+00	2021-05-18 16:04:59.753+00	\N	\N	ecg	1.19921875,0.237401212308442	fGQobjreD6	FEuHlBgcyE
aHCWCtEJCF	2021-05-18 16:04:59.953+00	2021-05-18 16:04:59.953+00	\N	\N	ecg	1.203125,0.399070054102479	fGQobjreD6	FEuHlBgcyE
QLOWxU53Wf	2021-05-18 16:05:00.153+00	2021-05-18 16:05:00.153+00	\N	\N	ecg	1.20703125,0.345663533588839	fGQobjreD6	FEuHlBgcyE
NEy0qvrBiE	2021-05-18 16:05:00.354+00	2021-05-18 16:05:00.354+00	\N	\N	ecg	1.2109375,0.421630562459038	fGQobjreD6	FEuHlBgcyE
0jtTyN1UBk	2021-05-18 16:05:00.554+00	2021-05-18 16:05:00.554+00	\N	\N	ecg	1.21484375,0.408571667473728	fGQobjreD6	FEuHlBgcyE
0GS64OEgFO	2021-05-18 16:05:00.756+00	2021-05-18 16:05:00.756+00	\N	\N	ecg	1.21875,0.326508748625089	fGQobjreD6	FEuHlBgcyE
xgEd5D8EIH	2021-05-18 16:05:00.956+00	2021-05-18 16:05:00.956+00	\N	\N	ecg	1.22265625,0.453684747853945	fGQobjreD6	FEuHlBgcyE
XSHHSbMORt	2021-05-18 16:05:01.156+00	2021-05-18 16:05:01.156+00	\N	\N	ecg	1.2265625,0.402663390443594	fGQobjreD6	FEuHlBgcyE
vsMp7fc7E0	2021-05-18 16:05:01.358+00	2021-05-18 16:05:01.358+00	\N	\N	ecg	1.23046875,0.454747407531027	fGQobjreD6	FEuHlBgcyE
lBkABDAt6p	2021-05-18 16:05:01.558+00	2021-05-18 16:05:01.558+00	\N	\N	ecg	1.234375,0.410165185665853	fGQobjreD6	FEuHlBgcyE
pzofgfxKg5	2021-05-18 16:05:01.758+00	2021-05-18 16:05:01.758+00	\N	\N	ecg	1.23828125,0.335879947892884	fGQobjreD6	FEuHlBgcyE
ezexqxwbFI	2021-05-18 16:05:01.959+00	2021-05-18 16:05:01.959+00	\N	\N	ecg	1.2421875,0.338521936402238	fGQobjreD6	FEuHlBgcyE
qVLE0p9TWg	2021-05-18 16:05:02.16+00	2021-05-18 16:05:02.16+00	\N	\N	ecg	1.24609375,0.480067383046126	fGQobjreD6	FEuHlBgcyE
iGi9ndLXls	2021-05-18 16:05:02.359+00	2021-05-18 16:05:02.359+00	\N	\N	ecg	1.25,0.444931717265355	fGQobjreD6	FEuHlBgcyE
tp3eBIxU7K	2021-05-18 16:05:02.56+00	2021-05-18 16:05:02.56+00	\N	\N	ecg	1.25390625,0.420641810193508	fGQobjreD6	FEuHlBgcyE
gWVpniojKO	2021-05-18 16:05:02.761+00	2021-05-18 16:05:02.761+00	\N	\N	ecg	1.2578125,0.316493445668136	fGQobjreD6	FEuHlBgcyE
z6Hhivpx32	2021-05-18 16:05:02.961+00	2021-05-18 16:05:02.961+00	\N	\N	ecg	1.26171875,0.309922380841522	fGQobjreD6	FEuHlBgcyE
KunBxDBzK3	2021-05-18 16:05:03.162+00	2021-05-18 16:05:03.162+00	\N	\N	ecg	1.265625,0.279488900817205	fGQobjreD6	FEuHlBgcyE
kINreozoLi	2021-05-18 16:05:03.362+00	2021-05-18 16:05:03.362+00	\N	\N	ecg	1.26953125,0.315024095161497	fGQobjreD6	FEuHlBgcyE
sP8LAywHbg	2021-05-18 16:05:03.566+00	2021-05-18 16:05:03.566+00	\N	\N	ecg	1.2734375,0.320330790998883	fGQobjreD6	FEuHlBgcyE
XNV8Z4ZlGc	2021-05-18 16:05:03.763+00	2021-05-18 16:05:03.763+00	\N	\N	ecg	1.27734375,0.370425008099375	fGQobjreD6	FEuHlBgcyE
xzNYP9HBdO	2021-05-18 16:05:03.964+00	2021-05-18 16:05:03.964+00	\N	\N	ecg	1.28125,0.387059137355977	fGQobjreD6	FEuHlBgcyE
IXUBf6OOG3	2021-05-18 16:05:04.164+00	2021-05-18 16:05:04.164+00	\N	\N	ecg	1.28515625,0.312637095674988	fGQobjreD6	FEuHlBgcyE
C7Vveu3uIG	2021-05-18 16:05:04.365+00	2021-05-18 16:05:04.365+00	\N	\N	ecg	1.2890625,0.294533411534843	fGQobjreD6	FEuHlBgcyE
x3nCrozlJh	2021-05-18 16:05:04.564+00	2021-05-18 16:05:04.564+00	\N	\N	ecg	1.29296875,0.302799410682013	fGQobjreD6	FEuHlBgcyE
F9y8yqUC3C	2021-05-18 16:05:04.766+00	2021-05-18 16:05:04.766+00	\N	\N	ecg	1.296875,0.179773410836103	fGQobjreD6	FEuHlBgcyE
At3t16zzXw	2021-05-18 16:05:04.966+00	2021-05-18 16:05:04.966+00	\N	\N	ecg	1.30078125,0.276255214340195	fGQobjreD6	FEuHlBgcyE
VGyzmwafKE	2021-05-18 16:05:05.167+00	2021-05-18 16:05:05.167+00	\N	\N	ecg	1.3046875,0.161100726368793	fGQobjreD6	FEuHlBgcyE
mV9J6rjCBC	2021-05-18 16:05:05.367+00	2021-05-18 16:05:05.367+00	\N	\N	ecg	1.30859375,0.284264424904188	fGQobjreD6	FEuHlBgcyE
3nJGHQIuZn	2021-05-18 16:05:05.568+00	2021-05-18 16:05:05.568+00	\N	\N	ecg	1.3125,0.198367800813536	fGQobjreD6	FEuHlBgcyE
qDjYxg6g7i	2021-05-18 16:05:05.769+00	2021-05-18 16:05:05.769+00	\N	\N	ecg	1.31640625,0.0966300820930321	fGQobjreD6	FEuHlBgcyE
nhwAp5PUCZ	2021-05-18 16:05:05.969+00	2021-05-18 16:05:05.969+00	\N	\N	ecg	1.3203125,0.0836706917542261	fGQobjreD6	FEuHlBgcyE
RXJKiIDJ8v	2021-05-18 16:05:06.169+00	2021-05-18 16:05:06.169+00	\N	\N	ecg	1.32421875,0.109200631654795	fGQobjreD6	FEuHlBgcyE
9SL8DScj4c	2021-05-18 16:05:06.372+00	2021-05-18 16:05:06.372+00	\N	\N	ecg	1.328125,0.094076257896318	fGQobjreD6	FEuHlBgcyE
OXxrgcRjjs	2021-05-18 16:05:06.571+00	2021-05-18 16:05:06.571+00	\N	\N	ecg	1.33203125,0.0340272894121502	fGQobjreD6	FEuHlBgcyE
TTB6PnHoro	2021-05-18 16:05:06.774+00	2021-05-18 16:05:06.774+00	\N	\N	ecg	1.3359375,0.181006962891072	fGQobjreD6	FEuHlBgcyE
XLsxCzBIaw	2021-05-18 16:05:06.974+00	2021-05-18 16:05:06.974+00	\N	\N	ecg	1.33984375,0.166189492901873	fGQobjreD6	FEuHlBgcyE
P9A5nFUyAg	2021-05-18 16:05:07.174+00	2021-05-18 16:05:07.174+00	\N	\N	ecg	1.34375,-0.0134765328778534	fGQobjreD6	FEuHlBgcyE
HgGDT2pFG4	2021-05-18 16:05:07.375+00	2021-05-18 16:05:07.375+00	\N	\N	ecg	1.34765625,0.154011479402941	fGQobjreD6	FEuHlBgcyE
5mrc6g2Nq3	2021-05-18 16:05:07.574+00	2021-05-18 16:05:07.574+00	\N	\N	ecg	1.3515625,0.0554861408141964	fGQobjreD6	FEuHlBgcyE
IfgSPMz1zF	2021-05-18 16:05:07.776+00	2021-05-18 16:05:07.776+00	\N	\N	ecg	1.35546875,0.0335430313062925	fGQobjreD6	FEuHlBgcyE
DGT2yTKzaG	2021-05-18 16:05:07.975+00	2021-05-18 16:05:07.975+00	\N	\N	ecg	1.359375,-0.0305423381088788	fGQobjreD6	FEuHlBgcyE
jJZD5Blg1g	2021-05-18 16:05:08.176+00	2021-05-18 16:05:08.176+00	\N	\N	ecg	1.36328125,0.0050385631803817	fGQobjreD6	FEuHlBgcyE
k3r83T0FtY	2021-05-18 16:05:08.377+00	2021-05-18 16:05:08.377+00	\N	\N	ecg	1.3671875,-0.0310119032252117	fGQobjreD6	FEuHlBgcyE
713rskyFsC	2021-05-18 16:05:08.584+00	2021-05-18 16:05:08.584+00	\N	\N	ecg	1.37109375,-0.0085589146683882	fGQobjreD6	FEuHlBgcyE
gEhwI8Bp5Q	2021-05-18 16:05:08.778+00	2021-05-18 16:05:08.778+00	\N	\N	ecg	1.375,-0.0413570845218212	fGQobjreD6	FEuHlBgcyE
hghcpFOVlH	2021-05-18 16:05:08.979+00	2021-05-18 16:05:08.979+00	\N	\N	ecg	1.37890625,0.0882271548048075	fGQobjreD6	FEuHlBgcyE
Truww1A8ZU	2021-05-18 16:05:09.179+00	2021-05-18 16:05:09.179+00	\N	\N	ecg	1.3828125,0.00280616873407654	fGQobjreD6	FEuHlBgcyE
XMNzuLQ4ja	2021-05-18 16:05:09.38+00	2021-05-18 16:05:09.38+00	\N	\N	ecg	1.38671875,-0.0736756310882781	fGQobjreD6	FEuHlBgcyE
ZcM3xE5kun	2021-05-18 16:05:09.582+00	2021-05-18 16:05:09.582+00	\N	\N	ecg	1.390625,-0.046991675110333	fGQobjreD6	FEuHlBgcyE
M7kH6hchKq	2021-05-18 16:05:09.781+00	2021-05-18 16:05:09.781+00	\N	\N	ecg	1.39453125,-0.00947655728589637	fGQobjreD6	FEuHlBgcyE
5l736PL9jk	2021-05-18 16:05:09.984+00	2021-05-18 16:05:09.984+00	\N	\N	ecg	1.3984375,-0.117730609031758	fGQobjreD6	FEuHlBgcyE
mBexfX2IzE	2021-05-18 16:05:10.185+00	2021-05-18 16:05:10.185+00	\N	\N	ecg	1.40234375,-0.120381648711539	fGQobjreD6	FEuHlBgcyE
mDORWTX20D	2021-05-18 16:05:10.386+00	2021-05-18 16:05:10.386+00	\N	\N	ecg	1.40625,0.0452457250836829	fGQobjreD6	FEuHlBgcyE
6YyAoAcidj	2021-05-18 16:05:10.585+00	2021-05-18 16:05:10.585+00	\N	\N	ecg	1.41015625,-0.13803790404141	fGQobjreD6	FEuHlBgcyE
WIBvpAJsBq	2021-05-18 16:05:10.785+00	2021-05-18 16:05:10.785+00	\N	\N	ecg	1.4140625,0.022700142726962	fGQobjreD6	FEuHlBgcyE
mZE4DyRDu7	2021-05-18 16:05:10.986+00	2021-05-18 16:05:10.986+00	\N	\N	ecg	1.41796875,-0.121632858316668	fGQobjreD6	FEuHlBgcyE
ThHv9eJgPf	2021-05-18 16:05:11.187+00	2021-05-18 16:05:11.187+00	\N	\N	ecg	1.421875,-0.0877866607033838	fGQobjreD6	FEuHlBgcyE
z9rEJZAhLM	2021-05-18 16:05:11.388+00	2021-05-18 16:05:11.388+00	\N	\N	ecg	1.42578125,-0.142284280941236	fGQobjreD6	FEuHlBgcyE
FiWXReJw0N	2021-05-18 16:05:11.588+00	2021-05-18 16:05:11.588+00	\N	\N	ecg	1.4296875,-0.0438381338450631	fGQobjreD6	FEuHlBgcyE
9cXB7N51Rc	2021-05-18 16:05:11.788+00	2021-05-18 16:05:11.788+00	\N	\N	ecg	1.43359375,0.021509645885696	fGQobjreD6	FEuHlBgcyE
bjEmIvBrra	2021-05-18 16:05:11.989+00	2021-05-18 16:05:11.989+00	\N	\N	ecg	1.4375,-0.027263162496985	fGQobjreD6	FEuHlBgcyE
XhhOuxbnRC	2021-05-18 16:05:12.19+00	2021-05-18 16:05:12.19+00	\N	\N	ecg	1.44140625,-0.0585229040973365	fGQobjreD6	FEuHlBgcyE
SR2VIaTFAy	2021-05-18 16:05:12.389+00	2021-05-18 16:05:12.389+00	\N	\N	ecg	1.4453125,0.0528362007139422	fGQobjreD6	FEuHlBgcyE
87TITtLMOi	2021-05-18 16:05:12.59+00	2021-05-18 16:05:12.59+00	\N	\N	ecg	1.44921875,-0.0415359512716529	fGQobjreD6	FEuHlBgcyE
DYzPFhBbw2	2021-05-18 16:05:12.791+00	2021-05-18 16:05:12.791+00	\N	\N	ecg	1.453125,-0.0664070847931159	fGQobjreD6	FEuHlBgcyE
b8x5X1emcC	2021-05-18 16:05:12.992+00	2021-05-18 16:05:12.992+00	\N	\N	ecg	1.45703125,-0.085265913616269	fGQobjreD6	FEuHlBgcyE
O232L4QbV8	2021-05-18 16:05:13.192+00	2021-05-18 16:05:13.192+00	\N	\N	ecg	1.4609375,0.0170288687324424	fGQobjreD6	FEuHlBgcyE
BM8j2GBjix	2021-05-18 16:05:13.394+00	2021-05-18 16:05:13.394+00	\N	\N	ecg	1.46484375,-0.0994135063240511	fGQobjreD6	FEuHlBgcyE
J9WmaJVQbM	2021-05-18 16:05:13.597+00	2021-05-18 16:05:13.597+00	\N	\N	ecg	1.46875,-0.0914474894169695	fGQobjreD6	FEuHlBgcyE
maJgovxdDA	2021-05-18 16:05:13.794+00	2021-05-18 16:05:13.794+00	\N	\N	ecg	1.47265625,0.0573887084220024	fGQobjreD6	FEuHlBgcyE
ms6t6o9Je4	2021-05-18 16:05:13.994+00	2021-05-18 16:05:13.994+00	\N	\N	ecg	1.4765625,-0.139721554462703	fGQobjreD6	FEuHlBgcyE
IF7wfqHbQb	2021-05-18 16:05:14.197+00	2021-05-18 16:05:14.197+00	\N	\N	ecg	1.48046875,-0.103318531963274	fGQobjreD6	FEuHlBgcyE
ocaEElD7kH	2021-05-18 16:05:14.395+00	2021-05-18 16:05:14.395+00	\N	\N	ecg	1.484375,0.059615075962462	fGQobjreD6	FEuHlBgcyE
4DEKTWzFti	2021-05-18 16:05:14.597+00	2021-05-18 16:05:14.597+00	\N	\N	ecg	1.48828125,-0.0937670038975264	fGQobjreD6	FEuHlBgcyE
boVf9VnZEo	2021-05-18 16:05:14.797+00	2021-05-18 16:05:14.797+00	\N	\N	ecg	1.4921875,0.0444557533055442	fGQobjreD6	FEuHlBgcyE
377HNm0eVJ	2021-05-18 16:05:14.999+00	2021-05-18 16:05:14.999+00	\N	\N	ecg	1.49609375,-0.0555677239651816	fGQobjreD6	FEuHlBgcyE
kV6qvJo8Aq	2021-05-18 16:05:15.197+00	2021-05-18 16:05:15.197+00	\N	\N	ecg	1.5,-0.0158356480141744	fGQobjreD6	FEuHlBgcyE
nxxSXkQfaY	2021-05-18 16:05:15.399+00	2021-05-18 16:05:15.399+00	\N	\N	ecg	1.50390625,0.0452806581720361	fGQobjreD6	FEuHlBgcyE
ijFAbB2XO2	2021-05-18 16:05:15.599+00	2021-05-18 16:05:15.599+00	\N	\N	ecg	1.5078125,-0.0971565334284623	fGQobjreD6	FEuHlBgcyE
44xONFWoSR	2021-05-18 16:05:15.799+00	2021-05-18 16:05:15.799+00	\N	\N	ecg	1.51171875,-0.0951167169061745	fGQobjreD6	FEuHlBgcyE
p4vy7C9eop	2021-05-18 16:05:15.999+00	2021-05-18 16:05:15.999+00	\N	\N	ecg	1.515625,-0.124630870192969	fGQobjreD6	FEuHlBgcyE
MKMuPMjJMY	2021-05-18 16:05:16.199+00	2021-05-18 16:05:16.199+00	\N	\N	ecg	1.51953125,0.0558887387699032	fGQobjreD6	FEuHlBgcyE
3IjeGby4EQ	2021-05-18 16:05:16.4+00	2021-05-18 16:05:16.4+00	\N	\N	ecg	1.5234375,-0.115493469465828	fGQobjreD6	FEuHlBgcyE
iqGytArNbi	2021-05-18 16:05:16.6+00	2021-05-18 16:05:16.6+00	\N	\N	ecg	1.52734375,-0.0677631915313475	fGQobjreD6	FEuHlBgcyE
hqw05mxlrg	2021-05-18 16:05:16.8+00	2021-05-18 16:05:16.8+00	\N	\N	ecg	1.53125,-0.0858273237588429	fGQobjreD6	FEuHlBgcyE
MToJ4qElzf	2021-05-18 16:05:17.001+00	2021-05-18 16:05:17.001+00	\N	\N	ecg	1.53515625,-0.0131629912193893	fGQobjreD6	FEuHlBgcyE
7D18zhPBOo	2021-05-18 16:05:17.202+00	2021-05-18 16:05:17.202+00	\N	\N	ecg	1.5390625,-0.0441037763206974	fGQobjreD6	FEuHlBgcyE
GkaYSeeeTm	2021-05-18 16:05:17.403+00	2021-05-18 16:05:17.403+00	\N	\N	ecg	1.54296875,-0.0898557529407844	fGQobjreD6	FEuHlBgcyE
y4FL0gZpir	2021-05-18 16:05:17.603+00	2021-05-18 16:05:17.603+00	\N	\N	ecg	1.546875,-0.0363553080942667	fGQobjreD6	FEuHlBgcyE
B8AV4JqyTn	2021-05-18 16:05:17.803+00	2021-05-18 16:05:17.803+00	\N	\N	ecg	1.55078125,-0.0771366935216973	fGQobjreD6	FEuHlBgcyE
Iq3FoNPYep	2021-05-18 16:05:18.003+00	2021-05-18 16:05:18.003+00	\N	\N	ecg	1.5546875,0.0559029316290867	fGQobjreD6	FEuHlBgcyE
nBQVqELlNG	2021-05-18 16:05:18.204+00	2021-05-18 16:05:18.204+00	\N	\N	ecg	1.55859375,0.0231597739768244	fGQobjreD6	FEuHlBgcyE
Hb9Ycjt4RP	2021-05-18 16:05:18.404+00	2021-05-18 16:05:18.404+00	\N	\N	ecg	1.5625,-0.0807222722533805	fGQobjreD6	FEuHlBgcyE
0jocF7QR6G	2021-05-18 16:05:18.611+00	2021-05-18 16:05:18.611+00	\N	\N	ecg	1.56640625,-0.0101844006197011	fGQobjreD6	FEuHlBgcyE
kmmmEVB57A	2021-05-18 16:05:18.805+00	2021-05-18 16:05:18.805+00	\N	\N	ecg	1.5703125,0.0237084093192928	fGQobjreD6	FEuHlBgcyE
wO6Ph9a0ag	2021-05-18 16:05:19.005+00	2021-05-18 16:05:19.005+00	\N	\N	ecg	1.57421875,-0.0907511717619149	fGQobjreD6	FEuHlBgcyE
GQ0BxhQu0r	2021-05-18 16:05:19.208+00	2021-05-18 16:05:19.208+00	\N	\N	ecg	1.578125,-0.0911970637256693	fGQobjreD6	FEuHlBgcyE
mA6OUwZ0DT	2021-05-18 16:05:19.407+00	2021-05-18 16:05:19.407+00	\N	\N	ecg	1.58203125,-0.0589254128710708	fGQobjreD6	FEuHlBgcyE
32sho4jWZU	2021-05-18 16:05:19.609+00	2021-05-18 16:05:19.609+00	\N	\N	ecg	1.5859375,-0.0665505101506306	fGQobjreD6	FEuHlBgcyE
jEgvJDo2wM	2021-05-18 16:05:19.809+00	2021-05-18 16:05:19.809+00	\N	\N	ecg	1.58984375,-0.00681759073876825	fGQobjreD6	FEuHlBgcyE
SKc7xyKgfV	2021-05-18 16:05:20.013+00	2021-05-18 16:05:20.013+00	\N	\N	ecg	1.59375,-0.0997773010278427	fGQobjreD6	FEuHlBgcyE
g9TExndxI1	2021-05-18 16:05:20.212+00	2021-05-18 16:05:20.212+00	\N	\N	ecg	1.59765625,0.0829647143113702	fGQobjreD6	FEuHlBgcyE
WoAT2Dg2h1	2021-05-18 16:05:20.412+00	2021-05-18 16:05:20.412+00	\N	\N	ecg	1.6015625,0.0603826463996578	fGQobjreD6	FEuHlBgcyE
N9smFF2w9G	2021-05-18 16:05:20.613+00	2021-05-18 16:05:20.613+00	\N	\N	ecg	1.60546875,-0.0453164990299239	fGQobjreD6	FEuHlBgcyE
UzJDxNL0hA	2021-05-18 16:05:20.813+00	2021-05-18 16:05:20.813+00	\N	\N	ecg	1.609375,0.044699166943504	fGQobjreD6	FEuHlBgcyE
2wzDwp8pjX	2021-05-18 16:05:21.013+00	2021-05-18 16:05:21.013+00	\N	\N	ecg	1.61328125,-0.0630556407049914	fGQobjreD6	FEuHlBgcyE
AgDxTfUPLs	2021-05-18 16:05:21.215+00	2021-05-18 16:05:21.215+00	\N	\N	ecg	1.6171875,-0.0621335284475862	fGQobjreD6	FEuHlBgcyE
SSOxKE1WrO	2021-05-18 16:05:21.414+00	2021-05-18 16:05:21.414+00	\N	\N	ecg	1.62109375,-0.0488954905998347	fGQobjreD6	FEuHlBgcyE
A6PWs647rL	2021-05-18 16:05:21.615+00	2021-05-18 16:05:21.615+00	\N	\N	ecg	1.625,0.0751324462188925	fGQobjreD6	FEuHlBgcyE
K1SlTbouOh	2021-05-18 16:05:21.816+00	2021-05-18 16:05:21.816+00	\N	\N	ecg	1.62890625,-0.00188934887938398	fGQobjreD6	FEuHlBgcyE
Z1lDHjT92p	2021-05-18 16:05:22.06+00	2021-05-18 16:05:22.06+00	\N	\N	ecg	1.6328125,-0.0265907425432962	fGQobjreD6	FEuHlBgcyE
q3HVBkP8VF	2021-05-18 16:05:22.224+00	2021-05-18 16:05:22.224+00	\N	\N	ecg	1.63671875,0.0638525097770323	fGQobjreD6	FEuHlBgcyE
Z8ma5fUDiH	2021-05-18 16:05:22.427+00	2021-05-18 16:05:22.427+00	\N	\N	ecg	1.640625,-0.0298996422801941	fGQobjreD6	FEuHlBgcyE
97x4fEPC4d	2021-05-18 16:05:22.625+00	2021-05-18 16:05:22.625+00	\N	\N	ecg	1.64453125,0.0392370740443337	fGQobjreD6	FEuHlBgcyE
o288DudYDJ	2021-05-18 16:05:22.826+00	2021-05-18 16:05:22.826+00	\N	\N	ecg	1.6484375,-0.0371911865037357	fGQobjreD6	FEuHlBgcyE
0ZUp6hLIbd	2021-05-18 16:05:23.026+00	2021-05-18 16:05:23.026+00	\N	\N	ecg	1.65234375,0.0275619973003453	fGQobjreD6	FEuHlBgcyE
K2CZpSx7td	2021-05-18 16:05:23.226+00	2021-05-18 16:05:23.226+00	\N	\N	ecg	1.65625,-0.0536530681139482	fGQobjreD6	FEuHlBgcyE
3WAgd4x4iq	2021-05-18 16:05:23.427+00	2021-05-18 16:05:23.427+00	\N	\N	ecg	1.66015625,-0.0192728154324219	fGQobjreD6	FEuHlBgcyE
iPwU3ae400	2021-05-18 16:05:23.632+00	2021-05-18 16:05:23.632+00	\N	\N	ecg	1.6640625,-0.0208584609344444	fGQobjreD6	FEuHlBgcyE
wDyJQGQ2np	2021-05-18 16:05:23.829+00	2021-05-18 16:05:23.829+00	\N	\N	ecg	1.66796875,-0.0505181087801421	fGQobjreD6	FEuHlBgcyE
EDJKVtuDGI	2021-05-18 16:05:24.029+00	2021-05-18 16:05:24.029+00	\N	\N	ecg	1.671875,-0.0198608211300341	fGQobjreD6	FEuHlBgcyE
WGFhohP2ne	2021-05-18 16:05:24.23+00	2021-05-18 16:05:24.23+00	\N	\N	ecg	1.67578125,-0.00536604985980523	fGQobjreD6	FEuHlBgcyE
9MaFO3YP0e	2021-05-18 16:05:24.431+00	2021-05-18 16:05:24.431+00	\N	\N	ecg	1.6796875,-0.00678395331308003	fGQobjreD6	FEuHlBgcyE
dE5ZLfjmyQ	2021-05-18 16:05:24.631+00	2021-05-18 16:05:24.631+00	\N	\N	ecg	1.68359375,-0.0153865043130764	fGQobjreD6	FEuHlBgcyE
n0B6JbMJSS	2021-05-18 16:05:24.831+00	2021-05-18 16:05:24.831+00	\N	\N	ecg	1.6875,0.0826131786726928	fGQobjreD6	FEuHlBgcyE
GMwDF8nD5x	2021-05-18 16:05:25.031+00	2021-05-18 16:05:25.031+00	\N	\N	ecg	1.69140625,-0.0657794922748262	fGQobjreD6	FEuHlBgcyE
WxVattRWz1	2021-05-18 16:05:25.232+00	2021-05-18 16:05:25.232+00	\N	\N	ecg	1.6953125,0.0144229548256896	fGQobjreD6	FEuHlBgcyE
cG9pLxhDF5	2021-05-18 16:05:25.432+00	2021-05-18 16:05:25.432+00	\N	\N	ecg	1.69921875,0.0964051724313587	fGQobjreD6	FEuHlBgcyE
MO3zNxtHgc	2021-05-18 16:05:25.633+00	2021-05-18 16:05:25.633+00	\N	\N	ecg	1.703125,-0.0259311850083524	fGQobjreD6	FEuHlBgcyE
Olvn3IITcT	2021-05-18 16:05:25.834+00	2021-05-18 16:05:25.834+00	\N	\N	ecg	1.70703125,-0.0861710658390892	fGQobjreD6	FEuHlBgcyE
Eu1sMjA5yA	2021-05-18 16:05:26.035+00	2021-05-18 16:05:26.035+00	\N	\N	ecg	1.7109375,0.10873990519859	fGQobjreD6	FEuHlBgcyE
Ge2UqYQEOO	2021-05-18 16:05:26.235+00	2021-05-18 16:05:26.235+00	\N	\N	ecg	1.71484375,-0.0354368880739339	fGQobjreD6	FEuHlBgcyE
JNQqok4p9S	2021-05-18 16:05:26.436+00	2021-05-18 16:05:26.436+00	\N	\N	ecg	1.71875,0.0111402285344782	fGQobjreD6	FEuHlBgcyE
VHehdf4JJe	2021-05-18 16:05:26.637+00	2021-05-18 16:05:26.637+00	\N	\N	ecg	1.72265625,-0.0454891613525848	fGQobjreD6	FEuHlBgcyE
s5nZXjEONA	2021-05-18 16:05:26.837+00	2021-05-18 16:05:26.837+00	\N	\N	ecg	1.7265625,-0.00912257595545842	fGQobjreD6	FEuHlBgcyE
RTFR7S2RUZ	2021-05-18 16:05:27.038+00	2021-05-18 16:05:27.038+00	\N	\N	ecg	1.73046875,-0.0680615864745478	fGQobjreD6	FEuHlBgcyE
gnX3hxkH2S	2021-05-18 16:05:27.238+00	2021-05-18 16:05:27.238+00	\N	\N	ecg	1.734375,0.127996753394931	fGQobjreD6	FEuHlBgcyE
ZfnF3UM8JH	2021-05-18 16:05:27.439+00	2021-05-18 16:05:27.439+00	\N	\N	ecg	1.73828125,0.0997070419554419	fGQobjreD6	FEuHlBgcyE
b7BLAXY3CV	2021-05-18 16:05:27.639+00	2021-05-18 16:05:27.639+00	\N	\N	ecg	1.7421875,0.123127027347168	fGQobjreD6	FEuHlBgcyE
wrk7LPqncg	2021-05-18 16:05:27.839+00	2021-05-18 16:05:27.839+00	\N	\N	ecg	1.74609375,0.136732783765027	fGQobjreD6	FEuHlBgcyE
yHse6tERgs	2021-05-18 16:05:28.041+00	2021-05-18 16:05:28.041+00	\N	\N	ecg	1.75,0.0407842622533523	fGQobjreD6	FEuHlBgcyE
bbNlGpGMIs	2021-05-18 16:05:28.24+00	2021-05-18 16:05:28.24+00	\N	\N	ecg	1.75390625,0.0864737790014718	fGQobjreD6	FEuHlBgcyE
fbm42X71rJ	2021-05-18 16:05:28.441+00	2021-05-18 16:05:28.441+00	\N	\N	ecg	1.7578125,0.096544835028964	fGQobjreD6	FEuHlBgcyE
DwCuusXwQQ	2021-05-18 16:05:28.644+00	2021-05-18 16:05:28.644+00	\N	\N	ecg	1.76171875,0.119136770566511	fGQobjreD6	FEuHlBgcyE
TT4lFJx5NI	2021-05-18 16:05:28.842+00	2021-05-18 16:05:28.842+00	\N	\N	ecg	1.765625,0.101442564498996	fGQobjreD6	FEuHlBgcyE
Lc1TAkZc1h	2021-05-18 16:05:29.043+00	2021-05-18 16:05:29.043+00	\N	\N	ecg	1.76953125,0.167309437052069	fGQobjreD6	FEuHlBgcyE
KeGLcS1mkf	2021-05-18 16:05:29.243+00	2021-05-18 16:05:29.243+00	\N	\N	ecg	1.7734375,0.0377353079026451	fGQobjreD6	FEuHlBgcyE
5GXEaw8N0m	2021-05-18 16:05:29.443+00	2021-05-18 16:05:29.443+00	\N	\N	ecg	1.77734375,0.124293133501512	fGQobjreD6	FEuHlBgcyE
fSZVdGCVIW	2021-05-18 16:05:29.646+00	2021-05-18 16:05:29.646+00	\N	\N	ecg	1.78125,0.134544307493096	fGQobjreD6	FEuHlBgcyE
6xs6pqvTCC	2021-05-18 16:05:29.844+00	2021-05-18 16:05:29.844+00	\N	\N	ecg	1.78515625,0.178707155894595	fGQobjreD6	FEuHlBgcyE
Do5RHeb8CV	2021-05-18 16:05:30.045+00	2021-05-18 16:05:30.045+00	\N	\N	ecg	1.7890625,0.142802478724873	fGQobjreD6	FEuHlBgcyE
hhNsZf7vBo	2021-05-18 16:05:30.246+00	2021-05-18 16:05:30.246+00	\N	\N	ecg	1.79296875,0.156542060673886	fGQobjreD6	FEuHlBgcyE
GXyWvkfLdp	2021-05-18 16:05:30.447+00	2021-05-18 16:05:30.447+00	\N	\N	ecg	1.796875,0.295925466495326	fGQobjreD6	FEuHlBgcyE
7OG6koboyf	2021-05-18 16:05:30.647+00	2021-05-18 16:05:30.647+00	\N	\N	ecg	1.80078125,0.203004111730433	fGQobjreD6	FEuHlBgcyE
4ENwfffdOp	2021-05-18 16:05:30.847+00	2021-05-18 16:05:30.847+00	\N	\N	ecg	1.8046875,0.285204581463664	fGQobjreD6	FEuHlBgcyE
HPxxoDUc8N	2021-05-18 16:05:31.048+00	2021-05-18 16:05:31.048+00	\N	\N	ecg	1.80859375,0.277974916147161	fGQobjreD6	FEuHlBgcyE
4x8hLwxOMk	2021-05-18 16:05:31.248+00	2021-05-18 16:05:31.248+00	\N	\N	ecg	1.8125,0.334666544429197	fGQobjreD6	FEuHlBgcyE
JMPUEu4IgR	2021-05-18 16:05:31.449+00	2021-05-18 16:05:31.449+00	\N	\N	ecg	1.81640625,0.33902974647277	fGQobjreD6	FEuHlBgcyE
iSIsFNpg2k	2021-05-18 16:05:31.649+00	2021-05-18 16:05:31.649+00	\N	\N	ecg	1.8203125,0.204161476587801	fGQobjreD6	FEuHlBgcyE
feo10K40Ac	2021-05-18 16:05:31.85+00	2021-05-18 16:05:31.85+00	\N	\N	ecg	1.82421875,0.319574367497006	fGQobjreD6	FEuHlBgcyE
fXrWPEsRHa	2021-05-18 16:05:32.05+00	2021-05-18 16:05:32.05+00	\N	\N	ecg	1.828125,0.389379361899809	fGQobjreD6	FEuHlBgcyE
e9QbxsPORO	2021-05-18 16:05:32.251+00	2021-05-18 16:05:32.251+00	\N	\N	ecg	1.83203125,0.386061647726	fGQobjreD6	FEuHlBgcyE
kxbAcQGqxr	2021-05-18 16:05:32.451+00	2021-05-18 16:05:32.451+00	\N	\N	ecg	1.8359375,0.261831010039264	fGQobjreD6	FEuHlBgcyE
iR4T495lDQ	2021-05-18 16:05:32.652+00	2021-05-18 16:05:32.652+00	\N	\N	ecg	1.83984375,0.333939310083479	fGQobjreD6	FEuHlBgcyE
0a180oqDd9	2021-05-18 16:05:32.852+00	2021-05-18 16:05:32.852+00	\N	\N	ecg	1.84375,0.182305701008605	fGQobjreD6	FEuHlBgcyE
H4J7tQ0Aie	2021-05-18 16:05:33.052+00	2021-05-18 16:05:33.052+00	\N	\N	ecg	1.84765625,0.292685051987256	fGQobjreD6	FEuHlBgcyE
vmPnknciz1	2021-05-18 16:05:33.253+00	2021-05-18 16:05:33.253+00	\N	\N	ecg	1.8515625,0.213812050542015	fGQobjreD6	FEuHlBgcyE
knyCCRaBA7	2021-05-18 16:05:33.454+00	2021-05-18 16:05:33.454+00	\N	\N	ecg	1.85546875,0.285746439122494	fGQobjreD6	FEuHlBgcyE
trKCQJiWGN	2021-05-18 16:05:33.659+00	2021-05-18 16:05:33.659+00	\N	\N	ecg	1.859375,0.229004321668699	fGQobjreD6	FEuHlBgcyE
IBzwrjEzzS	2021-05-18 16:05:33.855+00	2021-05-18 16:05:33.855+00	\N	\N	ecg	1.86328125,0.250698118914564	fGQobjreD6	FEuHlBgcyE
cqXb2kYilv	2021-05-18 16:05:34.056+00	2021-05-18 16:05:34.056+00	\N	\N	ecg	1.8671875,0.28438780443771	fGQobjreD6	FEuHlBgcyE
pTriSBLEJZ	2021-05-18 16:05:34.255+00	2021-05-18 16:05:34.255+00	\N	\N	ecg	1.87109375,0.133227654191309	fGQobjreD6	FEuHlBgcyE
HfuLllfdvO	2021-05-18 16:05:34.456+00	2021-05-18 16:05:34.456+00	\N	\N	ecg	1.875,0.227394325819718	fGQobjreD6	FEuHlBgcyE
draF1KpfAg	2021-05-18 16:05:34.657+00	2021-05-18 16:05:34.657+00	\N	\N	ecg	1.87890625,0.138843107469857	fGQobjreD6	FEuHlBgcyE
Wqb3nJLHEH	2021-05-18 16:05:34.857+00	2021-05-18 16:05:34.857+00	\N	\N	ecg	1.8828125,0.120521307047579	fGQobjreD6	FEuHlBgcyE
QlIDk19ILv	2021-05-18 16:05:35.059+00	2021-05-18 16:05:35.059+00	\N	\N	ecg	1.88671875,0.162405386679642	fGQobjreD6	FEuHlBgcyE
abEHCiL397	2021-05-18 16:05:35.258+00	2021-05-18 16:05:35.258+00	\N	\N	ecg	1.890625,0.102135385367308	fGQobjreD6	FEuHlBgcyE
eejqtKrR9W	2021-05-18 16:05:35.46+00	2021-05-18 16:05:35.46+00	\N	\N	ecg	1.89453125,0.033475768741972	fGQobjreD6	FEuHlBgcyE
AfVtxHcOLI	2021-05-18 16:05:35.659+00	2021-05-18 16:05:35.659+00	\N	\N	ecg	1.8984375,0.132676146304381	fGQobjreD6	FEuHlBgcyE
XEAP7TERJS	2021-05-18 16:05:35.86+00	2021-05-18 16:05:35.86+00	\N	\N	ecg	1.90234375,-0.00705801161508589	fGQobjreD6	FEuHlBgcyE
OaK0crL9iF	2021-05-18 16:05:36.061+00	2021-05-18 16:05:36.061+00	\N	\N	ecg	1.90625,0.0380674905553353	fGQobjreD6	FEuHlBgcyE
PRALCEg1Ep	2021-05-18 16:05:36.263+00	2021-05-18 16:05:36.263+00	\N	\N	ecg	1.91015625,0.0954089623089891	fGQobjreD6	FEuHlBgcyE
xajZ7AJfIg	2021-05-18 16:05:36.462+00	2021-05-18 16:05:36.462+00	\N	\N	ecg	1.9140625,0.0685272779988416	fGQobjreD6	FEuHlBgcyE
HrflZ9k4Ck	2021-05-18 16:05:36.663+00	2021-05-18 16:05:36.663+00	\N	\N	ecg	1.91796875,-0.0131143574994507	fGQobjreD6	FEuHlBgcyE
zXRzodRu89	2021-05-18 16:05:36.863+00	2021-05-18 16:05:36.863+00	\N	\N	ecg	1.921875,0.0845656473768603	fGQobjreD6	FEuHlBgcyE
uMLHcEDMUZ	2021-05-18 16:05:37.064+00	2021-05-18 16:05:37.064+00	\N	\N	ecg	1.92578125,0.0762124643422892	fGQobjreD6	FEuHlBgcyE
SeEc1YW9Kw	2021-05-18 16:05:37.265+00	2021-05-18 16:05:37.265+00	\N	\N	ecg	1.9296875,-0.0724664569693898	fGQobjreD6	FEuHlBgcyE
zvOC1mcu6z	2021-05-18 16:05:37.47+00	2021-05-18 16:05:37.47+00	\N	\N	ecg	1.93359375,-0.161498432952839	fGQobjreD6	FEuHlBgcyE
UO4j6QTTPc	2021-05-18 16:05:37.667+00	2021-05-18 16:05:37.667+00	\N	\N	ecg	1.9375,-0.079727714046906	fGQobjreD6	FEuHlBgcyE
zxCJh1kaL7	2021-05-18 16:05:37.868+00	2021-05-18 16:05:37.868+00	\N	\N	ecg	1.94140625,-0.183467751182479	fGQobjreD6	FEuHlBgcyE
etwPy2vG7Q	2021-05-18 16:05:38.069+00	2021-05-18 16:05:38.069+00	\N	\N	ecg	1.9453125,-0.144304425275969	fGQobjreD6	FEuHlBgcyE
ihvtB3RmBm	2021-05-18 16:05:38.269+00	2021-05-18 16:05:38.269+00	\N	\N	ecg	1.94921875,-0.163458658403001	fGQobjreD6	FEuHlBgcyE
HMZOYPZeqM	2021-05-18 16:05:38.469+00	2021-05-18 16:05:38.469+00	\N	\N	ecg	1.953125,-0.0711002446953886	fGQobjreD6	FEuHlBgcyE
WOUvzUMXqa	2021-05-18 16:05:38.677+00	2021-05-18 16:05:38.677+00	\N	\N	ecg	1.95703125,-0.140922149572985	fGQobjreD6	FEuHlBgcyE
rGeOU9QSr9	2021-05-18 16:05:38.871+00	2021-05-18 16:05:38.871+00	\N	\N	ecg	1.9609375,0.0844452792869589	fGQobjreD6	FEuHlBgcyE
oUo0C8cViW	2021-05-18 16:05:39.071+00	2021-05-18 16:05:39.071+00	\N	\N	ecg	1.96484375,0.106514860005852	fGQobjreD6	FEuHlBgcyE
sSKUKCpCEt	2021-05-18 16:05:39.272+00	2021-05-18 16:05:39.272+00	\N	\N	ecg	1.96875,0.232933385838573	fGQobjreD6	FEuHlBgcyE
vKXpdgjqNa	2021-05-18 16:05:39.473+00	2021-05-18 16:05:39.473+00	\N	\N	ecg	1.97265625,0.399347566621186	fGQobjreD6	FEuHlBgcyE
1ZSyLqRxzZ	2021-05-18 16:05:39.673+00	2021-05-18 16:05:39.673+00	\N	\N	ecg	1.9765625,0.648487264644577	fGQobjreD6	FEuHlBgcyE
bqxHz3R6Xt	2021-05-18 16:05:39.875+00	2021-05-18 16:05:39.875+00	\N	\N	ecg	1.98046875,0.788939387361108	fGQobjreD6	FEuHlBgcyE
2gJnUBuJRD	2021-05-18 16:05:40.077+00	2021-05-18 16:05:40.077+00	\N	\N	ecg	1.984375,1.06321073401698	fGQobjreD6	FEuHlBgcyE
AshpVRKUVZ	2021-05-18 16:05:40.275+00	2021-05-18 16:05:40.275+00	\N	\N	ecg	1.98828125,1.15679534283234	fGQobjreD6	FEuHlBgcyE
jLC3o2pa22	2021-05-18 16:05:40.477+00	2021-05-18 16:05:40.477+00	\N	\N	ecg	1.9921875,1.08560398945084	fGQobjreD6	FEuHlBgcyE
wP0jzrKr7l	2021-05-18 16:05:40.678+00	2021-05-18 16:05:40.678+00	\N	\N	ecg	1.99609375,1.06583785466464	fGQobjreD6	FEuHlBgcyE
j3onFiu232	2021-05-18 16:05:40.878+00	2021-05-18 16:05:40.878+00	\N	\N	ecg	2.0,1.12705852985289	fGQobjreD6	FEuHlBgcyE
u6HH1OwBWf	2021-05-18 16:05:41.081+00	2021-05-18 16:05:41.081+00	\N	\N	ecg	2.00390625,1.06244793594112	fGQobjreD6	FEuHlBgcyE
sar8h1oanX	2021-05-18 16:05:41.279+00	2021-05-18 16:05:41.279+00	\N	\N	ecg	2.0078125,0.875759757505777	fGQobjreD6	FEuHlBgcyE
AqHkYJag8N	2021-05-18 16:05:41.48+00	2021-05-18 16:05:41.48+00	\N	\N	ecg	2.01171875,0.823738951746154	fGQobjreD6	FEuHlBgcyE
CO0WacWVwX	2021-05-18 16:05:41.681+00	2021-05-18 16:05:41.681+00	\N	\N	ecg	2.015625,0.604728179158279	fGQobjreD6	FEuHlBgcyE
o3GnBc2KtN	2021-05-18 16:05:41.881+00	2021-05-18 16:05:41.881+00	\N	\N	ecg	2.01953125,0.450252045996394	fGQobjreD6	FEuHlBgcyE
L9Dh74K3Sx	2021-05-18 16:05:42.083+00	2021-05-18 16:05:42.083+00	\N	\N	ecg	2.0234375,0.187966012385694	fGQobjreD6	FEuHlBgcyE
zR7kHfHuNN	2021-05-18 16:05:42.283+00	2021-05-18 16:05:42.283+00	\N	\N	ecg	2.02734375,-0.0592836927927862	fGQobjreD6	FEuHlBgcyE
Vvxv33cakQ	2021-05-18 16:05:42.483+00	2021-05-18 16:05:42.483+00	\N	\N	ecg	2.03125,-0.233386801821144	fGQobjreD6	FEuHlBgcyE
NcWjXzFqM8	2021-05-18 16:05:42.683+00	2021-05-18 16:05:42.683+00	\N	\N	ecg	2.03515625,-0.206492786527422	fGQobjreD6	FEuHlBgcyE
4fkNuRiLrd	2021-05-18 16:05:42.884+00	2021-05-18 16:05:42.884+00	\N	\N	ecg	2.0390625,-0.387907012645616	fGQobjreD6	FEuHlBgcyE
G3qVJIhbjZ	2021-05-18 16:05:43.086+00	2021-05-18 16:05:43.086+00	\N	\N	ecg	2.04296875,-0.35693074990372	fGQobjreD6	FEuHlBgcyE
PEpYHbbuF4	2021-05-18 16:05:43.286+00	2021-05-18 16:05:43.286+00	\N	\N	ecg	2.046875,-0.290222265475376	fGQobjreD6	FEuHlBgcyE
sKGuvMHf2G	2021-05-18 16:05:43.487+00	2021-05-18 16:05:43.487+00	\N	\N	ecg	2.05078125,-0.192017903885469	fGQobjreD6	FEuHlBgcyE
EkWWqcaQ1A	2021-05-18 16:05:43.692+00	2021-05-18 16:05:43.692+00	\N	\N	ecg	2.0546875,-0.277527170112164	fGQobjreD6	FEuHlBgcyE
ua30aXEk2N	2021-05-18 16:05:43.887+00	2021-05-18 16:05:43.887+00	\N	\N	ecg	2.05859375,-0.250093220451493	fGQobjreD6	FEuHlBgcyE
yGPvXWlFkQ	2021-05-18 16:05:44.089+00	2021-05-18 16:05:44.089+00	\N	\N	ecg	2.0625,-0.235729070324845	fGQobjreD6	FEuHlBgcyE
1F7eHTN1u4	2021-05-18 16:05:44.29+00	2021-05-18 16:05:44.29+00	\N	\N	ecg	2.06640625,-0.059024185306969	fGQobjreD6	FEuHlBgcyE
oDBzxbYrT7	2021-05-18 16:05:44.49+00	2021-05-18 16:05:44.49+00	\N	\N	ecg	2.0703125,-0.0428235239163977	fGQobjreD6	FEuHlBgcyE
cXHs2Y41MI	2021-05-18 16:05:44.691+00	2021-05-18 16:05:44.691+00	\N	\N	ecg	2.07421875,0.0194783311918042	fGQobjreD6	FEuHlBgcyE
Tk6OZokgEz	2021-05-18 16:05:44.888+00	2021-05-18 16:05:44.888+00	\N	\N	ecg	2.078125,-0.131853851051741	fGQobjreD6	FEuHlBgcyE
8E2Gz2a0dh	2021-05-18 16:05:45.089+00	2021-05-18 16:05:45.089+00	\N	\N	ecg	2.08203125,-0.0806966713945835	fGQobjreD6	FEuHlBgcyE
vIzHcY9zYI	2021-05-18 16:05:45.29+00	2021-05-18 16:05:45.29+00	\N	\N	ecg	2.0859375,-0.045575810958973	fGQobjreD6	FEuHlBgcyE
KWDJB9nNxo	2021-05-18 16:05:45.49+00	2021-05-18 16:05:45.49+00	\N	\N	ecg	2.08984375,-0.0498133966754605	fGQobjreD6	FEuHlBgcyE
d9jyrtKk8D	2021-05-18 16:05:45.69+00	2021-05-18 16:05:45.69+00	\N	\N	ecg	2.09375,0.0286909842798259	fGQobjreD6	FEuHlBgcyE
AZzD7kF4oW	2021-05-18 16:05:45.891+00	2021-05-18 16:05:45.891+00	\N	\N	ecg	2.09765625,-0.101691429951695	fGQobjreD6	FEuHlBgcyE
CzXd4cu235	2021-05-18 16:05:46.093+00	2021-05-18 16:05:46.093+00	\N	\N	ecg	2.1015625,0.0688875623691073	fGQobjreD6	FEuHlBgcyE
ZMWqrhpY9E	2021-05-18 16:05:46.292+00	2021-05-18 16:05:46.292+00	\N	\N	ecg	2.10546875,-0.0341086571432948	fGQobjreD6	FEuHlBgcyE
FkETjixv9Q	2021-05-18 16:05:46.493+00	2021-05-18 16:05:46.493+00	\N	\N	ecg	2.109375,-0.00354894593836948	fGQobjreD6	FEuHlBgcyE
wxNBE6jIu4	2021-05-18 16:05:46.693+00	2021-05-18 16:05:46.693+00	\N	\N	ecg	2.11328125,0.0292451353128132	fGQobjreD6	FEuHlBgcyE
J0uWrpJ196	2021-05-18 16:05:46.894+00	2021-05-18 16:05:46.894+00	\N	\N	ecg	2.1171875,-0.00373658554987735	fGQobjreD6	FEuHlBgcyE
gF8aFpKzIl	2021-05-18 16:05:47.095+00	2021-05-18 16:05:47.095+00	\N	\N	ecg	2.12109375,-0.0450412238007426	fGQobjreD6	FEuHlBgcyE
lTa0URq3PA	2021-05-18 16:05:47.295+00	2021-05-18 16:05:47.295+00	\N	\N	ecg	2.125,0.0992968646039004	fGQobjreD6	FEuHlBgcyE
5FDZTO2rFj	2021-05-18 16:05:47.495+00	2021-05-18 16:05:47.495+00	\N	\N	ecg	2.12890625,-0.0210341503077046	fGQobjreD6	FEuHlBgcyE
sdMGKFgHI5	2021-05-18 16:05:47.696+00	2021-05-18 16:05:47.696+00	\N	\N	ecg	2.1328125,0.0671065812014678	fGQobjreD6	FEuHlBgcyE
tA5XLj8iQx	2021-05-18 16:05:47.897+00	2021-05-18 16:05:47.897+00	\N	\N	ecg	2.13671875,0.11481088862095	fGQobjreD6	FEuHlBgcyE
WSepzEArZ1	2021-05-18 16:05:48.098+00	2021-05-18 16:05:48.098+00	\N	\N	ecg	2.140625,0.0343380699276404	fGQobjreD6	FEuHlBgcyE
1jbenv1LZw	2021-05-18 16:05:48.297+00	2021-05-18 16:05:48.297+00	\N	\N	ecg	2.14453125,0.171373661560386	fGQobjreD6	FEuHlBgcyE
4sxLCYail3	2021-05-18 16:05:48.499+00	2021-05-18 16:05:48.499+00	\N	\N	ecg	2.1484375,0.0218884515978358	fGQobjreD6	FEuHlBgcyE
e8TSHbSeNI	2021-05-18 16:05:48.705+00	2021-05-18 16:05:48.705+00	\N	\N	ecg	2.15234375,0.135763401042889	fGQobjreD6	FEuHlBgcyE
rpUKBSXRr1	2021-05-18 16:05:48.9+00	2021-05-18 16:05:48.9+00	\N	\N	ecg	2.15625,0.178347881143365	fGQobjreD6	FEuHlBgcyE
Dy89AZdAzm	2021-05-18 16:05:49.1+00	2021-05-18 16:05:49.1+00	\N	\N	ecg	2.16015625,0.0700744935663874	fGQobjreD6	FEuHlBgcyE
YhrBkHrhQP	2021-05-18 16:05:49.303+00	2021-05-18 16:05:49.303+00	\N	\N	ecg	2.1640625,0.126583310783601	fGQobjreD6	FEuHlBgcyE
kSFKBChY4j	2021-05-18 16:05:49.502+00	2021-05-18 16:05:49.502+00	\N	\N	ecg	2.16796875,0.250651516668627	fGQobjreD6	FEuHlBgcyE
3DVtVbK26V	2021-05-18 16:05:49.702+00	2021-05-18 16:05:49.702+00	\N	\N	ecg	2.171875,0.11405003651	fGQobjreD6	FEuHlBgcyE
tSsWw0B52F	2021-05-18 16:05:49.902+00	2021-05-18 16:05:49.902+00	\N	\N	ecg	2.17578125,0.239882169940308	fGQobjreD6	FEuHlBgcyE
ghkIL4fVol	2021-05-18 16:05:50.103+00	2021-05-18 16:05:50.103+00	\N	\N	ecg	2.1796875,0.159191582015438	fGQobjreD6	FEuHlBgcyE
4J3uRgylyc	2021-05-18 16:05:50.303+00	2021-05-18 16:05:50.303+00	\N	\N	ecg	2.18359375,0.145765935143261	fGQobjreD6	FEuHlBgcyE
A8QfhXFQv6	2021-05-18 16:05:50.504+00	2021-05-18 16:05:50.504+00	\N	\N	ecg	2.1875,0.204971215889314	fGQobjreD6	FEuHlBgcyE
b2WNPcDm9C	2021-05-18 16:05:50.705+00	2021-05-18 16:05:50.705+00	\N	\N	ecg	2.19140625,0.247349096907832	fGQobjreD6	FEuHlBgcyE
g0jggGsORI	2021-05-18 16:05:50.905+00	2021-05-18 16:05:50.905+00	\N	\N	ecg	2.1953125,0.37358488367951	fGQobjreD6	FEuHlBgcyE
VlLlqfTUqM	2021-05-18 16:05:51.107+00	2021-05-18 16:05:51.107+00	\N	\N	ecg	2.19921875,0.237401212308442	fGQobjreD6	FEuHlBgcyE
jIwd53mVUN	2021-05-18 16:05:51.309+00	2021-05-18 16:05:51.309+00	\N	\N	ecg	2.203125,0.399070054102479	fGQobjreD6	FEuHlBgcyE
cFGEnEAKRN	2021-05-18 16:05:51.507+00	2021-05-18 16:05:51.507+00	\N	\N	ecg	2.20703125,0.345663533588839	fGQobjreD6	FEuHlBgcyE
luxYxbAmKK	2021-05-18 16:05:51.707+00	2021-05-18 16:05:51.707+00	\N	\N	ecg	2.2109375,0.421630562459038	fGQobjreD6	FEuHlBgcyE
khhaHAGAmF	2021-05-18 16:05:51.908+00	2021-05-18 16:05:51.908+00	\N	\N	ecg	2.21484375,0.408571667473728	fGQobjreD6	FEuHlBgcyE
4SRJM48I03	2021-05-18 16:05:52.108+00	2021-05-18 16:05:52.108+00	\N	\N	ecg	2.21875,0.326508748625089	fGQobjreD6	FEuHlBgcyE
bi4fRmgxyj	2021-05-18 16:05:52.312+00	2021-05-18 16:05:52.312+00	\N	\N	ecg	2.22265625,0.453684747853945	fGQobjreD6	FEuHlBgcyE
90i45A4YH9	2021-05-18 16:05:52.511+00	2021-05-18 16:05:52.511+00	\N	\N	ecg	2.2265625,0.402663390443594	fGQobjreD6	FEuHlBgcyE
xRDeHzHyJY	2021-05-18 16:05:52.711+00	2021-05-18 16:05:52.711+00	\N	\N	ecg	2.23046875,0.454747407531027	fGQobjreD6	FEuHlBgcyE
W9qRXnkPq0	2021-05-18 16:05:52.912+00	2021-05-18 16:05:52.912+00	\N	\N	ecg	2.234375,0.410165185665853	fGQobjreD6	FEuHlBgcyE
CZblCLyawW	2021-05-18 16:05:53.112+00	2021-05-18 16:05:53.112+00	\N	\N	ecg	2.23828125,0.335879947892884	fGQobjreD6	FEuHlBgcyE
rnW5CeTIMI	2021-05-18 16:05:53.314+00	2021-05-18 16:05:53.314+00	\N	\N	ecg	2.2421875,0.338521936402238	fGQobjreD6	FEuHlBgcyE
PbtLVXR9RX	2021-05-18 16:05:53.515+00	2021-05-18 16:05:53.515+00	\N	\N	ecg	2.24609375,0.480067383046126	fGQobjreD6	FEuHlBgcyE
PEU2s6yrTY	2021-05-18 16:05:53.72+00	2021-05-18 16:05:53.72+00	\N	\N	ecg	2.25,0.444931717265355	fGQobjreD6	FEuHlBgcyE
j31dphlOom	2021-05-18 16:05:53.915+00	2021-05-18 16:05:53.915+00	\N	\N	ecg	2.25390625,0.420641810193508	fGQobjreD6	FEuHlBgcyE
kfPn19LFez	2021-05-18 16:05:54.117+00	2021-05-18 16:05:54.117+00	\N	\N	ecg	2.2578125,0.316493445668136	fGQobjreD6	FEuHlBgcyE
g7Q1sBBYie	2021-05-18 16:05:54.317+00	2021-05-18 16:05:54.317+00	\N	\N	ecg	2.26171875,0.309922380841522	fGQobjreD6	FEuHlBgcyE
ZXYQjHwEDS	2021-05-18 16:05:54.517+00	2021-05-18 16:05:54.517+00	\N	\N	ecg	2.265625,0.279488900817205	fGQobjreD6	FEuHlBgcyE
uACiAwtSkd	2021-05-18 16:05:54.718+00	2021-05-18 16:05:54.718+00	\N	\N	ecg	2.26953125,0.315024095161497	fGQobjreD6	FEuHlBgcyE
7dOF4Bu3Lc	2021-05-18 16:05:54.919+00	2021-05-18 16:05:54.919+00	\N	\N	ecg	2.2734375,0.320330790998883	fGQobjreD6	FEuHlBgcyE
qDhfK1RCyy	2021-05-18 16:05:55.119+00	2021-05-18 16:05:55.119+00	\N	\N	ecg	2.27734375,0.370425008099375	fGQobjreD6	FEuHlBgcyE
WaqukYOTty	2021-05-18 16:05:55.319+00	2021-05-18 16:05:55.319+00	\N	\N	ecg	2.28125,0.387059137355977	fGQobjreD6	FEuHlBgcyE
UEvbT47EIs	2021-05-18 16:05:55.521+00	2021-05-18 16:05:55.521+00	\N	\N	ecg	2.28515625,0.312637095674988	fGQobjreD6	FEuHlBgcyE
j7aTYbj2tz	2021-05-18 16:05:55.72+00	2021-05-18 16:05:55.72+00	\N	\N	ecg	2.2890625,0.294533411534843	fGQobjreD6	FEuHlBgcyE
VeTNcVAe5U	2021-05-18 16:05:55.922+00	2021-05-18 16:05:55.922+00	\N	\N	ecg	2.29296875,0.302799410682013	fGQobjreD6	FEuHlBgcyE
Q1kUVjHGsL	2021-05-18 16:05:56.122+00	2021-05-18 16:05:56.122+00	\N	\N	ecg	2.296875,0.179773410836103	fGQobjreD6	FEuHlBgcyE
lf8eGAxB2L	2021-05-18 16:05:56.321+00	2021-05-18 16:05:56.321+00	\N	\N	ecg	2.30078125,0.276255214340195	fGQobjreD6	FEuHlBgcyE
gfsB90QrPt	2021-05-18 16:05:56.523+00	2021-05-18 16:05:56.523+00	\N	\N	ecg	2.3046875,0.161100726368793	fGQobjreD6	FEuHlBgcyE
LkupU9n2Pi	2021-05-18 16:05:56.724+00	2021-05-18 16:05:56.724+00	\N	\N	ecg	2.30859375,0.284264424904188	fGQobjreD6	FEuHlBgcyE
qz0OoA2qpK	2021-05-18 16:05:56.923+00	2021-05-18 16:05:56.923+00	\N	\N	ecg	2.3125,0.198367800813536	fGQobjreD6	FEuHlBgcyE
5fgXnLQcMF	2021-05-18 16:05:57.124+00	2021-05-18 16:05:57.124+00	\N	\N	ecg	2.31640625,0.0966300820930321	fGQobjreD6	FEuHlBgcyE
6C8ejXxfvG	2021-05-18 16:05:57.325+00	2021-05-18 16:05:57.325+00	\N	\N	ecg	2.3203125,0.0836706917542261	fGQobjreD6	FEuHlBgcyE
hmDDIsaHwa	2021-05-18 16:05:57.524+00	2021-05-18 16:05:57.524+00	\N	\N	ecg	2.32421875,0.109200631654795	fGQobjreD6	FEuHlBgcyE
YRf5RH1KHs	2021-05-18 16:05:57.726+00	2021-05-18 16:05:57.726+00	\N	\N	ecg	2.328125,0.094076257896318	fGQobjreD6	FEuHlBgcyE
rtkV0ZcFBC	2021-05-18 16:05:57.926+00	2021-05-18 16:05:57.926+00	\N	\N	ecg	2.33203125,0.0340272894121502	fGQobjreD6	FEuHlBgcyE
wuKoZqgou0	2021-05-18 16:05:58.126+00	2021-05-18 16:05:58.126+00	\N	\N	ecg	2.3359375,0.181006962891072	fGQobjreD6	FEuHlBgcyE
AYBBfbHGiT	2021-05-18 16:05:58.326+00	2021-05-18 16:05:58.326+00	\N	\N	ecg	2.33984375,0.166189492901873	fGQobjreD6	FEuHlBgcyE
Ej0fvd9OCF	2021-05-18 16:05:58.527+00	2021-05-18 16:05:58.527+00	\N	\N	ecg	2.34375,-0.0134765328778534	fGQobjreD6	FEuHlBgcyE
8hrvrMGnKw	2021-05-18 16:05:58.73+00	2021-05-18 16:05:58.73+00	\N	\N	ecg	2.34765625,0.154011479402941	fGQobjreD6	FEuHlBgcyE
XuC73T3eaH	2021-05-18 16:05:58.928+00	2021-05-18 16:05:58.928+00	\N	\N	ecg	2.3515625,0.0554861408141964	fGQobjreD6	FEuHlBgcyE
RfHeqcqW77	2021-05-18 16:05:59.128+00	2021-05-18 16:05:59.128+00	\N	\N	ecg	2.35546875,0.0335430313062925	fGQobjreD6	FEuHlBgcyE
gwWO3G7MGl	2021-05-18 16:05:59.329+00	2021-05-18 16:05:59.329+00	\N	\N	ecg	2.359375,-0.0305423381088788	fGQobjreD6	FEuHlBgcyE
fpSM9SktBT	2021-05-18 16:05:59.529+00	2021-05-18 16:05:59.529+00	\N	\N	ecg	2.36328125,0.0050385631803817	fGQobjreD6	FEuHlBgcyE
vF2tehRmqe	2021-05-18 16:05:59.73+00	2021-05-18 16:05:59.73+00	\N	\N	ecg	2.3671875,-0.0310119032252117	fGQobjreD6	FEuHlBgcyE
yO4voaEKxg	2021-05-18 16:05:59.93+00	2021-05-18 16:05:59.93+00	\N	\N	ecg	2.37109375,-0.0085589146683882	fGQobjreD6	FEuHlBgcyE
iECVQpiv6P	2021-05-18 16:06:00.13+00	2021-05-18 16:06:00.13+00	\N	\N	ecg	2.375,-0.0413570845218212	fGQobjreD6	FEuHlBgcyE
fHeRvRynO5	2021-05-18 16:06:00.331+00	2021-05-18 16:06:00.331+00	\N	\N	ecg	2.37890625,0.0882271548048075	fGQobjreD6	FEuHlBgcyE
z4dTDLX2Ku	2021-05-18 16:06:00.531+00	2021-05-18 16:06:00.531+00	\N	\N	ecg	2.3828125,0.00280616873407654	fGQobjreD6	FEuHlBgcyE
zhYQvw9mWv	2021-05-18 16:06:00.732+00	2021-05-18 16:06:00.732+00	\N	\N	ecg	2.38671875,-0.0736756310882781	fGQobjreD6	FEuHlBgcyE
MU8YASoaKy	2021-05-18 16:06:00.932+00	2021-05-18 16:06:00.932+00	\N	\N	ecg	2.390625,-0.046991675110333	fGQobjreD6	FEuHlBgcyE
ABkeEmHgFT	2021-05-18 16:06:01.133+00	2021-05-18 16:06:01.133+00	\N	\N	ecg	2.39453125,-0.00947655728589637	fGQobjreD6	FEuHlBgcyE
k9QQUkVUTo	2021-05-18 16:06:01.333+00	2021-05-18 16:06:01.333+00	\N	\N	ecg	2.3984375,-0.117730609031758	fGQobjreD6	FEuHlBgcyE
FPUwDtX6BA	2021-05-18 16:06:01.533+00	2021-05-18 16:06:01.533+00	\N	\N	ecg	2.40234375,-0.120381648711539	fGQobjreD6	FEuHlBgcyE
KLSeHIK8Da	2021-05-18 16:06:01.734+00	2021-05-18 16:06:01.734+00	\N	\N	ecg	2.40625,0.0452457250836829	fGQobjreD6	FEuHlBgcyE
25SqtDg8Ce	2021-05-18 16:06:01.934+00	2021-05-18 16:06:01.934+00	\N	\N	ecg	2.41015625,-0.13803790404141	fGQobjreD6	FEuHlBgcyE
GO15F4xRGz	2021-05-18 16:06:02.136+00	2021-05-18 16:06:02.136+00	\N	\N	ecg	2.4140625,0.022700142726962	fGQobjreD6	FEuHlBgcyE
k4Lrf6o1V8	2021-05-18 16:06:02.336+00	2021-05-18 16:06:02.336+00	\N	\N	ecg	2.41796875,-0.121632858316668	fGQobjreD6	FEuHlBgcyE
wlO8Urk6HH	2021-05-18 16:06:02.536+00	2021-05-18 16:06:02.536+00	\N	\N	ecg	2.421875,-0.0877866607033838	fGQobjreD6	FEuHlBgcyE
LQCe8yASQ1	2021-05-18 16:06:02.737+00	2021-05-18 16:06:02.737+00	\N	\N	ecg	2.42578125,-0.142284280941236	fGQobjreD6	FEuHlBgcyE
YIOf5QwfGH	2021-05-18 16:06:02.937+00	2021-05-18 16:06:02.937+00	\N	\N	ecg	2.4296875,-0.0438381338450631	fGQobjreD6	FEuHlBgcyE
UHRc6HwAXD	2021-05-18 16:06:03.138+00	2021-05-18 16:06:03.138+00	\N	\N	ecg	2.43359375,0.021509645885696	fGQobjreD6	FEuHlBgcyE
rf5edUKYMa	2021-05-18 16:06:03.338+00	2021-05-18 16:06:03.338+00	\N	\N	ecg	2.4375,-0.027263162496985	fGQobjreD6	FEuHlBgcyE
0ZinxPZPGR	2021-05-18 16:06:03.538+00	2021-05-18 16:06:03.538+00	\N	\N	ecg	2.44140625,-0.0585229040973365	fGQobjreD6	FEuHlBgcyE
DGwQKtufGZ	2021-05-18 16:06:03.743+00	2021-05-18 16:06:03.743+00	\N	\N	ecg	2.4453125,0.0528362007139422	fGQobjreD6	FEuHlBgcyE
IeTBcN4B6z	2021-05-18 16:06:03.939+00	2021-05-18 16:06:03.939+00	\N	\N	ecg	2.44921875,-0.0415359512716529	fGQobjreD6	FEuHlBgcyE
Mvz5C9P1NB	2021-05-18 16:06:04.14+00	2021-05-18 16:06:04.14+00	\N	\N	ecg	2.453125,-0.0664070847931159	fGQobjreD6	FEuHlBgcyE
qfaWBaAvJm	2021-05-18 16:06:04.34+00	2021-05-18 16:06:04.34+00	\N	\N	ecg	2.45703125,-0.085265913616269	fGQobjreD6	FEuHlBgcyE
Hp0kv4LNrt	2021-05-18 16:06:04.541+00	2021-05-18 16:06:04.541+00	\N	\N	ecg	2.4609375,0.0170288687324424	fGQobjreD6	FEuHlBgcyE
ORpjW3Qcmi	2021-05-18 16:06:04.743+00	2021-05-18 16:06:04.743+00	\N	\N	ecg	2.46484375,-0.0994135063240511	fGQobjreD6	FEuHlBgcyE
hMZaD9jgVE	2021-05-18 16:06:04.942+00	2021-05-18 16:06:04.942+00	\N	\N	ecg	2.46875,-0.0914474894169695	fGQobjreD6	FEuHlBgcyE
mUoHRfwikV	2021-05-18 16:06:05.142+00	2021-05-18 16:06:05.142+00	\N	\N	ecg	2.47265625,0.0573887084220024	fGQobjreD6	FEuHlBgcyE
nB3NLiYJ39	2021-05-18 16:06:05.343+00	2021-05-18 16:06:05.343+00	\N	\N	ecg	2.4765625,-0.139721554462703	fGQobjreD6	FEuHlBgcyE
d8PYEHpUSs	2021-05-18 16:06:05.543+00	2021-05-18 16:06:05.543+00	\N	\N	ecg	2.48046875,-0.103318531963274	fGQobjreD6	FEuHlBgcyE
8gWMSuc6EY	2021-05-18 16:06:05.744+00	2021-05-18 16:06:05.744+00	\N	\N	ecg	2.484375,0.059615075962462	fGQobjreD6	FEuHlBgcyE
8cKGUX6bAC	2021-05-18 16:06:05.944+00	2021-05-18 16:06:05.944+00	\N	\N	ecg	2.48828125,-0.0937670038975264	fGQobjreD6	FEuHlBgcyE
DJf8ADT3tl	2021-05-18 16:06:06.144+00	2021-05-18 16:06:06.144+00	\N	\N	ecg	2.4921875,0.0444557533055442	fGQobjreD6	FEuHlBgcyE
VXPGLXhugv	2021-05-18 16:06:06.346+00	2021-05-18 16:06:06.346+00	\N	\N	ecg	2.49609375,-0.0555677239651816	fGQobjreD6	FEuHlBgcyE
Ely8xt70vE	2021-05-18 16:06:06.545+00	2021-05-18 16:06:06.545+00	\N	\N	ecg	2.5,-0.0158356480141744	fGQobjreD6	FEuHlBgcyE
vrf3fJKnVf	2021-05-18 16:06:06.746+00	2021-05-18 16:06:06.746+00	\N	\N	ecg	2.50390625,0.0452806581720361	fGQobjreD6	FEuHlBgcyE
GBGCRZFiJZ	2021-05-18 16:06:06.946+00	2021-05-18 16:06:06.946+00	\N	\N	ecg	2.5078125,-0.0971565334284623	fGQobjreD6	FEuHlBgcyE
sUJIEpKnb5	2021-05-18 16:06:07.147+00	2021-05-18 16:06:07.147+00	\N	\N	ecg	2.51171875,-0.0951167169061745	fGQobjreD6	FEuHlBgcyE
mWIPtoXTiw	2021-05-18 16:06:07.348+00	2021-05-18 16:06:07.348+00	\N	\N	ecg	2.515625,-0.124630870192969	fGQobjreD6	FEuHlBgcyE
cd0ZfxBYpL	2021-05-18 16:06:07.548+00	2021-05-18 16:06:07.548+00	\N	\N	ecg	2.51953125,0.0558887387699032	fGQobjreD6	FEuHlBgcyE
MvUTPgcU1N	2021-05-18 16:06:07.749+00	2021-05-18 16:06:07.749+00	\N	\N	ecg	2.5234375,-0.115493469465828	fGQobjreD6	FEuHlBgcyE
YwFKFWOa1I	2021-05-18 16:06:07.949+00	2021-05-18 16:06:07.949+00	\N	\N	ecg	2.52734375,-0.0677631915313475	fGQobjreD6	FEuHlBgcyE
VaGoE8tzDM	2021-05-18 16:06:08.153+00	2021-05-18 16:06:08.153+00	\N	\N	ecg	2.53125,-0.0858273237588429	fGQobjreD6	FEuHlBgcyE
HQrqh8kYh4	2021-05-18 16:06:08.351+00	2021-05-18 16:06:08.351+00	\N	\N	ecg	2.53515625,-0.0131629912193893	fGQobjreD6	FEuHlBgcyE
KNwB4biSUv	2021-05-18 16:06:08.551+00	2021-05-18 16:06:08.551+00	\N	\N	ecg	2.5390625,-0.0441037763206974	fGQobjreD6	FEuHlBgcyE
GK6y5G8W4x	2021-05-18 16:06:08.756+00	2021-05-18 16:06:08.756+00	\N	\N	ecg	2.54296875,-0.0898557529407844	fGQobjreD6	FEuHlBgcyE
zYC5nRgWIH	2021-05-18 16:06:08.953+00	2021-05-18 16:06:08.953+00	\N	\N	ecg	2.546875,-0.0363553080942667	fGQobjreD6	FEuHlBgcyE
ZPbfsHAvMF	2021-05-18 16:06:09.153+00	2021-05-18 16:06:09.153+00	\N	\N	ecg	2.55078125,-0.0771366935216973	fGQobjreD6	FEuHlBgcyE
jxNjE5Bl6P	2021-05-18 16:06:09.353+00	2021-05-18 16:06:09.353+00	\N	\N	ecg	2.5546875,0.0559029316290867	fGQobjreD6	FEuHlBgcyE
aGkFhDdCvK	2021-05-18 16:06:09.553+00	2021-05-18 16:06:09.553+00	\N	\N	ecg	2.55859375,0.0231597739768244	fGQobjreD6	FEuHlBgcyE
HWEWXcVmJt	2021-05-18 16:06:09.754+00	2021-05-18 16:06:09.754+00	\N	\N	ecg	2.5625,-0.0807222722533805	fGQobjreD6	FEuHlBgcyE
iMulJvsEVv	2021-05-18 16:06:09.955+00	2021-05-18 16:06:09.955+00	\N	\N	ecg	2.56640625,-0.0101844006197011	fGQobjreD6	FEuHlBgcyE
AMH476gyZp	2021-05-18 16:06:10.155+00	2021-05-18 16:06:10.155+00	\N	\N	ecg	2.5703125,0.0237084093192928	fGQobjreD6	FEuHlBgcyE
rk5XNWDS9M	2021-05-18 16:06:10.355+00	2021-05-18 16:06:10.355+00	\N	\N	ecg	2.57421875,-0.0907511717619149	fGQobjreD6	FEuHlBgcyE
CKKS4sbZtQ	2021-05-18 16:06:10.556+00	2021-05-18 16:06:10.556+00	\N	\N	ecg	2.578125,-0.0911970637256693	fGQobjreD6	FEuHlBgcyE
74hEF5EcCd	2021-05-18 16:06:10.756+00	2021-05-18 16:06:10.756+00	\N	\N	ecg	2.58203125,-0.0589254128710708	fGQobjreD6	FEuHlBgcyE
4jp0RZKp7y	2021-05-18 16:06:10.956+00	2021-05-18 16:06:10.956+00	\N	\N	ecg	2.5859375,-0.0665505101506306	fGQobjreD6	FEuHlBgcyE
ODe6hPQxB4	2021-05-18 16:06:11.157+00	2021-05-18 16:06:11.157+00	\N	\N	ecg	2.58984375,-0.00681759073876825	fGQobjreD6	FEuHlBgcyE
BiHf6sScct	2021-05-18 16:06:11.357+00	2021-05-18 16:06:11.357+00	\N	\N	ecg	2.59375,-0.0997773010278427	fGQobjreD6	FEuHlBgcyE
EqdpPIaF3g	2021-05-18 16:06:11.558+00	2021-05-18 16:06:11.558+00	\N	\N	ecg	2.59765625,0.0829647143113702	fGQobjreD6	FEuHlBgcyE
dVMmaO2OnN	2021-05-18 16:06:11.758+00	2021-05-18 16:06:11.758+00	\N	\N	ecg	2.6015625,0.0603826463996578	fGQobjreD6	FEuHlBgcyE
ZOPI82mGYt	2021-05-18 16:06:11.959+00	2021-05-18 16:06:11.959+00	\N	\N	ecg	2.60546875,-0.0453164990299239	fGQobjreD6	FEuHlBgcyE
umVGeyvs4Y	2021-05-18 16:06:12.16+00	2021-05-18 16:06:12.16+00	\N	\N	ecg	2.609375,0.044699166943504	fGQobjreD6	FEuHlBgcyE
eTd791vGAs	2021-05-18 16:06:12.361+00	2021-05-18 16:06:12.361+00	\N	\N	ecg	2.61328125,-0.0630556407049914	fGQobjreD6	FEuHlBgcyE
nfuS0oNAw1	2021-05-18 16:06:12.561+00	2021-05-18 16:06:12.561+00	\N	\N	ecg	2.6171875,-0.0621335284475862	fGQobjreD6	FEuHlBgcyE
teogpgUenN	2021-05-18 16:06:12.762+00	2021-05-18 16:06:12.762+00	\N	\N	ecg	2.62109375,-0.0488954905998347	fGQobjreD6	FEuHlBgcyE
omATFbtjwM	2021-05-18 16:06:12.963+00	2021-05-18 16:06:12.963+00	\N	\N	ecg	2.625,0.0751324462188925	fGQobjreD6	FEuHlBgcyE
CTBkKLms9I	2021-05-18 16:06:13.163+00	2021-05-18 16:06:13.163+00	\N	\N	ecg	2.62890625,-0.00188934887938398	fGQobjreD6	FEuHlBgcyE
SB8nBHZBiy	2021-05-18 16:06:13.363+00	2021-05-18 16:06:13.363+00	\N	\N	ecg	2.6328125,-0.0265907425432962	fGQobjreD6	FEuHlBgcyE
lH9MV1nq5H	2021-05-18 16:06:13.563+00	2021-05-18 16:06:13.563+00	\N	\N	ecg	2.63671875,0.0638525097770323	fGQobjreD6	FEuHlBgcyE
1lwsFnNIBt	2021-05-18 16:06:13.767+00	2021-05-18 16:06:13.767+00	\N	\N	ecg	2.640625,-0.0298996422801941	fGQobjreD6	FEuHlBgcyE
3LIrvz2GuN	2021-05-18 16:06:13.965+00	2021-05-18 16:06:13.965+00	\N	\N	ecg	2.64453125,0.0392370740443337	fGQobjreD6	FEuHlBgcyE
8Lp8MMN4Fg	2021-05-18 16:06:14.165+00	2021-05-18 16:06:14.165+00	\N	\N	ecg	2.6484375,-0.0371911865037357	fGQobjreD6	FEuHlBgcyE
7L2USfuWZa	2021-05-18 16:06:14.366+00	2021-05-18 16:06:14.366+00	\N	\N	ecg	2.65234375,0.0275619973003453	fGQobjreD6	FEuHlBgcyE
OxM0W7cNq0	2021-05-18 16:06:14.566+00	2021-05-18 16:06:14.566+00	\N	\N	ecg	2.65625,-0.0536530681139482	fGQobjreD6	FEuHlBgcyE
uYoMQ5v1EW	2021-05-18 16:06:14.767+00	2021-05-18 16:06:14.767+00	\N	\N	ecg	2.66015625,-0.0192728154324219	fGQobjreD6	FEuHlBgcyE
ThVDBKCuHK	2021-05-18 16:06:14.968+00	2021-05-18 16:06:14.968+00	\N	\N	ecg	2.6640625,-0.0208584609344444	fGQobjreD6	FEuHlBgcyE
YCz3E4HSFw	2021-05-18 16:06:15.168+00	2021-05-18 16:06:15.168+00	\N	\N	ecg	2.66796875,-0.0505181087801421	fGQobjreD6	FEuHlBgcyE
QP5kdGY7Qt	2021-05-18 16:06:15.369+00	2021-05-18 16:06:15.369+00	\N	\N	ecg	2.671875,-0.0198608211300341	fGQobjreD6	FEuHlBgcyE
9Uev5IhQIt	2021-05-18 16:06:15.569+00	2021-05-18 16:06:15.569+00	\N	\N	ecg	2.67578125,-0.00536604985980523	fGQobjreD6	FEuHlBgcyE
inQByJHcqK	2021-05-18 16:06:15.769+00	2021-05-18 16:06:15.769+00	\N	\N	ecg	2.6796875,-0.00678395331308003	fGQobjreD6	FEuHlBgcyE
SY0tZHpB5t	2021-05-18 16:06:15.971+00	2021-05-18 16:06:15.971+00	\N	\N	ecg	2.68359375,-0.0153865043130764	fGQobjreD6	FEuHlBgcyE
18w5R5Dm64	2021-05-18 16:06:16.171+00	2021-05-18 16:06:16.171+00	\N	\N	ecg	2.6875,0.0826131786726928	fGQobjreD6	FEuHlBgcyE
TWUu6tjNx8	2021-05-18 16:06:16.371+00	2021-05-18 16:06:16.371+00	\N	\N	ecg	2.69140625,-0.0657794922748262	fGQobjreD6	FEuHlBgcyE
UAao1bYrl1	2021-05-18 16:06:16.571+00	2021-05-18 16:06:16.571+00	\N	\N	ecg	2.6953125,0.0144229548256896	fGQobjreD6	FEuHlBgcyE
dVn2Tvgt4S	2021-05-18 16:06:16.772+00	2021-05-18 16:06:16.772+00	\N	\N	ecg	2.69921875,0.0964051724313587	fGQobjreD6	FEuHlBgcyE
MxvRU9R7wM	2021-05-18 16:06:16.973+00	2021-05-18 16:06:16.973+00	\N	\N	ecg	2.703125,-0.0259311850083524	fGQobjreD6	FEuHlBgcyE
KsTLYah83Z	2021-05-18 16:06:17.173+00	2021-05-18 16:06:17.173+00	\N	\N	ecg	2.70703125,-0.0861710658390892	fGQobjreD6	FEuHlBgcyE
Xv0OuHATxk	2021-05-18 16:06:17.374+00	2021-05-18 16:06:17.374+00	\N	\N	ecg	2.7109375,0.10873990519859	fGQobjreD6	FEuHlBgcyE
jlErFEV3jG	2021-05-18 16:06:17.575+00	2021-05-18 16:06:17.575+00	\N	\N	ecg	2.71484375,-0.0354368880739339	fGQobjreD6	FEuHlBgcyE
UeCvln1Zel	2021-05-18 16:06:17.774+00	2021-05-18 16:06:17.774+00	\N	\N	ecg	2.71875,0.0111402285344782	fGQobjreD6	FEuHlBgcyE
Wvjw880fvM	2021-05-18 16:06:17.975+00	2021-05-18 16:06:17.975+00	\N	\N	ecg	2.72265625,-0.0454891613525848	fGQobjreD6	FEuHlBgcyE
MfIBd5ocio	2021-05-18 16:06:18.176+00	2021-05-18 16:06:18.176+00	\N	\N	ecg	2.7265625,-0.00912257595545842	fGQobjreD6	FEuHlBgcyE
nWjyVF9EaZ	2021-05-18 16:06:18.377+00	2021-05-18 16:06:18.377+00	\N	\N	ecg	2.73046875,-0.0680615864745478	fGQobjreD6	FEuHlBgcyE
hQeoJcS2fA	2021-05-18 16:06:18.576+00	2021-05-18 16:06:18.576+00	\N	\N	ecg	2.734375,0.127996753394931	fGQobjreD6	FEuHlBgcyE
D6SqM2YDRc	2021-05-18 16:06:18.78+00	2021-05-18 16:06:18.78+00	\N	\N	ecg	2.73828125,0.0997070419554419	fGQobjreD6	FEuHlBgcyE
edCB6KTVtN	2021-05-18 16:06:18.978+00	2021-05-18 16:06:18.978+00	\N	\N	ecg	2.7421875,0.123127027347168	fGQobjreD6	FEuHlBgcyE
j8CHBn1EHf	2021-05-18 16:06:19.178+00	2021-05-18 16:06:19.178+00	\N	\N	ecg	2.74609375,0.136732783765027	fGQobjreD6	FEuHlBgcyE
55OAPCcSRt	2021-05-18 16:06:19.379+00	2021-05-18 16:06:19.379+00	\N	\N	ecg	2.75,0.0407842622533523	fGQobjreD6	FEuHlBgcyE
OmrWijDE7q	2021-05-18 16:06:19.579+00	2021-05-18 16:06:19.579+00	\N	\N	ecg	2.75390625,0.0864737790014718	fGQobjreD6	FEuHlBgcyE
MhEcA6a0a0	2021-05-18 16:06:19.779+00	2021-05-18 16:06:19.779+00	\N	\N	ecg	2.7578125,0.096544835028964	fGQobjreD6	FEuHlBgcyE
jjRli6w0x5	2021-05-18 16:06:19.98+00	2021-05-18 16:06:19.98+00	\N	\N	ecg	2.76171875,0.119136770566511	fGQobjreD6	FEuHlBgcyE
Cv4pIqPLEV	2021-05-18 16:06:20.181+00	2021-05-18 16:06:20.181+00	\N	\N	ecg	2.765625,0.101442564498996	fGQobjreD6	FEuHlBgcyE
Pym7yAE3RC	2021-05-18 16:06:20.381+00	2021-05-18 16:06:20.381+00	\N	\N	ecg	2.76953125,0.167309437052069	fGQobjreD6	FEuHlBgcyE
DYnE2oX3qq	2021-05-18 16:06:20.582+00	2021-05-18 16:06:20.582+00	\N	\N	ecg	2.7734375,0.0377353079026451	fGQobjreD6	FEuHlBgcyE
AcnZ8SjiUh	2021-05-18 16:06:20.782+00	2021-05-18 16:06:20.782+00	\N	\N	ecg	2.77734375,0.124293133501512	fGQobjreD6	FEuHlBgcyE
RuT5wKKEyR	2021-05-18 16:06:20.982+00	2021-05-18 16:06:20.982+00	\N	\N	ecg	2.78125,0.134544307493096	fGQobjreD6	FEuHlBgcyE
ITks9kRVA3	2021-05-18 16:06:21.182+00	2021-05-18 16:06:21.182+00	\N	\N	ecg	2.78515625,0.178707155894595	fGQobjreD6	FEuHlBgcyE
80TkeRzz1G	2021-05-18 16:06:21.383+00	2021-05-18 16:06:21.383+00	\N	\N	ecg	2.7890625,0.142802478724873	fGQobjreD6	FEuHlBgcyE
aO7U88a6WO	2021-05-18 16:06:21.583+00	2021-05-18 16:06:21.583+00	\N	\N	ecg	2.79296875,0.156542060673886	fGQobjreD6	FEuHlBgcyE
ylZZHnzAVP	2021-05-18 16:06:21.785+00	2021-05-18 16:06:21.785+00	\N	\N	ecg	2.796875,0.295925466495326	fGQobjreD6	FEuHlBgcyE
TrprLBhYpt	2021-05-18 16:06:21.984+00	2021-05-18 16:06:21.984+00	\N	\N	ecg	2.80078125,0.203004111730433	fGQobjreD6	FEuHlBgcyE
nqo5lUAtmV	2021-05-18 16:06:22.186+00	2021-05-18 16:06:22.186+00	\N	\N	ecg	2.8046875,0.285204581463664	fGQobjreD6	FEuHlBgcyE
9SFzySx4PU	2021-05-18 16:06:22.386+00	2021-05-18 16:06:22.386+00	\N	\N	ecg	2.80859375,0.277974916147161	fGQobjreD6	FEuHlBgcyE
xbotbxXTNB	2021-05-18 16:06:22.586+00	2021-05-18 16:06:22.586+00	\N	\N	ecg	2.8125,0.334666544429197	fGQobjreD6	FEuHlBgcyE
fxHSHGRNSz	2021-05-18 16:06:22.786+00	2021-05-18 16:06:22.786+00	\N	\N	ecg	2.81640625,0.33902974647277	fGQobjreD6	FEuHlBgcyE
uk7oMqAYLI	2021-05-18 16:06:22.987+00	2021-05-18 16:06:22.987+00	\N	\N	ecg	2.8203125,0.204161476587801	fGQobjreD6	FEuHlBgcyE
8pJwmgPb2f	2021-05-18 16:06:23.187+00	2021-05-18 16:06:23.187+00	\N	\N	ecg	2.82421875,0.319574367497006	fGQobjreD6	FEuHlBgcyE
9I0eu2zGuV	2021-05-18 16:06:23.393+00	2021-05-18 16:06:23.393+00	\N	\N	ecg	2.828125,0.389379361899809	fGQobjreD6	FEuHlBgcyE
LuL8hMAoGY	2021-05-18 16:06:23.591+00	2021-05-18 16:06:23.591+00	\N	\N	ecg	2.83203125,0.386061647726	fGQobjreD6	FEuHlBgcyE
KLnSRZndsw	2021-05-18 16:06:23.793+00	2021-05-18 16:06:23.793+00	\N	\N	ecg	2.8359375,0.261831010039264	fGQobjreD6	FEuHlBgcyE
LE5JpYG2xH	2021-05-18 16:06:23.991+00	2021-05-18 16:06:23.991+00	\N	\N	ecg	2.83984375,0.333939310083479	fGQobjreD6	FEuHlBgcyE
icCK1ZJO8m	2021-05-18 16:06:24.191+00	2021-05-18 16:06:24.191+00	\N	\N	ecg	2.84375,0.182305701008605	fGQobjreD6	FEuHlBgcyE
8K3JvG6Ouh	2021-05-18 16:06:24.392+00	2021-05-18 16:06:24.392+00	\N	\N	ecg	2.84765625,0.292685051987256	fGQobjreD6	FEuHlBgcyE
HUb7UDHvbT	2021-05-18 16:06:24.592+00	2021-05-18 16:06:24.592+00	\N	\N	ecg	2.8515625,0.213812050542015	fGQobjreD6	FEuHlBgcyE
W9mrqT1yJy	2021-05-18 16:06:24.793+00	2021-05-18 16:06:24.793+00	\N	\N	ecg	2.85546875,0.285746439122494	fGQobjreD6	FEuHlBgcyE
Gl7Tm9XaKV	2021-05-18 16:06:24.993+00	2021-05-18 16:06:24.993+00	\N	\N	ecg	2.859375,0.229004321668699	fGQobjreD6	FEuHlBgcyE
rut4Y3M51v	2021-05-18 16:06:25.194+00	2021-05-18 16:06:25.194+00	\N	\N	ecg	2.86328125,0.250698118914564	fGQobjreD6	FEuHlBgcyE
eNgmlD38Fp	2021-05-18 16:06:25.394+00	2021-05-18 16:06:25.394+00	\N	\N	ecg	2.8671875,0.28438780443771	fGQobjreD6	FEuHlBgcyE
zOcEwfl9aG	2021-05-18 16:06:25.594+00	2021-05-18 16:06:25.594+00	\N	\N	ecg	2.87109375,0.133227654191309	fGQobjreD6	FEuHlBgcyE
3Jh2tV2oX9	2021-05-18 16:06:25.795+00	2021-05-18 16:06:25.795+00	\N	\N	ecg	2.875,0.227394325819718	fGQobjreD6	FEuHlBgcyE
0RaVU4Vod3	2021-05-18 16:06:25.995+00	2021-05-18 16:06:25.995+00	\N	\N	ecg	2.87890625,0.138843107469857	fGQobjreD6	FEuHlBgcyE
CdvoqEyo7M	2021-05-18 16:06:26.197+00	2021-05-18 16:06:26.197+00	\N	\N	ecg	2.8828125,0.120521307047579	fGQobjreD6	FEuHlBgcyE
Ev2Dryp6In	2021-05-18 16:06:26.396+00	2021-05-18 16:06:26.396+00	\N	\N	ecg	2.88671875,0.162405386679642	fGQobjreD6	FEuHlBgcyE
Y2kFNyf0tx	2021-05-18 16:06:26.596+00	2021-05-18 16:06:26.596+00	\N	\N	ecg	2.890625,0.102135385367308	fGQobjreD6	FEuHlBgcyE
ZFprrvk9Yb	2021-05-18 16:06:26.798+00	2021-05-18 16:06:26.798+00	\N	\N	ecg	2.89453125,0.033475768741972	fGQobjreD6	FEuHlBgcyE
KtvQWsii9t	2021-05-18 16:06:26.998+00	2021-05-18 16:06:26.998+00	\N	\N	ecg	2.8984375,0.132676146304381	fGQobjreD6	FEuHlBgcyE
PIYdkYEh5X	2021-05-18 16:06:27.198+00	2021-05-18 16:06:27.198+00	\N	\N	ecg	2.90234375,-0.00705801161508589	fGQobjreD6	FEuHlBgcyE
NcpzyUnC42	2021-05-18 16:06:27.398+00	2021-05-18 16:06:27.398+00	\N	\N	ecg	2.90625,0.0380674905553353	fGQobjreD6	FEuHlBgcyE
JMs7DJL9Ck	2021-05-18 16:06:27.599+00	2021-05-18 16:06:27.599+00	\N	\N	ecg	2.91015625,0.0954089623089891	fGQobjreD6	FEuHlBgcyE
1d7Ky75sUB	2021-05-18 16:06:27.801+00	2021-05-18 16:06:27.801+00	\N	\N	ecg	2.9140625,0.0685272779988416	fGQobjreD6	FEuHlBgcyE
AJoyoUauJW	2021-05-18 16:06:28+00	2021-05-18 16:06:28+00	\N	\N	ecg	2.91796875,-0.0131143574994507	fGQobjreD6	FEuHlBgcyE
c3EGwIOmkn	2021-05-18 16:06:28.201+00	2021-05-18 16:06:28.201+00	\N	\N	ecg	2.921875,0.0845656473768603	fGQobjreD6	FEuHlBgcyE
pW5IqMWCao	2021-05-18 16:06:28.401+00	2021-05-18 16:06:28.401+00	\N	\N	ecg	2.92578125,0.0762124643422892	fGQobjreD6	FEuHlBgcyE
3L7MHEmtey	2021-05-18 16:06:28.601+00	2021-05-18 16:06:28.601+00	\N	\N	ecg	2.9296875,-0.0724664569693898	fGQobjreD6	FEuHlBgcyE
VbeewPmWes	2021-05-18 16:06:28.806+00	2021-05-18 16:06:28.806+00	\N	\N	ecg	2.93359375,-0.161498432952839	fGQobjreD6	FEuHlBgcyE
800LZFgTSc	2021-05-18 16:06:29.003+00	2021-05-18 16:06:29.003+00	\N	\N	ecg	2.9375,-0.079727714046906	fGQobjreD6	FEuHlBgcyE
STCmXJegqh	2021-05-18 16:06:29.203+00	2021-05-18 16:06:29.203+00	\N	\N	ecg	2.94140625,-0.183467751182479	fGQobjreD6	FEuHlBgcyE
DLII2DpAgQ	2021-05-18 16:06:29.403+00	2021-05-18 16:06:29.403+00	\N	\N	ecg	2.9453125,-0.144304425275969	fGQobjreD6	FEuHlBgcyE
GBUFnjkgHf	2021-05-18 16:06:29.604+00	2021-05-18 16:06:29.604+00	\N	\N	ecg	2.94921875,-0.163458658403001	fGQobjreD6	FEuHlBgcyE
a7yltUKwmP	2021-05-18 16:06:29.804+00	2021-05-18 16:06:29.804+00	\N	\N	ecg	2.953125,-0.0711002446953886	fGQobjreD6	FEuHlBgcyE
dMkvySyUhm	2021-05-18 16:06:30.004+00	2021-05-18 16:06:30.004+00	\N	\N	ecg	2.95703125,-0.140922149572985	fGQobjreD6	FEuHlBgcyE
vES57Ki9Y6	2021-05-18 16:06:30.205+00	2021-05-18 16:06:30.205+00	\N	\N	ecg	2.9609375,0.0844452792869589	fGQobjreD6	FEuHlBgcyE
tuK4061Hb9	2021-05-18 16:06:30.406+00	2021-05-18 16:06:30.406+00	\N	\N	ecg	2.96484375,0.106514860005852	fGQobjreD6	FEuHlBgcyE
MvDlFIJB6N	2021-05-18 16:06:30.606+00	2021-05-18 16:06:30.606+00	\N	\N	ecg	2.96875,0.232933385838573	fGQobjreD6	FEuHlBgcyE
clV4P53GAp	2021-05-18 16:06:30.807+00	2021-05-18 16:06:30.807+00	\N	\N	ecg	2.97265625,0.399347566621186	fGQobjreD6	FEuHlBgcyE
TxBR3ugWHb	2021-05-18 16:06:31.006+00	2021-05-18 16:06:31.006+00	\N	\N	ecg	2.9765625,0.648487264644577	fGQobjreD6	FEuHlBgcyE
IlRF9ZebZ7	2021-05-18 16:06:31.207+00	2021-05-18 16:06:31.207+00	\N	\N	ecg	2.98046875,0.788939387361108	fGQobjreD6	FEuHlBgcyE
KSxRUwdwvC	2021-05-18 16:06:31.408+00	2021-05-18 16:06:31.408+00	\N	\N	ecg	2.984375,1.06321073401698	fGQobjreD6	FEuHlBgcyE
ba33Pm5crS	2021-05-18 16:06:31.608+00	2021-05-18 16:06:31.608+00	\N	\N	ecg	2.98828125,1.15679534283234	fGQobjreD6	FEuHlBgcyE
6cbGZMyfvJ	2021-05-18 16:06:31.809+00	2021-05-18 16:06:31.809+00	\N	\N	ecg	2.9921875,1.08560398945084	fGQobjreD6	FEuHlBgcyE
xpsuhH8IHo	2021-05-18 16:06:32.009+00	2021-05-18 16:06:32.009+00	\N	\N	ecg	2.99609375,1.06583785466464	fGQobjreD6	FEuHlBgcyE
RW9X9k9FBX	2021-05-18 16:06:32.21+00	2021-05-18 16:06:32.21+00	\N	\N	ecg	3.0,1.12705852985289	fGQobjreD6	FEuHlBgcyE
2XhR7EbpzT	2021-05-18 16:06:32.41+00	2021-05-18 16:06:32.41+00	\N	\N	ecg	3.00390625,1.06244793594112	fGQobjreD6	FEuHlBgcyE
1iJbHiUOBD	2021-05-18 16:06:32.611+00	2021-05-18 16:06:32.611+00	\N	\N	ecg	3.0078125,0.875759757505777	fGQobjreD6	FEuHlBgcyE
KKDb6UgHjh	2021-05-18 16:06:32.813+00	2021-05-18 16:06:32.813+00	\N	\N	ecg	3.01171875,0.823738951746154	fGQobjreD6	FEuHlBgcyE
YtSOA8BJEx	2021-05-18 16:06:33.012+00	2021-05-18 16:06:33.012+00	\N	\N	ecg	3.015625,0.604728179158279	fGQobjreD6	FEuHlBgcyE
5UYA720Wfj	2021-05-18 16:06:33.212+00	2021-05-18 16:06:33.212+00	\N	\N	ecg	3.01953125,0.450252045996394	fGQobjreD6	FEuHlBgcyE
YxoXGRSB1P	2021-05-18 16:06:33.413+00	2021-05-18 16:06:33.413+00	\N	\N	ecg	3.0234375,0.187966012385694	fGQobjreD6	FEuHlBgcyE
7fVgdSjMpE	2021-05-18 16:06:33.613+00	2021-05-18 16:06:33.613+00	\N	\N	ecg	3.02734375,-0.0592836927927862	fGQobjreD6	FEuHlBgcyE
4BRT3GDQAG	2021-05-18 16:06:33.817+00	2021-05-18 16:06:33.817+00	\N	\N	ecg	3.03125,-0.233386801821144	fGQobjreD6	FEuHlBgcyE
itbOxwNEaq	2021-05-18 16:06:34.014+00	2021-05-18 16:06:34.014+00	\N	\N	ecg	3.03515625,-0.206492786527422	fGQobjreD6	FEuHlBgcyE
BbdJFrRGOV	2021-05-18 16:06:34.214+00	2021-05-18 16:06:34.214+00	\N	\N	ecg	3.0390625,-0.387907012645616	fGQobjreD6	FEuHlBgcyE
fLcOP0U9BZ	2021-05-18 16:06:34.415+00	2021-05-18 16:06:34.415+00	\N	\N	ecg	3.04296875,-0.35693074990372	fGQobjreD6	FEuHlBgcyE
o2Ueh2xIL4	2021-05-18 16:06:34.615+00	2021-05-18 16:06:34.615+00	\N	\N	ecg	3.046875,-0.290222265475376	fGQobjreD6	FEuHlBgcyE
2hiT9uI4OW	2021-05-18 16:06:34.815+00	2021-05-18 16:06:34.815+00	\N	\N	ecg	3.05078125,-0.192017903885469	fGQobjreD6	FEuHlBgcyE
iJmdVwFGkU	2021-05-18 16:06:35.016+00	2021-05-18 16:06:35.016+00	\N	\N	ecg	3.0546875,-0.277527170112164	fGQobjreD6	FEuHlBgcyE
ClBeX0G3wv	2021-05-18 16:06:35.217+00	2021-05-18 16:06:35.217+00	\N	\N	ecg	3.05859375,-0.250093220451493	fGQobjreD6	FEuHlBgcyE
o7gfWvfu1v	2021-05-18 16:06:35.418+00	2021-05-18 16:06:35.418+00	\N	\N	ecg	3.0625,-0.235729070324845	fGQobjreD6	FEuHlBgcyE
xUQZmBjvID	2021-05-18 16:06:35.618+00	2021-05-18 16:06:35.618+00	\N	\N	ecg	3.06640625,-0.059024185306969	fGQobjreD6	FEuHlBgcyE
OrYoSEuwRz	2021-05-18 16:06:35.818+00	2021-05-18 16:06:35.818+00	\N	\N	ecg	3.0703125,-0.0428235239163977	fGQobjreD6	FEuHlBgcyE
PSavtMOtD3	2021-05-18 16:06:36.019+00	2021-05-18 16:06:36.019+00	\N	\N	ecg	3.07421875,0.0194783311918042	fGQobjreD6	FEuHlBgcyE
n5sBZYZP6F	2021-05-18 16:06:36.22+00	2021-05-18 16:06:36.22+00	\N	\N	ecg	3.078125,-0.131853851051741	fGQobjreD6	FEuHlBgcyE
2SnQQio4dn	2021-05-18 16:06:36.42+00	2021-05-18 16:06:36.42+00	\N	\N	ecg	3.08203125,-0.0806966713945835	fGQobjreD6	FEuHlBgcyE
1fJNPMKjai	2021-05-18 16:06:36.62+00	2021-05-18 16:06:36.62+00	\N	\N	ecg	3.0859375,-0.045575810958973	fGQobjreD6	FEuHlBgcyE
LlePcnB2SZ	2021-05-18 16:06:36.822+00	2021-05-18 16:06:36.822+00	\N	\N	ecg	3.08984375,-0.0498133966754605	fGQobjreD6	FEuHlBgcyE
8ifYAb1SJi	2021-05-18 16:06:37.021+00	2021-05-18 16:06:37.021+00	\N	\N	ecg	3.09375,0.0286909842798259	fGQobjreD6	FEuHlBgcyE
PRDTYvZm4i	2021-05-18 16:06:37.221+00	2021-05-18 16:06:37.221+00	\N	\N	ecg	3.09765625,-0.101691429951695	fGQobjreD6	FEuHlBgcyE
BGZdDLe9HB	2021-05-18 16:06:37.422+00	2021-05-18 16:06:37.422+00	\N	\N	ecg	3.1015625,0.0688875623691073	fGQobjreD6	FEuHlBgcyE
MQzojDr5T9	2021-05-18 16:06:37.622+00	2021-05-18 16:06:37.622+00	\N	\N	ecg	3.10546875,-0.0341086571432948	fGQobjreD6	FEuHlBgcyE
oWqCePbv2m	2021-05-18 16:06:37.823+00	2021-05-18 16:06:37.823+00	\N	\N	ecg	3.109375,-0.00354894593836948	fGQobjreD6	FEuHlBgcyE
JXbzSXxeVT	2021-05-18 16:06:38.023+00	2021-05-18 16:06:38.023+00	\N	\N	ecg	3.11328125,0.0292451353128132	fGQobjreD6	FEuHlBgcyE
QQBmIY641i	2021-05-18 16:06:38.224+00	2021-05-18 16:06:38.224+00	\N	\N	ecg	3.1171875,-0.00373658554987735	fGQobjreD6	FEuHlBgcyE
2t4YeSRLTI	2021-05-18 16:06:38.425+00	2021-05-18 16:06:38.425+00	\N	\N	ecg	3.12109375,-0.0450412238007426	fGQobjreD6	FEuHlBgcyE
Gz6WQsaufL	2021-05-18 16:06:38.625+00	2021-05-18 16:06:38.625+00	\N	\N	ecg	3.125,0.0992968646039004	fGQobjreD6	FEuHlBgcyE
L3Um3sqvPX	2021-05-18 16:06:38.834+00	2021-05-18 16:06:38.834+00	\N	\N	ecg	3.12890625,-0.0210341503077046	fGQobjreD6	FEuHlBgcyE
hof7dQvewd	2021-05-18 16:06:39.027+00	2021-05-18 16:06:39.027+00	\N	\N	ecg	3.1328125,0.0671065812014678	fGQobjreD6	FEuHlBgcyE
lOnYOKGbFD	2021-05-18 16:06:39.227+00	2021-05-18 16:06:39.227+00	\N	\N	ecg	3.13671875,0.11481088862095	fGQobjreD6	FEuHlBgcyE
lvs2V09Fev	2021-05-18 16:06:39.428+00	2021-05-18 16:06:39.428+00	\N	\N	ecg	3.140625,0.0343380699276404	fGQobjreD6	FEuHlBgcyE
KwGvDt1CVH	2021-05-18 16:06:39.628+00	2021-05-18 16:06:39.628+00	\N	\N	ecg	3.14453125,0.171373661560386	fGQobjreD6	FEuHlBgcyE
F4EsiSdFg0	2021-05-18 16:06:39.828+00	2021-05-18 16:06:39.828+00	\N	\N	ecg	3.1484375,0.0218884515978358	fGQobjreD6	FEuHlBgcyE
6EsNMlJqd6	2021-05-18 16:06:40.031+00	2021-05-18 16:06:40.031+00	\N	\N	ecg	3.15234375,0.135763401042889	fGQobjreD6	FEuHlBgcyE
flMBoOLWEo	2021-05-18 16:06:40.229+00	2021-05-18 16:06:40.229+00	\N	\N	ecg	3.15625,0.178347881143365	fGQobjreD6	FEuHlBgcyE
jVXnzwsEEU	2021-05-18 16:06:40.43+00	2021-05-18 16:06:40.43+00	\N	\N	ecg	3.16015625,0.0700744935663874	fGQobjreD6	FEuHlBgcyE
IBbrmuUd0T	2021-05-18 16:06:40.631+00	2021-05-18 16:06:40.631+00	\N	\N	ecg	3.1640625,0.126583310783601	fGQobjreD6	FEuHlBgcyE
LrXaPw8LdE	2021-05-18 16:06:40.831+00	2021-05-18 16:06:40.831+00	\N	\N	ecg	3.16796875,0.250651516668627	fGQobjreD6	FEuHlBgcyE
jXFZPde47I	2021-05-18 16:06:41.032+00	2021-05-18 16:06:41.032+00	\N	\N	ecg	3.171875,0.11405003651	fGQobjreD6	FEuHlBgcyE
hyGu3XWvHW	2021-05-18 16:06:41.232+00	2021-05-18 16:06:41.232+00	\N	\N	ecg	3.17578125,0.239882169940308	fGQobjreD6	FEuHlBgcyE
GqkCioeuhZ	2021-05-18 16:06:41.432+00	2021-05-18 16:06:41.432+00	\N	\N	ecg	3.1796875,0.159191582015438	fGQobjreD6	FEuHlBgcyE
udEFOkWsJn	2021-05-18 16:06:41.633+00	2021-05-18 16:06:41.633+00	\N	\N	ecg	3.18359375,0.145765935143261	fGQobjreD6	FEuHlBgcyE
TqlhM1l0Cx	2021-05-18 16:06:41.833+00	2021-05-18 16:06:41.833+00	\N	\N	ecg	3.1875,0.204971215889314	fGQobjreD6	FEuHlBgcyE
NXLyVxWqjT	2021-05-18 16:06:42.034+00	2021-05-18 16:06:42.034+00	\N	\N	ecg	3.19140625,0.247349096907832	fGQobjreD6	FEuHlBgcyE
0sRGJFjVBv	2021-05-18 16:06:42.234+00	2021-05-18 16:06:42.234+00	\N	\N	ecg	3.1953125,0.37358488367951	fGQobjreD6	FEuHlBgcyE
kIGAF9Vdh3	2021-05-18 16:06:42.435+00	2021-05-18 16:06:42.435+00	\N	\N	ecg	3.19921875,0.237401212308442	fGQobjreD6	FEuHlBgcyE
o6GQPqsznn	2021-05-18 16:06:42.636+00	2021-05-18 16:06:42.636+00	\N	\N	ecg	3.203125,0.399070054102479	fGQobjreD6	FEuHlBgcyE
86DnGMeM2p	2021-05-18 16:06:42.837+00	2021-05-18 16:06:42.837+00	\N	\N	ecg	3.20703125,0.345663533588839	fGQobjreD6	FEuHlBgcyE
NnxByjy6CY	2021-05-18 16:06:43.037+00	2021-05-18 16:06:43.037+00	\N	\N	ecg	3.2109375,0.421630562459038	fGQobjreD6	FEuHlBgcyE
E74KJB4ODH	2021-05-18 16:06:43.238+00	2021-05-18 16:06:43.238+00	\N	\N	ecg	3.21484375,0.408571667473728	fGQobjreD6	FEuHlBgcyE
emP0bcUpBn	2021-05-18 16:06:43.438+00	2021-05-18 16:06:43.438+00	\N	\N	ecg	3.21875,0.326508748625089	fGQobjreD6	FEuHlBgcyE
GoMrfGvCCc	2021-05-18 16:06:43.639+00	2021-05-18 16:06:43.639+00	\N	\N	ecg	3.22265625,0.453684747853945	fGQobjreD6	FEuHlBgcyE
fLmGCFROqJ	2021-05-18 16:06:43.844+00	2021-05-18 16:06:43.844+00	\N	\N	ecg	3.2265625,0.402663390443594	fGQobjreD6	FEuHlBgcyE
lV1o9dLI1k	2021-05-18 16:06:44.04+00	2021-05-18 16:06:44.04+00	\N	\N	ecg	3.23046875,0.454747407531027	fGQobjreD6	FEuHlBgcyE
AsELpNHPjR	2021-05-18 16:06:44.244+00	2021-05-18 16:06:44.244+00	\N	\N	ecg	3.234375,0.410165185665853	fGQobjreD6	FEuHlBgcyE
ddaZhC1lrW	2021-05-18 16:06:44.441+00	2021-05-18 16:06:44.441+00	\N	\N	ecg	3.23828125,0.335879947892884	fGQobjreD6	FEuHlBgcyE
Gq9FoRQ4P3	2021-05-18 16:06:44.641+00	2021-05-18 16:06:44.641+00	\N	\N	ecg	3.2421875,0.338521936402238	fGQobjreD6	FEuHlBgcyE
7uvzh6qJWT	2021-05-18 16:06:44.842+00	2021-05-18 16:06:44.842+00	\N	\N	ecg	3.24609375,0.480067383046126	fGQobjreD6	FEuHlBgcyE
FkGsPZF04t	2021-05-18 16:06:45.042+00	2021-05-18 16:06:45.042+00	\N	\N	ecg	3.25,0.444931717265355	fGQobjreD6	FEuHlBgcyE
wY6C9ZzsEJ	2021-05-18 16:06:45.243+00	2021-05-18 16:06:45.243+00	\N	\N	ecg	3.25390625,0.420641810193508	fGQobjreD6	FEuHlBgcyE
2Jk32T0YYl	2021-05-18 16:06:45.443+00	2021-05-18 16:06:45.443+00	\N	\N	ecg	3.2578125,0.316493445668136	fGQobjreD6	FEuHlBgcyE
FTum2weX4p	2021-05-18 16:06:45.644+00	2021-05-18 16:06:45.644+00	\N	\N	ecg	3.26171875,0.309922380841522	fGQobjreD6	FEuHlBgcyE
SCqNaTC3TU	2021-05-18 16:06:45.844+00	2021-05-18 16:06:45.844+00	\N	\N	ecg	3.265625,0.279488900817205	fGQobjreD6	FEuHlBgcyE
kgjKX2tij0	2021-05-18 16:06:46.046+00	2021-05-18 16:06:46.046+00	\N	\N	ecg	3.26953125,0.315024095161497	fGQobjreD6	FEuHlBgcyE
KMbv9dBOGx	2021-05-18 16:06:46.247+00	2021-05-18 16:06:46.247+00	\N	\N	ecg	3.2734375,0.320330790998883	fGQobjreD6	FEuHlBgcyE
5SMrvRVTEU	2021-05-18 16:06:46.447+00	2021-05-18 16:06:46.447+00	\N	\N	ecg	3.27734375,0.370425008099375	fGQobjreD6	FEuHlBgcyE
BJl4ZXvCcM	2021-05-18 16:06:46.65+00	2021-05-18 16:06:46.65+00	\N	\N	ecg	3.28125,0.387059137355977	fGQobjreD6	FEuHlBgcyE
xmpo2v6PFd	2021-05-18 16:06:46.848+00	2021-05-18 16:06:46.848+00	\N	\N	ecg	3.28515625,0.312637095674988	fGQobjreD6	FEuHlBgcyE
BFlwGerlFw	2021-05-18 16:06:47.05+00	2021-05-18 16:06:47.05+00	\N	\N	ecg	3.2890625,0.294533411534843	fGQobjreD6	FEuHlBgcyE
wnd6d3Akbg	2021-05-18 16:06:47.251+00	2021-05-18 16:06:47.251+00	\N	\N	ecg	3.29296875,0.302799410682013	fGQobjreD6	FEuHlBgcyE
HpCwJsJmg6	2021-05-18 16:06:47.452+00	2021-05-18 16:06:47.452+00	\N	\N	ecg	3.296875,0.179773410836103	fGQobjreD6	FEuHlBgcyE
WcYLNXDhKD	2021-05-18 16:06:47.652+00	2021-05-18 16:06:47.652+00	\N	\N	ecg	3.30078125,0.276255214340195	fGQobjreD6	FEuHlBgcyE
uXXNMhhBZp	2021-05-18 16:06:47.851+00	2021-05-18 16:06:47.851+00	\N	\N	ecg	3.3046875,0.161100726368793	fGQobjreD6	FEuHlBgcyE
QqjaGLLpLA	2021-05-18 16:06:48.052+00	2021-05-18 16:06:48.052+00	\N	\N	ecg	3.30859375,0.284264424904188	fGQobjreD6	FEuHlBgcyE
O02Hiz87sa	2021-05-18 16:06:48.254+00	2021-05-18 16:06:48.254+00	\N	\N	ecg	3.3125,0.198367800813536	fGQobjreD6	FEuHlBgcyE
ZovBurEIT6	2021-05-18 16:06:48.453+00	2021-05-18 16:06:48.453+00	\N	\N	ecg	3.31640625,0.0966300820930321	fGQobjreD6	FEuHlBgcyE
fY0hjdy2aJ	2021-05-18 16:06:48.654+00	2021-05-18 16:06:48.654+00	\N	\N	ecg	3.3203125,0.0836706917542261	fGQobjreD6	FEuHlBgcyE
pYrkGpJgGh	2021-05-18 16:06:48.857+00	2021-05-18 16:06:48.857+00	\N	\N	ecg	3.32421875,0.109200631654795	fGQobjreD6	FEuHlBgcyE
6jLMMeDMIc	2021-05-18 16:06:49.055+00	2021-05-18 16:06:49.055+00	\N	\N	ecg	3.328125,0.094076257896318	fGQobjreD6	FEuHlBgcyE
40KrGGczvJ	2021-05-18 16:06:49.256+00	2021-05-18 16:06:49.256+00	\N	\N	ecg	3.33203125,0.0340272894121502	fGQobjreD6	FEuHlBgcyE
76q95FccUF	2021-05-18 16:06:49.457+00	2021-05-18 16:06:49.457+00	\N	\N	ecg	3.3359375,0.181006962891072	fGQobjreD6	FEuHlBgcyE
5kbCx0B9Ld	2021-05-18 16:06:49.657+00	2021-05-18 16:06:49.657+00	\N	\N	ecg	3.33984375,0.166189492901873	fGQobjreD6	FEuHlBgcyE
EAwprq6WCw	2021-05-18 16:06:49.858+00	2021-05-18 16:06:49.858+00	\N	\N	ecg	3.34375,-0.0134765328778534	fGQobjreD6	FEuHlBgcyE
9Msv3A8yJM	2021-05-18 16:06:50.058+00	2021-05-18 16:06:50.058+00	\N	\N	ecg	3.34765625,0.154011479402941	fGQobjreD6	FEuHlBgcyE
B5es3bWGrF	2021-05-18 16:06:50.258+00	2021-05-18 16:06:50.258+00	\N	\N	ecg	3.3515625,0.0554861408141964	fGQobjreD6	FEuHlBgcyE
udeD9pvaPc	2021-05-18 16:06:50.458+00	2021-05-18 16:06:50.458+00	\N	\N	ecg	3.35546875,0.0335430313062925	fGQobjreD6	FEuHlBgcyE
IhhwRCp9yN	2021-05-18 16:06:50.66+00	2021-05-18 16:06:50.66+00	\N	\N	ecg	3.359375,-0.0305423381088788	fGQobjreD6	FEuHlBgcyE
iVgGLTRO6z	2021-05-18 16:06:50.86+00	2021-05-18 16:06:50.86+00	\N	\N	ecg	3.36328125,0.0050385631803817	fGQobjreD6	FEuHlBgcyE
u4Bq2KgTrd	2021-05-18 16:06:51.061+00	2021-05-18 16:06:51.061+00	\N	\N	ecg	3.3671875,-0.0310119032252117	fGQobjreD6	FEuHlBgcyE
hdFy1gYGad	2021-05-18 16:06:51.265+00	2021-05-18 16:06:51.265+00	\N	\N	ecg	3.37109375,-0.0085589146683882	fGQobjreD6	FEuHlBgcyE
MqM8xQlajh	2021-05-18 16:06:51.464+00	2021-05-18 16:06:51.464+00	\N	\N	ecg	3.375,-0.0413570845218212	fGQobjreD6	FEuHlBgcyE
FtVPOlCXmh	2021-05-18 16:06:51.665+00	2021-05-18 16:06:51.665+00	\N	\N	ecg	3.37890625,0.0882271548048075	fGQobjreD6	FEuHlBgcyE
Ourr8n8EkU	2021-05-18 16:06:51.865+00	2021-05-18 16:06:51.865+00	\N	\N	ecg	3.3828125,0.00280616873407654	fGQobjreD6	FEuHlBgcyE
HGoWQGGhUc	2021-05-18 16:06:52.066+00	2021-05-18 16:06:52.066+00	\N	\N	ecg	3.38671875,-0.0736756310882781	fGQobjreD6	FEuHlBgcyE
LkklwCZuGK	2021-05-18 16:06:52.267+00	2021-05-18 16:06:52.267+00	\N	\N	ecg	3.390625,-0.046991675110333	fGQobjreD6	FEuHlBgcyE
VHJ3RyqlYx	2021-05-18 16:06:52.467+00	2021-05-18 16:06:52.467+00	\N	\N	ecg	3.39453125,-0.00947655728589637	fGQobjreD6	FEuHlBgcyE
sCpEH1dY4a	2021-05-18 16:06:52.667+00	2021-05-18 16:06:52.667+00	\N	\N	ecg	3.3984375,-0.117730609031758	fGQobjreD6	FEuHlBgcyE
PppSuN0xbG	2021-05-18 16:06:52.869+00	2021-05-18 16:06:52.869+00	\N	\N	ecg	3.40234375,-0.120381648711539	fGQobjreD6	FEuHlBgcyE
6H6swDn68x	2021-05-18 16:06:53.069+00	2021-05-18 16:06:53.069+00	\N	\N	ecg	3.40625,0.0452457250836829	fGQobjreD6	FEuHlBgcyE
3e8IKiUBz9	2021-05-18 16:06:53.271+00	2021-05-18 16:06:53.271+00	\N	\N	ecg	3.41015625,-0.13803790404141	fGQobjreD6	FEuHlBgcyE
5L9JeFbDFZ	2021-05-18 16:06:53.47+00	2021-05-18 16:06:53.47+00	\N	\N	ecg	3.4140625,0.022700142726962	fGQobjreD6	FEuHlBgcyE
38ds7pcCHw	2021-05-18 16:06:53.67+00	2021-05-18 16:06:53.67+00	\N	\N	ecg	3.41796875,-0.121632858316668	fGQobjreD6	FEuHlBgcyE
YtBno2EiRW	2021-05-18 16:06:53.874+00	2021-05-18 16:06:53.874+00	\N	\N	ecg	3.421875,-0.0877866607033838	fGQobjreD6	FEuHlBgcyE
XZGCuTEvWc	2021-05-18 16:06:54.071+00	2021-05-18 16:06:54.071+00	\N	\N	ecg	3.42578125,-0.142284280941236	fGQobjreD6	FEuHlBgcyE
bsuDyLA0su	2021-05-18 16:06:54.274+00	2021-05-18 16:06:54.274+00	\N	\N	ecg	3.4296875,-0.0438381338450631	fGQobjreD6	FEuHlBgcyE
V9UvPsX75T	2021-05-18 16:06:54.474+00	2021-05-18 16:06:54.474+00	\N	\N	ecg	3.43359375,0.021509645885696	fGQobjreD6	FEuHlBgcyE
Dz4KYWbyn2	2021-05-18 16:06:54.676+00	2021-05-18 16:06:54.676+00	\N	\N	ecg	3.4375,-0.027263162496985	fGQobjreD6	FEuHlBgcyE
tmNFRBHgqL	2021-05-18 16:06:54.875+00	2021-05-18 16:06:54.875+00	\N	\N	ecg	3.44140625,-0.0585229040973365	fGQobjreD6	FEuHlBgcyE
zeTij1o401	2021-05-18 16:06:55.075+00	2021-05-18 16:06:55.075+00	\N	\N	ecg	3.4453125,0.0528362007139422	fGQobjreD6	FEuHlBgcyE
WBU1rqcFoq	2021-05-18 16:06:55.276+00	2021-05-18 16:06:55.276+00	\N	\N	ecg	3.44921875,-0.0415359512716529	fGQobjreD6	FEuHlBgcyE
sviSwELwrx	2021-05-18 16:06:55.477+00	2021-05-18 16:06:55.477+00	\N	\N	ecg	3.453125,-0.0664070847931159	fGQobjreD6	FEuHlBgcyE
gCIJxQUU2n	2021-05-18 16:06:55.676+00	2021-05-18 16:06:55.676+00	\N	\N	ecg	3.45703125,-0.085265913616269	fGQobjreD6	FEuHlBgcyE
bauuUGMgi2	2021-05-18 16:06:55.876+00	2021-05-18 16:06:55.876+00	\N	\N	ecg	3.4609375,0.0170288687324424	fGQobjreD6	FEuHlBgcyE
EtnPZJ21Mi	2021-05-18 16:06:56.077+00	2021-05-18 16:06:56.077+00	\N	\N	ecg	3.46484375,-0.0994135063240511	fGQobjreD6	FEuHlBgcyE
j4CjT9F2aP	2021-05-18 16:06:56.277+00	2021-05-18 16:06:56.277+00	\N	\N	ecg	3.46875,-0.0914474894169695	fGQobjreD6	FEuHlBgcyE
KHlLHrK8a9	2021-05-18 16:06:56.478+00	2021-05-18 16:06:56.478+00	\N	\N	ecg	3.47265625,0.0573887084220024	fGQobjreD6	FEuHlBgcyE
7H94KRAxQD	2021-05-18 16:06:56.678+00	2021-05-18 16:06:56.678+00	\N	\N	ecg	3.4765625,-0.139721554462703	fGQobjreD6	FEuHlBgcyE
TaKW0vbQ0W	2021-05-18 16:06:56.878+00	2021-05-18 16:06:56.878+00	\N	\N	ecg	3.48046875,-0.103318531963274	fGQobjreD6	FEuHlBgcyE
3MRJ8K6EqW	2021-05-18 16:06:57.079+00	2021-05-18 16:06:57.079+00	\N	\N	ecg	3.484375,0.059615075962462	fGQobjreD6	FEuHlBgcyE
BsKhRhnhda	2021-05-18 16:06:57.282+00	2021-05-18 16:06:57.282+00	\N	\N	ecg	3.48828125,-0.0937670038975264	fGQobjreD6	FEuHlBgcyE
8YO5xdfYPd	2021-05-18 16:06:57.48+00	2021-05-18 16:06:57.48+00	\N	\N	ecg	3.4921875,0.0444557533055442	fGQobjreD6	FEuHlBgcyE
7pJMfPbD67	2021-05-18 16:06:57.68+00	2021-05-18 16:06:57.68+00	\N	\N	ecg	3.49609375,-0.0555677239651816	fGQobjreD6	FEuHlBgcyE
j3KmCnMlbE	2021-05-18 16:06:57.882+00	2021-05-18 16:06:57.882+00	\N	\N	ecg	3.5,-0.0158356480141744	fGQobjreD6	FEuHlBgcyE
ZaiXN6RaqX	2021-05-18 16:06:58.082+00	2021-05-18 16:06:58.082+00	\N	\N	ecg	3.50390625,0.0452806581720361	fGQobjreD6	FEuHlBgcyE
OmgUlFTZhB	2021-05-18 16:06:58.282+00	2021-05-18 16:06:58.282+00	\N	\N	ecg	3.5078125,-0.0971565334284623	fGQobjreD6	FEuHlBgcyE
Ex3pLOLpYm	2021-05-18 16:06:58.483+00	2021-05-18 16:06:58.483+00	\N	\N	ecg	3.51171875,-0.0951167169061745	fGQobjreD6	FEuHlBgcyE
LCFMJ3fOsV	2021-05-18 16:06:58.683+00	2021-05-18 16:06:58.683+00	\N	\N	ecg	3.515625,-0.124630870192969	fGQobjreD6	FEuHlBgcyE
OG2SUXGZHU	2021-05-18 16:06:58.888+00	2021-05-18 16:06:58.888+00	\N	\N	ecg	3.51953125,0.0558887387699032	fGQobjreD6	FEuHlBgcyE
h5pCQ2YA37	2021-05-18 16:06:59.084+00	2021-05-18 16:06:59.084+00	\N	\N	ecg	3.5234375,-0.115493469465828	fGQobjreD6	FEuHlBgcyE
6U1sZIBuRr	2021-05-18 16:06:59.285+00	2021-05-18 16:06:59.285+00	\N	\N	ecg	3.52734375,-0.0677631915313475	fGQobjreD6	FEuHlBgcyE
oGSYFWKXDH	2021-05-18 16:06:59.485+00	2021-05-18 16:06:59.485+00	\N	\N	ecg	3.53125,-0.0858273237588429	fGQobjreD6	FEuHlBgcyE
gW9F1IMfFE	2021-05-18 16:06:59.687+00	2021-05-18 16:06:59.687+00	\N	\N	ecg	3.53515625,-0.0131629912193893	fGQobjreD6	FEuHlBgcyE
qrj3pp857U	2021-05-18 16:06:59.886+00	2021-05-18 16:06:59.886+00	\N	\N	ecg	3.5390625,-0.0441037763206974	fGQobjreD6	FEuHlBgcyE
NUYENP8Ajj	2021-05-18 16:07:00.087+00	2021-05-18 16:07:00.087+00	\N	\N	ecg	3.54296875,-0.0898557529407844	fGQobjreD6	FEuHlBgcyE
3S7cFjgVBd	2021-05-18 16:07:00.287+00	2021-05-18 16:07:00.287+00	\N	\N	ecg	3.546875,-0.0363553080942667	fGQobjreD6	FEuHlBgcyE
Id1uAHOl62	2021-05-18 16:07:00.487+00	2021-05-18 16:07:00.487+00	\N	\N	ecg	3.55078125,-0.0771366935216973	fGQobjreD6	FEuHlBgcyE
pZsIO5gywP	2021-05-18 16:07:00.688+00	2021-05-18 16:07:00.688+00	\N	\N	ecg	3.5546875,0.0559029316290867	fGQobjreD6	FEuHlBgcyE
KmCcT4wgOZ	2021-05-18 16:07:00.889+00	2021-05-18 16:07:00.889+00	\N	\N	ecg	3.55859375,0.0231597739768244	fGQobjreD6	FEuHlBgcyE
fJmxLOxamy	2021-05-18 16:07:01.09+00	2021-05-18 16:07:01.09+00	\N	\N	ecg	3.5625,-0.0807222722533805	fGQobjreD6	FEuHlBgcyE
krG8hDEijt	2021-05-18 16:07:01.291+00	2021-05-18 16:07:01.291+00	\N	\N	ecg	3.56640625,-0.0101844006197011	fGQobjreD6	FEuHlBgcyE
JBrCy6eATr	2021-05-18 16:07:01.492+00	2021-05-18 16:07:01.492+00	\N	\N	ecg	3.5703125,0.0237084093192928	fGQobjreD6	FEuHlBgcyE
KjlA9lA4R4	2021-05-18 16:07:01.693+00	2021-05-18 16:07:01.693+00	\N	\N	ecg	3.57421875,-0.0907511717619149	fGQobjreD6	FEuHlBgcyE
OBbhzOMDca	2021-05-18 16:07:01.892+00	2021-05-18 16:07:01.892+00	\N	\N	ecg	3.578125,-0.0911970637256693	fGQobjreD6	FEuHlBgcyE
OLQwhHNSpC	2021-05-18 16:07:02.092+00	2021-05-18 16:07:02.092+00	\N	\N	ecg	3.58203125,-0.0589254128710708	fGQobjreD6	FEuHlBgcyE
IbdpDyb3oJ	2021-05-18 16:07:02.293+00	2021-05-18 16:07:02.293+00	\N	\N	ecg	3.5859375,-0.0665505101506306	fGQobjreD6	FEuHlBgcyE
z3gdxnTSzY	2021-05-18 16:07:02.493+00	2021-05-18 16:07:02.493+00	\N	\N	ecg	3.58984375,-0.00681759073876825	fGQobjreD6	FEuHlBgcyE
2mlk7O0MUV	2021-05-18 16:07:02.694+00	2021-05-18 16:07:02.694+00	\N	\N	ecg	3.59375,-0.0997773010278427	fGQobjreD6	FEuHlBgcyE
JKsqpD9cuy	2021-05-18 16:07:02.894+00	2021-05-18 16:07:02.894+00	\N	\N	ecg	3.59765625,0.0829647143113702	fGQobjreD6	FEuHlBgcyE
EvDIxMRCOF	2021-05-18 16:07:03.097+00	2021-05-18 16:07:03.097+00	\N	\N	ecg	3.6015625,0.0603826463996578	fGQobjreD6	FEuHlBgcyE
F9e6hZD1SH	2021-05-18 16:07:03.295+00	2021-05-18 16:07:03.295+00	\N	\N	ecg	3.60546875,-0.0453164990299239	fGQobjreD6	FEuHlBgcyE
CqaedDHwGf	2021-05-18 16:07:03.496+00	2021-05-18 16:07:03.496+00	\N	\N	ecg	3.609375,0.044699166943504	fGQobjreD6	FEuHlBgcyE
4HoZDFT81W	2021-05-18 16:07:03.699+00	2021-05-18 16:07:03.699+00	\N	\N	ecg	3.61328125,-0.0630556407049914	fGQobjreD6	FEuHlBgcyE
r43KpJve12	2021-05-18 16:07:03.902+00	2021-05-18 16:07:03.902+00	\N	\N	ecg	3.6171875,-0.0621335284475862	fGQobjreD6	FEuHlBgcyE
ouoNa0IfLI	2021-05-18 16:07:04.097+00	2021-05-18 16:07:04.097+00	\N	\N	ecg	3.62109375,-0.0488954905998347	fGQobjreD6	FEuHlBgcyE
ngRkHTAtdt	2021-05-18 16:07:04.298+00	2021-05-18 16:07:04.298+00	\N	\N	ecg	3.625,0.0751324462188925	fGQobjreD6	FEuHlBgcyE
xOpub8GLsa	2021-05-18 16:07:04.5+00	2021-05-18 16:07:04.5+00	\N	\N	ecg	3.62890625,-0.00188934887938398	fGQobjreD6	FEuHlBgcyE
QdVKBvRyOF	2021-05-18 16:07:04.7+00	2021-05-18 16:07:04.7+00	\N	\N	ecg	3.6328125,-0.0265907425432962	fGQobjreD6	FEuHlBgcyE
LRZgMBHbCY	2021-05-18 16:07:04.901+00	2021-05-18 16:07:04.901+00	\N	\N	ecg	3.63671875,0.0638525097770323	fGQobjreD6	FEuHlBgcyE
I6RMNxpQcW	2021-05-18 16:07:05.102+00	2021-05-18 16:07:05.102+00	\N	\N	ecg	3.640625,-0.0298996422801941	fGQobjreD6	FEuHlBgcyE
jvuBw7pkyS	2021-05-18 16:07:05.302+00	2021-05-18 16:07:05.302+00	\N	\N	ecg	3.64453125,0.0392370740443337	fGQobjreD6	FEuHlBgcyE
FjngVrSNsi	2021-05-18 16:07:05.503+00	2021-05-18 16:07:05.503+00	\N	\N	ecg	3.6484375,-0.0371911865037357	fGQobjreD6	FEuHlBgcyE
fQfwiU6Qt4	2021-05-18 16:07:05.703+00	2021-05-18 16:07:05.703+00	\N	\N	ecg	3.65234375,0.0275619973003453	fGQobjreD6	FEuHlBgcyE
4R5KAdjIh6	2021-05-18 16:07:05.904+00	2021-05-18 16:07:05.904+00	\N	\N	ecg	3.65625,-0.0536530681139482	fGQobjreD6	FEuHlBgcyE
eCLB6lTQbu	2021-05-18 16:07:06.104+00	2021-05-18 16:07:06.104+00	\N	\N	ecg	3.66015625,-0.0192728154324219	fGQobjreD6	FEuHlBgcyE
q1JhyDi91X	2021-05-18 16:07:06.305+00	2021-05-18 16:07:06.305+00	\N	\N	ecg	3.6640625,-0.0208584609344444	fGQobjreD6	FEuHlBgcyE
xqV9lbAg2k	2021-05-18 16:07:06.505+00	2021-05-18 16:07:06.505+00	\N	\N	ecg	3.66796875,-0.0505181087801421	fGQobjreD6	FEuHlBgcyE
yxeT0oCJaR	2021-05-18 16:07:06.706+00	2021-05-18 16:07:06.706+00	\N	\N	ecg	3.671875,-0.0198608211300341	fGQobjreD6	FEuHlBgcyE
Gigi4IyX5D	2021-05-18 16:07:06.906+00	2021-05-18 16:07:06.906+00	\N	\N	ecg	3.67578125,-0.00536604985980523	fGQobjreD6	FEuHlBgcyE
HyRl8svVtU	2021-05-18 16:07:07.107+00	2021-05-18 16:07:07.107+00	\N	\N	ecg	3.6796875,-0.00678395331308003	fGQobjreD6	FEuHlBgcyE
u2Iskdoat5	2021-05-18 16:07:07.307+00	2021-05-18 16:07:07.307+00	\N	\N	ecg	3.68359375,-0.0153865043130764	fGQobjreD6	FEuHlBgcyE
lqAgAsXNVT	2021-05-18 16:07:07.508+00	2021-05-18 16:07:07.508+00	\N	\N	ecg	3.6875,0.0826131786726928	fGQobjreD6	FEuHlBgcyE
cbHnIAJNEz	2021-05-18 16:07:07.708+00	2021-05-18 16:07:07.708+00	\N	\N	ecg	3.69140625,-0.0657794922748262	fGQobjreD6	FEuHlBgcyE
qF7q4EDgEZ	2021-05-18 16:07:07.909+00	2021-05-18 16:07:07.909+00	\N	\N	ecg	3.6953125,0.0144229548256896	fGQobjreD6	FEuHlBgcyE
oNi5K2TOqE	2021-05-18 16:07:08.109+00	2021-05-18 16:07:08.109+00	\N	\N	ecg	3.69921875,0.0964051724313587	fGQobjreD6	FEuHlBgcyE
cbjhzQdxWr	2021-05-18 16:07:08.31+00	2021-05-18 16:07:08.31+00	\N	\N	ecg	3.703125,-0.0259311850083524	fGQobjreD6	FEuHlBgcyE
KwuXebvZ0R	2021-05-18 16:07:08.51+00	2021-05-18 16:07:08.51+00	\N	\N	ecg	3.70703125,-0.0861710658390892	fGQobjreD6	FEuHlBgcyE
VsXrpHFXeE	2021-05-18 16:07:08.711+00	2021-05-18 16:07:08.711+00	\N	\N	ecg	3.7109375,0.10873990519859	fGQobjreD6	FEuHlBgcyE
vN8YvtKohh	2021-05-18 16:07:08.914+00	2021-05-18 16:07:08.914+00	\N	\N	ecg	3.71484375,-0.0354368880739339	fGQobjreD6	FEuHlBgcyE
kgpHhPLmfe	2021-05-18 16:07:09.112+00	2021-05-18 16:07:09.112+00	\N	\N	ecg	3.71875,0.0111402285344782	fGQobjreD6	FEuHlBgcyE
lZmq46SYbs	2021-05-18 16:07:09.314+00	2021-05-18 16:07:09.314+00	\N	\N	ecg	3.72265625,-0.0454891613525848	fGQobjreD6	FEuHlBgcyE
oI4dZB5Xeo	2021-05-18 16:07:09.516+00	2021-05-18 16:07:09.516+00	\N	\N	ecg	3.7265625,-0.00912257595545842	fGQobjreD6	FEuHlBgcyE
pS8Y0ocf5o	2021-05-18 16:07:09.716+00	2021-05-18 16:07:09.716+00	\N	\N	ecg	3.73046875,-0.0680615864745478	fGQobjreD6	FEuHlBgcyE
OwHIePc0lH	2021-05-18 16:07:09.916+00	2021-05-18 16:07:09.916+00	\N	\N	ecg	3.734375,0.127996753394931	fGQobjreD6	FEuHlBgcyE
kAplWV6jX5	2021-05-18 16:07:10.116+00	2021-05-18 16:07:10.116+00	\N	\N	ecg	3.73828125,0.0997070419554419	fGQobjreD6	FEuHlBgcyE
h3TPA84Eet	2021-05-18 16:07:10.316+00	2021-05-18 16:07:10.316+00	\N	\N	ecg	3.7421875,0.123127027347168	fGQobjreD6	FEuHlBgcyE
CEDJ7kPR9Z	2021-05-18 16:07:10.517+00	2021-05-18 16:07:10.517+00	\N	\N	ecg	3.74609375,0.136732783765027	fGQobjreD6	FEuHlBgcyE
vyu7fm287k	2021-05-18 16:07:10.717+00	2021-05-18 16:07:10.717+00	\N	\N	ecg	3.75,0.0407842622533523	fGQobjreD6	FEuHlBgcyE
MzD29hiMsl	2021-05-18 16:07:10.917+00	2021-05-18 16:07:10.917+00	\N	\N	ecg	3.75390625,0.0864737790014718	fGQobjreD6	FEuHlBgcyE
Yg70xFL6pH	2021-05-18 16:07:11.118+00	2021-05-18 16:07:11.118+00	\N	\N	ecg	3.7578125,0.096544835028964	fGQobjreD6	FEuHlBgcyE
VINMq3Pz13	2021-05-18 16:07:11.319+00	2021-05-18 16:07:11.319+00	\N	\N	ecg	3.76171875,0.119136770566511	fGQobjreD6	FEuHlBgcyE
eQi13K4EBn	2021-05-18 16:07:11.519+00	2021-05-18 16:07:11.519+00	\N	\N	ecg	3.765625,0.101442564498996	fGQobjreD6	FEuHlBgcyE
rfqu7bAKAK	2021-05-18 16:07:11.719+00	2021-05-18 16:07:11.719+00	\N	\N	ecg	3.76953125,0.167309437052069	fGQobjreD6	FEuHlBgcyE
oIxNiWDTHE	2021-05-18 16:07:11.921+00	2021-05-18 16:07:11.921+00	\N	\N	ecg	3.7734375,0.0377353079026451	fGQobjreD6	FEuHlBgcyE
q9rTdjW1XO	2021-05-18 16:07:12.12+00	2021-05-18 16:07:12.12+00	\N	\N	ecg	3.77734375,0.124293133501512	fGQobjreD6	FEuHlBgcyE
BYJwNF2cC1	2021-05-18 16:07:12.321+00	2021-05-18 16:07:12.321+00	\N	\N	ecg	3.78125,0.134544307493096	fGQobjreD6	FEuHlBgcyE
bXbXAcYTSD	2021-05-18 16:07:12.521+00	2021-05-18 16:07:12.521+00	\N	\N	ecg	3.78515625,0.178707155894595	fGQobjreD6	FEuHlBgcyE
XHYkTNHHDx	2021-05-18 16:07:12.722+00	2021-05-18 16:07:12.722+00	\N	\N	ecg	3.7890625,0.142802478724873	fGQobjreD6	FEuHlBgcyE
KBrORkQrUV	2021-05-18 16:07:12.923+00	2021-05-18 16:07:12.923+00	\N	\N	ecg	3.79296875,0.156542060673886	fGQobjreD6	FEuHlBgcyE
sl5y7Q83bD	2021-05-18 16:07:13.123+00	2021-05-18 16:07:13.123+00	\N	\N	ecg	3.796875,0.295925466495326	fGQobjreD6	FEuHlBgcyE
AsVh7DE5Da	2021-05-18 16:07:13.323+00	2021-05-18 16:07:13.323+00	\N	\N	ecg	3.80078125,0.203004111730433	fGQobjreD6	FEuHlBgcyE
usAzDGTLAt	2021-05-18 16:07:13.523+00	2021-05-18 16:07:13.523+00	\N	\N	ecg	3.8046875,0.285204581463664	fGQobjreD6	FEuHlBgcyE
Vj24whh0Zy	2021-05-18 16:07:13.725+00	2021-05-18 16:07:13.725+00	\N	\N	ecg	3.80859375,0.277974916147161	fGQobjreD6	FEuHlBgcyE
o5eVkLeti1	2021-05-18 16:07:13.928+00	2021-05-18 16:07:13.928+00	\N	\N	ecg	3.8125,0.334666544429197	fGQobjreD6	FEuHlBgcyE
kvu5NgZ2Zj	2021-05-18 16:07:14.125+00	2021-05-18 16:07:14.125+00	\N	\N	ecg	3.81640625,0.33902974647277	fGQobjreD6	FEuHlBgcyE
uhTG2isl7g	2021-05-18 16:07:14.326+00	2021-05-18 16:07:14.326+00	\N	\N	ecg	3.8203125,0.204161476587801	fGQobjreD6	FEuHlBgcyE
B1Vt39BpxU	2021-05-18 16:07:14.527+00	2021-05-18 16:07:14.527+00	\N	\N	ecg	3.82421875,0.319574367497006	fGQobjreD6	FEuHlBgcyE
8KAeop1l1M	2021-05-18 16:07:14.727+00	2021-05-18 16:07:14.727+00	\N	\N	ecg	3.828125,0.389379361899809	fGQobjreD6	FEuHlBgcyE
vwoH0ybXXW	2021-05-18 16:07:14.927+00	2021-05-18 16:07:14.927+00	\N	\N	ecg	3.83203125,0.386061647726	fGQobjreD6	FEuHlBgcyE
yKJckdyRTN	2021-05-18 16:07:15.128+00	2021-05-18 16:07:15.128+00	\N	\N	ecg	3.8359375,0.261831010039264	fGQobjreD6	FEuHlBgcyE
OQEH9UOIi6	2021-05-18 16:07:15.328+00	2021-05-18 16:07:15.328+00	\N	\N	ecg	3.83984375,0.333939310083479	fGQobjreD6	FEuHlBgcyE
3iGIOrOVoS	2021-05-18 16:07:15.529+00	2021-05-18 16:07:15.529+00	\N	\N	ecg	3.84375,0.182305701008605	fGQobjreD6	FEuHlBgcyE
OiO7cPBPzQ	2021-05-18 16:07:15.729+00	2021-05-18 16:07:15.729+00	\N	\N	ecg	3.84765625,0.292685051987256	fGQobjreD6	FEuHlBgcyE
O8OhDzWMV7	2021-05-18 16:07:15.929+00	2021-05-18 16:07:15.929+00	\N	\N	ecg	3.8515625,0.213812050542015	fGQobjreD6	FEuHlBgcyE
YgbjRIK3Hw	2021-05-18 16:07:16.131+00	2021-05-18 16:07:16.131+00	\N	\N	ecg	3.85546875,0.285746439122494	fGQobjreD6	FEuHlBgcyE
lMlfw4rock	2021-05-18 16:07:16.331+00	2021-05-18 16:07:16.331+00	\N	\N	ecg	3.859375,0.229004321668699	fGQobjreD6	FEuHlBgcyE
EHJqD75zV9	2021-05-18 16:07:16.532+00	2021-05-18 16:07:16.532+00	\N	\N	ecg	3.86328125,0.250698118914564	fGQobjreD6	FEuHlBgcyE
RmZxVNGP4s	2021-05-18 16:07:16.732+00	2021-05-18 16:07:16.732+00	\N	\N	ecg	3.8671875,0.28438780443771	fGQobjreD6	FEuHlBgcyE
w4zJbingbE	2021-05-18 16:07:16.932+00	2021-05-18 16:07:16.932+00	\N	\N	ecg	3.87109375,0.133227654191309	fGQobjreD6	FEuHlBgcyE
3nGoC3EGPA	2021-05-18 16:07:17.133+00	2021-05-18 16:07:17.133+00	\N	\N	ecg	3.875,0.227394325819718	fGQobjreD6	FEuHlBgcyE
djwxblz6WR	2021-05-18 16:07:17.334+00	2021-05-18 16:07:17.334+00	\N	\N	ecg	3.87890625,0.138843107469857	fGQobjreD6	FEuHlBgcyE
df3Dc2PW0p	2021-05-18 16:07:17.534+00	2021-05-18 16:07:17.534+00	\N	\N	ecg	3.8828125,0.120521307047579	fGQobjreD6	FEuHlBgcyE
hxhZEJVQyt	2021-05-18 16:07:17.736+00	2021-05-18 16:07:17.736+00	\N	\N	ecg	3.88671875,0.162405386679642	fGQobjreD6	FEuHlBgcyE
FcKn0MMXry	2021-05-18 16:07:17.935+00	2021-05-18 16:07:17.935+00	\N	\N	ecg	3.890625,0.102135385367308	fGQobjreD6	FEuHlBgcyE
NeHnin1QMU	2021-05-18 16:07:18.137+00	2021-05-18 16:07:18.137+00	\N	\N	ecg	3.89453125,0.033475768741972	fGQobjreD6	FEuHlBgcyE
OPmfV4gZfm	2021-05-18 16:07:18.337+00	2021-05-18 16:07:18.337+00	\N	\N	ecg	3.8984375,0.132676146304381	fGQobjreD6	FEuHlBgcyE
niIfgJKgv0	2021-05-18 16:07:18.537+00	2021-05-18 16:07:18.537+00	\N	\N	ecg	3.90234375,-0.00705801161508589	fGQobjreD6	FEuHlBgcyE
IZq3dkOer5	2021-05-18 16:07:18.737+00	2021-05-18 16:07:18.737+00	\N	\N	ecg	3.90625,0.0380674905553353	fGQobjreD6	FEuHlBgcyE
HebGxXyG4X	2021-05-18 16:07:18.941+00	2021-05-18 16:07:18.941+00	\N	\N	ecg	3.91015625,0.0954089623089891	fGQobjreD6	FEuHlBgcyE
QUipVUgbSW	2021-05-18 16:07:19.138+00	2021-05-18 16:07:19.138+00	\N	\N	ecg	3.9140625,0.0685272779988416	fGQobjreD6	FEuHlBgcyE
yT4cPq8khn	2021-05-18 16:07:19.34+00	2021-05-18 16:07:19.34+00	\N	\N	ecg	3.91796875,-0.0131143574994507	fGQobjreD6	FEuHlBgcyE
neOnrogIpg	2021-05-18 16:07:19.54+00	2021-05-18 16:07:19.54+00	\N	\N	ecg	3.921875,0.0845656473768603	fGQobjreD6	FEuHlBgcyE
PlStXITISU	2021-05-18 16:07:19.742+00	2021-05-18 16:07:19.742+00	\N	\N	ecg	3.92578125,0.0762124643422892	fGQobjreD6	FEuHlBgcyE
fMVl6dWLww	2021-05-18 16:07:19.942+00	2021-05-18 16:07:19.942+00	\N	\N	ecg	3.9296875,-0.0724664569693898	fGQobjreD6	FEuHlBgcyE
F4RtcMsAp8	2021-05-18 16:07:20.143+00	2021-05-18 16:07:20.143+00	\N	\N	ecg	3.93359375,-0.161498432952839	fGQobjreD6	FEuHlBgcyE
CaNgqx3TR4	2021-05-18 16:07:20.343+00	2021-05-18 16:07:20.343+00	\N	\N	ecg	3.9375,-0.079727714046906	fGQobjreD6	FEuHlBgcyE
vHPtPy8SEX	2021-05-18 16:07:20.544+00	2021-05-18 16:07:20.544+00	\N	\N	ecg	3.94140625,-0.183467751182479	fGQobjreD6	FEuHlBgcyE
X4ojSxsjMn	2021-05-18 16:07:20.745+00	2021-05-18 16:07:20.745+00	\N	\N	ecg	3.9453125,-0.144304425275969	fGQobjreD6	FEuHlBgcyE
93kCStOSfy	2021-05-18 16:07:20.946+00	2021-05-18 16:07:20.946+00	\N	\N	ecg	3.94921875,-0.163458658403001	fGQobjreD6	FEuHlBgcyE
EBNbtR5LDP	2021-05-18 16:07:21.146+00	2021-05-18 16:07:21.146+00	\N	\N	ecg	3.953125,-0.0711002446953886	fGQobjreD6	FEuHlBgcyE
9DkMvFyAqm	2021-05-18 16:07:21.351+00	2021-05-18 16:07:21.351+00	\N	\N	ecg	3.95703125,-0.140922149572985	fGQobjreD6	FEuHlBgcyE
qp9RWF1iFw	2021-05-18 16:07:21.547+00	2021-05-18 16:07:21.547+00	\N	\N	ecg	3.9609375,0.0844452792869589	fGQobjreD6	FEuHlBgcyE
5inNHDTIQk	2021-05-18 16:07:21.748+00	2021-05-18 16:07:21.748+00	\N	\N	ecg	3.96484375,0.106514860005852	fGQobjreD6	FEuHlBgcyE
VHmHevi6nP	2021-05-18 16:07:21.949+00	2021-05-18 16:07:21.949+00	\N	\N	ecg	3.96875,0.232933385838573	fGQobjreD6	FEuHlBgcyE
dKGr9ahQX8	2021-05-18 16:07:22.149+00	2021-05-18 16:07:22.149+00	\N	\N	ecg	3.97265625,0.399347566621186	fGQobjreD6	FEuHlBgcyE
kYKwypC369	2021-05-18 16:07:22.35+00	2021-05-18 16:07:22.35+00	\N	\N	ecg	3.9765625,0.648487264644577	fGQobjreD6	FEuHlBgcyE
KqxI95cogg	2021-05-18 16:07:22.55+00	2021-05-18 16:07:22.55+00	\N	\N	ecg	3.98046875,0.788939387361108	fGQobjreD6	FEuHlBgcyE
aALwvv6hhA	2021-05-18 16:07:22.75+00	2021-05-18 16:07:22.75+00	\N	\N	ecg	3.984375,1.06321073401698	fGQobjreD6	FEuHlBgcyE
7ViwwNuiuU	2021-05-18 16:07:22.951+00	2021-05-18 16:07:22.951+00	\N	\N	ecg	3.98828125,1.15679534283234	fGQobjreD6	FEuHlBgcyE
E5tcZu5rTf	2021-05-18 16:07:23.151+00	2021-05-18 16:07:23.151+00	\N	\N	ecg	3.9921875,1.08560398945084	fGQobjreD6	FEuHlBgcyE
PQQ6GKvqmM	2021-05-18 16:07:23.352+00	2021-05-18 16:07:23.352+00	\N	\N	ecg	3.99609375,1.06583785466464	fGQobjreD6	FEuHlBgcyE
L9vlbEpKYZ	2021-05-18 16:07:23.552+00	2021-05-18 16:07:23.552+00	\N	\N	ecg	4.0,1.12705852985289	fGQobjreD6	FEuHlBgcyE
9SFm3lhEgW	2021-05-18 16:07:23.753+00	2021-05-18 16:07:23.753+00	\N	\N	ecg	4.00390625,1.06244793594112	fGQobjreD6	FEuHlBgcyE
hLa1AsXyGL	2021-05-18 16:07:23.956+00	2021-05-18 16:07:23.956+00	\N	\N	ecg	4.0078125,0.875759757505777	fGQobjreD6	FEuHlBgcyE
TyTf4JrrBh	2021-05-18 16:07:24.154+00	2021-05-18 16:07:24.154+00	\N	\N	ecg	4.01171875,0.823738951746154	fGQobjreD6	FEuHlBgcyE
IpeeQIUgVe	2021-05-18 16:07:24.354+00	2021-05-18 16:07:24.354+00	\N	\N	ecg	4.015625,0.604728179158279	fGQobjreD6	FEuHlBgcyE
KEhX4SIdKw	2021-05-18 16:07:24.555+00	2021-05-18 16:07:24.555+00	\N	\N	ecg	4.01953125,0.450252045996394	fGQobjreD6	FEuHlBgcyE
gCkMA85CzD	2021-05-18 16:07:24.755+00	2021-05-18 16:07:24.755+00	\N	\N	ecg	4.0234375,0.187966012385694	fGQobjreD6	FEuHlBgcyE
ulofEBrl2V	2021-05-18 16:07:24.959+00	2021-05-18 16:07:24.959+00	\N	\N	ecg	4.02734375,-0.0592836927927862	fGQobjreD6	FEuHlBgcyE
F3RaLXytFV	2021-05-18 16:07:25.157+00	2021-05-18 16:07:25.157+00	\N	\N	ecg	4.03125,-0.233386801821144	fGQobjreD6	FEuHlBgcyE
yXGcmmGmiE	2021-05-18 16:07:25.358+00	2021-05-18 16:07:25.358+00	\N	\N	ecg	4.03515625,-0.206492786527422	fGQobjreD6	FEuHlBgcyE
SV2gtT0SFA	2021-05-18 16:07:25.558+00	2021-05-18 16:07:25.558+00	\N	\N	ecg	4.0390625,-0.387907012645616	fGQobjreD6	FEuHlBgcyE
Kc1oH0uZ2p	2021-05-18 16:07:25.759+00	2021-05-18 16:07:25.759+00	\N	\N	ecg	4.04296875,-0.35693074990372	fGQobjreD6	FEuHlBgcyE
h7ZRuJOjyn	2021-05-18 16:07:25.96+00	2021-05-18 16:07:25.96+00	\N	\N	ecg	4.046875,-0.290222265475376	fGQobjreD6	FEuHlBgcyE
LPopk8HN5j	2021-05-18 16:07:26.161+00	2021-05-18 16:07:26.161+00	\N	\N	ecg	4.05078125,-0.192017903885469	fGQobjreD6	FEuHlBgcyE
9wwW8nDR3G	2021-05-18 16:07:26.361+00	2021-05-18 16:07:26.361+00	\N	\N	ecg	4.0546875,-0.277527170112164	fGQobjreD6	FEuHlBgcyE
BxeXd5fFrH	2021-05-18 16:07:26.561+00	2021-05-18 16:07:26.561+00	\N	\N	ecg	4.05859375,-0.250093220451493	fGQobjreD6	FEuHlBgcyE
lhEd5zLVzG	2021-05-18 16:07:26.762+00	2021-05-18 16:07:26.762+00	\N	\N	ecg	4.0625,-0.235729070324845	fGQobjreD6	FEuHlBgcyE
2wxNZ3OKlz	2021-05-18 16:07:26.963+00	2021-05-18 16:07:26.963+00	\N	\N	ecg	4.06640625,-0.059024185306969	fGQobjreD6	FEuHlBgcyE
gzQDSS9FSE	2021-05-18 16:07:27.163+00	2021-05-18 16:07:27.163+00	\N	\N	ecg	4.0703125,-0.0428235239163977	fGQobjreD6	FEuHlBgcyE
xnGb0yQmWo	2021-05-18 16:07:27.364+00	2021-05-18 16:07:27.364+00	\N	\N	ecg	4.07421875,0.0194783311918042	fGQobjreD6	FEuHlBgcyE
l2LxQi8ODr	2021-05-18 16:07:27.564+00	2021-05-18 16:07:27.564+00	\N	\N	ecg	4.078125,-0.131853851051741	fGQobjreD6	FEuHlBgcyE
mxEB7etsS8	2021-05-18 16:07:27.765+00	2021-05-18 16:07:27.765+00	\N	\N	ecg	4.08203125,-0.0806966713945835	fGQobjreD6	FEuHlBgcyE
GSkLMEfBI7	2021-05-18 16:07:27.965+00	2021-05-18 16:07:27.965+00	\N	\N	ecg	4.0859375,-0.045575810958973	fGQobjreD6	FEuHlBgcyE
oWoxnTDgAb	2021-05-18 16:07:28.165+00	2021-05-18 16:07:28.165+00	\N	\N	ecg	4.08984375,-0.0498133966754605	fGQobjreD6	FEuHlBgcyE
24gK9dwN7U	2021-05-18 16:07:28.366+00	2021-05-18 16:07:28.366+00	\N	\N	ecg	4.09375,0.0286909842798259	fGQobjreD6	FEuHlBgcyE
rXm8j7ibuG	2021-05-18 16:07:28.567+00	2021-05-18 16:07:28.567+00	\N	\N	ecg	4.09765625,-0.101691429951695	fGQobjreD6	FEuHlBgcyE
6PphoSTsK5	2021-05-18 16:07:28.767+00	2021-05-18 16:07:28.767+00	\N	\N	ecg	4.1015625,0.0688875623691073	fGQobjreD6	FEuHlBgcyE
HpObAq5QKW	2021-05-18 16:07:28.971+00	2021-05-18 16:07:28.971+00	\N	\N	ecg	4.10546875,-0.0341086571432948	fGQobjreD6	FEuHlBgcyE
dcOCAuxSoz	2021-05-18 16:07:29.168+00	2021-05-18 16:07:29.168+00	\N	\N	ecg	4.109375,-0.00354894593836948	fGQobjreD6	FEuHlBgcyE
rO4lYhCnWP	2021-05-18 16:07:29.368+00	2021-05-18 16:07:29.368+00	\N	\N	ecg	4.11328125,0.0292451353128132	fGQobjreD6	FEuHlBgcyE
7eD1Gjtsn8	2021-05-18 16:07:29.569+00	2021-05-18 16:07:29.569+00	\N	\N	ecg	4.1171875,-0.00373658554987735	fGQobjreD6	FEuHlBgcyE
YONyBrxPYY	2021-05-18 16:07:29.769+00	2021-05-18 16:07:29.769+00	\N	\N	ecg	4.12109375,-0.0450412238007426	fGQobjreD6	FEuHlBgcyE
QBSsqmWcls	2021-05-18 16:07:29.97+00	2021-05-18 16:07:29.97+00	\N	\N	ecg	4.125,0.0992968646039004	fGQobjreD6	FEuHlBgcyE
GuHW3mFLFd	2021-05-18 16:07:30.17+00	2021-05-18 16:07:30.17+00	\N	\N	ecg	4.12890625,-0.0210341503077046	fGQobjreD6	FEuHlBgcyE
K7bLAqrW8T	2021-05-18 16:07:30.371+00	2021-05-18 16:07:30.371+00	\N	\N	ecg	4.1328125,0.0671065812014678	fGQobjreD6	FEuHlBgcyE
tjc416LYj7	2021-05-18 16:07:30.571+00	2021-05-18 16:07:30.571+00	\N	\N	ecg	4.13671875,0.11481088862095	fGQobjreD6	FEuHlBgcyE
EYKIbFL6ux	2021-05-18 16:07:30.772+00	2021-05-18 16:07:30.772+00	\N	\N	ecg	4.140625,0.0343380699276404	fGQobjreD6	FEuHlBgcyE
Mi1nvoZrfk	2021-05-18 16:07:30.972+00	2021-05-18 16:07:30.972+00	\N	\N	ecg	4.14453125,0.171373661560386	fGQobjreD6	FEuHlBgcyE
mGHJByYLuW	2021-05-18 16:07:31.172+00	2021-05-18 16:07:31.172+00	\N	\N	ecg	4.1484375,0.0218884515978358	fGQobjreD6	FEuHlBgcyE
FFEioOcFJt	2021-05-18 16:07:31.373+00	2021-05-18 16:07:31.373+00	\N	\N	ecg	4.15234375,0.135763401042889	fGQobjreD6	FEuHlBgcyE
SrwJi3ZWRq	2021-05-18 16:07:31.574+00	2021-05-18 16:07:31.574+00	\N	\N	ecg	4.15625,0.178347881143365	fGQobjreD6	FEuHlBgcyE
lZpSkY998x	2021-05-18 16:07:31.775+00	2021-05-18 16:07:31.775+00	\N	\N	ecg	4.16015625,0.0700744935663874	fGQobjreD6	FEuHlBgcyE
yICnkRufK0	2021-05-18 16:07:31.975+00	2021-05-18 16:07:31.975+00	\N	\N	ecg	4.1640625,0.126583310783601	fGQobjreD6	FEuHlBgcyE
fAYXuYxKjQ	2021-05-18 16:07:32.175+00	2021-05-18 16:07:32.175+00	\N	\N	ecg	4.16796875,0.250651516668627	fGQobjreD6	FEuHlBgcyE
lBdLD8sRHG	2021-05-18 16:07:32.378+00	2021-05-18 16:07:32.378+00	\N	\N	ecg	4.171875,0.11405003651	fGQobjreD6	FEuHlBgcyE
2eEdCpBiUy	2021-05-18 16:07:32.578+00	2021-05-18 16:07:32.578+00	\N	\N	ecg	4.17578125,0.239882169940308	fGQobjreD6	FEuHlBgcyE
TeutHnhuDi	2021-05-18 16:07:32.777+00	2021-05-18 16:07:32.777+00	\N	\N	ecg	4.1796875,0.159191582015438	fGQobjreD6	FEuHlBgcyE
7mCFlZ8VTX	2021-05-18 16:07:32.979+00	2021-05-18 16:07:32.979+00	\N	\N	ecg	4.18359375,0.145765935143261	fGQobjreD6	FEuHlBgcyE
ZxGUSu3nmA	2021-05-18 16:07:33.179+00	2021-05-18 16:07:33.179+00	\N	\N	ecg	4.1875,0.204971215889314	fGQobjreD6	FEuHlBgcyE
tyOJURR9Sk	2021-05-18 16:07:33.38+00	2021-05-18 16:07:33.38+00	\N	\N	ecg	4.19140625,0.247349096907832	fGQobjreD6	FEuHlBgcyE
LARGllNQ5Z	2021-05-18 16:07:33.58+00	2021-05-18 16:07:33.58+00	\N	\N	ecg	4.1953125,0.37358488367951	fGQobjreD6	FEuHlBgcyE
cRYp8osaED	2021-05-18 16:07:33.78+00	2021-05-18 16:07:33.78+00	\N	\N	ecg	4.19921875,0.237401212308442	fGQobjreD6	FEuHlBgcyE
nN9YW4iqsM	2021-05-18 16:07:33.985+00	2021-05-18 16:07:33.985+00	\N	\N	ecg	4.203125,0.399070054102479	fGQobjreD6	FEuHlBgcyE
Hgb0vsCZQ8	2021-05-18 16:07:34.181+00	2021-05-18 16:07:34.181+00	\N	\N	ecg	4.20703125,0.345663533588839	fGQobjreD6	FEuHlBgcyE
SoPKHBT7J5	2021-05-18 16:07:34.381+00	2021-05-18 16:07:34.381+00	\N	\N	ecg	4.2109375,0.421630562459038	fGQobjreD6	FEuHlBgcyE
SdzARHuCQr	2021-05-18 16:07:34.583+00	2021-05-18 16:07:34.583+00	\N	\N	ecg	4.21484375,0.408571667473728	fGQobjreD6	FEuHlBgcyE
WUnNrGrjoI	2021-05-18 16:07:34.783+00	2021-05-18 16:07:34.783+00	\N	\N	ecg	4.21875,0.326508748625089	fGQobjreD6	FEuHlBgcyE
nzw3UWcLWU	2021-05-18 16:07:34.984+00	2021-05-18 16:07:34.984+00	\N	\N	ecg	4.22265625,0.453684747853945	fGQobjreD6	FEuHlBgcyE
Zgae2Yif48	2021-05-18 16:07:35.185+00	2021-05-18 16:07:35.185+00	\N	\N	ecg	4.2265625,0.402663390443594	fGQobjreD6	FEuHlBgcyE
XgufFvY9vY	2021-05-18 16:07:35.385+00	2021-05-18 16:07:35.385+00	\N	\N	ecg	4.23046875,0.454747407531027	fGQobjreD6	FEuHlBgcyE
xbwhUNq3m7	2021-05-18 16:07:35.585+00	2021-05-18 16:07:35.585+00	\N	\N	ecg	4.234375,0.410165185665853	fGQobjreD6	FEuHlBgcyE
BeMF6dZMqB	2021-05-18 16:07:35.786+00	2021-05-18 16:07:35.786+00	\N	\N	ecg	4.23828125,0.335879947892884	fGQobjreD6	FEuHlBgcyE
67Oik1GFE6	2021-05-18 16:07:35.986+00	2021-05-18 16:07:35.986+00	\N	\N	ecg	4.2421875,0.338521936402238	fGQobjreD6	FEuHlBgcyE
oar1tP3oq5	2021-05-18 16:07:36.187+00	2021-05-18 16:07:36.187+00	\N	\N	ecg	4.24609375,0.480067383046126	fGQobjreD6	FEuHlBgcyE
bZZr2AoWex	2021-05-18 16:07:36.387+00	2021-05-18 16:07:36.387+00	\N	\N	ecg	4.25,0.444931717265355	fGQobjreD6	FEuHlBgcyE
x1xUiYzSE6	2021-05-18 16:07:36.588+00	2021-05-18 16:07:36.588+00	\N	\N	ecg	4.25390625,0.420641810193508	fGQobjreD6	FEuHlBgcyE
YC6ifUCfnt	2021-05-18 16:07:36.789+00	2021-05-18 16:07:36.789+00	\N	\N	ecg	4.2578125,0.316493445668136	fGQobjreD6	FEuHlBgcyE
AdWyQRCeds	2021-05-18 16:07:36.989+00	2021-05-18 16:07:36.989+00	\N	\N	ecg	4.26171875,0.309922380841522	fGQobjreD6	FEuHlBgcyE
wpgfDY2NPP	2021-05-18 16:07:37.189+00	2021-05-18 16:07:37.189+00	\N	\N	ecg	4.265625,0.279488900817205	fGQobjreD6	FEuHlBgcyE
VG6HYhoHZY	2021-05-18 16:07:37.39+00	2021-05-18 16:07:37.39+00	\N	\N	ecg	4.26953125,0.315024095161497	fGQobjreD6	FEuHlBgcyE
6hdQm4eJ0l	2021-05-18 16:07:37.59+00	2021-05-18 16:07:37.59+00	\N	\N	ecg	4.2734375,0.320330790998883	fGQobjreD6	FEuHlBgcyE
qZXCHTPg6N	2021-05-18 16:07:37.791+00	2021-05-18 16:07:37.791+00	\N	\N	ecg	4.27734375,0.370425008099375	fGQobjreD6	FEuHlBgcyE
pLuby6FzZo	2021-05-18 16:07:37.992+00	2021-05-18 16:07:37.992+00	\N	\N	ecg	4.28125,0.387059137355977	fGQobjreD6	FEuHlBgcyE
N9PxHqy41F	2021-05-18 16:07:38.191+00	2021-05-18 16:07:38.191+00	\N	\N	ecg	4.28515625,0.312637095674988	fGQobjreD6	FEuHlBgcyE
spymX3U3VR	2021-05-18 16:07:38.392+00	2021-05-18 16:07:38.392+00	\N	\N	ecg	4.2890625,0.294533411534843	fGQobjreD6	FEuHlBgcyE
faHWWb9Bfi	2021-05-18 16:07:38.592+00	2021-05-18 16:07:38.592+00	\N	\N	ecg	4.29296875,0.302799410682013	fGQobjreD6	FEuHlBgcyE
8adJqrW6dE	2021-05-18 16:07:38.794+00	2021-05-18 16:07:38.794+00	\N	\N	ecg	4.296875,0.179773410836103	fGQobjreD6	FEuHlBgcyE
rfV3Kreq2R	2021-05-18 16:07:38.997+00	2021-05-18 16:07:38.997+00	\N	\N	ecg	4.30078125,0.276255214340195	fGQobjreD6	FEuHlBgcyE
zv6k8WEU4T	2021-05-18 16:07:39.194+00	2021-05-18 16:07:39.194+00	\N	\N	ecg	4.3046875,0.161100726368793	fGQobjreD6	FEuHlBgcyE
FsOVMPcE6S	2021-05-18 16:07:39.395+00	2021-05-18 16:07:39.395+00	\N	\N	ecg	4.30859375,0.284264424904188	fGQobjreD6	FEuHlBgcyE
wQwk0pAd8S	2021-05-18 16:07:39.595+00	2021-05-18 16:07:39.595+00	\N	\N	ecg	4.3125,0.198367800813536	fGQobjreD6	FEuHlBgcyE
RR7fLmAYAF	2021-05-18 16:07:39.795+00	2021-05-18 16:07:39.795+00	\N	\N	ecg	4.31640625,0.0966300820930321	fGQobjreD6	FEuHlBgcyE
lunbs5e0bh	2021-05-18 16:07:39.996+00	2021-05-18 16:07:39.996+00	\N	\N	ecg	4.3203125,0.0836706917542261	fGQobjreD6	FEuHlBgcyE
Jfu8MHkS2n	2021-05-18 16:07:40.21+00	2021-05-18 16:07:40.21+00	\N	\N	ecg	4.32421875,0.109200631654795	fGQobjreD6	FEuHlBgcyE
ymTvY20IlG	2021-05-18 16:07:40.4+00	2021-05-18 16:07:40.4+00	\N	\N	ecg	4.328125,0.094076257896318	fGQobjreD6	FEuHlBgcyE
CUUq5s4jv9	2021-05-18 16:07:40.6+00	2021-05-18 16:07:40.6+00	\N	\N	ecg	4.33203125,0.0340272894121502	fGQobjreD6	FEuHlBgcyE
dtUY567m60	2021-05-18 16:07:40.8+00	2021-05-18 16:07:40.8+00	\N	\N	ecg	4.3359375,0.181006962891072	fGQobjreD6	FEuHlBgcyE
bJixRpIlQh	2021-05-18 16:07:41+00	2021-05-18 16:07:41+00	\N	\N	ecg	4.33984375,0.166189492901873	fGQobjreD6	FEuHlBgcyE
U8hcwGX69I	2021-05-18 16:07:41.201+00	2021-05-18 16:07:41.201+00	\N	\N	ecg	4.34375,-0.0134765328778534	fGQobjreD6	FEuHlBgcyE
ZBZbDCfROe	2021-05-18 16:07:41.403+00	2021-05-18 16:07:41.403+00	\N	\N	ecg	4.34765625,0.154011479402941	fGQobjreD6	FEuHlBgcyE
4zmUxFf3NP	2021-05-18 16:07:41.603+00	2021-05-18 16:07:41.603+00	\N	\N	ecg	4.3515625,0.0554861408141964	fGQobjreD6	FEuHlBgcyE
Bkr3guoZFr	2021-05-18 16:07:41.804+00	2021-05-18 16:07:41.804+00	\N	\N	ecg	4.35546875,0.0335430313062925	fGQobjreD6	FEuHlBgcyE
xnCoOAL9t5	2021-05-18 16:07:42.003+00	2021-05-18 16:07:42.003+00	\N	\N	ecg	4.359375,-0.0305423381088788	fGQobjreD6	FEuHlBgcyE
dYZI9jbxo4	2021-05-18 16:07:42.206+00	2021-05-18 16:07:42.206+00	\N	\N	ecg	4.36328125,0.0050385631803817	fGQobjreD6	FEuHlBgcyE
WWhF3uCELb	2021-05-18 16:07:42.406+00	2021-05-18 16:07:42.406+00	\N	\N	ecg	4.3671875,-0.0310119032252117	fGQobjreD6	FEuHlBgcyE
bC8TBOKYK2	2021-05-18 16:07:42.607+00	2021-05-18 16:07:42.607+00	\N	\N	ecg	4.37109375,-0.0085589146683882	fGQobjreD6	FEuHlBgcyE
G7X7bSMYhp	2021-05-18 16:07:42.807+00	2021-05-18 16:07:42.807+00	\N	\N	ecg	4.375,-0.0413570845218212	fGQobjreD6	FEuHlBgcyE
bNFs3XQyTi	2021-05-18 16:07:43.007+00	2021-05-18 16:07:43.007+00	\N	\N	ecg	4.37890625,0.0882271548048075	fGQobjreD6	FEuHlBgcyE
d9e8grYUfI	2021-05-18 16:07:43.208+00	2021-05-18 16:07:43.208+00	\N	\N	ecg	4.3828125,0.00280616873407654	fGQobjreD6	FEuHlBgcyE
BgFFHvt4h6	2021-05-18 16:07:43.408+00	2021-05-18 16:07:43.408+00	\N	\N	ecg	4.38671875,-0.0736756310882781	fGQobjreD6	FEuHlBgcyE
aUHFtZw4nf	2021-05-18 16:07:43.609+00	2021-05-18 16:07:43.609+00	\N	\N	ecg	4.390625,-0.046991675110333	fGQobjreD6	FEuHlBgcyE
UugtxwBGY6	2021-05-18 16:07:43.809+00	2021-05-18 16:07:43.809+00	\N	\N	ecg	4.39453125,-0.00947655728589637	fGQobjreD6	FEuHlBgcyE
L7LOTP9qHg	2021-05-18 16:07:44.012+00	2021-05-18 16:07:44.012+00	\N	\N	ecg	4.3984375,-0.117730609031758	fGQobjreD6	FEuHlBgcyE
SYivAk3NY3	2021-05-18 16:07:44.211+00	2021-05-18 16:07:44.211+00	\N	\N	ecg	4.40234375,-0.120381648711539	fGQobjreD6	FEuHlBgcyE
vrAGYe1qpX	2021-05-18 16:07:44.411+00	2021-05-18 16:07:44.411+00	\N	\N	ecg	4.40625,0.0452457250836829	fGQobjreD6	FEuHlBgcyE
jhsElmvKCL	2021-05-18 16:07:44.611+00	2021-05-18 16:07:44.611+00	\N	\N	ecg	4.41015625,-0.13803790404141	fGQobjreD6	FEuHlBgcyE
RBP9upYm2E	2021-05-18 16:07:44.812+00	2021-05-18 16:07:44.812+00	\N	\N	ecg	4.4140625,0.022700142726962	fGQobjreD6	FEuHlBgcyE
i4CJX26kN0	2021-05-18 16:07:45.012+00	2021-05-18 16:07:45.012+00	\N	\N	ecg	4.41796875,-0.121632858316668	fGQobjreD6	FEuHlBgcyE
kunLsG3H3X	2021-05-18 16:07:45.213+00	2021-05-18 16:07:45.213+00	\N	\N	ecg	4.421875,-0.0877866607033838	fGQobjreD6	FEuHlBgcyE
GOuuA8yss1	2021-05-18 16:07:45.414+00	2021-05-18 16:07:45.414+00	\N	\N	ecg	4.42578125,-0.142284280941236	fGQobjreD6	FEuHlBgcyE
jXbXnRhPA2	2021-05-18 16:07:45.614+00	2021-05-18 16:07:45.614+00	\N	\N	ecg	4.4296875,-0.0438381338450631	fGQobjreD6	FEuHlBgcyE
RhC8OczsPy	2021-05-18 16:07:45.814+00	2021-05-18 16:07:45.814+00	\N	\N	ecg	4.43359375,0.021509645885696	fGQobjreD6	FEuHlBgcyE
9HvEcCryop	2021-05-18 16:07:46.015+00	2021-05-18 16:07:46.015+00	\N	\N	ecg	4.4375,-0.027263162496985	fGQobjreD6	FEuHlBgcyE
HEhszTUjIa	2021-05-18 16:07:46.216+00	2021-05-18 16:07:46.216+00	\N	\N	ecg	4.44140625,-0.0585229040973365	fGQobjreD6	FEuHlBgcyE
DPpfbPQk3k	2021-05-18 16:07:46.417+00	2021-05-18 16:07:46.417+00	\N	\N	ecg	4.4453125,0.0528362007139422	fGQobjreD6	FEuHlBgcyE
MAeqAEQDJL	2021-05-18 16:07:46.617+00	2021-05-18 16:07:46.617+00	\N	\N	ecg	4.44921875,-0.0415359512716529	fGQobjreD6	FEuHlBgcyE
loeYVfyPGB	2021-05-18 16:07:46.818+00	2021-05-18 16:07:46.818+00	\N	\N	ecg	4.453125,-0.0664070847931159	fGQobjreD6	FEuHlBgcyE
hKaW8l0Sfw	2021-05-18 16:07:47.018+00	2021-05-18 16:07:47.018+00	\N	\N	ecg	4.45703125,-0.085265913616269	fGQobjreD6	FEuHlBgcyE
Yvsp9XFyy8	2021-05-18 16:07:47.22+00	2021-05-18 16:07:47.22+00	\N	\N	ecg	4.4609375,0.0170288687324424	fGQobjreD6	FEuHlBgcyE
HUMc4p5g3y	2021-05-18 16:07:47.42+00	2021-05-18 16:07:47.42+00	\N	\N	ecg	4.46484375,-0.0994135063240511	fGQobjreD6	FEuHlBgcyE
NbjgjJALnA	2021-05-18 16:07:47.62+00	2021-05-18 16:07:47.62+00	\N	\N	ecg	4.46875,-0.0914474894169695	fGQobjreD6	FEuHlBgcyE
RA0S5ozMLs	2021-05-18 16:07:47.821+00	2021-05-18 16:07:47.821+00	\N	\N	ecg	4.47265625,0.0573887084220024	fGQobjreD6	FEuHlBgcyE
emAmYWi1Tz	2021-05-18 16:07:48.021+00	2021-05-18 16:07:48.021+00	\N	\N	ecg	4.4765625,-0.139721554462703	fGQobjreD6	FEuHlBgcyE
vAvMHZ7qeW	2021-05-18 16:07:48.222+00	2021-05-18 16:07:48.222+00	\N	\N	ecg	4.48046875,-0.103318531963274	fGQobjreD6	FEuHlBgcyE
UyAcyCPscW	2021-05-18 16:07:48.422+00	2021-05-18 16:07:48.422+00	\N	\N	ecg	4.484375,0.059615075962462	fGQobjreD6	FEuHlBgcyE
7b019GzHKz	2021-05-18 16:07:48.622+00	2021-05-18 16:07:48.622+00	\N	\N	ecg	4.48828125,-0.0937670038975264	fGQobjreD6	FEuHlBgcyE
tPeCSPoTP6	2021-05-18 16:07:48.823+00	2021-05-18 16:07:48.823+00	\N	\N	ecg	4.4921875,0.0444557533055442	fGQobjreD6	FEuHlBgcyE
8sOkQZJvim	2021-05-18 16:07:49.027+00	2021-05-18 16:07:49.027+00	\N	\N	ecg	4.49609375,-0.0555677239651816	fGQobjreD6	FEuHlBgcyE
FrYBzG1qPC	2021-05-18 16:07:49.224+00	2021-05-18 16:07:49.224+00	\N	\N	ecg	4.5,-0.0158356480141744	fGQobjreD6	FEuHlBgcyE
YvABuOOqVK	2021-05-18 16:07:49.424+00	2021-05-18 16:07:49.424+00	\N	\N	ecg	4.50390625,0.0452806581720361	fGQobjreD6	FEuHlBgcyE
myVyJpAi7o	2021-05-18 16:07:49.625+00	2021-05-18 16:07:49.625+00	\N	\N	ecg	4.5078125,-0.0971565334284623	fGQobjreD6	FEuHlBgcyE
K0EFmwR8vR	2021-05-18 16:07:49.825+00	2021-05-18 16:07:49.825+00	\N	\N	ecg	4.51171875,-0.0951167169061745	fGQobjreD6	FEuHlBgcyE
AIf2dYt1Fu	2021-05-18 16:07:50.026+00	2021-05-18 16:07:50.026+00	\N	\N	ecg	4.515625,-0.124630870192969	fGQobjreD6	FEuHlBgcyE
6AMnAipgTA	2021-05-18 16:07:50.227+00	2021-05-18 16:07:50.227+00	\N	\N	ecg	4.51953125,0.0558887387699032	fGQobjreD6	FEuHlBgcyE
PaZjft6bKb	2021-05-18 16:07:50.427+00	2021-05-18 16:07:50.427+00	\N	\N	ecg	4.5234375,-0.115493469465828	fGQobjreD6	FEuHlBgcyE
Y0fELLAKTi	2021-05-18 16:07:50.627+00	2021-05-18 16:07:50.627+00	\N	\N	ecg	4.52734375,-0.0677631915313475	fGQobjreD6	FEuHlBgcyE
53WNVCoCDb	2021-05-18 16:07:50.828+00	2021-05-18 16:07:50.828+00	\N	\N	ecg	4.53125,-0.0858273237588429	fGQobjreD6	FEuHlBgcyE
UaDV8X0jAF	2021-05-18 16:07:51.029+00	2021-05-18 16:07:51.029+00	\N	\N	ecg	4.53515625,-0.0131629912193893	fGQobjreD6	FEuHlBgcyE
K3Rgg7hnCa	2021-05-18 16:07:51.23+00	2021-05-18 16:07:51.23+00	\N	\N	ecg	4.5390625,-0.0441037763206974	fGQobjreD6	FEuHlBgcyE
2nqvFpLHPZ	2021-05-18 16:07:51.43+00	2021-05-18 16:07:51.43+00	\N	\N	ecg	4.54296875,-0.0898557529407844	fGQobjreD6	FEuHlBgcyE
3BfZ20HlCq	2021-05-18 16:07:51.632+00	2021-05-18 16:07:51.632+00	\N	\N	ecg	4.546875,-0.0363553080942667	fGQobjreD6	FEuHlBgcyE
8sBCdcTo5y	2021-05-18 16:07:51.832+00	2021-05-18 16:07:51.832+00	\N	\N	ecg	4.55078125,-0.0771366935216973	fGQobjreD6	FEuHlBgcyE
iVPmO61yfX	2021-05-18 16:07:52.032+00	2021-05-18 16:07:52.032+00	\N	\N	ecg	4.5546875,0.0559029316290867	fGQobjreD6	FEuHlBgcyE
KQu6n4zO4z	2021-05-18 16:07:52.234+00	2021-05-18 16:07:52.234+00	\N	\N	ecg	4.55859375,0.0231597739768244	fGQobjreD6	FEuHlBgcyE
vXHh0FkKr7	2021-05-18 16:07:52.436+00	2021-05-18 16:07:52.436+00	\N	\N	ecg	4.5625,-0.0807222722533805	fGQobjreD6	FEuHlBgcyE
PC7feTQT6k	2021-05-18 16:07:52.634+00	2021-05-18 16:07:52.634+00	\N	\N	ecg	4.56640625,-0.0101844006197011	fGQobjreD6	FEuHlBgcyE
3xGuHx9Hff	2021-05-18 16:07:52.835+00	2021-05-18 16:07:52.835+00	\N	\N	ecg	4.5703125,0.0237084093192928	fGQobjreD6	FEuHlBgcyE
ASVKuVB2Fp	2021-05-18 16:07:53.035+00	2021-05-18 16:07:53.035+00	\N	\N	ecg	4.57421875,-0.0907511717619149	fGQobjreD6	FEuHlBgcyE
I7m3X6wEZm	2021-05-18 16:07:53.235+00	2021-05-18 16:07:53.235+00	\N	\N	ecg	4.578125,-0.0911970637256693	fGQobjreD6	FEuHlBgcyE
vm7SKH1U7M	2021-05-18 16:07:53.436+00	2021-05-18 16:07:53.436+00	\N	\N	ecg	4.58203125,-0.0589254128710708	fGQobjreD6	FEuHlBgcyE
qqWersYUAI	2021-05-18 16:07:53.638+00	2021-05-18 16:07:53.638+00	\N	\N	ecg	4.5859375,-0.0665505101506306	fGQobjreD6	FEuHlBgcyE
Q47CEebbvp	2021-05-18 16:07:53.837+00	2021-05-18 16:07:53.837+00	\N	\N	ecg	4.58984375,-0.00681759073876825	fGQobjreD6	FEuHlBgcyE
e8Ti2yzQVb	2021-05-18 16:07:54.042+00	2021-05-18 16:07:54.042+00	\N	\N	ecg	4.59375,-0.0997773010278427	fGQobjreD6	FEuHlBgcyE
EowLru6NoN	2021-05-18 16:07:54.239+00	2021-05-18 16:07:54.239+00	\N	\N	ecg	4.59765625,0.0829647143113702	fGQobjreD6	FEuHlBgcyE
hPHnqbMRUp	2021-05-18 16:07:54.443+00	2021-05-18 16:07:54.443+00	\N	\N	ecg	4.6015625,0.0603826463996578	fGQobjreD6	FEuHlBgcyE
wtk4S8CgDz	2021-05-18 16:07:54.641+00	2021-05-18 16:07:54.641+00	\N	\N	ecg	4.60546875,-0.0453164990299239	fGQobjreD6	FEuHlBgcyE
Ya30nTpMY2	2021-05-18 16:07:54.841+00	2021-05-18 16:07:54.841+00	\N	\N	ecg	4.609375,0.044699166943504	fGQobjreD6	FEuHlBgcyE
vUfQEBDojL	2021-05-18 16:07:55.041+00	2021-05-18 16:07:55.041+00	\N	\N	ecg	4.61328125,-0.0630556407049914	fGQobjreD6	FEuHlBgcyE
csDujF08dj	2021-05-18 16:07:55.242+00	2021-05-18 16:07:55.242+00	\N	\N	ecg	4.6171875,-0.0621335284475862	fGQobjreD6	FEuHlBgcyE
n6b2QlXS4F	2021-05-18 16:07:55.442+00	2021-05-18 16:07:55.442+00	\N	\N	ecg	4.62109375,-0.0488954905998347	fGQobjreD6	FEuHlBgcyE
524a3jz4g0	2021-05-18 16:07:55.645+00	2021-05-18 16:07:55.645+00	\N	\N	ecg	4.625,0.0751324462188925	fGQobjreD6	FEuHlBgcyE
KWHgLNmigv	2021-05-18 16:07:55.844+00	2021-05-18 16:07:55.844+00	\N	\N	ecg	4.62890625,-0.00188934887938398	fGQobjreD6	FEuHlBgcyE
ww1SKOYjDr	2021-05-18 16:07:56.044+00	2021-05-18 16:07:56.044+00	\N	\N	ecg	4.6328125,-0.0265907425432962	fGQobjreD6	FEuHlBgcyE
nFWJ6htlLs	2021-05-18 16:07:56.245+00	2021-05-18 16:07:56.245+00	\N	\N	ecg	4.63671875,0.0638525097770323	fGQobjreD6	FEuHlBgcyE
hK44wZKQ1X	2021-05-18 16:07:56.445+00	2021-05-18 16:07:56.445+00	\N	\N	ecg	4.640625,-0.0298996422801941	fGQobjreD6	FEuHlBgcyE
PZIhtjvcrR	2021-05-18 16:07:56.645+00	2021-05-18 16:07:56.645+00	\N	\N	ecg	4.64453125,0.0392370740443337	fGQobjreD6	FEuHlBgcyE
cBg7A7fa6H	2021-05-18 16:07:56.845+00	2021-05-18 16:07:56.845+00	\N	\N	ecg	4.6484375,-0.0371911865037357	fGQobjreD6	FEuHlBgcyE
0PNOfZEkCw	2021-05-18 16:07:57.046+00	2021-05-18 16:07:57.046+00	\N	\N	ecg	4.65234375,0.0275619973003453	fGQobjreD6	FEuHlBgcyE
yi1mtFnSEv	2021-05-18 16:07:57.246+00	2021-05-18 16:07:57.246+00	\N	\N	ecg	4.65625,-0.0536530681139482	fGQobjreD6	FEuHlBgcyE
dD5xzNz1pG	2021-05-18 16:07:57.447+00	2021-05-18 16:07:57.447+00	\N	\N	ecg	4.66015625,-0.0192728154324219	fGQobjreD6	FEuHlBgcyE
hG35mPzrTK	2021-05-18 16:07:57.647+00	2021-05-18 16:07:57.647+00	\N	\N	ecg	4.6640625,-0.0208584609344444	fGQobjreD6	FEuHlBgcyE
k8zaapzgHi	2021-05-18 16:07:57.848+00	2021-05-18 16:07:57.848+00	\N	\N	ecg	4.66796875,-0.0505181087801421	fGQobjreD6	FEuHlBgcyE
WVdkYgZwip	2021-05-18 16:07:58.049+00	2021-05-18 16:07:58.049+00	\N	\N	ecg	4.671875,-0.0198608211300341	fGQobjreD6	FEuHlBgcyE
bsPE6mcALX	2021-05-18 16:07:58.249+00	2021-05-18 16:07:58.249+00	\N	\N	ecg	4.67578125,-0.00536604985980523	fGQobjreD6	FEuHlBgcyE
SLYhViY61D	2021-05-18 16:07:58.45+00	2021-05-18 16:07:58.45+00	\N	\N	ecg	4.6796875,-0.00678395331308003	fGQobjreD6	FEuHlBgcyE
CehDOkT0DJ	2021-05-18 16:07:58.651+00	2021-05-18 16:07:58.651+00	\N	\N	ecg	4.68359375,-0.0153865043130764	fGQobjreD6	FEuHlBgcyE
8YYnDKTN2X	2021-05-18 16:07:58.852+00	2021-05-18 16:07:58.852+00	\N	\N	ecg	4.6875,0.0826131786726928	fGQobjreD6	FEuHlBgcyE
ggfh068xqK	2021-05-18 16:07:59.057+00	2021-05-18 16:07:59.057+00	\N	\N	ecg	4.69140625,-0.0657794922748262	fGQobjreD6	FEuHlBgcyE
GlFpKrCP1y	2021-05-18 16:07:59.253+00	2021-05-18 16:07:59.253+00	\N	\N	ecg	4.6953125,0.0144229548256896	fGQobjreD6	FEuHlBgcyE
mxIh1psomn	2021-05-18 16:07:59.453+00	2021-05-18 16:07:59.453+00	\N	\N	ecg	4.69921875,0.0964051724313587	fGQobjreD6	FEuHlBgcyE
epmYFQRzp0	2021-05-18 16:07:59.654+00	2021-05-18 16:07:59.654+00	\N	\N	ecg	4.703125,-0.0259311850083524	fGQobjreD6	FEuHlBgcyE
CS5wcrPhll	2021-05-18 16:07:59.854+00	2021-05-18 16:07:59.854+00	\N	\N	ecg	4.70703125,-0.0861710658390892	fGQobjreD6	FEuHlBgcyE
KNWSjzVu8d	2021-05-18 16:08:00.055+00	2021-05-18 16:08:00.055+00	\N	\N	ecg	4.7109375,0.10873990519859	fGQobjreD6	FEuHlBgcyE
QAwKDQoBCP	2021-05-18 16:08:00.257+00	2021-05-18 16:08:00.257+00	\N	\N	ecg	4.71484375,-0.0354368880739339	fGQobjreD6	FEuHlBgcyE
VswleTYwvj	2021-05-18 16:08:00.456+00	2021-05-18 16:08:00.456+00	\N	\N	ecg	4.71875,0.0111402285344782	fGQobjreD6	FEuHlBgcyE
OtUc9G2HNy	2021-05-18 16:08:00.656+00	2021-05-18 16:08:00.656+00	\N	\N	ecg	4.72265625,-0.0454891613525848	fGQobjreD6	FEuHlBgcyE
4t3o5gWY5W	2021-05-18 16:08:00.857+00	2021-05-18 16:08:00.857+00	\N	\N	ecg	4.7265625,-0.00912257595545842	fGQobjreD6	FEuHlBgcyE
39M32QR7vM	2021-05-18 16:08:01.057+00	2021-05-18 16:08:01.057+00	\N	\N	ecg	4.73046875,-0.0680615864745478	fGQobjreD6	FEuHlBgcyE
hS3b7JL3zP	2021-05-18 16:08:01.259+00	2021-05-18 16:08:01.259+00	\N	\N	ecg	4.734375,0.127996753394931	fGQobjreD6	FEuHlBgcyE
OWoEhm9OmI	2021-05-18 16:08:01.459+00	2021-05-18 16:08:01.459+00	\N	\N	ecg	4.73828125,0.0997070419554419	fGQobjreD6	FEuHlBgcyE
8D7BCGyTsD	2021-05-18 16:08:01.66+00	2021-05-18 16:08:01.66+00	\N	\N	ecg	4.7421875,0.123127027347168	fGQobjreD6	FEuHlBgcyE
j1eA8OgycX	2021-05-18 16:08:01.861+00	2021-05-18 16:08:01.861+00	\N	\N	ecg	4.74609375,0.136732783765027	fGQobjreD6	FEuHlBgcyE
AEbtSpvLNh	2021-05-18 16:08:02.061+00	2021-05-18 16:08:02.061+00	\N	\N	ecg	4.75,0.0407842622533523	fGQobjreD6	FEuHlBgcyE
uPl4Cz3r0V	2021-05-18 16:08:02.262+00	2021-05-18 16:08:02.262+00	\N	\N	ecg	4.75390625,0.0864737790014718	fGQobjreD6	FEuHlBgcyE
CUU2kDcl2v	2021-05-18 16:08:02.461+00	2021-05-18 16:08:02.461+00	\N	\N	ecg	4.7578125,0.096544835028964	fGQobjreD6	FEuHlBgcyE
sVBKJhfrbB	2021-05-18 16:08:02.665+00	2021-05-18 16:08:02.665+00	\N	\N	ecg	4.76171875,0.119136770566511	fGQobjreD6	FEuHlBgcyE
vLXsTHssZz	2021-05-18 16:08:02.863+00	2021-05-18 16:08:02.863+00	\N	\N	ecg	4.765625,0.101442564498996	fGQobjreD6	FEuHlBgcyE
EYqm4bfekg	2021-05-18 16:08:03.063+00	2021-05-18 16:08:03.063+00	\N	\N	ecg	4.76953125,0.167309437052069	fGQobjreD6	FEuHlBgcyE
5EdLdHHf6O	2021-05-18 16:08:03.263+00	2021-05-18 16:08:03.263+00	\N	\N	ecg	4.7734375,0.0377353079026451	fGQobjreD6	FEuHlBgcyE
chDgKEFLgR	2021-05-18 16:08:03.466+00	2021-05-18 16:08:03.466+00	\N	\N	ecg	4.77734375,0.124293133501512	fGQobjreD6	FEuHlBgcyE
FKLmi8MdNr	2021-05-18 16:08:03.665+00	2021-05-18 16:08:03.665+00	\N	\N	ecg	4.78125,0.134544307493096	fGQobjreD6	FEuHlBgcyE
6B68tutkw9	2021-05-18 16:08:03.865+00	2021-05-18 16:08:03.865+00	\N	\N	ecg	4.78515625,0.178707155894595	fGQobjreD6	FEuHlBgcyE
l0mncX0EkY	2021-05-18 16:08:04.069+00	2021-05-18 16:08:04.069+00	\N	\N	ecg	4.7890625,0.142802478724873	fGQobjreD6	FEuHlBgcyE
3AFpqz4MWJ	2021-05-18 16:08:04.266+00	2021-05-18 16:08:04.266+00	\N	\N	ecg	4.79296875,0.156542060673886	fGQobjreD6	FEuHlBgcyE
M2wVKB2ZDz	2021-05-18 16:08:04.467+00	2021-05-18 16:08:04.467+00	\N	\N	ecg	4.796875,0.295925466495326	fGQobjreD6	FEuHlBgcyE
owrPEdqtCq	2021-05-18 16:08:04.666+00	2021-05-18 16:08:04.666+00	\N	\N	ecg	4.80078125,0.203004111730433	fGQobjreD6	FEuHlBgcyE
tvMXHDeB64	2021-05-18 16:08:04.867+00	2021-05-18 16:08:04.867+00	\N	\N	ecg	4.8046875,0.285204581463664	fGQobjreD6	FEuHlBgcyE
HrdoTFgVS8	2021-05-18 16:08:05.069+00	2021-05-18 16:08:05.069+00	\N	\N	ecg	4.80859375,0.277974916147161	fGQobjreD6	FEuHlBgcyE
Fup3Kjk4ip	2021-05-18 16:08:05.269+00	2021-05-18 16:08:05.269+00	\N	\N	ecg	4.8125,0.334666544429197	fGQobjreD6	FEuHlBgcyE
ERuAy0gf5G	2021-05-18 16:08:05.469+00	2021-05-18 16:08:05.469+00	\N	\N	ecg	4.81640625,0.33902974647277	fGQobjreD6	FEuHlBgcyE
uQJD2gkZIs	2021-05-18 16:08:05.669+00	2021-05-18 16:08:05.669+00	\N	\N	ecg	4.8203125,0.204161476587801	fGQobjreD6	FEuHlBgcyE
6poWwWTmhc	2021-05-18 16:08:05.87+00	2021-05-18 16:08:05.87+00	\N	\N	ecg	4.82421875,0.319574367497006	fGQobjreD6	FEuHlBgcyE
DFbsYFFdFP	2021-05-18 16:08:06.069+00	2021-05-18 16:08:06.069+00	\N	\N	ecg	4.828125,0.389379361899809	fGQobjreD6	FEuHlBgcyE
qRClzk0p14	2021-05-18 16:08:06.27+00	2021-05-18 16:08:06.27+00	\N	\N	ecg	4.83203125,0.386061647726	fGQobjreD6	FEuHlBgcyE
xNkvDAZtYm	2021-05-18 16:08:06.47+00	2021-05-18 16:08:06.47+00	\N	\N	ecg	4.8359375,0.261831010039264	fGQobjreD6	FEuHlBgcyE
DBnVzRGu45	2021-05-18 16:08:06.672+00	2021-05-18 16:08:06.672+00	\N	\N	ecg	4.83984375,0.333939310083479	fGQobjreD6	FEuHlBgcyE
zrTm0w6m4j	2021-05-18 16:08:06.872+00	2021-05-18 16:08:06.872+00	\N	\N	ecg	4.84375,0.182305701008605	fGQobjreD6	FEuHlBgcyE
tHJDJEZNFY	2021-05-18 16:08:07.072+00	2021-05-18 16:08:07.072+00	\N	\N	ecg	4.84765625,0.292685051987256	fGQobjreD6	FEuHlBgcyE
o4iVHNd6TL	2021-05-18 16:08:07.274+00	2021-05-18 16:08:07.274+00	\N	\N	ecg	4.8515625,0.213812050542015	fGQobjreD6	FEuHlBgcyE
l0LwBSRMv2	2021-05-18 16:08:07.474+00	2021-05-18 16:08:07.474+00	\N	\N	ecg	4.85546875,0.285746439122494	fGQobjreD6	FEuHlBgcyE
WELnaDYhWG	2021-05-18 16:08:07.673+00	2021-05-18 16:08:07.673+00	\N	\N	ecg	4.859375,0.229004321668699	fGQobjreD6	FEuHlBgcyE
pvWjmrKOjj	2021-05-18 16:08:07.874+00	2021-05-18 16:08:07.874+00	\N	\N	ecg	4.86328125,0.250698118914564	fGQobjreD6	FEuHlBgcyE
XwQQH7mrtk	2021-05-18 16:08:08.074+00	2021-05-18 16:08:08.074+00	\N	\N	ecg	4.8671875,0.28438780443771	fGQobjreD6	FEuHlBgcyE
66oka9H3Wa	2021-05-18 16:08:08.276+00	2021-05-18 16:08:08.276+00	\N	\N	ecg	4.87109375,0.133227654191309	fGQobjreD6	FEuHlBgcyE
tTFM0oaLDf	2021-05-18 16:08:08.476+00	2021-05-18 16:08:08.476+00	\N	\N	ecg	4.875,0.227394325819718	fGQobjreD6	FEuHlBgcyE
EXvNB8FPD4	2021-05-18 16:08:08.676+00	2021-05-18 16:08:08.676+00	\N	\N	ecg	4.87890625,0.138843107469857	fGQobjreD6	FEuHlBgcyE
MaFXQBmmMi	2021-05-18 16:08:08.877+00	2021-05-18 16:08:08.877+00	\N	\N	ecg	4.8828125,0.120521307047579	fGQobjreD6	FEuHlBgcyE
KrL14dWbiQ	2021-05-18 16:08:09.082+00	2021-05-18 16:08:09.082+00	\N	\N	ecg	4.88671875,0.162405386679642	fGQobjreD6	FEuHlBgcyE
I73YEZm2g6	2021-05-18 16:08:09.279+00	2021-05-18 16:08:09.279+00	\N	\N	ecg	4.890625,0.102135385367308	fGQobjreD6	FEuHlBgcyE
7nPsIHAgni	2021-05-18 16:08:09.478+00	2021-05-18 16:08:09.478+00	\N	\N	ecg	4.89453125,0.033475768741972	fGQobjreD6	FEuHlBgcyE
sbRB9jezS9	2021-05-18 16:08:09.68+00	2021-05-18 16:08:09.68+00	\N	\N	ecg	4.8984375,0.132676146304381	fGQobjreD6	FEuHlBgcyE
c6Ne4pqgo1	2021-05-18 16:08:09.88+00	2021-05-18 16:08:09.88+00	\N	\N	ecg	4.90234375,-0.00705801161508589	fGQobjreD6	FEuHlBgcyE
FpRrjtZP3s	2021-05-18 16:08:10.08+00	2021-05-18 16:08:10.08+00	\N	\N	ecg	4.90625,0.0380674905553353	fGQobjreD6	FEuHlBgcyE
Ta8HM7i2IL	2021-05-18 16:08:10.287+00	2021-05-18 16:08:10.287+00	\N	\N	ecg	4.91015625,0.0954089623089891	fGQobjreD6	FEuHlBgcyE
3jyEXs91PF	2021-05-18 16:08:10.481+00	2021-05-18 16:08:10.481+00	\N	\N	ecg	4.9140625,0.0685272779988416	fGQobjreD6	FEuHlBgcyE
CIEBs1Nywo	2021-05-18 16:08:10.683+00	2021-05-18 16:08:10.683+00	\N	\N	ecg	4.91796875,-0.0131143574994507	fGQobjreD6	FEuHlBgcyE
3xUy4FAm64	2021-05-18 16:08:10.882+00	2021-05-18 16:08:10.882+00	\N	\N	ecg	4.921875,0.0845656473768603	fGQobjreD6	FEuHlBgcyE
4v01Zon09t	2021-05-18 16:08:11.084+00	2021-05-18 16:08:11.084+00	\N	\N	ecg	4.92578125,0.0762124643422892	fGQobjreD6	FEuHlBgcyE
I31yeEXxP5	2021-05-18 16:08:11.283+00	2021-05-18 16:08:11.283+00	\N	\N	ecg	4.9296875,-0.0724664569693898	fGQobjreD6	FEuHlBgcyE
rTCT16kdbv	2021-05-18 16:08:11.485+00	2021-05-18 16:08:11.485+00	\N	\N	ecg	4.93359375,-0.161498432952839	fGQobjreD6	FEuHlBgcyE
vHzgDqiGqu	2021-05-18 16:08:11.684+00	2021-05-18 16:08:11.684+00	\N	\N	ecg	4.9375,-0.079727714046906	fGQobjreD6	FEuHlBgcyE
qw74CA8BO0	2021-05-18 16:08:11.885+00	2021-05-18 16:08:11.885+00	\N	\N	ecg	4.94140625,-0.183467751182479	fGQobjreD6	FEuHlBgcyE
FIppAK2VkF	2021-05-18 16:08:12.085+00	2021-05-18 16:08:12.085+00	\N	\N	ecg	4.9453125,-0.144304425275969	fGQobjreD6	FEuHlBgcyE
iUBG1F6uxl	2021-05-18 16:08:12.285+00	2021-05-18 16:08:12.285+00	\N	\N	ecg	4.94921875,-0.163458658403001	fGQobjreD6	FEuHlBgcyE
088IsjJcmt	2021-05-18 16:08:12.486+00	2021-05-18 16:08:12.486+00	\N	\N	ecg	4.953125,-0.0711002446953886	fGQobjreD6	FEuHlBgcyE
fClWLjKQj0	2021-05-18 16:08:12.686+00	2021-05-18 16:08:12.686+00	\N	\N	ecg	4.95703125,-0.140922149572985	fGQobjreD6	FEuHlBgcyE
muRuZFldvR	2021-05-18 16:08:12.886+00	2021-05-18 16:08:12.886+00	\N	\N	ecg	4.9609375,0.0844452792869589	fGQobjreD6	FEuHlBgcyE
BZt7uTiJOq	2021-05-18 16:08:13.089+00	2021-05-18 16:08:13.089+00	\N	\N	ecg	4.96484375,0.106514860005852	fGQobjreD6	FEuHlBgcyE
VvGMUAHpq4	2021-05-18 16:08:13.288+00	2021-05-18 16:08:13.288+00	\N	\N	ecg	4.96875,0.232933385838573	fGQobjreD6	FEuHlBgcyE
wECkSCgZya	2021-05-18 16:08:13.488+00	2021-05-18 16:08:13.488+00	\N	\N	ecg	4.97265625,0.399347566621186	fGQobjreD6	FEuHlBgcyE
LHl4uAKqyA	2021-05-18 16:08:13.689+00	2021-05-18 16:08:13.689+00	\N	\N	ecg	4.9765625,0.648487264644577	fGQobjreD6	FEuHlBgcyE
aRnTkFfDuk	2021-05-18 16:08:13.888+00	2021-05-18 16:08:13.888+00	\N	\N	ecg	4.98046875,0.788939387361108	fGQobjreD6	FEuHlBgcyE
n7drpWsYXL	2021-05-18 16:08:14.092+00	2021-05-18 16:08:14.092+00	\N	\N	ecg	4.984375,1.06321073401698	fGQobjreD6	FEuHlBgcyE
ZkCetd8U9A	2021-05-18 16:08:14.289+00	2021-05-18 16:08:14.289+00	\N	\N	ecg	4.98828125,1.15679534283234	fGQobjreD6	FEuHlBgcyE
DfiWX3KoSo	2021-05-18 16:08:14.49+00	2021-05-18 16:08:14.49+00	\N	\N	ecg	4.9921875,1.08560398945084	fGQobjreD6	FEuHlBgcyE
0RgLl43a2Q	2021-05-18 16:08:14.69+00	2021-05-18 16:08:14.69+00	\N	\N	ecg	4.99609375,1.06583785466464	fGQobjreD6	FEuHlBgcyE
N3NerEJlbh	2021-05-18 16:08:14.891+00	2021-05-18 16:08:14.891+00	\N	\N	ecg	5.0,1.12705852985289	fGQobjreD6	FEuHlBgcyE
xhSTnhGL6E	2021-05-18 16:08:15.092+00	2021-05-18 16:08:15.092+00	\N	\N	ecg	5.00390625,1.06244793594112	fGQobjreD6	FEuHlBgcyE
UfzqWCJIiy	2021-05-18 16:08:15.292+00	2021-05-18 16:08:15.292+00	\N	\N	ecg	5.0078125,0.875759757505777	fGQobjreD6	FEuHlBgcyE
VKBLdWAhd2	2021-05-18 16:08:15.492+00	2021-05-18 16:08:15.492+00	\N	\N	ecg	5.01171875,0.823738951746154	fGQobjreD6	FEuHlBgcyE
HYLRUxhEDZ	2021-05-18 16:08:15.693+00	2021-05-18 16:08:15.693+00	\N	\N	ecg	5.015625,0.604728179158279	fGQobjreD6	FEuHlBgcyE
nTf3ERYFqg	2021-05-18 16:08:15.894+00	2021-05-18 16:08:15.894+00	\N	\N	ecg	5.01953125,0.450252045996394	fGQobjreD6	FEuHlBgcyE
xtvDG0NcCk	2021-05-18 16:08:16.095+00	2021-05-18 16:08:16.095+00	\N	\N	ecg	5.0234375,0.187966012385694	fGQobjreD6	FEuHlBgcyE
prUn3zqtKw	2021-05-18 16:08:16.295+00	2021-05-18 16:08:16.295+00	\N	\N	ecg	5.02734375,-0.0592836927927862	fGQobjreD6	FEuHlBgcyE
cw4U9KNaWy	2021-05-18 16:08:16.496+00	2021-05-18 16:08:16.496+00	\N	\N	ecg	5.03125,-0.233386801821144	fGQobjreD6	FEuHlBgcyE
VRtS62pRwD	2021-05-18 16:08:16.696+00	2021-05-18 16:08:16.696+00	\N	\N	ecg	5.03515625,-0.206492786527422	fGQobjreD6	FEuHlBgcyE
MI8ODH9LUe	2021-05-18 16:08:16.896+00	2021-05-18 16:08:16.896+00	\N	\N	ecg	5.0390625,-0.387907012645616	fGQobjreD6	FEuHlBgcyE
TxNKYoYigS	2021-05-18 16:08:17.097+00	2021-05-18 16:08:17.097+00	\N	\N	ecg	5.04296875,-0.35693074990372	fGQobjreD6	FEuHlBgcyE
FuZoFw6J7O	2021-05-18 16:08:17.297+00	2021-05-18 16:08:17.297+00	\N	\N	ecg	5.046875,-0.290222265475376	fGQobjreD6	FEuHlBgcyE
UhUEgiiVJ1	2021-05-18 16:08:17.498+00	2021-05-18 16:08:17.498+00	\N	\N	ecg	5.05078125,-0.192017903885469	fGQobjreD6	FEuHlBgcyE
xAeDqvKnfH	2021-05-18 16:08:17.698+00	2021-05-18 16:08:17.698+00	\N	\N	ecg	5.0546875,-0.277527170112164	fGQobjreD6	FEuHlBgcyE
LMSL3sXbio	2021-05-18 16:08:17.899+00	2021-05-18 16:08:17.899+00	\N	\N	ecg	5.05859375,-0.250093220451493	fGQobjreD6	FEuHlBgcyE
9DOj7UrrCz	2021-05-18 16:08:18.099+00	2021-05-18 16:08:18.099+00	\N	\N	ecg	5.0625,-0.235729070324845	fGQobjreD6	FEuHlBgcyE
ZU9pn3ztzW	2021-05-18 16:08:18.301+00	2021-05-18 16:08:18.301+00	\N	\N	ecg	5.06640625,-0.059024185306969	fGQobjreD6	FEuHlBgcyE
8zUwPfmpgt	2021-05-18 16:08:18.501+00	2021-05-18 16:08:18.501+00	\N	\N	ecg	5.0703125,-0.0428235239163977	fGQobjreD6	FEuHlBgcyE
in2SCEWqdo	2021-05-18 16:08:18.701+00	2021-05-18 16:08:18.701+00	\N	\N	ecg	5.07421875,0.0194783311918042	fGQobjreD6	FEuHlBgcyE
VeLI97MpFD	2021-05-18 16:08:18.903+00	2021-05-18 16:08:18.903+00	\N	\N	ecg	5.078125,-0.131853851051741	fGQobjreD6	FEuHlBgcyE
mjjKyzS8FR	2021-05-18 16:08:19.107+00	2021-05-18 16:08:19.107+00	\N	\N	ecg	5.08203125,-0.0806966713945835	fGQobjreD6	FEuHlBgcyE
RzrbCiKmWk	2021-05-18 16:08:19.303+00	2021-05-18 16:08:19.303+00	\N	\N	ecg	5.0859375,-0.045575810958973	fGQobjreD6	FEuHlBgcyE
CwH6QvXvOH	2021-05-18 16:08:19.504+00	2021-05-18 16:08:19.504+00	\N	\N	ecg	5.08984375,-0.0498133966754605	fGQobjreD6	FEuHlBgcyE
iPbePbSibG	2021-05-18 16:08:19.704+00	2021-05-18 16:08:19.704+00	\N	\N	ecg	5.09375,0.0286909842798259	fGQobjreD6	FEuHlBgcyE
J7rgnVM3wB	2021-05-18 16:08:19.904+00	2021-05-18 16:08:19.904+00	\N	\N	ecg	5.09765625,-0.101691429951695	fGQobjreD6	FEuHlBgcyE
dro49RBcFy	2021-05-18 16:08:20.105+00	2021-05-18 16:08:20.105+00	\N	\N	ecg	5.1015625,0.0688875623691073	fGQobjreD6	FEuHlBgcyE
WZqMP4M3lc	2021-05-18 16:08:20.306+00	2021-05-18 16:08:20.306+00	\N	\N	ecg	5.10546875,-0.0341086571432948	fGQobjreD6	FEuHlBgcyE
u3BydQttkH	2021-05-18 16:08:20.507+00	2021-05-18 16:08:20.507+00	\N	\N	ecg	5.109375,-0.00354894593836948	fGQobjreD6	FEuHlBgcyE
M2RgHrr6vr	2021-05-18 16:08:20.707+00	2021-05-18 16:08:20.707+00	\N	\N	ecg	5.11328125,0.0292451353128132	fGQobjreD6	FEuHlBgcyE
SUYOzcvNIK	2021-05-18 16:08:20.907+00	2021-05-18 16:08:20.907+00	\N	\N	ecg	5.1171875,-0.00373658554987735	fGQobjreD6	FEuHlBgcyE
FHAbihCHNe	2021-05-18 16:08:21.108+00	2021-05-18 16:08:21.108+00	\N	\N	ecg	5.12109375,-0.0450412238007426	fGQobjreD6	FEuHlBgcyE
w0iG9xhIW0	2021-05-18 16:08:21.307+00	2021-05-18 16:08:21.307+00	\N	\N	ecg	5.125,0.0992968646039004	fGQobjreD6	FEuHlBgcyE
c6DZ12yXv9	2021-05-18 16:08:21.508+00	2021-05-18 16:08:21.508+00	\N	\N	ecg	5.12890625,-0.0210341503077046	fGQobjreD6	FEuHlBgcyE
3hnUtFBwgq	2021-05-18 16:08:21.708+00	2021-05-18 16:08:21.708+00	\N	\N	ecg	5.1328125,0.0671065812014678	fGQobjreD6	FEuHlBgcyE
Ys82ZyP2k0	2021-05-18 16:08:21.909+00	2021-05-18 16:08:21.909+00	\N	\N	ecg	5.13671875,0.11481088862095	fGQobjreD6	FEuHlBgcyE
oEzs0NO3Cm	2021-05-18 16:08:22.109+00	2021-05-18 16:08:22.109+00	\N	\N	ecg	5.140625,0.0343380699276404	fGQobjreD6	FEuHlBgcyE
ukWD1ByV5F	2021-05-18 16:08:22.31+00	2021-05-18 16:08:22.31+00	\N	\N	ecg	5.14453125,0.171373661560386	fGQobjreD6	FEuHlBgcyE
sCfpQiUnUK	2021-05-18 16:08:22.51+00	2021-05-18 16:08:22.51+00	\N	\N	ecg	5.1484375,0.0218884515978358	fGQobjreD6	FEuHlBgcyE
vTO1ANWroI	2021-05-18 16:08:22.711+00	2021-05-18 16:08:22.711+00	\N	\N	ecg	5.15234375,0.135763401042889	fGQobjreD6	FEuHlBgcyE
8k2HV8Hjhd	2021-05-18 16:08:22.912+00	2021-05-18 16:08:22.912+00	\N	\N	ecg	5.15625,0.178347881143365	fGQobjreD6	FEuHlBgcyE
NzlnUsqHyQ	2021-05-18 16:08:23.112+00	2021-05-18 16:08:23.112+00	\N	\N	ecg	5.16015625,0.0700744935663874	fGQobjreD6	FEuHlBgcyE
BdS9mmHiB2	2021-05-18 16:08:23.313+00	2021-05-18 16:08:23.313+00	\N	\N	ecg	5.1640625,0.126583310783601	fGQobjreD6	FEuHlBgcyE
2csoqJ518A	2021-05-18 16:08:23.513+00	2021-05-18 16:08:23.513+00	\N	\N	ecg	5.16796875,0.250651516668627	fGQobjreD6	FEuHlBgcyE
YEAkNGTDgs	2021-05-18 16:08:23.713+00	2021-05-18 16:08:23.713+00	\N	\N	ecg	5.171875,0.11405003651	fGQobjreD6	FEuHlBgcyE
iIxXciSfqW	2021-05-18 16:08:23.914+00	2021-05-18 16:08:23.914+00	\N	\N	ecg	5.17578125,0.239882169940308	fGQobjreD6	FEuHlBgcyE
JfdAtHCikH	2021-05-18 16:08:24.117+00	2021-05-18 16:08:24.117+00	\N	\N	ecg	5.1796875,0.159191582015438	fGQobjreD6	FEuHlBgcyE
g4eDgvscLT	2021-05-18 16:08:24.315+00	2021-05-18 16:08:24.315+00	\N	\N	ecg	5.18359375,0.145765935143261	fGQobjreD6	FEuHlBgcyE
cmFE3bFmeR	2021-05-18 16:08:24.516+00	2021-05-18 16:08:24.516+00	\N	\N	ecg	5.1875,0.204971215889314	fGQobjreD6	FEuHlBgcyE
nrd1f1HOQ5	2021-05-18 16:08:24.715+00	2021-05-18 16:08:24.715+00	\N	\N	ecg	5.19140625,0.247349096907832	fGQobjreD6	FEuHlBgcyE
qqvBS3gsAM	2021-05-18 16:08:24.916+00	2021-05-18 16:08:24.916+00	\N	\N	ecg	5.1953125,0.37358488367951	fGQobjreD6	FEuHlBgcyE
gTAq391PJ1	2021-05-18 16:08:25.116+00	2021-05-18 16:08:25.116+00	\N	\N	ecg	5.19921875,0.237401212308442	fGQobjreD6	FEuHlBgcyE
VUcsByK0PP	2021-05-18 16:08:25.317+00	2021-05-18 16:08:25.317+00	\N	\N	ecg	5.203125,0.399070054102479	fGQobjreD6	FEuHlBgcyE
K1Fo9xuVNe	2021-05-18 16:08:25.517+00	2021-05-18 16:08:25.517+00	\N	\N	ecg	5.20703125,0.345663533588839	fGQobjreD6	FEuHlBgcyE
bP5aD5n2in	2021-05-18 16:08:25.718+00	2021-05-18 16:08:25.718+00	\N	\N	ecg	5.2109375,0.421630562459038	fGQobjreD6	FEuHlBgcyE
EeuZFy1A86	2021-05-18 16:08:25.918+00	2021-05-18 16:08:25.918+00	\N	\N	ecg	5.21484375,0.408571667473728	fGQobjreD6	FEuHlBgcyE
1vcQrfpt99	2021-05-18 16:08:26.119+00	2021-05-18 16:08:26.119+00	\N	\N	ecg	5.21875,0.326508748625089	fGQobjreD6	FEuHlBgcyE
Of5dfIAqBv	2021-05-18 16:08:26.321+00	2021-05-18 16:08:26.321+00	\N	\N	ecg	5.22265625,0.453684747853945	fGQobjreD6	FEuHlBgcyE
h9K28DGCx9	2021-05-18 16:08:26.521+00	2021-05-18 16:08:26.521+00	\N	\N	ecg	5.2265625,0.402663390443594	fGQobjreD6	FEuHlBgcyE
GHhZuuwE7m	2021-05-18 16:08:26.721+00	2021-05-18 16:08:26.721+00	\N	\N	ecg	5.23046875,0.454747407531027	fGQobjreD6	FEuHlBgcyE
TUxlmuaz3m	2021-05-18 16:08:26.921+00	2021-05-18 16:08:26.921+00	\N	\N	ecg	5.234375,0.410165185665853	fGQobjreD6	FEuHlBgcyE
5A6EEjPXIK	2021-05-18 16:08:27.122+00	2021-05-18 16:08:27.122+00	\N	\N	ecg	5.23828125,0.335879947892884	fGQobjreD6	FEuHlBgcyE
1B5GM7UE7D	2021-05-18 16:08:27.322+00	2021-05-18 16:08:27.322+00	\N	\N	ecg	5.2421875,0.338521936402238	fGQobjreD6	FEuHlBgcyE
tjLJMqiDPn	2021-05-18 16:08:27.523+00	2021-05-18 16:08:27.523+00	\N	\N	ecg	5.24609375,0.480067383046126	fGQobjreD6	FEuHlBgcyE
xtr5VwhDLB	2021-05-18 16:08:27.723+00	2021-05-18 16:08:27.723+00	\N	\N	ecg	5.25,0.444931717265355	fGQobjreD6	FEuHlBgcyE
PfXV4bBYRe	2021-05-18 16:08:27.923+00	2021-05-18 16:08:27.923+00	\N	\N	ecg	5.25390625,0.420641810193508	fGQobjreD6	FEuHlBgcyE
AkhxxXCOzb	2021-05-18 16:08:28.124+00	2021-05-18 16:08:28.124+00	\N	\N	ecg	5.2578125,0.316493445668136	fGQobjreD6	FEuHlBgcyE
YqlQWGkDQU	2021-05-18 16:08:28.324+00	2021-05-18 16:08:28.324+00	\N	\N	ecg	5.26171875,0.309922380841522	fGQobjreD6	FEuHlBgcyE
R5zELRbuXF	2021-05-18 16:08:28.526+00	2021-05-18 16:08:28.526+00	\N	\N	ecg	5.265625,0.279488900817205	fGQobjreD6	FEuHlBgcyE
dMzUT9mgkF	2021-05-18 16:08:28.726+00	2021-05-18 16:08:28.726+00	\N	\N	ecg	5.26953125,0.315024095161497	fGQobjreD6	FEuHlBgcyE
4EwnmyBgwh	2021-05-18 16:08:28.927+00	2021-05-18 16:08:28.927+00	\N	\N	ecg	5.2734375,0.320330790998883	fGQobjreD6	FEuHlBgcyE
dHjiUABr8t	2021-05-18 16:08:29.132+00	2021-05-18 16:08:29.132+00	\N	\N	ecg	5.27734375,0.370425008099375	fGQobjreD6	FEuHlBgcyE
ozh3aQyTlB	2021-05-18 16:08:29.327+00	2021-05-18 16:08:29.327+00	\N	\N	ecg	5.28125,0.387059137355977	fGQobjreD6	FEuHlBgcyE
2c2hz2pKQH	2021-05-18 16:08:29.528+00	2021-05-18 16:08:29.528+00	\N	\N	ecg	5.28515625,0.312637095674988	fGQobjreD6	FEuHlBgcyE
toDY1nMESD	2021-05-18 16:08:29.728+00	2021-05-18 16:08:29.728+00	\N	\N	ecg	5.2890625,0.294533411534843	fGQobjreD6	FEuHlBgcyE
2c1PksGDmO	2021-05-18 16:08:29.929+00	2021-05-18 16:08:29.929+00	\N	\N	ecg	5.29296875,0.302799410682013	fGQobjreD6	FEuHlBgcyE
YNS9EeNQZx	2021-05-18 16:08:30.13+00	2021-05-18 16:08:30.13+00	\N	\N	ecg	5.296875,0.179773410836103	fGQobjreD6	FEuHlBgcyE
XZ6wDCCdGz	2021-05-18 16:08:30.33+00	2021-05-18 16:08:30.33+00	\N	\N	ecg	5.30078125,0.276255214340195	fGQobjreD6	FEuHlBgcyE
Nb4bpDcuww	2021-05-18 16:08:30.53+00	2021-05-18 16:08:30.53+00	\N	\N	ecg	5.3046875,0.161100726368793	fGQobjreD6	FEuHlBgcyE
Z9gE8D54NF	2021-05-18 16:08:30.731+00	2021-05-18 16:08:30.731+00	\N	\N	ecg	5.30859375,0.284264424904188	fGQobjreD6	FEuHlBgcyE
ZCKpCjV18A	2021-05-18 16:08:30.931+00	2021-05-18 16:08:30.931+00	\N	\N	ecg	5.3125,0.198367800813536	fGQobjreD6	FEuHlBgcyE
fd0eKxjKXt	2021-05-18 16:08:31.131+00	2021-05-18 16:08:31.131+00	\N	\N	ecg	5.31640625,0.0966300820930321	fGQobjreD6	FEuHlBgcyE
DYRCLa4Vxu	2021-05-18 16:08:31.331+00	2021-05-18 16:08:31.331+00	\N	\N	ecg	5.3203125,0.0836706917542261	fGQobjreD6	FEuHlBgcyE
yRUfxa9sbj	2021-05-18 16:08:31.532+00	2021-05-18 16:08:31.532+00	\N	\N	ecg	5.32421875,0.109200631654795	fGQobjreD6	FEuHlBgcyE
gU4GxwSoCo	2021-05-18 16:08:31.732+00	2021-05-18 16:08:31.732+00	\N	\N	ecg	5.328125,0.094076257896318	fGQobjreD6	FEuHlBgcyE
Yl95kqEyhw	2021-05-18 16:08:31.933+00	2021-05-18 16:08:31.933+00	\N	\N	ecg	5.33203125,0.0340272894121502	fGQobjreD6	FEuHlBgcyE
hYpDy5x74L	2021-05-18 16:08:32.133+00	2021-05-18 16:08:32.133+00	\N	\N	ecg	5.3359375,0.181006962891072	fGQobjreD6	FEuHlBgcyE
y2lEARzrtu	2021-05-18 16:08:32.333+00	2021-05-18 16:08:32.333+00	\N	\N	ecg	5.33984375,0.166189492901873	fGQobjreD6	FEuHlBgcyE
D37X5xLs2n	2021-05-18 16:08:32.534+00	2021-05-18 16:08:32.534+00	\N	\N	ecg	5.34375,-0.0134765328778534	fGQobjreD6	FEuHlBgcyE
l6QEa9EwU5	2021-05-18 16:08:32.734+00	2021-05-18 16:08:32.734+00	\N	\N	ecg	5.34765625,0.154011479402941	fGQobjreD6	FEuHlBgcyE
aJNGSQjbfo	2021-05-18 16:08:32.934+00	2021-05-18 16:08:32.934+00	\N	\N	ecg	5.3515625,0.0554861408141964	fGQobjreD6	FEuHlBgcyE
Np1uMrq27s	2021-05-18 16:08:33.135+00	2021-05-18 16:08:33.135+00	\N	\N	ecg	5.35546875,0.0335430313062925	fGQobjreD6	FEuHlBgcyE
nh3bqeFgIS	2021-05-18 16:08:33.335+00	2021-05-18 16:08:33.335+00	\N	\N	ecg	5.359375,-0.0305423381088788	fGQobjreD6	FEuHlBgcyE
dXYRGUNI1B	2021-05-18 16:08:33.536+00	2021-05-18 16:08:33.536+00	\N	\N	ecg	5.36328125,0.0050385631803817	fGQobjreD6	FEuHlBgcyE
TBUuRoIimg	2021-05-18 16:08:33.737+00	2021-05-18 16:08:33.737+00	\N	\N	ecg	5.3671875,-0.0310119032252117	fGQobjreD6	FEuHlBgcyE
XsWVxgRgNX	2021-05-18 16:08:33.937+00	2021-05-18 16:08:33.937+00	\N	\N	ecg	5.37109375,-0.0085589146683882	fGQobjreD6	FEuHlBgcyE
G0InuBgxmA	2021-05-18 16:08:34.142+00	2021-05-18 16:08:34.142+00	\N	\N	ecg	5.375,-0.0413570845218212	fGQobjreD6	FEuHlBgcyE
1WAmH88Evi	2021-05-18 16:08:34.338+00	2021-05-18 16:08:34.338+00	\N	\N	ecg	5.37890625,0.0882271548048075	fGQobjreD6	FEuHlBgcyE
b4T6n7NHua	2021-05-18 16:08:34.538+00	2021-05-18 16:08:34.538+00	\N	\N	ecg	5.3828125,0.00280616873407654	fGQobjreD6	FEuHlBgcyE
Tcl9dV3jEo	2021-05-18 16:08:34.739+00	2021-05-18 16:08:34.739+00	\N	\N	ecg	5.38671875,-0.0736756310882781	fGQobjreD6	FEuHlBgcyE
mFc5BmQROy	2021-05-18 16:08:34.939+00	2021-05-18 16:08:34.939+00	\N	\N	ecg	5.390625,-0.046991675110333	fGQobjreD6	FEuHlBgcyE
4gDxLoEOKh	2021-05-18 16:08:35.139+00	2021-05-18 16:08:35.139+00	\N	\N	ecg	5.39453125,-0.00947655728589637	fGQobjreD6	FEuHlBgcyE
CzZTe4Gbcu	2021-05-18 16:08:35.34+00	2021-05-18 16:08:35.34+00	\N	\N	ecg	5.3984375,-0.117730609031758	fGQobjreD6	FEuHlBgcyE
WBVCFkBHgx	2021-05-18 16:08:35.54+00	2021-05-18 16:08:35.54+00	\N	\N	ecg	5.40234375,-0.120381648711539	fGQobjreD6	FEuHlBgcyE
RIXkyxOVFX	2021-05-18 16:08:35.74+00	2021-05-18 16:08:35.74+00	\N	\N	ecg	5.40625,0.0452457250836829	fGQobjreD6	FEuHlBgcyE
J7RJxLaa1x	2021-05-18 16:08:35.942+00	2021-05-18 16:08:35.942+00	\N	\N	ecg	5.41015625,-0.13803790404141	fGQobjreD6	FEuHlBgcyE
DE23bZM0Jh	2021-05-18 16:08:36.141+00	2021-05-18 16:08:36.141+00	\N	\N	ecg	5.4140625,0.022700142726962	fGQobjreD6	FEuHlBgcyE
SbJ7VBbl0z	2021-05-18 16:08:36.343+00	2021-05-18 16:08:36.343+00	\N	\N	ecg	5.41796875,-0.121632858316668	fGQobjreD6	FEuHlBgcyE
1Bu2dUypza	2021-05-18 16:08:36.542+00	2021-05-18 16:08:36.542+00	\N	\N	ecg	5.421875,-0.0877866607033838	fGQobjreD6	FEuHlBgcyE
GefS5PoQjH	2021-05-18 16:08:36.743+00	2021-05-18 16:08:36.743+00	\N	\N	ecg	5.42578125,-0.142284280941236	fGQobjreD6	FEuHlBgcyE
5hEtEZC7cu	2021-05-18 16:08:36.943+00	2021-05-18 16:08:36.943+00	\N	\N	ecg	5.4296875,-0.0438381338450631	fGQobjreD6	FEuHlBgcyE
t3okaQSnbc	2021-05-18 16:08:37.143+00	2021-05-18 16:08:37.143+00	\N	\N	ecg	5.43359375,0.021509645885696	fGQobjreD6	FEuHlBgcyE
c3xWVf9xmL	2021-05-18 16:08:37.344+00	2021-05-18 16:08:37.344+00	\N	\N	ecg	5.4375,-0.027263162496985	fGQobjreD6	FEuHlBgcyE
xpPsK9n8Hb	2021-05-18 16:08:37.544+00	2021-05-18 16:08:37.544+00	\N	\N	ecg	5.44140625,-0.0585229040973365	fGQobjreD6	FEuHlBgcyE
MwWQY81lAS	2021-05-18 16:08:37.744+00	2021-05-18 16:08:37.744+00	\N	\N	ecg	5.4453125,0.0528362007139422	fGQobjreD6	FEuHlBgcyE
shHYE04olH	2021-05-18 16:08:37.946+00	2021-05-18 16:08:37.946+00	\N	\N	ecg	5.44921875,-0.0415359512716529	fGQobjreD6	FEuHlBgcyE
lx9Q4Hl33v	2021-05-18 16:08:38.145+00	2021-05-18 16:08:38.145+00	\N	\N	ecg	5.453125,-0.0664070847931159	fGQobjreD6	FEuHlBgcyE
aQstu4lBxg	2021-05-18 16:08:38.347+00	2021-05-18 16:08:38.347+00	\N	\N	ecg	5.45703125,-0.085265913616269	fGQobjreD6	FEuHlBgcyE
PRdtcf8vEW	2021-05-18 16:08:38.546+00	2021-05-18 16:08:38.546+00	\N	\N	ecg	5.4609375,0.0170288687324424	fGQobjreD6	FEuHlBgcyE
fKgoG4DLKA	2021-05-18 16:08:38.747+00	2021-05-18 16:08:38.747+00	\N	\N	ecg	5.46484375,-0.0994135063240511	fGQobjreD6	FEuHlBgcyE
JScz43oVJ3	2021-05-18 16:08:38.947+00	2021-05-18 16:08:38.947+00	\N	\N	ecg	5.46875,-0.0914474894169695	fGQobjreD6	FEuHlBgcyE
gEWsiY74Yv	2021-05-18 16:08:39.152+00	2021-05-18 16:08:39.152+00	\N	\N	ecg	5.47265625,0.0573887084220024	fGQobjreD6	FEuHlBgcyE
wpPSHgVCnu	2021-05-18 16:08:39.348+00	2021-05-18 16:08:39.348+00	\N	\N	ecg	5.4765625,-0.139721554462703	fGQobjreD6	FEuHlBgcyE
IcVSlBO59Y	2021-05-18 16:08:39.549+00	2021-05-18 16:08:39.549+00	\N	\N	ecg	5.48046875,-0.103318531963274	fGQobjreD6	FEuHlBgcyE
0YjRx9tXfm	2021-05-18 16:08:39.75+00	2021-05-18 16:08:39.75+00	\N	\N	ecg	5.484375,0.059615075962462	fGQobjreD6	FEuHlBgcyE
qbwKpkPolH	2021-05-18 16:08:39.951+00	2021-05-18 16:08:39.951+00	\N	\N	ecg	5.48828125,-0.0937670038975264	fGQobjreD6	FEuHlBgcyE
QgHH4Hc4ip	2021-05-18 16:08:40.151+00	2021-05-18 16:08:40.151+00	\N	\N	ecg	5.4921875,0.0444557533055442	fGQobjreD6	FEuHlBgcyE
edgrPkcBaE	2021-05-18 16:08:40.351+00	2021-05-18 16:08:40.351+00	\N	\N	ecg	5.49609375,-0.0555677239651816	fGQobjreD6	FEuHlBgcyE
VlRQ3LaEpe	2021-05-18 16:08:40.553+00	2021-05-18 16:08:40.553+00	\N	\N	ecg	5.5,-0.0158356480141744	fGQobjreD6	FEuHlBgcyE
HNrUOsiZXU	2021-05-18 16:08:40.752+00	2021-05-18 16:08:40.752+00	\N	\N	ecg	5.50390625,0.0452806581720361	fGQobjreD6	FEuHlBgcyE
HhV5TBl3sO	2021-05-18 16:08:40.953+00	2021-05-18 16:08:40.953+00	\N	\N	ecg	5.5078125,-0.0971565334284623	fGQobjreD6	FEuHlBgcyE
WI3erGyF1f	2021-05-18 16:08:41.153+00	2021-05-18 16:08:41.153+00	\N	\N	ecg	5.51171875,-0.0951167169061745	fGQobjreD6	FEuHlBgcyE
iZCVUXqYw7	2021-05-18 16:08:41.354+00	2021-05-18 16:08:41.354+00	\N	\N	ecg	5.515625,-0.124630870192969	fGQobjreD6	FEuHlBgcyE
MRTJIDSezs	2021-05-18 16:08:41.554+00	2021-05-18 16:08:41.554+00	\N	\N	ecg	5.51953125,0.0558887387699032	fGQobjreD6	FEuHlBgcyE
gLXUPMVDfE	2021-05-18 16:08:41.765+00	2021-05-18 16:08:41.765+00	\N	\N	ecg	5.5234375,-0.115493469465828	fGQobjreD6	FEuHlBgcyE
dq1KDUSfrE	2021-05-18 16:08:41.962+00	2021-05-18 16:08:41.962+00	\N	\N	ecg	5.52734375,-0.0677631915313475	fGQobjreD6	FEuHlBgcyE
zn943AmvSB	2021-05-18 16:08:42.162+00	2021-05-18 16:08:42.162+00	\N	\N	ecg	5.53125,-0.0858273237588429	fGQobjreD6	FEuHlBgcyE
fo1XII9r7c	2021-05-18 16:08:42.362+00	2021-05-18 16:08:42.362+00	\N	\N	ecg	5.53515625,-0.0131629912193893	fGQobjreD6	FEuHlBgcyE
osPijbpFBh	2021-05-18 16:08:42.563+00	2021-05-18 16:08:42.563+00	\N	\N	ecg	5.5390625,-0.0441037763206974	fGQobjreD6	FEuHlBgcyE
LL3zRtUhtq	2021-05-18 16:08:42.764+00	2021-05-18 16:08:42.764+00	\N	\N	ecg	5.54296875,-0.0898557529407844	fGQobjreD6	FEuHlBgcyE
fngjm2qxlO	2021-05-18 16:08:42.965+00	2021-05-18 16:08:42.965+00	\N	\N	ecg	5.546875,-0.0363553080942667	fGQobjreD6	FEuHlBgcyE
ksIBDxRXRb	2021-05-18 16:08:43.165+00	2021-05-18 16:08:43.165+00	\N	\N	ecg	5.55078125,-0.0771366935216973	fGQobjreD6	FEuHlBgcyE
oGnnCZjr0g	2021-05-18 16:08:43.365+00	2021-05-18 16:08:43.365+00	\N	\N	ecg	5.5546875,0.0559029316290867	fGQobjreD6	FEuHlBgcyE
idZeI28WUe	2021-05-18 16:08:43.568+00	2021-05-18 16:08:43.568+00	\N	\N	ecg	5.55859375,0.0231597739768244	fGQobjreD6	FEuHlBgcyE
OYBg7ISNVG	2021-05-18 16:08:43.767+00	2021-05-18 16:08:43.767+00	\N	\N	ecg	5.5625,-0.0807222722533805	fGQobjreD6	FEuHlBgcyE
u3ArbzDhHn	2021-05-18 16:08:43.967+00	2021-05-18 16:08:43.967+00	\N	\N	ecg	5.56640625,-0.0101844006197011	fGQobjreD6	FEuHlBgcyE
ffYWC6LZHx	2021-05-18 16:08:44.172+00	2021-05-18 16:08:44.172+00	\N	\N	ecg	5.5703125,0.0237084093192928	fGQobjreD6	FEuHlBgcyE
nsgSeHO29N	2021-05-18 16:08:44.369+00	2021-05-18 16:08:44.369+00	\N	\N	ecg	5.57421875,-0.0907511717619149	fGQobjreD6	FEuHlBgcyE
H0LeXyCeR9	2021-05-18 16:08:44.569+00	2021-05-18 16:08:44.569+00	\N	\N	ecg	5.578125,-0.0911970637256693	fGQobjreD6	FEuHlBgcyE
AEDtKnLu3H	2021-05-18 16:08:44.769+00	2021-05-18 16:08:44.769+00	\N	\N	ecg	5.58203125,-0.0589254128710708	fGQobjreD6	FEuHlBgcyE
2jwpeDc2Pn	2021-05-18 16:08:44.97+00	2021-05-18 16:08:44.97+00	\N	\N	ecg	5.5859375,-0.0665505101506306	fGQobjreD6	FEuHlBgcyE
H7Hml1SgSO	2021-05-18 16:08:45.17+00	2021-05-18 16:08:45.17+00	\N	\N	ecg	5.58984375,-0.00681759073876825	fGQobjreD6	FEuHlBgcyE
OK88YeQCDK	2021-05-18 16:08:45.372+00	2021-05-18 16:08:45.372+00	\N	\N	ecg	5.59375,-0.0997773010278427	fGQobjreD6	FEuHlBgcyE
GXKp4AEj4W	2021-05-18 16:08:45.572+00	2021-05-18 16:08:45.572+00	\N	\N	ecg	5.59765625,0.0829647143113702	fGQobjreD6	FEuHlBgcyE
gDcjEloiZs	2021-05-18 16:08:45.772+00	2021-05-18 16:08:45.772+00	\N	\N	ecg	5.6015625,0.0603826463996578	fGQobjreD6	FEuHlBgcyE
DyGQGEHxob	2021-05-18 16:08:45.973+00	2021-05-18 16:08:45.973+00	\N	\N	ecg	5.60546875,-0.0453164990299239	fGQobjreD6	FEuHlBgcyE
SBquXrmuK0	2021-05-18 16:08:46.173+00	2021-05-18 16:08:46.173+00	\N	\N	ecg	5.609375,0.044699166943504	fGQobjreD6	FEuHlBgcyE
rS7ABVJXNv	2021-05-18 16:08:46.373+00	2021-05-18 16:08:46.373+00	\N	\N	ecg	5.61328125,-0.0630556407049914	fGQobjreD6	FEuHlBgcyE
URN3GRFyY3	2021-05-18 16:08:46.574+00	2021-05-18 16:08:46.574+00	\N	\N	ecg	5.6171875,-0.0621335284475862	fGQobjreD6	FEuHlBgcyE
LBtXgZJCoo	2021-05-18 16:08:46.775+00	2021-05-18 16:08:46.775+00	\N	\N	ecg	5.62109375,-0.0488954905998347	fGQobjreD6	FEuHlBgcyE
nQMF9Q28J2	2021-05-18 16:08:46.975+00	2021-05-18 16:08:46.975+00	\N	\N	ecg	5.625,0.0751324462188925	fGQobjreD6	FEuHlBgcyE
tt98CSsO19	2021-05-18 16:08:47.176+00	2021-05-18 16:08:47.176+00	\N	\N	ecg	5.62890625,-0.00188934887938398	fGQobjreD6	FEuHlBgcyE
OK5ta8uK3n	2021-05-18 16:08:47.377+00	2021-05-18 16:08:47.377+00	\N	\N	ecg	5.6328125,-0.0265907425432962	fGQobjreD6	FEuHlBgcyE
ieiIYzkMmX	2021-05-18 16:08:47.578+00	2021-05-18 16:08:47.578+00	\N	\N	ecg	5.63671875,0.0638525097770323	fGQobjreD6	FEuHlBgcyE
m6GIzXa2y5	2021-05-18 16:08:47.778+00	2021-05-18 16:08:47.778+00	\N	\N	ecg	5.640625,-0.0298996422801941	fGQobjreD6	FEuHlBgcyE
6BOGG5FBNh	2021-05-18 16:08:47.978+00	2021-05-18 16:08:47.978+00	\N	\N	ecg	5.64453125,0.0392370740443337	fGQobjreD6	FEuHlBgcyE
h8EbT8wHBu	2021-05-18 16:08:48.18+00	2021-05-18 16:08:48.18+00	\N	\N	ecg	5.6484375,-0.0371911865037357	fGQobjreD6	FEuHlBgcyE
IbkzVe9eQY	2021-05-18 16:08:48.38+00	2021-05-18 16:08:48.38+00	\N	\N	ecg	5.65234375,0.0275619973003453	fGQobjreD6	FEuHlBgcyE
6khRyvRFwG	2021-05-18 16:08:48.58+00	2021-05-18 16:08:48.58+00	\N	\N	ecg	5.65625,-0.0536530681139482	fGQobjreD6	FEuHlBgcyE
RTb02ptG6E	2021-05-18 16:08:48.781+00	2021-05-18 16:08:48.781+00	\N	\N	ecg	5.66015625,-0.0192728154324219	fGQobjreD6	FEuHlBgcyE
dFkLkSK5av	2021-05-18 16:08:48.982+00	2021-05-18 16:08:48.982+00	\N	\N	ecg	5.6640625,-0.0208584609344444	fGQobjreD6	FEuHlBgcyE
dNqxXcjrQ0	2021-05-18 16:08:49.186+00	2021-05-18 16:08:49.186+00	\N	\N	ecg	5.66796875,-0.0505181087801421	fGQobjreD6	FEuHlBgcyE
yxwU32WPNm	2021-05-18 16:08:49.384+00	2021-05-18 16:08:49.384+00	\N	\N	ecg	5.671875,-0.0198608211300341	fGQobjreD6	FEuHlBgcyE
nW5L69Igmi	2021-05-18 16:08:49.583+00	2021-05-18 16:08:49.583+00	\N	\N	ecg	5.67578125,-0.00536604985980523	fGQobjreD6	FEuHlBgcyE
vzwbxfUpRs	2021-05-18 16:08:49.785+00	2021-05-18 16:08:49.785+00	\N	\N	ecg	5.6796875,-0.00678395331308003	fGQobjreD6	FEuHlBgcyE
TbFLax66EB	2021-05-18 16:08:49.985+00	2021-05-18 16:08:49.985+00	\N	\N	ecg	5.68359375,-0.0153865043130764	fGQobjreD6	FEuHlBgcyE
vWW0Wvjjoc	2021-05-18 16:08:50.185+00	2021-05-18 16:08:50.185+00	\N	\N	ecg	5.6875,0.0826131786726928	fGQobjreD6	FEuHlBgcyE
9lpnEu2gUc	2021-05-18 16:08:50.387+00	2021-05-18 16:08:50.387+00	\N	\N	ecg	5.69140625,-0.0657794922748262	fGQobjreD6	FEuHlBgcyE
HLphn8BdYM	2021-05-18 16:08:50.587+00	2021-05-18 16:08:50.587+00	\N	\N	ecg	5.6953125,0.0144229548256896	fGQobjreD6	FEuHlBgcyE
R0AkzzuCpK	2021-05-18 16:08:50.788+00	2021-05-18 16:08:50.788+00	\N	\N	ecg	5.69921875,0.0964051724313587	fGQobjreD6	FEuHlBgcyE
mLF8qTn8f4	2021-05-18 16:08:50.988+00	2021-05-18 16:08:50.988+00	\N	\N	ecg	5.703125,-0.0259311850083524	fGQobjreD6	FEuHlBgcyE
1dqYS4iUGZ	2021-05-18 16:08:51.188+00	2021-05-18 16:08:51.188+00	\N	\N	ecg	5.70703125,-0.0861710658390892	fGQobjreD6	FEuHlBgcyE
3xDp13EKiq	2021-05-18 16:08:51.389+00	2021-05-18 16:08:51.389+00	\N	\N	ecg	5.7109375,0.10873990519859	fGQobjreD6	FEuHlBgcyE
gHpXGIp30T	2021-05-18 16:08:51.59+00	2021-05-18 16:08:51.59+00	\N	\N	ecg	5.71484375,-0.0354368880739339	fGQobjreD6	FEuHlBgcyE
8baOIiX5ww	2021-05-18 16:08:51.789+00	2021-05-18 16:08:51.789+00	\N	\N	ecg	5.71875,0.0111402285344782	fGQobjreD6	FEuHlBgcyE
R1bxvGNhc1	2021-05-18 16:08:51.992+00	2021-05-18 16:08:51.992+00	\N	\N	ecg	5.72265625,-0.0454891613525848	fGQobjreD6	FEuHlBgcyE
APoS7vuHaE	2021-05-18 16:08:52.191+00	2021-05-18 16:08:52.191+00	\N	\N	ecg	5.7265625,-0.00912257595545842	fGQobjreD6	FEuHlBgcyE
1BDz0HuPWv	2021-05-18 16:08:52.392+00	2021-05-18 16:08:52.392+00	\N	\N	ecg	5.73046875,-0.0680615864745478	fGQobjreD6	FEuHlBgcyE
nF8mAQNR3B	2021-05-18 16:08:52.592+00	2021-05-18 16:08:52.592+00	\N	\N	ecg	5.734375,0.127996753394931	fGQobjreD6	FEuHlBgcyE
FxQhwojhvC	2021-05-18 16:08:52.795+00	2021-05-18 16:08:52.795+00	\N	\N	ecg	5.73828125,0.0997070419554419	fGQobjreD6	FEuHlBgcyE
uBSoon34VL	2021-05-18 16:08:52.993+00	2021-05-18 16:08:52.993+00	\N	\N	ecg	5.7421875,0.123127027347168	fGQobjreD6	FEuHlBgcyE
NizVjP6TEm	2021-05-18 16:08:53.193+00	2021-05-18 16:08:53.193+00	\N	\N	ecg	5.74609375,0.136732783765027	fGQobjreD6	FEuHlBgcyE
gRzhl4CkvH	2021-05-18 16:08:53.394+00	2021-05-18 16:08:53.394+00	\N	\N	ecg	5.75,0.0407842622533523	fGQobjreD6	FEuHlBgcyE
ZLGRKd0IFY	2021-05-18 16:08:53.595+00	2021-05-18 16:08:53.595+00	\N	\N	ecg	5.75390625,0.0864737790014718	fGQobjreD6	FEuHlBgcyE
eHzKEM871Z	2021-05-18 16:08:53.795+00	2021-05-18 16:08:53.795+00	\N	\N	ecg	5.7578125,0.096544835028964	fGQobjreD6	FEuHlBgcyE
Zml3BBsbmH	2021-05-18 16:08:53.996+00	2021-05-18 16:08:53.996+00	\N	\N	ecg	5.76171875,0.119136770566511	fGQobjreD6	FEuHlBgcyE
WdIlx9ktAG	2021-05-18 16:08:54.199+00	2021-05-18 16:08:54.199+00	\N	\N	ecg	5.765625,0.101442564498996	fGQobjreD6	FEuHlBgcyE
aqFgfjcwES	2021-05-18 16:08:54.397+00	2021-05-18 16:08:54.397+00	\N	\N	ecg	5.76953125,0.167309437052069	fGQobjreD6	FEuHlBgcyE
NUYsc0bf3R	2021-05-18 16:08:54.597+00	2021-05-18 16:08:54.597+00	\N	\N	ecg	5.7734375,0.0377353079026451	fGQobjreD6	FEuHlBgcyE
yya0yr7DhN	2021-05-18 16:08:54.798+00	2021-05-18 16:08:54.798+00	\N	\N	ecg	5.77734375,0.124293133501512	fGQobjreD6	FEuHlBgcyE
KVaq0ZWYJh	2021-05-18 16:08:54.998+00	2021-05-18 16:08:54.998+00	\N	\N	ecg	5.78125,0.134544307493096	fGQobjreD6	FEuHlBgcyE
cXiw2FU8aj	2021-05-18 16:08:55.198+00	2021-05-18 16:08:55.198+00	\N	\N	ecg	5.78515625,0.178707155894595	fGQobjreD6	FEuHlBgcyE
ulrKw684G9	2021-05-18 16:08:55.399+00	2021-05-18 16:08:55.399+00	\N	\N	ecg	5.7890625,0.142802478724873	fGQobjreD6	FEuHlBgcyE
av3IBfVEcw	2021-05-18 16:08:55.6+00	2021-05-18 16:08:55.6+00	\N	\N	ecg	5.79296875,0.156542060673886	fGQobjreD6	FEuHlBgcyE
a2OMWCBylp	2021-05-18 16:08:55.799+00	2021-05-18 16:08:55.799+00	\N	\N	ecg	5.796875,0.295925466495326	fGQobjreD6	FEuHlBgcyE
p6zqfHpDTy	2021-05-18 16:08:56+00	2021-05-18 16:08:56+00	\N	\N	ecg	5.80078125,0.203004111730433	fGQobjreD6	FEuHlBgcyE
LKDMbIaiRF	2021-05-18 16:08:56.201+00	2021-05-18 16:08:56.201+00	\N	\N	ecg	5.8046875,0.285204581463664	fGQobjreD6	FEuHlBgcyE
A5oLKLt6Bw	2021-05-18 16:08:56.402+00	2021-05-18 16:08:56.402+00	\N	\N	ecg	5.80859375,0.277974916147161	fGQobjreD6	FEuHlBgcyE
IFhZncxNlV	2021-05-18 16:08:56.602+00	2021-05-18 16:08:56.602+00	\N	\N	ecg	5.8125,0.334666544429197	fGQobjreD6	FEuHlBgcyE
ZmbBUUxUcj	2021-05-18 16:08:56.803+00	2021-05-18 16:08:56.803+00	\N	\N	ecg	5.81640625,0.33902974647277	fGQobjreD6	FEuHlBgcyE
rPCh7jr1pJ	2021-05-18 16:08:57.009+00	2021-05-18 16:08:57.009+00	\N	\N	ecg	5.8203125,0.204161476587801	fGQobjreD6	FEuHlBgcyE
U8MUzCPl6B	2021-05-18 16:08:57.207+00	2021-05-18 16:08:57.207+00	\N	\N	ecg	5.82421875,0.319574367497006	fGQobjreD6	FEuHlBgcyE
M1rmbFyBXb	2021-05-18 16:08:57.406+00	2021-05-18 16:08:57.406+00	\N	\N	ecg	5.828125,0.389379361899809	fGQobjreD6	FEuHlBgcyE
x6iGBGK8Z4	2021-05-18 16:08:57.607+00	2021-05-18 16:08:57.607+00	\N	\N	ecg	5.83203125,0.386061647726	fGQobjreD6	FEuHlBgcyE
2rgbrHDNQy	2021-05-18 16:08:57.807+00	2021-05-18 16:08:57.807+00	\N	\N	ecg	5.8359375,0.261831010039264	fGQobjreD6	FEuHlBgcyE
CAziMlP4MN	2021-05-18 16:08:58.01+00	2021-05-18 16:08:58.01+00	\N	\N	ecg	5.83984375,0.333939310083479	fGQobjreD6	FEuHlBgcyE
pRQsTTo62t	2021-05-18 16:03:58.177+00	2021-05-18 16:03:58.177+00	\N	\N	ecg	0.0,1.12705852985289	fGQobjreD6	FEuHlBgcyE
XC7faFc9bd	2021-05-18 16:03:58.344+00	2021-05-18 16:03:58.344+00	\N	\N	ecg	0.00390625,1.06244793594112	fGQobjreD6	FEuHlBgcyE
ZpY7x4eP6B	2021-05-18 16:03:58.548+00	2021-05-18 16:03:58.548+00	\N	\N	ecg	0.0078125,0.875759757505777	fGQobjreD6	FEuHlBgcyE
0q3rdJpOTT	2021-05-18 16:03:58.748+00	2021-05-18 16:03:58.748+00	\N	\N	ecg	0.01171875,0.823738951746154	fGQobjreD6	FEuHlBgcyE
CFSkavF5eL	2021-05-18 16:03:58.949+00	2021-05-18 16:03:58.949+00	\N	\N	ecg	0.015625,0.604728179158279	fGQobjreD6	FEuHlBgcyE
fEGMFe7gXw	2021-05-18 16:03:59.149+00	2021-05-18 16:03:59.149+00	\N	\N	ecg	0.01953125,0.450252045996394	fGQobjreD6	FEuHlBgcyE
vGXugXo4u6	2021-05-18 16:03:59.349+00	2021-05-18 16:03:59.349+00	\N	\N	ecg	0.0234375,0.187966012385694	fGQobjreD6	FEuHlBgcyE
2wimHROFeP	2021-05-18 16:03:59.551+00	2021-05-18 16:03:59.551+00	\N	\N	ecg	0.02734375,-0.0592836927927862	fGQobjreD6	FEuHlBgcyE
EukasxxFlT	2021-05-18 16:03:59.751+00	2021-05-18 16:03:59.751+00	\N	\N	ecg	0.03125,-0.233386801821144	fGQobjreD6	FEuHlBgcyE
nviz2fQAP1	2021-05-18 16:03:59.951+00	2021-05-18 16:03:59.951+00	\N	\N	ecg	0.03515625,-0.206492786527422	fGQobjreD6	FEuHlBgcyE
uQGY6O5GFe	2021-05-18 16:04:00.152+00	2021-05-18 16:04:00.152+00	\N	\N	ecg	0.0390625,-0.387907012645616	fGQobjreD6	FEuHlBgcyE
Vt0cA5j3jZ	2021-05-18 16:04:00.354+00	2021-05-18 16:04:00.354+00	\N	\N	ecg	0.04296875,-0.35693074990372	fGQobjreD6	FEuHlBgcyE
BIbJoSF0wg	2021-05-18 16:04:00.553+00	2021-05-18 16:04:00.553+00	\N	\N	ecg	0.046875,-0.290222265475376	fGQobjreD6	FEuHlBgcyE
148sSj3CNm	2021-05-18 16:04:00.754+00	2021-05-18 16:04:00.754+00	\N	\N	ecg	0.05078125,-0.192017903885469	fGQobjreD6	FEuHlBgcyE
yDctUmiWyT	2021-05-18 16:04:00.956+00	2021-05-18 16:04:00.956+00	\N	\N	ecg	0.0546875,-0.277527170112164	fGQobjreD6	FEuHlBgcyE
MFBBEVMx1L	2021-05-18 16:04:01.156+00	2021-05-18 16:04:01.156+00	\N	\N	ecg	0.05859375,-0.250093220451493	fGQobjreD6	FEuHlBgcyE
zfcz3jAUyC	2021-05-18 16:04:01.357+00	2021-05-18 16:04:01.357+00	\N	\N	ecg	0.0625,-0.235729070324845	fGQobjreD6	FEuHlBgcyE
oYLX8tANvK	2021-05-18 16:04:01.557+00	2021-05-18 16:04:01.557+00	\N	\N	ecg	0.06640625,-0.059024185306969	fGQobjreD6	FEuHlBgcyE
vv1auS3iry	2021-05-18 16:04:01.759+00	2021-05-18 16:04:01.759+00	\N	\N	ecg	0.0703125,-0.0428235239163977	fGQobjreD6	FEuHlBgcyE
CH7Olla1zw	2021-05-18 16:04:01.958+00	2021-05-18 16:04:01.958+00	\N	\N	ecg	0.07421875,0.0194783311918042	fGQobjreD6	FEuHlBgcyE
5kZ1A2K1LW	2021-05-18 16:04:02.16+00	2021-05-18 16:04:02.16+00	\N	\N	ecg	0.078125,-0.131853851051741	fGQobjreD6	FEuHlBgcyE
jj9Q8BC313	2021-05-18 16:04:02.362+00	2021-05-18 16:04:02.362+00	\N	\N	ecg	0.08203125,-0.0806966713945835	fGQobjreD6	FEuHlBgcyE
x6oRGFMTDq	2021-05-18 16:04:02.562+00	2021-05-18 16:04:02.562+00	\N	\N	ecg	0.0859375,-0.045575810958973	fGQobjreD6	FEuHlBgcyE
H8PNFXR6qx	2021-05-18 16:04:02.768+00	2021-05-18 16:04:02.768+00	\N	\N	ecg	0.08984375,-0.0498133966754605	fGQobjreD6	FEuHlBgcyE
LKFIED8nk8	2021-05-18 16:04:02.964+00	2021-05-18 16:04:02.964+00	\N	\N	ecg	0.09375,0.0286909842798259	fGQobjreD6	FEuHlBgcyE
3TyQUdwzKO	2021-05-18 16:04:03.166+00	2021-05-18 16:04:03.166+00	\N	\N	ecg	0.09765625,-0.101691429951695	fGQobjreD6	FEuHlBgcyE
I0YZpBKA0r	2021-05-18 16:04:03.372+00	2021-05-18 16:04:03.372+00	\N	\N	ecg	0.1015625,0.0688875623691073	fGQobjreD6	FEuHlBgcyE
lt4CZTunji	2021-05-18 16:04:03.567+00	2021-05-18 16:04:03.567+00	\N	\N	ecg	0.10546875,-0.0341086571432948	fGQobjreD6	FEuHlBgcyE
dxADLt6ppA	2021-05-18 16:04:03.768+00	2021-05-18 16:04:03.768+00	\N	\N	ecg	0.109375,-0.00354894593836948	fGQobjreD6	FEuHlBgcyE
sFAoSUoOKV	2021-05-18 16:04:03.968+00	2021-05-18 16:04:03.968+00	\N	\N	ecg	0.11328125,0.0292451353128132	fGQobjreD6	FEuHlBgcyE
1ZmNCvhard	2021-05-18 16:04:04.169+00	2021-05-18 16:04:04.169+00	\N	\N	ecg	0.1171875,-0.00373658554987735	fGQobjreD6	FEuHlBgcyE
p1A1FvQLMR	2021-05-18 16:04:04.374+00	2021-05-18 16:04:04.374+00	\N	\N	ecg	0.12109375,-0.0450412238007426	fGQobjreD6	FEuHlBgcyE
uvIojEZhlU	2021-05-18 16:04:04.572+00	2021-05-18 16:04:04.572+00	\N	\N	ecg	0.125,0.0992968646039004	fGQobjreD6	FEuHlBgcyE
7wpVLxRWVw	2021-05-18 16:04:04.773+00	2021-05-18 16:04:04.773+00	\N	\N	ecg	0.12890625,-0.0210341503077046	fGQobjreD6	FEuHlBgcyE
Ofyq6hgaTS	2021-05-18 16:04:04.973+00	2021-05-18 16:04:04.973+00	\N	\N	ecg	0.1328125,0.0671065812014678	fGQobjreD6	FEuHlBgcyE
Be6PJCDG6C	2021-05-18 16:04:05.2+00	2021-05-18 16:04:05.2+00	\N	\N	ecg	0.13671875,0.11481088862095	fGQobjreD6	FEuHlBgcyE
El1sX8IBEf	2021-05-18 16:04:05.384+00	2021-05-18 16:04:05.384+00	\N	\N	ecg	0.140625,0.0343380699276404	fGQobjreD6	FEuHlBgcyE
rE8X17bqTM	2021-05-18 16:04:05.583+00	2021-05-18 16:04:05.583+00	\N	\N	ecg	0.14453125,0.171373661560386	fGQobjreD6	FEuHlBgcyE
owwTEYq1Pk	2021-05-18 16:04:05.783+00	2021-05-18 16:04:05.783+00	\N	\N	ecg	0.1484375,0.0218884515978358	fGQobjreD6	FEuHlBgcyE
8CZm4MYQt9	2021-05-18 16:04:05.983+00	2021-05-18 16:04:05.983+00	\N	\N	ecg	0.15234375,0.135763401042889	fGQobjreD6	FEuHlBgcyE
82HMknI02f	2021-05-18 16:04:06.184+00	2021-05-18 16:04:06.184+00	\N	\N	ecg	0.15625,0.178347881143365	fGQobjreD6	FEuHlBgcyE
AUlY4m5tvc	2021-05-18 16:04:06.385+00	2021-05-18 16:04:06.385+00	\N	\N	ecg	0.16015625,0.0700744935663874	fGQobjreD6	FEuHlBgcyE
A5EM85kc9o	2021-05-18 16:04:06.585+00	2021-05-18 16:04:06.585+00	\N	\N	ecg	0.1640625,0.126583310783601	fGQobjreD6	FEuHlBgcyE
RxQGmei9x2	2021-05-18 16:04:06.786+00	2021-05-18 16:04:06.786+00	\N	\N	ecg	0.16796875,0.250651516668627	fGQobjreD6	FEuHlBgcyE
TSQKymL9XV	2021-05-18 16:04:06.986+00	2021-05-18 16:04:06.986+00	\N	\N	ecg	0.171875,0.11405003651	fGQobjreD6	FEuHlBgcyE
0lO9wmrmXR	2021-05-18 16:04:07.188+00	2021-05-18 16:04:07.188+00	\N	\N	ecg	0.17578125,0.239882169940308	fGQobjreD6	FEuHlBgcyE
jXHZ7Jffw5	2021-05-18 16:04:07.388+00	2021-05-18 16:04:07.388+00	\N	\N	ecg	0.1796875,0.159191582015438	fGQobjreD6	FEuHlBgcyE
2qo21abdsO	2021-05-18 16:04:07.589+00	2021-05-18 16:04:07.589+00	\N	\N	ecg	0.18359375,0.145765935143261	fGQobjreD6	FEuHlBgcyE
GbXZhfJ7Aw	2021-05-18 16:04:07.791+00	2021-05-18 16:04:07.791+00	\N	\N	ecg	0.1875,0.204971215889314	fGQobjreD6	FEuHlBgcyE
0oRFU0K7MA	2021-05-18 16:04:07.99+00	2021-05-18 16:04:07.99+00	\N	\N	ecg	0.19140625,0.247349096907832	fGQobjreD6	FEuHlBgcyE
qc4bv4rU53	2021-05-18 16:04:08.19+00	2021-05-18 16:04:08.19+00	\N	\N	ecg	0.1953125,0.37358488367951	fGQobjreD6	FEuHlBgcyE
T88eOcp7px	2021-05-18 16:04:08.396+00	2021-05-18 16:04:08.396+00	\N	\N	ecg	0.19921875,0.237401212308442	fGQobjreD6	FEuHlBgcyE
k2y9MnHiAE	2021-05-18 16:04:08.593+00	2021-05-18 16:04:08.593+00	\N	\N	ecg	0.203125,0.399070054102479	fGQobjreD6	FEuHlBgcyE
FHnMFZHVai	2021-05-18 16:04:08.793+00	2021-05-18 16:04:08.793+00	\N	\N	ecg	0.20703125,0.345663533588839	fGQobjreD6	FEuHlBgcyE
ivezAqUjS5	2021-05-18 16:04:08.993+00	2021-05-18 16:04:08.993+00	\N	\N	ecg	0.2109375,0.421630562459038	fGQobjreD6	FEuHlBgcyE
NBwUTIu7y3	2021-05-18 16:04:09.194+00	2021-05-18 16:04:09.194+00	\N	\N	ecg	0.21484375,0.408571667473728	fGQobjreD6	FEuHlBgcyE
9WJxbnCUVq	2021-05-18 16:04:09.399+00	2021-05-18 16:04:09.399+00	\N	\N	ecg	0.21875,0.326508748625089	fGQobjreD6	FEuHlBgcyE
sVUJV2vgs2	2021-05-18 16:04:09.594+00	2021-05-18 16:04:09.594+00	\N	\N	ecg	0.22265625,0.453684747853945	fGQobjreD6	FEuHlBgcyE
vtauC74RUK	2021-05-18 16:04:09.796+00	2021-05-18 16:04:09.796+00	\N	\N	ecg	0.2265625,0.402663390443594	fGQobjreD6	FEuHlBgcyE
eC3jFXMAqJ	2021-05-18 16:04:09.996+00	2021-05-18 16:04:09.996+00	\N	\N	ecg	0.23046875,0.454747407531027	fGQobjreD6	FEuHlBgcyE
0OBCRVHkhy	2021-05-18 16:04:10.197+00	2021-05-18 16:04:10.197+00	\N	\N	ecg	0.234375,0.410165185665853	fGQobjreD6	FEuHlBgcyE
YbOHEPsV3S	2021-05-18 16:04:10.398+00	2021-05-18 16:04:10.398+00	\N	\N	ecg	0.23828125,0.335879947892884	fGQobjreD6	FEuHlBgcyE
zsAtpKO9x2	2021-05-18 16:04:10.6+00	2021-05-18 16:04:10.6+00	\N	\N	ecg	0.2421875,0.338521936402238	fGQobjreD6	FEuHlBgcyE
pqlcMCtIvq	2021-05-18 16:04:10.8+00	2021-05-18 16:04:10.8+00	\N	\N	ecg	0.24609375,0.480067383046126	fGQobjreD6	FEuHlBgcyE
A65FLrCFCp	2021-05-18 16:04:11+00	2021-05-18 16:04:11+00	\N	\N	ecg	0.25,0.444931717265355	fGQobjreD6	FEuHlBgcyE
peOo5qtmfk	2021-05-18 16:04:11.202+00	2021-05-18 16:04:11.202+00	\N	\N	ecg	0.25390625,0.420641810193508	fGQobjreD6	FEuHlBgcyE
BR7dBihtEB	2021-05-18 16:04:11.403+00	2021-05-18 16:04:11.403+00	\N	\N	ecg	0.2578125,0.316493445668136	fGQobjreD6	FEuHlBgcyE
7lH7VnhSqU	2021-05-18 16:04:11.604+00	2021-05-18 16:04:11.604+00	\N	\N	ecg	0.26171875,0.309922380841522	fGQobjreD6	FEuHlBgcyE
ikQCE7jn1Y	2021-05-18 16:04:11.806+00	2021-05-18 16:04:11.806+00	\N	\N	ecg	0.265625,0.279488900817205	fGQobjreD6	FEuHlBgcyE
7n3jlqbl7D	2021-05-18 16:04:12.005+00	2021-05-18 16:04:12.005+00	\N	\N	ecg	0.26953125,0.315024095161497	fGQobjreD6	FEuHlBgcyE
HGgcGBeWKI	2021-05-18 16:04:12.206+00	2021-05-18 16:04:12.206+00	\N	\N	ecg	0.2734375,0.320330790998883	fGQobjreD6	FEuHlBgcyE
BauhwggvIm	2021-05-18 16:04:12.406+00	2021-05-18 16:04:12.406+00	\N	\N	ecg	0.27734375,0.370425008099375	fGQobjreD6	FEuHlBgcyE
p5fa4ihCw0	2021-05-18 16:04:12.606+00	2021-05-18 16:04:12.606+00	\N	\N	ecg	0.28125,0.387059137355977	fGQobjreD6	FEuHlBgcyE
t8jYB9KMiw	2021-05-18 16:04:12.807+00	2021-05-18 16:04:12.807+00	\N	\N	ecg	0.28515625,0.312637095674988	fGQobjreD6	FEuHlBgcyE
AoemCVfiaM	2021-05-18 16:04:13.008+00	2021-05-18 16:04:13.008+00	\N	\N	ecg	0.2890625,0.294533411534843	fGQobjreD6	FEuHlBgcyE
H73qjTzk4M	2021-05-18 16:04:13.209+00	2021-05-18 16:04:13.209+00	\N	\N	ecg	0.29296875,0.302799410682013	fGQobjreD6	FEuHlBgcyE
A8C3NlzSsF	2021-05-18 16:04:13.412+00	2021-05-18 16:04:13.412+00	\N	\N	ecg	0.296875,0.179773410836103	fGQobjreD6	FEuHlBgcyE
Sc9dCB5hwO	2021-05-18 16:04:13.609+00	2021-05-18 16:04:13.609+00	\N	\N	ecg	0.30078125,0.276255214340195	fGQobjreD6	FEuHlBgcyE
GrWtKGrqcS	2021-05-18 16:04:13.81+00	2021-05-18 16:04:13.81+00	\N	\N	ecg	0.3046875,0.161100726368793	fGQobjreD6	FEuHlBgcyE
LPCcCJRLZE	2021-05-18 16:04:14.011+00	2021-05-18 16:04:14.011+00	\N	\N	ecg	0.30859375,0.284264424904188	fGQobjreD6	FEuHlBgcyE
rnaC5LvRYU	2021-05-18 16:04:14.211+00	2021-05-18 16:04:14.211+00	\N	\N	ecg	0.3125,0.198367800813536	fGQobjreD6	FEuHlBgcyE
0oIp0vwEGQ	2021-05-18 16:04:14.416+00	2021-05-18 16:04:14.416+00	\N	\N	ecg	0.31640625,0.0966300820930321	fGQobjreD6	FEuHlBgcyE
VTvR1E8Rwk	2021-05-18 16:04:14.614+00	2021-05-18 16:04:14.614+00	\N	\N	ecg	0.3203125,0.0836706917542261	fGQobjreD6	FEuHlBgcyE
DzXmAarOeb	2021-05-18 16:04:14.813+00	2021-05-18 16:04:14.813+00	\N	\N	ecg	0.32421875,0.109200631654795	fGQobjreD6	FEuHlBgcyE
aglP93RzHW	2021-05-18 16:04:15.014+00	2021-05-18 16:04:15.014+00	\N	\N	ecg	0.328125,0.094076257896318	fGQobjreD6	FEuHlBgcyE
YG3xV2DFpE	2021-05-18 16:04:15.215+00	2021-05-18 16:04:15.215+00	\N	\N	ecg	0.33203125,0.0340272894121502	fGQobjreD6	FEuHlBgcyE
PZpPW0QTUJ	2021-05-18 16:04:15.417+00	2021-05-18 16:04:15.417+00	\N	\N	ecg	0.3359375,0.181006962891072	fGQobjreD6	FEuHlBgcyE
ij6x0eECVi	2021-05-18 16:04:15.617+00	2021-05-18 16:04:15.617+00	\N	\N	ecg	0.33984375,0.166189492901873	fGQobjreD6	FEuHlBgcyE
VGslmGduCg	2021-05-18 16:04:15.816+00	2021-05-18 16:04:15.816+00	\N	\N	ecg	0.34375,-0.0134765328778534	fGQobjreD6	FEuHlBgcyE
8A5wolFQPU	2021-05-18 16:04:16.018+00	2021-05-18 16:04:16.018+00	\N	\N	ecg	0.34765625,0.154011479402941	fGQobjreD6	FEuHlBgcyE
SDYDHxzg3D	2021-05-18 16:04:16.218+00	2021-05-18 16:04:16.218+00	\N	\N	ecg	0.3515625,0.0554861408141964	fGQobjreD6	FEuHlBgcyE
4qrKh8Crsn	2021-05-18 16:04:16.418+00	2021-05-18 16:04:16.418+00	\N	\N	ecg	0.35546875,0.0335430313062925	fGQobjreD6	FEuHlBgcyE
wFNYIqcIVv	2021-05-18 16:04:16.621+00	2021-05-18 16:04:16.621+00	\N	\N	ecg	0.359375,-0.0305423381088788	fGQobjreD6	FEuHlBgcyE
R8lkwkA02F	2021-05-18 16:04:16.82+00	2021-05-18 16:04:16.82+00	\N	\N	ecg	0.36328125,0.0050385631803817	fGQobjreD6	FEuHlBgcyE
qydxumVdBi	2021-05-18 16:04:17.022+00	2021-05-18 16:04:17.022+00	\N	\N	ecg	0.3671875,-0.0310119032252117	fGQobjreD6	FEuHlBgcyE
lTWvDPKw7w	2021-05-18 16:04:17.221+00	2021-05-18 16:04:17.221+00	\N	\N	ecg	0.37109375,-0.0085589146683882	fGQobjreD6	FEuHlBgcyE
qtBcY367Ai	2021-05-18 16:04:17.422+00	2021-05-18 16:04:17.422+00	\N	\N	ecg	0.375,-0.0413570845218212	fGQobjreD6	FEuHlBgcyE
MvUuu8exXn	2021-05-18 16:04:17.622+00	2021-05-18 16:04:17.622+00	\N	\N	ecg	0.37890625,0.0882271548048075	fGQobjreD6	FEuHlBgcyE
lrFC3UiJgN	2021-05-18 16:04:17.822+00	2021-05-18 16:04:17.822+00	\N	\N	ecg	0.3828125,0.00280616873407654	fGQobjreD6	FEuHlBgcyE
6wUmreIE10	2021-05-18 16:04:18.023+00	2021-05-18 16:04:18.023+00	\N	\N	ecg	0.38671875,-0.0736756310882781	fGQobjreD6	FEuHlBgcyE
\.


--
-- Data for Name: Mission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Mission" ("objectId", "createdAt", "updatedAt", _rperm, _wperm, location, status, description, location_string) FROM stdin;
fBO3ReRqIt	2021-05-10 09:16:28.148+00	2021-05-16 16:06:46.764+00	\N	\N	(35.6522734664244,34.1137348169966)	complete	Done	\N
DTbwfPk9OE	2021-05-16 16:24:15.433+00	2021-05-17 13:50:36.747+00	\N	\N	(35.6516706770075,34.1244045876806)	complete	Done	\N
ngcWMpo1U7	2021-04-27 08:20:15.537+00	2021-05-09 15:56:29.658+00	\N	\N	(0,0)	complete		\N
j8qruAaqh3	2021-04-26 13:10:43.522+00	2021-05-09 15:56:30.232+00	\N	\N	(0,0)	complete	\N	\N
XOGFrhqD2k	2021-05-08 14:03:42.5+00	2021-05-09 15:59:31.122+00	\N	\N	(35.656369907201594,34.123871692356914)	complete	The patient died horribly with blood drowning him.	\N
R7loxcvNpX	2021-05-09 16:45:29.68+00	2021-05-14 18:56:07.43+00	\N	\N	(35.656026584447694,34.12610983014545)	complete	Done	\N
FEuHlBgcyE	2021-05-10 09:15:30.367+00	2021-05-18 16:56:16.069+00	\N	\N	(35.64813016110785,34.122237459087515)	active	Low blood sugar	SGBL, Street 100, Byblos 4504
\.


--
-- Data for Name: MissionLog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."MissionLog" ("objectId", "createdAt", "updatedAt", _rperm, _wperm, update, related_to_mission) FROM stdin;
\.


--
-- Data for Name: Patient; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Patient" ("objectId", "createdAt", "updatedAt", _rperm, _wperm, firstname, lastname, home_address, dob, gender, blood_type, fathers_name, emergency_nbr, mothers_name, phone_nbr) FROM stdin;
D9FPJwGZON	2021-04-24 12:26:25.191+00	2021-05-14 18:29:18.267+00	\N	\N	Cheese	Smith	Byblos	1960-12-24 22:00:00+00	Female	A-	James	03654321	Tina	03321654
DoKRHmaMxr	2021-04-24 12:18:18.738+00	2021-05-16 16:24:21.682+00	\N	\N	John	Smith	Byblos	1960-12-24 22:00:00+00	Female	A-	Tom	03987654	Lena	76987654
fGQobjreD6	2021-05-17 14:09:21.063+00	2021-05-18 15:37:02.936+00	\N	\N	Joe	BMW	Location Location 1	\N	Man	A-	BMW	09856253	Samar	03466523
\.


--
-- Data for Name: Worker; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Worker" ("objectId", "createdAt", "updatedAt", _rperm, _wperm, user_id, firstname, lastname, "phoneNb", status, image_file, distrct) FROM stdin;
GLRC4Dz1ws	2021-04-24 12:27:55.48+00	2021-04-27 08:54:20.176+00	\N	\N	L1SIutW5FQ	Carol	Smith	01234567	offline	e22d66d6ff32c55cc38e392743de2f3f_carolsmith.field.png	Beirut
aNfHksYhDy	2021-04-24 12:56:41.673+00	2021-04-28 09:50:25.988+00	\N	\N	4I2fKctNRI	Picanto	Smith	03123456	offline	b0e23b52121fc910ab8512c513a4c06b_picantosmith.base.png	Beirut
lLDj2PUmaL	2021-04-06 11:54:51.982+00	2021-05-18 16:57:53.765+00	\N	\N	vlUJtBGHW9	Jane	Smith	03123456	offline	a2b7715a587f33f2f473e77e4a2e0c2e_random-pic-7.jpg	Byblos
T2vMHESrPa	2021-05-18 16:58:40.492+00	2021-05-18 16:58:40.492+00	\N	\N	mmCtJ6omCj	BMW	Mercedes	03123456	offline	5de56e5470f4d5f8b3d8dfe83776a0ab_bmwmercedes.field.png	\N
uQT12VgmhA	2021-04-06 11:55:36.509+00	2021-05-18 17:00:23.32+00	\N	\N	k5vYFm0Dbd	Joe	Smith	03123456	online	48019f2e07fe0e09a8a84e3d9479ac28_random-pic-1.jpg	Byblos
gAamhizOVN	2021-05-18 17:00:48.472+00	2021-05-18 17:00:48.472+00	\N	\N	1dUDx3khx9	Honda	Taxi	03123456	offline	1c753773f91b2c3268c67fa3b38f8b47_hondataxi.field.png	Byblos
y2u2BXLlnK	2021-04-06 11:53:18.225+00	2021-05-18 15:35:45.368+00	\N	\N	vekiIFmtwz	Karen	Smith	031234567	online	d0fe00aa669b476f716eda4059128a46_random-pic-6.jpg	Byblos
\.


--
-- Data for Name: _Audience; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_Audience" ("objectId", "createdAt", "updatedAt", name, query, "lastUsed", "timesUsed", _rperm, _wperm) FROM stdin;
\.


--
-- Data for Name: _GlobalConfig; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_GlobalConfig" ("objectId", params, "masterKeyOnly") FROM stdin;
\.


--
-- Data for Name: _GraphQLConfig; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_GraphQLConfig" ("objectId", config) FROM stdin;
\.


--
-- Data for Name: _Hooks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_Hooks" ("functionName", "className", "triggerName", url) FROM stdin;
\.


--
-- Data for Name: _Idempotency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_Idempotency" ("objectId", "createdAt", "updatedAt", "reqId", expire, _rperm, _wperm) FROM stdin;
\.


--
-- Data for Name: _JobSchedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_JobSchedule" ("objectId", "createdAt", "updatedAt", "jobName", description, params, "startAfter", "daysOfWeek", "timeOfDay", "lastRun", "repeatMinutes", _rperm, _wperm) FROM stdin;
\.


--
-- Data for Name: _JobStatus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_JobStatus" ("objectId", "createdAt", "updatedAt", "jobName", source, status, message, params, "finishedAt", _rperm, _wperm) FROM stdin;
\.


--
-- Data for Name: _Join:base_workers:Mission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_Join:base_workers:Mission" ("relatedId", "owningId") FROM stdin;
lLDj2PUmaL	aS05BJvToQ
lLDj2PUmaL	V7WWpz6iKF
lLDj2PUmaL	MjF4cNljyw
lLDj2PUmaL	1Yekhef1UC
lLDj2PUmaL	l4SapDdBtd
lLDj2PUmaL	2yiAX2BMth
lLDj2PUmaL	ASCbPHsN7x
lLDj2PUmaL	ahFFwltqIb
lLDj2PUmaL	Y9QsPhyvII
lLDj2PUmaL	j8qruAaqh3
lLDj2PUmaL	ngcWMpo1U7
lLDj2PUmaL	XOGFrhqD2k
lLDj2PUmaL	R7loxcvNpX
lLDj2PUmaL	muVamtcOVY
lLDj2PUmaL	fBO3ReRqIt
lLDj2PUmaL	DTbwfPk9OE
lLDj2PUmaL	FEuHlBgcyE
\.


--
-- Data for Name: _Join:field_workers:Mission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_Join:field_workers:Mission" ("relatedId", "owningId") FROM stdin;
y2u2BXLlnK	aS05BJvToQ
y2u2BXLlnK	V7WWpz6iKF
y2u2BXLlnK	MjF4cNljyw
y2u2BXLlnK	1Yekhef1UC
y2u2BXLlnK	l4SapDdBtd
y2u2BXLlnK	2yiAX2BMth
y2u2BXLlnK	ASCbPHsN7x
y2u2BXLlnK	ahFFwltqIb
y2u2BXLlnK	Y9QsPhyvII
y2u2BXLlnK	j8qruAaqh3
y2u2BXLlnK	XOGFrhqD2k
y2u2BXLlnK	R7loxcvNpX
y2u2BXLlnK	muVamtcOVY
y2u2BXLlnK	fBO3ReRqIt
y2u2BXLlnK	DTbwfPk9OE
y2u2BXLlnK	FEuHlBgcyE
\.


--
-- Data for Name: _Join:patients:Mission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_Join:patients:Mission" ("relatedId", "owningId") FROM stdin;
D9FPJwGZON	j8qruAaqh3
D9FPJwGZON	ngcWMpo1U7
D9FPJwGZON	XOGFrhqD2k
D9FPJwGZON	R7loxcvNpX
D9BnrUrZY3	muVamtcOVY
DoKRHmaMxr	fBO3ReRqIt
DoKRHmaMxr	DTbwfPk9OE
fGQobjreD6	FEuHlBgcyE
\.


--
-- Data for Name: _Join:roles:_Role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_Join:roles:_Role" ("relatedId", "owningId") FROM stdin;
\.


--
-- Data for Name: _Join:users:_Role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_Join:users:_Role" ("relatedId", "owningId") FROM stdin;
k5vYFm0Dbd	R92PAg71tf
vlUJtBGHW9	KFNZkyJZHC
vekiIFmtwz	VDYmJhwSss
L1SIutW5FQ	VDYmJhwSss
4I2fKctNRI	KFNZkyJZHC
mmCtJ6omCj	VDYmJhwSss
1dUDx3khx9	VDYmJhwSss
\.


--
-- Data for Name: _PushStatus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_PushStatus" ("objectId", "createdAt", "updatedAt", "pushTime", source, query, payload, title, expiry, expiration_interval, status, "numSent", "numFailed", "pushHash", "errorMessage", "sentPerType", "failedPerType", "sentPerUTCOffset", "failedPerUTCOffset", count, _rperm, _wperm) FROM stdin;
\.


--
-- Data for Name: _Role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_Role" ("objectId", "createdAt", "updatedAt", name, _rperm, _wperm) FROM stdin;
R92PAg71tf	2021-03-29 14:23:39.568+00	2021-03-29 14:35:12.203+00	district_chief	{*,role:district_chief}	{*,role:district_chief}
KFNZkyJZHC	2021-03-29 14:24:18.304+00	2021-04-24 12:56:41.55+00	base_worker	{*,role:base_worker}	{*,role:base_worker}
VDYmJhwSss	2021-03-29 14:24:39.544+00	2021-05-18 17:00:48.37+00	field_responder	{*,role:field_responder}	{*,role:field_responder}
\.


--
-- Data for Name: _SCHEMA; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_SCHEMA" ("className", schema, "isParseClass") FROM stdin;
_Role	{"fields": {"name": {"type": "String"}, "roles": {"type": "Relation", "targetClass": "_Role"}, "users": {"type": "Relation", "targetClass": "_User"}, "_rperm": {"type": "Array", "contents": {"type": "String"}}, "_wperm": {"type": "Array", "contents": {"type": "String"}}, "objectId": {"type": "String"}, "createdAt": {"type": "Date"}, "updatedAt": {"type": "Date"}}, "className": "_Role"}	t
_Session	{"fields": {"user": {"type": "Pointer", "targetClass": "_User"}, "_rperm": {"type": "Array", "contents": {"type": "String"}}, "_wperm": {"type": "Array", "contents": {"type": "String"}}, "objectId": {"type": "String"}, "createdAt": {"type": "Date"}, "expiresAt": {"type": "Date"}, "updatedAt": {"type": "Date"}, "restricted": {"type": "Boolean"}, "createdWith": {"type": "Object"}, "sessionToken": {"type": "String"}, "installationId": {"type": "String"}}, "className": "_Session"}	t
MedicalData	{"fields": {"ACL": {"type": "ACL"}, "value": {"type": "String", "required": false}, "patient": {"type": "Pointer", "required": false, "targetClass": "Patient"}, "datatype": {"type": "String", "required": false}, "objectId": {"type": "String"}, "createdAt": {"type": "Date"}, "updatedAt": {"type": "Date"}, "mission_record": {"type": "Pointer", "required": false, "targetClass": "Mission"}}, "className": "MedicalData", "classLevelPermissions": {"get": {"requiresAuthentication": true}, "find": {"requiresAuthentication": true}, "count": {"requiresAuthentication": true}, "create": {"requiresAuthentication": true}, "delete": {"requiresAuthentication": true}, "update": {"requiresAuthentication": true}, "addField": {"requiresAuthentication": true}, "protectedFields": {"*": []}}}	t
_User	{"fields": {"ACL": {"type": "ACL"}, "email": {"type": "String"}, "authData": {"type": "Object"}, "objectId": {"type": "String"}, "password": {"type": "String"}, "username": {"type": "String"}, "createdAt": {"type": "Date"}, "updatedAt": {"type": "Date"}, "emailVerified": {"type": "Boolean"}}, "className": "_User", "classLevelPermissions": {"get": {"*": true}, "find": {"*": true}, "count": {"*": true}, "create": {"*": true}, "delete": {"*": true}, "update": {"*": true}, "addField": {"*": true}, "protectedFields": {"*": []}}}	t
MissionLog	{"fields": {"ACL": {"type": "ACL"}, "update": {"type": "String", "required": false}, "objectId": {"type": "String"}, "createdAt": {"type": "Date"}, "updatedAt": {"type": "Date"}, "related_to_mission": {"type": "Pointer", "required": false, "targetClass": "Mission"}}, "className": "MissionLog", "classLevelPermissions": {"get": {"requiresAuthentication": true}, "find": {"requiresAuthentication": true}, "count": {"requiresAuthentication": true}, "create": {"requiresAuthentication": true}, "delete": {"requiresAuthentication": true}, "update": {"requiresAuthentication": true}, "addField": {"requiresAuthentication": true}, "protectedFields": {"*": []}}}	t
Worker	{"fields": {"ACL": {"type": "ACL"}, "status": {"type": "String", "required": false}, "distrct": {"type": "String", "required": false}, "phoneNb": {"type": "String", "required": false}, "user_id": {"type": "String", "required": false}, "lastname": {"type": "String", "required": false}, "objectId": {"type": "String"}, "createdAt": {"type": "Date"}, "firstname": {"type": "String", "required": false}, "updatedAt": {"type": "Date"}, "image_file": {"type": "File", "required": false}}, "className": "Worker", "classLevelPermissions": {"get": {"*": true}, "find": {"*": true}, "count": {"*": true}, "create": {"*": true}, "delete": {"*": true}, "update": {"*": true}, "addField": {"*": true}, "protectedFields": {"*": []}}}	t
ChatMessage	{"fields": {"ACL": {"type": "ACL"}, "image": {"type": "File", "required": false}, "sender": {"type": "Pointer", "required": false, "targetClass": "Worker"}, "message": {"type": "String", "required": false}, "objectId": {"type": "String"}, "createdAt": {"type": "Date"}, "updatedAt": {"type": "Date"}, "for_mission": {"type": "Pointer", "required": false, "targetClass": "Mission"}}, "className": "ChatMessage", "classLevelPermissions": {"get": {"requiresAuthentication": true}, "find": {"requiresAuthentication": true}, "count": {"requiresAuthentication": true}, "create": {"requiresAuthentication": true}, "delete": {"requiresAuthentication": true}, "update": {"requiresAuthentication": true}, "addField": {"requiresAuthentication": true}, "protectedFields": {"*": []}}}	t
Patient	{"fields": {"dob": {"type": "Date", "required": false}, "_rperm": {"type": "Array", "contents": {"type": "String"}}, "_wperm": {"type": "Array", "contents": {"type": "String"}}, "gender": {"type": "String", "required": false}, "lastname": {"type": "String", "required": false}, "objectId": {"type": "String"}, "createdAt": {"type": "Date"}, "firstname": {"type": "String", "required": false}, "phone_nbr": {"type": "String", "required": false}, "updatedAt": {"type": "Date"}, "blood_type": {"type": "String", "required": false}, "fathers_name": {"type": "String", "required": false}, "home_address": {"type": "String", "required": false}, "mothers_name": {"type": "String", "required": false}, "emergency_nbr": {"type": "String", "required": false}}, "className": "Patient", "classLevelPermissions": {"get": {"requiresAuthentication": true}, "find": {"requiresAuthentication": true}, "count": {"requiresAuthentication": true}, "create": {"requiresAuthentication": true}, "delete": {"requiresAuthentication": true}, "update": {"requiresAuthentication": true}, "addField": {"requiresAuthentication": true}, "protectedFields": {"*": []}}}	t
Mission	{"fields": {"ACL": {"type": "ACL"}, "status": {"type": "String", "required": false}, "location": {"type": "GeoPoint", "required": false}, "objectId": {"type": "String"}, "patients": {"type": "Relation", "required": false, "targetClass": "Patient"}, "createdAt": {"type": "Date"}, "updatedAt": {"type": "Date"}, "description": {"type": "String", "required": false}, "base_workers": {"type": "Relation", "required": false, "targetClass": "Worker"}, "field_workers": {"type": "Relation", "required": false, "targetClass": "Worker"}, "location_string": {"type": "String", "required": false}}, "className": "Mission", "classLevelPermissions": {"get": {"requiresAuthentication": true}, "find": {"requiresAuthentication": true}, "count": {"requiresAuthentication": true}, "create": {"requiresAuthentication": true}, "delete": {"requiresAuthentication": true}, "update": {"requiresAuthentication": true}, "addField": {"requiresAuthentication": true}, "protectedFields": {"*": []}}}	t
\.


--
-- Data for Name: _Session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_Session" ("objectId", "createdAt", "updatedAt", restricted, "user", "installationId", "sessionToken", "expiresAt", "createdWith", _rperm, _wperm) FROM stdin;
bNKjXtEZo2	2021-03-29 14:32:54.613+00	2021-03-29 14:32:54.613+00	f	k5vYFm0Dbd	327118a1-6265-446b-9799-1aef88b6d612	r:ec608b809a5b0ff253788241378760d3	2022-03-29 14:32:54.613+00	{"action": "signup", "authProvider": "password"}	\N	\N
H2NEEZ3E1N	2021-05-18 16:58:40.335+00	2021-05-18 16:58:40.335+00	f	mmCtJ6omCj	8c0de27b-e126-4686-9021-8c92333f6d17	r:50b157266bd0370fe0553020d4986a93	2022-05-18 16:58:40.335+00	{"action": "signup", "authProvider": "password"}	\N	\N
s6EgDaL6fy	2021-05-18 17:00:23.241+00	2021-05-18 17:00:23.241+00	f	k5vYFm0Dbd	8c0de27b-e126-4686-9021-8c92333f6d17	r:227f0bbaffba9124bb7a58a37bd110ef	2022-05-18 17:00:23.241+00	{"action": "login", "authProvider": "password"}	\N	\N
IjB7kiaaGc	2021-05-18 17:00:48.345+00	2021-05-18 17:00:48.345+00	f	1dUDx3khx9	8c0de27b-e126-4686-9021-8c92333f6d17	r:513ae0d661559de22c5a5cb5ffb20689	2022-05-18 17:00:48.345+00	{"action": "signup", "authProvider": "password"}	\N	\N
pFnEsT6aNK	2021-05-17 13:50:58.438+00	2021-05-17 13:50:58.438+00	f	vekiIFmtwz	fb599a81-99e8-4aa5-a63e-331554b603a9	r:2e42f213541b9e63a0e3be346838b6de	2022-05-17 13:50:58.438+00	{"action": "login", "authProvider": "password"}	\N	\N
\.


--
-- Data for Name: _User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_User" ("objectId", "createdAt", "updatedAt", username, email, "emailVerified", "authData", _rperm, _wperm, _hashed_password, _email_verify_token_expires_at, _email_verify_token, _account_lockout_expires_at, _failed_login_count, _perishable_token, _perishable_token_expires_at, _password_changed_at, _password_history) FROM stdin;
k5vYFm0Dbd	2021-03-29 14:32:54.523+00	2021-03-29 14:33:56.957+00	joesmith.chief	joesmith.chief@gmail.com	t	\N	{*,k5vYFm0Dbd,role:district_chief}	{k5vYFm0Dbd,role:district_chief}	$2b$10$U6fl0IIF3S5fHnbib5yOLuUaOoYeHlQ3vzE9a3bC59aNpKnCZ254.	\N	\N	\N	\N	\N	\N	\N	\N
L1SIutW5FQ	2021-04-24 12:27:55.279+00	2021-04-24 12:27:55.279+00	carolsmith.field	carol.smith@gmail.com	\N	\N	{*,L1SIutW5FQ}	{L1SIutW5FQ}	$2b$10$QiDxR.po/g1hU1cw3UNuyeSB8dQeiowyc0borgm9eq/Y.HXaE.vH2	\N	\N	\N	\N	\N	\N	\N	\N
4I2fKctNRI	2021-04-24 12:56:41.456+00	2021-04-24 12:56:41.456+00	picantosmith.base	p@gmail.com	\N	\N	{*,4I2fKctNRI}	{4I2fKctNRI}	$2b$10$654njbBISs156LNyoSmaK.uJON98PSDHexhA/LaY1kRTs1WCQ33tK	\N	\N	\N	\N	\N	\N	\N	\N
vlUJtBGHW9	2021-03-29 14:36:40.113+00	2021-05-10 08:46:51.358+00	janesmith.base	janesmith.base@gmail.com	t	\N	{*,vlUJtBGHW9}	{vlUJtBGHW9}	$2b$10$uU7B0MWHyq2a8Fkn/1UVieCAEAQlrsTCexYI8gl5ds/nhBcewEkii	\N	\N	\N	\N	\N	\N	\N	\N
vekiIFmtwz	2021-03-29 14:37:43.134+00	2021-05-17 13:39:22.023+00	karen.field	karen.field@gmail.com	t	\N	{*,vekiIFmtwz}	{vekiIFmtwz}	$2b$10$PfnBMHnA.E2i.vIKdWsFROFKNOOH33LdFVbkF1FqzDLgGWI/pBd5a	\N	\N	\N	\N	\N	\N	\N	\N
mmCtJ6omCj	2021-05-18 16:58:40.248+00	2021-05-18 16:58:40.248+00	bmwmercedes.field	bmw.mercedes@gmail.com	\N	\N	{*,mmCtJ6omCj}	{mmCtJ6omCj}	$2b$10$QIpNEenn9pfXl9f5moQ4fOOXJzw.aQbDTyWzE0H.F58.QBcfFbygm	\N	\N	\N	\N	\N	\N	\N	\N
1dUDx3khx9	2021-05-18 17:00:48.268+00	2021-05-18 17:00:48.268+00	hondataxi.field	helpme@gmail.com	\N	\N	{*,1dUDx3khx9}	{1dUDx3khx9}	$2b$10$lr/kTZSUGcsfyIKeHCz1PuMlUtp4wB4mdbtHnmer.L9uPtaJ.hgYm	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Name: ChatMessage ChatMessage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ChatMessage"
    ADD CONSTRAINT "ChatMessage_pkey" PRIMARY KEY ("objectId");


--
-- Name: MedicalData MedicalData_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MedicalData"
    ADD CONSTRAINT "MedicalData_pkey" PRIMARY KEY ("objectId");


--
-- Name: MissionLog MissionLog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MissionLog"
    ADD CONSTRAINT "MissionLog_pkey" PRIMARY KEY ("objectId");


--
-- Name: Mission Mission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Mission"
    ADD CONSTRAINT "Mission_pkey" PRIMARY KEY ("objectId");


--
-- Name: Patient Patient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Patient"
    ADD CONSTRAINT "Patient_pkey" PRIMARY KEY ("objectId");


--
-- Name: Worker Worker_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Worker"
    ADD CONSTRAINT "Worker_pkey" PRIMARY KEY ("objectId");


--
-- Name: _Audience _Audience_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_Audience"
    ADD CONSTRAINT "_Audience_pkey" PRIMARY KEY ("objectId");


--
-- Name: _GlobalConfig _GlobalConfig_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_GlobalConfig"
    ADD CONSTRAINT "_GlobalConfig_pkey" PRIMARY KEY ("objectId");


--
-- Name: _GraphQLConfig _GraphQLConfig_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_GraphQLConfig"
    ADD CONSTRAINT "_GraphQLConfig_pkey" PRIMARY KEY ("objectId");


--
-- Name: _Idempotency _Idempotency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_Idempotency"
    ADD CONSTRAINT "_Idempotency_pkey" PRIMARY KEY ("objectId");


--
-- Name: _JobSchedule _JobSchedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_JobSchedule"
    ADD CONSTRAINT "_JobSchedule_pkey" PRIMARY KEY ("objectId");


--
-- Name: _JobStatus _JobStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_JobStatus"
    ADD CONSTRAINT "_JobStatus_pkey" PRIMARY KEY ("objectId");


--
-- Name: _Join:base_workers:Mission _Join:base_workers:Mission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_Join:base_workers:Mission"
    ADD CONSTRAINT "_Join:base_workers:Mission_pkey" PRIMARY KEY ("relatedId", "owningId");


--
-- Name: _Join:field_workers:Mission _Join:field_workers:Mission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_Join:field_workers:Mission"
    ADD CONSTRAINT "_Join:field_workers:Mission_pkey" PRIMARY KEY ("relatedId", "owningId");


--
-- Name: _Join:patients:Mission _Join:patients:Mission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_Join:patients:Mission"
    ADD CONSTRAINT "_Join:patients:Mission_pkey" PRIMARY KEY ("relatedId", "owningId");


--
-- Name: _Join:roles:_Role _Join:roles:_Role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_Join:roles:_Role"
    ADD CONSTRAINT "_Join:roles:_Role_pkey" PRIMARY KEY ("relatedId", "owningId");


--
-- Name: _Join:users:_Role _Join:users:_Role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_Join:users:_Role"
    ADD CONSTRAINT "_Join:users:_Role_pkey" PRIMARY KEY ("relatedId", "owningId");


--
-- Name: _PushStatus _PushStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_PushStatus"
    ADD CONSTRAINT "_PushStatus_pkey" PRIMARY KEY ("objectId");


--
-- Name: _Role _Role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_Role"
    ADD CONSTRAINT "_Role_pkey" PRIMARY KEY ("objectId");


--
-- Name: _SCHEMA _SCHEMA_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_SCHEMA"
    ADD CONSTRAINT "_SCHEMA_pkey" PRIMARY KEY ("className");


--
-- Name: _Session _Session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_Session"
    ADD CONSTRAINT "_Session_pkey" PRIMARY KEY ("objectId");


--
-- Name: _User _User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_User"
    ADD CONSTRAINT "_User_pkey" PRIMARY KEY ("objectId");


--
-- Name: _Role_unique_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "_Role_unique_name" ON public."_Role" USING btree (name);


--
-- Name: _User_unique_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "_User_unique_email" ON public."_User" USING btree (email);


--
-- Name: _User_unique_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "_User_unique_username" ON public."_User" USING btree (username);


--
-- Name: case_insensitive_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX case_insensitive_email ON public."_User" USING btree (lower(email) varchar_pattern_ops);


--
-- Name: case_insensitive_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX case_insensitive_username ON public."_User" USING btree (lower(username) varchar_pattern_ops);


--
-- PostgreSQL database dump complete
--

