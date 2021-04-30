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
    sender text
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
    status text
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
    blood_type text
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

COPY public."ChatMessage" ("objectId", "createdAt", "updatedAt", _rperm, _wperm, message, for_mission, sender) FROM stdin;
QWXKtU48Lb	2021-04-26 14:12:49.446+00	2021-04-26 14:29:24.605+00	\N	\N	Just arrived. We see the patient. They are bleeding profusely	j8qruAaqh3	y2u2BXLlnK
vMVK3ZEMyh	2021-04-26 14:11:28.874+00	2021-04-26 14:29:45.521+00	\N	\N	Hi. Arriving Soon	j8qruAaqh3	y2u2BXLlnK
zLVPJufPCx	2021-04-26 14:12:10.794+00	2021-04-26 14:29:59.24+00	\N	\N	Great. Keep me posted	j8qruAaqh3	lLDj2PUmaL
N7t38zf92Y	2021-04-26 14:13:34.868+00	2021-04-26 14:30:17.306+00	\N	\N	Disinfected and bandaged all visible wounds. Whats next?	j8qruAaqh3	y2u2BXLlnK
jF2ufrBKRx	2021-04-26 14:14:48.765+00	2021-04-26 14:30:28.656+00	\N	\N	Get patient ready for transport I am looking for the closest hospital	j8qruAaqh3	lLDj2PUmaL
EXEOIFCyvr	2021-04-26 14:15:22.392+00	2021-04-26 14:30:40.933+00	\N	\N	The nearest hospital is LAUMC	j8qruAaqh3	lLDj2PUmaL
2vla0BslKt	2021-04-26 14:15:49.466+00	2021-04-26 14:30:51.129+00	\N	\N	Just arrived at hospital. Patient taken by staff	j8qruAaqh3	y2u2BXLlnK
\.


--
-- Data for Name: MedicalData; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."MedicalData" ("objectId", "createdAt", "updatedAt", _rperm, _wperm, datatype, value, patient, mission_record) FROM stdin;
\.


--
-- Data for Name: Mission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Mission" ("objectId", "createdAt", "updatedAt", _rperm, _wperm, location, status) FROM stdin;
j8qruAaqh3	2021-04-26 13:10:43.522+00	2021-04-26 13:12:40.737+00	\N	\N	\N	complete
ngcWMpo1U7	2021-04-27 08:20:15.537+00	2021-04-27 08:31:31.336+00	\N	\N	\N	complete
\.


--
-- Data for Name: MissionLog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."MissionLog" ("objectId", "createdAt", "updatedAt", _rperm, _wperm, update, related_to_mission) FROM stdin;
\.


--
-- Data for Name: Patient; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Patient" ("objectId", "createdAt", "updatedAt", _rperm, _wperm, firstname, lastname, home_address, dob, gender, blood_type) FROM stdin;
KnfbIlJNoo	2021-04-24 12:16:22.435+00	2021-04-24 12:16:22.435+00	\N	\N	John	Smith	Byblos	1960-12-24 22:00:00+00	Female	A-
DoKRHmaMxr	2021-04-24 12:18:18.738+00	2021-04-24 12:18:18.738+00	\N	\N	John	Smith	Byblos	1960-12-24 22:00:00+00	Female	A-
D9FPJwGZON	2021-04-24 12:26:25.191+00	2021-04-24 12:26:25.191+00	\N	\N	John	Smith	Byblos	1960-12-24 22:00:00+00	Female	A-
\.


--
-- Data for Name: Worker; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Worker" ("objectId", "createdAt", "updatedAt", _rperm, _wperm, user_id, firstname, lastname, "phoneNb", status, image_file, distrct) FROM stdin;
GLRC4Dz1ws	2021-04-24 12:27:55.48+00	2021-04-27 08:54:20.176+00	\N	\N	L1SIutW5FQ	Carol	Smith	01234567	offline	e22d66d6ff32c55cc38e392743de2f3f_carolsmith.field.png	Beirut
uQT12VgmhA	2021-04-06 11:55:36.509+00	2021-04-27 08:54:24.217+00	\N	\N	k5vYFm0Dbd	Joe	Smith	03123456	offline	48019f2e07fe0e09a8a84e3d9479ac28_random-pic-1.jpg	Byblos
y2u2BXLlnK	2021-04-06 11:53:18.225+00	2021-04-27 08:54:28.31+00	\N	\N	vekiIFmtwz	Karen	Smith	03123456	offline	d0fe00aa669b476f716eda4059128a46_random-pic-6.jpg	Byblos
lLDj2PUmaL	2021-04-06 11:54:51.982+00	2021-04-27 09:08:18.164+00	\N	\N	vlUJtBGHW9	Jane	Smith	03123456	offline	a2b7715a587f33f2f473e77e4a2e0c2e_random-pic-7.jpg	Byblos
aNfHksYhDy	2021-04-24 12:56:41.673+00	2021-04-28 09:50:25.988+00	\N	\N	4I2fKctNRI	Picanto	Smith	03123456	offline	b0e23b52121fc910ab8512c513a4c06b_picantosmith.base.png	Beirut
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
\.


--
-- Data for Name: _Join:patients:Mission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_Join:patients:Mission" ("relatedId", "owningId") FROM stdin;
D9FPJwGZON	j8qruAaqh3
D9FPJwGZON	ngcWMpo1U7
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
VDYmJhwSss	2021-03-29 14:24:39.544+00	2021-04-24 12:27:55.381+00	field_responder	{*,role:field_responder}	{*,role:field_responder}
KFNZkyJZHC	2021-03-29 14:24:18.304+00	2021-04-24 12:56:41.55+00	base_worker	{*,role:base_worker}	{*,role:base_worker}
\.


--
-- Data for Name: _SCHEMA; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_SCHEMA" ("className", schema, "isParseClass") FROM stdin;
_Role	{"fields": {"name": {"type": "String"}, "roles": {"type": "Relation", "targetClass": "_Role"}, "users": {"type": "Relation", "targetClass": "_User"}, "_rperm": {"type": "Array", "contents": {"type": "String"}}, "_wperm": {"type": "Array", "contents": {"type": "String"}}, "objectId": {"type": "String"}, "createdAt": {"type": "Date"}, "updatedAt": {"type": "Date"}}, "className": "_Role"}	t
_Session	{"fields": {"user": {"type": "Pointer", "targetClass": "_User"}, "_rperm": {"type": "Array", "contents": {"type": "String"}}, "_wperm": {"type": "Array", "contents": {"type": "String"}}, "objectId": {"type": "String"}, "createdAt": {"type": "Date"}, "expiresAt": {"type": "Date"}, "updatedAt": {"type": "Date"}, "restricted": {"type": "Boolean"}, "createdWith": {"type": "Object"}, "sessionToken": {"type": "String"}, "installationId": {"type": "String"}}, "className": "_Session"}	t
MedicalData	{"fields": {"ACL": {"type": "ACL"}, "value": {"type": "String", "required": false}, "patient": {"type": "Pointer", "required": false, "targetClass": "Patient"}, "datatype": {"type": "String", "required": false}, "objectId": {"type": "String"}, "createdAt": {"type": "Date"}, "updatedAt": {"type": "Date"}, "mission_record": {"type": "Pointer", "required": false, "targetClass": "Mission"}}, "className": "MedicalData", "classLevelPermissions": {"get": {"requiresAuthentication": true}, "find": {"requiresAuthentication": true}, "count": {"requiresAuthentication": true}, "create": {"requiresAuthentication": true}, "delete": {"requiresAuthentication": true}, "update": {"requiresAuthentication": true}, "addField": {"requiresAuthentication": true}, "protectedFields": {"*": []}}}	t
_User	{"fields": {"ACL": {"type": "ACL"}, "email": {"type": "String"}, "authData": {"type": "Object"}, "objectId": {"type": "String"}, "password": {"type": "String"}, "username": {"type": "String"}, "createdAt": {"type": "Date"}, "updatedAt": {"type": "Date"}, "emailVerified": {"type": "Boolean"}}, "className": "_User", "classLevelPermissions": {"get": {"*": true}, "find": {"*": true}, "count": {"*": true}, "create": {"*": true}, "delete": {"*": true}, "update": {"*": true}, "addField": {"*": true}, "protectedFields": {"*": []}}}	t
Mission	{"fields": {"ACL": {"type": "ACL"}, "status": {"type": "String", "required": false}, "location": {"type": "GeoPoint", "required": false}, "objectId": {"type": "String"}, "patients": {"type": "Relation", "required": false, "targetClass": "Patient"}, "createdAt": {"type": "Date"}, "updatedAt": {"type": "Date"}, "base_workers": {"type": "Relation", "required": false, "targetClass": "Worker"}, "field_workers": {"type": "Relation", "required": false, "targetClass": "Worker"}}, "className": "Mission", "classLevelPermissions": {"get": {"requiresAuthentication": true}, "find": {"requiresAuthentication": true}, "count": {"requiresAuthentication": true}, "create": {"requiresAuthentication": true}, "delete": {"requiresAuthentication": true}, "update": {"requiresAuthentication": true}, "addField": {"requiresAuthentication": true}, "protectedFields": {"*": []}}}	t
Patient	{"fields": {"dob": {"type": "Date", "required": false}, "_rperm": {"type": "Array", "contents": {"type": "String"}}, "_wperm": {"type": "Array", "contents": {"type": "String"}}, "gender": {"type": "String", "required": false}, "lastname": {"type": "String", "required": false}, "objectId": {"type": "String"}, "createdAt": {"type": "Date"}, "firstname": {"type": "String", "required": false}, "updatedAt": {"type": "Date"}, "blood_type": {"type": "String", "required": false}, "home_address": {"type": "String", "required": false}}, "className": "Patient", "classLevelPermissions": {"get": {"requiresAuthentication": true}, "find": {"requiresAuthentication": true}, "count": {"requiresAuthentication": true}, "create": {"requiresAuthentication": true}, "delete": {"requiresAuthentication": true}, "update": {"requiresAuthentication": true}, "addField": {"requiresAuthentication": true}, "protectedFields": {"*": []}}}	t
MissionLog	{"fields": {"ACL": {"type": "ACL"}, "update": {"type": "String", "required": false}, "objectId": {"type": "String"}, "createdAt": {"type": "Date"}, "updatedAt": {"type": "Date"}, "related_to_mission": {"type": "Pointer", "required": false, "targetClass": "Mission"}}, "className": "MissionLog", "classLevelPermissions": {"get": {"requiresAuthentication": true}, "find": {"requiresAuthentication": true}, "count": {"requiresAuthentication": true}, "create": {"requiresAuthentication": true}, "delete": {"requiresAuthentication": true}, "update": {"requiresAuthentication": true}, "addField": {"requiresAuthentication": true}, "protectedFields": {"*": []}}}	t
ChatMessage	{"fields": {"ACL": {"type": "ACL"}, "sender": {"type": "Pointer", "required": false, "targetClass": "Worker"}, "message": {"type": "String", "required": false}, "objectId": {"type": "String"}, "createdAt": {"type": "Date"}, "updatedAt": {"type": "Date"}, "for_mission": {"type": "Pointer", "required": false, "targetClass": "Mission"}}, "className": "ChatMessage", "classLevelPermissions": {"get": {"requiresAuthentication": true}, "find": {"requiresAuthentication": true}, "count": {"requiresAuthentication": true}, "create": {"requiresAuthentication": true}, "delete": {"requiresAuthentication": true}, "update": {"requiresAuthentication": true}, "addField": {"requiresAuthentication": true}, "protectedFields": {"*": []}}}	t
Worker	{"fields": {"ACL": {"type": "ACL"}, "status": {"type": "String", "required": false}, "distrct": {"type": "String", "required": false}, "phoneNb": {"type": "String", "required": false}, "user_id": {"type": "String", "required": false}, "lastname": {"type": "String", "required": false}, "objectId": {"type": "String"}, "createdAt": {"type": "Date"}, "firstname": {"type": "String", "required": false}, "updatedAt": {"type": "Date"}, "image_file": {"type": "File", "required": false}}, "className": "Worker", "classLevelPermissions": {"get": {"*": true}, "find": {"*": true}, "count": {"*": true}, "create": {"*": true}, "delete": {"*": true}, "update": {"*": true}, "addField": {"*": true}, "protectedFields": {"*": []}}}	t
\.


--
-- Data for Name: _Session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_Session" ("objectId", "createdAt", "updatedAt", restricted, "user", "installationId", "sessionToken", "expiresAt", "createdWith", _rperm, _wperm) FROM stdin;
bNKjXtEZo2	2021-03-29 14:32:54.613+00	2021-03-29 14:32:54.613+00	f	k5vYFm0Dbd	327118a1-6265-446b-9799-1aef88b6d612	r:ec608b809a5b0ff253788241378760d3	2022-03-29 14:32:54.613+00	{"action": "signup", "authProvider": "password"}	\N	\N
EPV9jTLYYR	2021-03-29 14:36:40.193+00	2021-03-29 14:36:40.193+00	f	vlUJtBGHW9	327118a1-6265-446b-9799-1aef88b6d612	r:ad0047ba19ddf991dfe52aebb084e9ad	2022-03-29 14:36:40.192+00	{"action": "signup", "authProvider": "password"}	\N	\N
7w5SZA1X4y	2021-03-29 14:37:43.218+00	2021-03-29 14:37:43.218+00	f	vekiIFmtwz	327118a1-6265-446b-9799-1aef88b6d612	r:63a711413ed696812ce41043351cddfc	2022-03-29 14:37:43.218+00	{"action": "signup", "authProvider": "password"}	\N	\N
\.


--
-- Data for Name: _User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_User" ("objectId", "createdAt", "updatedAt", username, email, "emailVerified", "authData", _rperm, _wperm, _hashed_password, _email_verify_token_expires_at, _email_verify_token, _account_lockout_expires_at, _failed_login_count, _perishable_token, _perishable_token_expires_at, _password_changed_at, _password_history) FROM stdin;
k5vYFm0Dbd	2021-03-29 14:32:54.523+00	2021-03-29 14:33:56.957+00	joesmith.chief	joesmith.chief@gmail.com	t	\N	{*,k5vYFm0Dbd,role:district_chief}	{k5vYFm0Dbd,role:district_chief}	$2b$10$U6fl0IIF3S5fHnbib5yOLuUaOoYeHlQ3vzE9a3bC59aNpKnCZ254.	\N	\N	\N	\N	\N	\N	\N	\N
vlUJtBGHW9	2021-03-29 14:36:40.113+00	2021-03-29 14:36:51.325+00	janesmith.base	janesmith.base@gmail.com	t	\N	{*,vlUJtBGHW9}	{vlUJtBGHW9}	$2b$10$J17W6yRQKhzFeM8.cZLjj.9V46Hnbynj5Ccc6aUYTDMxYd6710IfG	\N	\N	\N	\N	\N	\N	\N	\N
vekiIFmtwz	2021-03-29 14:37:43.134+00	2021-03-29 14:37:53.259+00	karen.field	karen.field@gmail.com	t	\N	{*,vekiIFmtwz}	{vekiIFmtwz}	$2b$10$vh2dzpDLjRWwSDLMCAiXR.6Ouhqf7yq2NEDX2X5LLNeQGVZBjnOha	\N	\N	\N	\N	\N	\N	\N	\N
L1SIutW5FQ	2021-04-24 12:27:55.279+00	2021-04-24 12:27:55.279+00	carolsmith.field	carol.smith@gmail.com	\N	\N	{*,L1SIutW5FQ}	{L1SIutW5FQ}	$2b$10$QiDxR.po/g1hU1cw3UNuyeSB8dQeiowyc0borgm9eq/Y.HXaE.vH2	\N	\N	\N	\N	\N	\N	\N	\N
4I2fKctNRI	2021-04-24 12:56:41.456+00	2021-04-24 12:56:41.456+00	picantosmith.base	p@gmail.com	\N	\N	{*,4I2fKctNRI}	{4I2fKctNRI}	$2b$10$654njbBISs156LNyoSmaK.uJON98PSDHexhA/LaY1kRTs1WCQ33tK	\N	\N	\N	\N	\N	\N	\N	\N
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

