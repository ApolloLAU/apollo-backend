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
KoTx54BJAT	2021-05-19 10:51:58.637+00	2021-05-19 10:51:58.637+00	\N	\N	REQUESTED ECG READING UPDATE	PxHgYjFpnc	WFARTYU9J4	\N
MNuZnCNovK	2021-05-19 10:54:51.198+00	2021-05-19 10:54:51.198+00	\N	\N	Done	PxHgYjFpnc	a28Bm3szmT	\N
iP8jIMaaiN	2021-05-19 10:54:56.976+00	2021-05-19 10:54:56.976+00	\N	\N	Send image	PxHgYjFpnc	WFARTYU9J4	\N
EFqFz423qW	2021-05-19 10:57:19.814+00	2021-05-19 10:57:19.814+00	\N	\N	\N	PxHgYjFpnc	a28Bm3szmT	5cb6ba0aa457414d68b9e17a839c4ec6_chat_image.png
qWh2Wn46vv	2021-05-19 10:58:54.724+00	2021-05-19 10:58:54.724+00	\N	\N	Patient seems stable	PxHgYjFpnc	a28Bm3szmT	\N
GXc7Zer2Wr	2021-05-19 10:59:29.534+00	2021-05-19 10:59:29.534+00	\N	\N	Completing mission	PxHgYjFpnc	WFARTYU9J4	\N
\.


--
-- Data for Name: MedicalData; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."MedicalData" ("objectId", "createdAt", "updatedAt", _rperm, _wperm, datatype, value, patient, mission_record) FROM stdin;
WnaI9uyS4V	2021-05-19 10:53:17.045+00	2021-05-19 10:53:17.045+00	\N	\N	ecg	0.0,1.12705852985289	8sycsF8enM	PxHgYjFpnc
n1ZAXnUFbW	2021-05-19 10:53:17.098+00	2021-05-19 10:53:17.098+00	\N	\N	ecg	0.00390625,1.06244793594112	8sycsF8enM	PxHgYjFpnc
xcXNWDUtwR	2021-05-19 10:53:17.142+00	2021-05-19 10:53:17.142+00	\N	\N	ecg	0.0078125,0.875759757505777	8sycsF8enM	PxHgYjFpnc
60KNH8vX7J	2021-05-19 10:53:17.197+00	2021-05-19 10:53:17.197+00	\N	\N	ecg	0.01171875,0.823738951746154	8sycsF8enM	PxHgYjFpnc
vWLnXHllJ1	2021-05-19 10:53:17.245+00	2021-05-19 10:53:17.245+00	\N	\N	ecg	0.015625,0.604728179158279	8sycsF8enM	PxHgYjFpnc
J27XoatW0B	2021-05-19 10:53:17.298+00	2021-05-19 10:53:17.298+00	\N	\N	ecg	0.01953125,0.450252045996394	8sycsF8enM	PxHgYjFpnc
E3QQG7YIVs	2021-05-19 10:53:17.348+00	2021-05-19 10:53:17.348+00	\N	\N	ecg	0.0234375,0.187966012385694	8sycsF8enM	PxHgYjFpnc
ewktAq9ELK	2021-05-19 10:53:17.401+00	2021-05-19 10:53:17.401+00	\N	\N	ecg	0.02734375,-0.0592836927927862	8sycsF8enM	PxHgYjFpnc
uGHMCUWPiY	2021-05-19 10:53:17.45+00	2021-05-19 10:53:17.45+00	\N	\N	ecg	0.03125,-0.233386801821144	8sycsF8enM	PxHgYjFpnc
AE9I5cjjcJ	2021-05-19 10:53:17.499+00	2021-05-19 10:53:17.499+00	\N	\N	ecg	0.03515625,-0.206492786527422	8sycsF8enM	PxHgYjFpnc
wUwKYPTEsL	2021-05-19 10:53:17.55+00	2021-05-19 10:53:17.55+00	\N	\N	ecg	0.0390625,-0.387907012645616	8sycsF8enM	PxHgYjFpnc
7cfRvF3yAr	2021-05-19 10:53:17.604+00	2021-05-19 10:53:17.604+00	\N	\N	ecg	0.04296875,-0.35693074990372	8sycsF8enM	PxHgYjFpnc
Du8VexrqIR	2021-05-19 10:53:17.656+00	2021-05-19 10:53:17.656+00	\N	\N	ecg	0.046875,-0.290222265475376	8sycsF8enM	PxHgYjFpnc
88FRJQEWBV	2021-05-19 10:53:17.705+00	2021-05-19 10:53:17.705+00	\N	\N	ecg	0.05078125,-0.192017903885469	8sycsF8enM	PxHgYjFpnc
Cm9BkAtLH9	2021-05-19 10:53:17.763+00	2021-05-19 10:53:17.763+00	\N	\N	ecg	0.0546875,-0.277527170112164	8sycsF8enM	PxHgYjFpnc
kOZjSPKlXZ	2021-05-19 10:53:17.817+00	2021-05-19 10:53:17.817+00	\N	\N	ecg	0.05859375,-0.250093220451493	8sycsF8enM	PxHgYjFpnc
sSa4FYA0Wr	2021-05-19 10:53:17.866+00	2021-05-19 10:53:17.866+00	\N	\N	ecg	0.0625,-0.235729070324845	8sycsF8enM	PxHgYjFpnc
Jst8lQMV9G	2021-05-19 10:53:17.919+00	2021-05-19 10:53:17.919+00	\N	\N	ecg	0.06640625,-0.059024185306969	8sycsF8enM	PxHgYjFpnc
CjZnDFuKtp	2021-05-19 10:53:17.97+00	2021-05-19 10:53:17.97+00	\N	\N	ecg	0.0703125,-0.0428235239163977	8sycsF8enM	PxHgYjFpnc
IZgepJew1n	2021-05-19 10:53:18.021+00	2021-05-19 10:53:18.021+00	\N	\N	ecg	0.07421875,0.0194783311918042	8sycsF8enM	PxHgYjFpnc
5NkALlK94f	2021-05-19 10:53:18.07+00	2021-05-19 10:53:18.07+00	\N	\N	ecg	0.078125,-0.131853851051741	8sycsF8enM	PxHgYjFpnc
YkSDSdGQgy	2021-05-19 10:53:18.122+00	2021-05-19 10:53:18.122+00	\N	\N	ecg	0.08203125,-0.0806966713945835	8sycsF8enM	PxHgYjFpnc
VdbdU85s3b	2021-05-19 10:53:18.176+00	2021-05-19 10:53:18.176+00	\N	\N	ecg	0.0859375,-0.045575810958973	8sycsF8enM	PxHgYjFpnc
uE7QKTJmrr	2021-05-19 10:53:18.223+00	2021-05-19 10:53:18.223+00	\N	\N	ecg	0.08984375,-0.0498133966754605	8sycsF8enM	PxHgYjFpnc
FAN0cAiE9B	2021-05-19 10:53:18.277+00	2021-05-19 10:53:18.277+00	\N	\N	ecg	0.09375,0.0286909842798259	8sycsF8enM	PxHgYjFpnc
UBtwKtZAMs	2021-05-19 10:53:18.324+00	2021-05-19 10:53:18.324+00	\N	\N	ecg	0.09765625,-0.101691429951695	8sycsF8enM	PxHgYjFpnc
fyTYOgOXDG	2021-05-19 10:53:18.379+00	2021-05-19 10:53:18.379+00	\N	\N	ecg	0.1015625,0.0688875623691073	8sycsF8enM	PxHgYjFpnc
NEuSODjsv3	2021-05-19 10:53:18.427+00	2021-05-19 10:53:18.427+00	\N	\N	ecg	0.10546875,-0.0341086571432948	8sycsF8enM	PxHgYjFpnc
0WtFUZEcib	2021-05-19 10:53:18.478+00	2021-05-19 10:53:18.478+00	\N	\N	ecg	0.109375,-0.00354894593836948	8sycsF8enM	PxHgYjFpnc
ZpNYLgh66d	2021-05-19 10:53:18.528+00	2021-05-19 10:53:18.528+00	\N	\N	ecg	0.11328125,0.0292451353128132	8sycsF8enM	PxHgYjFpnc
P3cnjeYfiN	2021-05-19 10:53:18.584+00	2021-05-19 10:53:18.584+00	\N	\N	ecg	0.1171875,-0.00373658554987735	8sycsF8enM	PxHgYjFpnc
mEhQoRVgl7	2021-05-19 10:53:18.631+00	2021-05-19 10:53:18.631+00	\N	\N	ecg	0.12109375,-0.0450412238007426	8sycsF8enM	PxHgYjFpnc
1zkoBYBu3P	2021-05-19 10:53:18.679+00	2021-05-19 10:53:18.679+00	\N	\N	ecg	0.125,0.0992968646039004	8sycsF8enM	PxHgYjFpnc
jAu8FAmK0Z	2021-05-19 10:53:18.757+00	2021-05-19 10:53:18.757+00	\N	\N	ecg	0.12890625,-0.0210341503077046	8sycsF8enM	PxHgYjFpnc
zhLnvoUgJA	2021-05-19 10:53:18.826+00	2021-05-19 10:53:18.826+00	\N	\N	ecg	0.1328125,0.0671065812014678	8sycsF8enM	PxHgYjFpnc
4ORwGztI9A	2021-05-19 10:53:18.845+00	2021-05-19 10:53:18.845+00	\N	\N	ecg	0.13671875,0.11481088862095	8sycsF8enM	PxHgYjFpnc
HeUMjbtyek	2021-05-19 10:53:18.894+00	2021-05-19 10:53:18.894+00	\N	\N	ecg	0.140625,0.0343380699276404	8sycsF8enM	PxHgYjFpnc
r9g9BD7zxy	2021-05-19 10:53:18.945+00	2021-05-19 10:53:18.945+00	\N	\N	ecg	0.14453125,0.171373661560386	8sycsF8enM	PxHgYjFpnc
AVC1hXEHY1	2021-05-19 10:53:18.994+00	2021-05-19 10:53:18.994+00	\N	\N	ecg	0.1484375,0.0218884515978358	8sycsF8enM	PxHgYjFpnc
AJc37eSEka	2021-05-19 10:53:19.043+00	2021-05-19 10:53:19.043+00	\N	\N	ecg	0.15234375,0.135763401042889	8sycsF8enM	PxHgYjFpnc
BcLoUpplir	2021-05-19 10:53:19.097+00	2021-05-19 10:53:19.097+00	\N	\N	ecg	0.15625,0.178347881143365	8sycsF8enM	PxHgYjFpnc
nmwh5V5SfJ	2021-05-19 10:53:19.146+00	2021-05-19 10:53:19.146+00	\N	\N	ecg	0.16015625,0.0700744935663874	8sycsF8enM	PxHgYjFpnc
f6IHAeWDI1	2021-05-19 10:53:19.2+00	2021-05-19 10:53:19.2+00	\N	\N	ecg	0.1640625,0.126583310783601	8sycsF8enM	PxHgYjFpnc
CNNgBmMeoy	2021-05-19 10:53:19.251+00	2021-05-19 10:53:19.251+00	\N	\N	ecg	0.16796875,0.250651516668627	8sycsF8enM	PxHgYjFpnc
kjycG5spMz	2021-05-19 10:53:19.303+00	2021-05-19 10:53:19.303+00	\N	\N	ecg	0.171875,0.11405003651	8sycsF8enM	PxHgYjFpnc
BTuT0hvczL	2021-05-19 10:53:19.353+00	2021-05-19 10:53:19.353+00	\N	\N	ecg	0.17578125,0.239882169940308	8sycsF8enM	PxHgYjFpnc
wVbZoq7kzU	2021-05-19 10:53:19.404+00	2021-05-19 10:53:19.404+00	\N	\N	ecg	0.1796875,0.159191582015438	8sycsF8enM	PxHgYjFpnc
lDuaszR3CW	2021-05-19 10:53:19.455+00	2021-05-19 10:53:19.455+00	\N	\N	ecg	0.18359375,0.145765935143261	8sycsF8enM	PxHgYjFpnc
6OOP2aTEuz	2021-05-19 10:53:19.504+00	2021-05-19 10:53:19.504+00	\N	\N	ecg	0.1875,0.204971215889314	8sycsF8enM	PxHgYjFpnc
MYL097cT3E	2021-05-19 10:53:19.557+00	2021-05-19 10:53:19.557+00	\N	\N	ecg	0.19140625,0.247349096907832	8sycsF8enM	PxHgYjFpnc
DVLo3yNPag	2021-05-19 10:53:19.608+00	2021-05-19 10:53:19.608+00	\N	\N	ecg	0.1953125,0.37358488367951	8sycsF8enM	PxHgYjFpnc
de7RBL5P1M	2021-05-19 10:53:19.657+00	2021-05-19 10:53:19.657+00	\N	\N	ecg	0.19921875,0.237401212308442	8sycsF8enM	PxHgYjFpnc
2fOotxQGtr	2021-05-19 10:53:19.706+00	2021-05-19 10:53:19.706+00	\N	\N	ecg	0.203125,0.399070054102479	8sycsF8enM	PxHgYjFpnc
wO586dDp1H	2021-05-19 10:53:19.758+00	2021-05-19 10:53:19.758+00	\N	\N	ecg	0.20703125,0.345663533588839	8sycsF8enM	PxHgYjFpnc
hsuaqNDtT1	2021-05-19 10:53:19.811+00	2021-05-19 10:53:19.811+00	\N	\N	ecg	0.2109375,0.421630562459038	8sycsF8enM	PxHgYjFpnc
DeUQWAocbY	2021-05-19 10:53:19.861+00	2021-05-19 10:53:19.861+00	\N	\N	ecg	0.21484375,0.408571667473728	8sycsF8enM	PxHgYjFpnc
MpvXBTAKdE	2021-05-19 10:53:19.913+00	2021-05-19 10:53:19.913+00	\N	\N	ecg	0.21875,0.326508748625089	8sycsF8enM	PxHgYjFpnc
9UuP3PGIiG	2021-05-19 10:53:19.962+00	2021-05-19 10:53:19.962+00	\N	\N	ecg	0.22265625,0.453684747853945	8sycsF8enM	PxHgYjFpnc
W5FByguBwG	2021-05-19 10:53:20.015+00	2021-05-19 10:53:20.015+00	\N	\N	ecg	0.2265625,0.402663390443594	8sycsF8enM	PxHgYjFpnc
gw3iZzazqN	2021-05-19 10:53:20.066+00	2021-05-19 10:53:20.066+00	\N	\N	ecg	0.23046875,0.454747407531027	8sycsF8enM	PxHgYjFpnc
G5ueXTX4aT	2021-05-19 10:53:20.115+00	2021-05-19 10:53:20.115+00	\N	\N	ecg	0.234375,0.410165185665853	8sycsF8enM	PxHgYjFpnc
znnUWpVwfn	2021-05-19 10:53:20.165+00	2021-05-19 10:53:20.165+00	\N	\N	ecg	0.23828125,0.335879947892884	8sycsF8enM	PxHgYjFpnc
nZ8OBlJhFv	2021-05-19 10:53:20.215+00	2021-05-19 10:53:20.215+00	\N	\N	ecg	0.2421875,0.338521936402238	8sycsF8enM	PxHgYjFpnc
lz0IAWULx3	2021-05-19 10:53:20.265+00	2021-05-19 10:53:20.265+00	\N	\N	ecg	0.24609375,0.480067383046126	8sycsF8enM	PxHgYjFpnc
iB9ZMuJSbM	2021-05-19 10:53:20.317+00	2021-05-19 10:53:20.317+00	\N	\N	ecg	0.25,0.444931717265355	8sycsF8enM	PxHgYjFpnc
X4hsFXxOXA	2021-05-19 10:53:20.367+00	2021-05-19 10:53:20.367+00	\N	\N	ecg	0.25390625,0.420641810193508	8sycsF8enM	PxHgYjFpnc
qRU98icWB8	2021-05-19 10:53:20.418+00	2021-05-19 10:53:20.418+00	\N	\N	ecg	0.2578125,0.316493445668136	8sycsF8enM	PxHgYjFpnc
2zy3FwsFLr	2021-05-19 10:53:20.47+00	2021-05-19 10:53:20.47+00	\N	\N	ecg	0.26171875,0.309922380841522	8sycsF8enM	PxHgYjFpnc
k9gNV7NjhU	2021-05-19 10:53:20.521+00	2021-05-19 10:53:20.521+00	\N	\N	ecg	0.265625,0.279488900817205	8sycsF8enM	PxHgYjFpnc
h2UtwSleKa	2021-05-19 10:53:20.571+00	2021-05-19 10:53:20.571+00	\N	\N	ecg	0.26953125,0.315024095161497	8sycsF8enM	PxHgYjFpnc
i8BfEpG7BD	2021-05-19 10:53:20.621+00	2021-05-19 10:53:20.621+00	\N	\N	ecg	0.2734375,0.320330790998883	8sycsF8enM	PxHgYjFpnc
A981wk3LHw	2021-05-19 10:53:20.673+00	2021-05-19 10:53:20.673+00	\N	\N	ecg	0.27734375,0.370425008099375	8sycsF8enM	PxHgYjFpnc
5DEODKBFM4	2021-05-19 10:53:20.723+00	2021-05-19 10:53:20.723+00	\N	\N	ecg	0.28125,0.387059137355977	8sycsF8enM	PxHgYjFpnc
q9yyGl5OzM	2021-05-19 10:53:20.774+00	2021-05-19 10:53:20.774+00	\N	\N	ecg	0.28515625,0.312637095674988	8sycsF8enM	PxHgYjFpnc
F8XxFvOj1X	2021-05-19 10:53:20.824+00	2021-05-19 10:53:20.824+00	\N	\N	ecg	0.2890625,0.294533411534843	8sycsF8enM	PxHgYjFpnc
CiW3hOFsNO	2021-05-19 10:53:20.876+00	2021-05-19 10:53:20.876+00	\N	\N	ecg	0.29296875,0.302799410682013	8sycsF8enM	PxHgYjFpnc
EhMQBLf7yU	2021-05-19 10:53:20.925+00	2021-05-19 10:53:20.925+00	\N	\N	ecg	0.296875,0.179773410836103	8sycsF8enM	PxHgYjFpnc
ILLJCczdKn	2021-05-19 10:53:20.978+00	2021-05-19 10:53:20.978+00	\N	\N	ecg	0.30078125,0.276255214340195	8sycsF8enM	PxHgYjFpnc
Ivmnql4zA3	2021-05-19 10:53:21.027+00	2021-05-19 10:53:21.027+00	\N	\N	ecg	0.3046875,0.161100726368793	8sycsF8enM	PxHgYjFpnc
BoGMXatFnR	2021-05-19 10:53:21.077+00	2021-05-19 10:53:21.077+00	\N	\N	ecg	0.30859375,0.284264424904188	8sycsF8enM	PxHgYjFpnc
QZePy1zHMS	2021-05-19 10:53:21.127+00	2021-05-19 10:53:21.127+00	\N	\N	ecg	0.3125,0.198367800813536	8sycsF8enM	PxHgYjFpnc
1O5os4PBb8	2021-05-19 10:53:21.178+00	2021-05-19 10:53:21.178+00	\N	\N	ecg	0.31640625,0.0966300820930321	8sycsF8enM	PxHgYjFpnc
cyUx6TMZDu	2021-05-19 10:53:21.229+00	2021-05-19 10:53:21.229+00	\N	\N	ecg	0.3203125,0.0836706917542261	8sycsF8enM	PxHgYjFpnc
FoFgkMWiNn	2021-05-19 10:53:21.279+00	2021-05-19 10:53:21.279+00	\N	\N	ecg	0.32421875,0.109200631654795	8sycsF8enM	PxHgYjFpnc
QCwDzjGifA	2021-05-19 10:53:21.331+00	2021-05-19 10:53:21.331+00	\N	\N	ecg	0.328125,0.094076257896318	8sycsF8enM	PxHgYjFpnc
mb9CvFVAKm	2021-05-19 10:53:21.382+00	2021-05-19 10:53:21.382+00	\N	\N	ecg	0.33203125,0.0340272894121502	8sycsF8enM	PxHgYjFpnc
CZXKnLH0oC	2021-05-19 10:53:21.432+00	2021-05-19 10:53:21.432+00	\N	\N	ecg	0.3359375,0.181006962891072	8sycsF8enM	PxHgYjFpnc
WJao1dW1uT	2021-05-19 10:53:21.483+00	2021-05-19 10:53:21.483+00	\N	\N	ecg	0.33984375,0.166189492901873	8sycsF8enM	PxHgYjFpnc
ZZX59n89wN	2021-05-19 10:53:21.532+00	2021-05-19 10:53:21.532+00	\N	\N	ecg	0.34375,-0.0134765328778534	8sycsF8enM	PxHgYjFpnc
D7djusBlp6	2021-05-19 10:53:21.585+00	2021-05-19 10:53:21.585+00	\N	\N	ecg	0.34765625,0.154011479402941	8sycsF8enM	PxHgYjFpnc
eQTqcn4tDb	2021-05-19 10:53:21.635+00	2021-05-19 10:53:21.635+00	\N	\N	ecg	0.3515625,0.0554861408141964	8sycsF8enM	PxHgYjFpnc
O030glyAJk	2021-05-19 10:53:21.685+00	2021-05-19 10:53:21.685+00	\N	\N	ecg	0.35546875,0.0335430313062925	8sycsF8enM	PxHgYjFpnc
xitLaV1Eaf	2021-05-19 10:53:21.736+00	2021-05-19 10:53:21.736+00	\N	\N	ecg	0.359375,-0.0305423381088788	8sycsF8enM	PxHgYjFpnc
qvj8hd7E5D	2021-05-19 10:53:21.787+00	2021-05-19 10:53:21.787+00	\N	\N	ecg	0.36328125,0.0050385631803817	8sycsF8enM	PxHgYjFpnc
86yFL1BwED	2021-05-19 10:53:21.837+00	2021-05-19 10:53:21.837+00	\N	\N	ecg	0.3671875,-0.0310119032252117	8sycsF8enM	PxHgYjFpnc
uiriCdfdoD	2021-05-19 10:53:21.889+00	2021-05-19 10:53:21.889+00	\N	\N	ecg	0.37109375,-0.0085589146683882	8sycsF8enM	PxHgYjFpnc
FuaZfeNJw3	2021-05-19 10:53:21.94+00	2021-05-19 10:53:21.94+00	\N	\N	ecg	0.375,-0.0413570845218212	8sycsF8enM	PxHgYjFpnc
VHk02zGHUm	2021-05-19 10:53:21.991+00	2021-05-19 10:53:21.991+00	\N	\N	ecg	0.37890625,0.0882271548048075	8sycsF8enM	PxHgYjFpnc
jwR1FobErk	2021-05-19 10:53:22.04+00	2021-05-19 10:53:22.04+00	\N	\N	ecg	0.3828125,0.00280616873407654	8sycsF8enM	PxHgYjFpnc
AGsxTt8lq5	2021-05-19 10:53:22.094+00	2021-05-19 10:53:22.094+00	\N	\N	ecg	0.38671875,-0.0736756310882781	8sycsF8enM	PxHgYjFpnc
E39UbFUutZ	2021-05-19 10:53:22.141+00	2021-05-19 10:53:22.141+00	\N	\N	ecg	0.390625,-0.046991675110333	8sycsF8enM	PxHgYjFpnc
qWWrEvl4IJ	2021-05-19 10:53:22.195+00	2021-05-19 10:53:22.195+00	\N	\N	ecg	0.39453125,-0.00947655728589637	8sycsF8enM	PxHgYjFpnc
fO4ZuplDza	2021-05-19 10:53:22.245+00	2021-05-19 10:53:22.245+00	\N	\N	ecg	0.3984375,-0.117730609031758	8sycsF8enM	PxHgYjFpnc
Ll7K6VfR0j	2021-05-19 10:53:22.295+00	2021-05-19 10:53:22.295+00	\N	\N	ecg	0.40234375,-0.120381648711539	8sycsF8enM	PxHgYjFpnc
lbmuT1HWC9	2021-05-19 10:53:22.345+00	2021-05-19 10:53:22.345+00	\N	\N	ecg	0.40625,0.0452457250836829	8sycsF8enM	PxHgYjFpnc
WdkHCNIX3y	2021-05-19 10:53:22.398+00	2021-05-19 10:53:22.398+00	\N	\N	ecg	0.41015625,-0.13803790404141	8sycsF8enM	PxHgYjFpnc
LfkVpTPpzC	2021-05-19 10:53:22.448+00	2021-05-19 10:53:22.448+00	\N	\N	ecg	0.4140625,0.022700142726962	8sycsF8enM	PxHgYjFpnc
cNlxVaZUN1	2021-05-19 10:53:22.498+00	2021-05-19 10:53:22.498+00	\N	\N	ecg	0.41796875,-0.121632858316668	8sycsF8enM	PxHgYjFpnc
W9pm1fhR5W	2021-05-19 10:53:22.55+00	2021-05-19 10:53:22.55+00	\N	\N	ecg	0.421875,-0.0877866607033838	8sycsF8enM	PxHgYjFpnc
yve9bXa1fM	2021-05-19 10:53:22.599+00	2021-05-19 10:53:22.599+00	\N	\N	ecg	0.42578125,-0.142284280941236	8sycsF8enM	PxHgYjFpnc
8hHEt1jFaJ	2021-05-19 10:53:22.65+00	2021-05-19 10:53:22.65+00	\N	\N	ecg	0.4296875,-0.0438381338450631	8sycsF8enM	PxHgYjFpnc
KUxIQejXgD	2021-05-19 10:53:22.701+00	2021-05-19 10:53:22.701+00	\N	\N	ecg	0.43359375,0.021509645885696	8sycsF8enM	PxHgYjFpnc
CxJ8yMjzJT	2021-05-19 10:53:22.751+00	2021-05-19 10:53:22.751+00	\N	\N	ecg	0.4375,-0.027263162496985	8sycsF8enM	PxHgYjFpnc
KQFFD4WU7d	2021-05-19 10:53:22.802+00	2021-05-19 10:53:22.802+00	\N	\N	ecg	0.44140625,-0.0585229040973365	8sycsF8enM	PxHgYjFpnc
h9jkIwDMFH	2021-05-19 10:53:22.855+00	2021-05-19 10:53:22.855+00	\N	\N	ecg	0.4453125,0.0528362007139422	8sycsF8enM	PxHgYjFpnc
ArORs81ZZP	2021-05-19 10:53:22.906+00	2021-05-19 10:53:22.906+00	\N	\N	ecg	0.44921875,-0.0415359512716529	8sycsF8enM	PxHgYjFpnc
PYdBzJd8wt	2021-05-19 10:53:22.958+00	2021-05-19 10:53:22.958+00	\N	\N	ecg	0.453125,-0.0664070847931159	8sycsF8enM	PxHgYjFpnc
nAb0YgqU2d	2021-05-19 10:53:23.008+00	2021-05-19 10:53:23.008+00	\N	\N	ecg	0.45703125,-0.085265913616269	8sycsF8enM	PxHgYjFpnc
CsCZchIJny	2021-05-19 10:53:23.058+00	2021-05-19 10:53:23.058+00	\N	\N	ecg	0.4609375,0.0170288687324424	8sycsF8enM	PxHgYjFpnc
KiPXFkKAEx	2021-05-19 10:53:23.109+00	2021-05-19 10:53:23.109+00	\N	\N	ecg	0.46484375,-0.0994135063240511	8sycsF8enM	PxHgYjFpnc
hx5J2IpjdI	2021-05-19 10:53:23.16+00	2021-05-19 10:53:23.16+00	\N	\N	ecg	0.46875,-0.0914474894169695	8sycsF8enM	PxHgYjFpnc
RE6vWUkUVH	2021-05-19 10:53:23.211+00	2021-05-19 10:53:23.211+00	\N	\N	ecg	0.47265625,0.0573887084220024	8sycsF8enM	PxHgYjFpnc
NG25adiCYy	2021-05-19 10:53:23.262+00	2021-05-19 10:53:23.262+00	\N	\N	ecg	0.4765625,-0.139721554462703	8sycsF8enM	PxHgYjFpnc
MCutaDZHMt	2021-05-19 10:53:23.322+00	2021-05-19 10:53:23.322+00	\N	\N	ecg	0.48046875,-0.103318531963274	8sycsF8enM	PxHgYjFpnc
QmZ44TkX0R	2021-05-19 10:53:23.381+00	2021-05-19 10:53:23.381+00	\N	\N	ecg	0.484375,0.059615075962462	8sycsF8enM	PxHgYjFpnc
VHIBlF0G0E	2021-05-19 10:53:23.429+00	2021-05-19 10:53:23.429+00	\N	\N	ecg	0.48828125,-0.0937670038975264	8sycsF8enM	PxHgYjFpnc
MASyVNb0cX	2021-05-19 10:53:23.476+00	2021-05-19 10:53:23.476+00	\N	\N	ecg	0.4921875,0.0444557533055442	8sycsF8enM	PxHgYjFpnc
4cn8AkPoGo	2021-05-19 10:53:23.527+00	2021-05-19 10:53:23.527+00	\N	\N	ecg	0.49609375,-0.0555677239651816	8sycsF8enM	PxHgYjFpnc
470HxnsH90	2021-05-19 10:53:23.578+00	2021-05-19 10:53:23.578+00	\N	\N	ecg	0.5,-0.0158356480141744	8sycsF8enM	PxHgYjFpnc
8bfjwvYGpU	2021-05-19 10:53:23.629+00	2021-05-19 10:53:23.629+00	\N	\N	ecg	0.50390625,0.0452806581720361	8sycsF8enM	PxHgYjFpnc
aTrgHNeH0O	2021-05-19 10:53:23.679+00	2021-05-19 10:53:23.679+00	\N	\N	ecg	0.5078125,-0.0971565334284623	8sycsF8enM	PxHgYjFpnc
mxHTha29Rq	2021-05-19 10:53:23.729+00	2021-05-19 10:53:23.729+00	\N	\N	ecg	0.51171875,-0.0951167169061745	8sycsF8enM	PxHgYjFpnc
hNJECHHdLW	2021-05-19 10:53:23.782+00	2021-05-19 10:53:23.782+00	\N	\N	ecg	0.515625,-0.124630870192969	8sycsF8enM	PxHgYjFpnc
Zhe04E9730	2021-05-19 10:53:23.83+00	2021-05-19 10:53:23.83+00	\N	\N	ecg	0.51953125,0.0558887387699032	8sycsF8enM	PxHgYjFpnc
XDpgZOpBFi	2021-05-19 10:53:23.88+00	2021-05-19 10:53:23.88+00	\N	\N	ecg	0.5234375,-0.115493469465828	8sycsF8enM	PxHgYjFpnc
PVPKwqURFW	2021-05-19 10:53:23.933+00	2021-05-19 10:53:23.933+00	\N	\N	ecg	0.52734375,-0.0677631915313475	8sycsF8enM	PxHgYjFpnc
VKMkOUhJiq	2021-05-19 10:53:23.984+00	2021-05-19 10:53:23.984+00	\N	\N	ecg	0.53125,-0.0858273237588429	8sycsF8enM	PxHgYjFpnc
0nlWzWHHwA	2021-05-19 10:53:24.034+00	2021-05-19 10:53:24.034+00	\N	\N	ecg	0.53515625,-0.0131629912193893	8sycsF8enM	PxHgYjFpnc
dgfxpnofDC	2021-05-19 10:53:24.085+00	2021-05-19 10:53:24.085+00	\N	\N	ecg	0.5390625,-0.0441037763206974	8sycsF8enM	PxHgYjFpnc
oYzqwXkXL1	2021-05-19 10:53:24.134+00	2021-05-19 10:53:24.134+00	\N	\N	ecg	0.54296875,-0.0898557529407844	8sycsF8enM	PxHgYjFpnc
Gqd0TymrlM	2021-05-19 10:53:24.191+00	2021-05-19 10:53:24.191+00	\N	\N	ecg	0.546875,-0.0363553080942667	8sycsF8enM	PxHgYjFpnc
jriSTmzGOl	2021-05-19 10:53:24.238+00	2021-05-19 10:53:24.238+00	\N	\N	ecg	0.55078125,-0.0771366935216973	8sycsF8enM	PxHgYjFpnc
GFUl0EDgVa	2021-05-19 10:53:24.29+00	2021-05-19 10:53:24.29+00	\N	\N	ecg	0.5546875,0.0559029316290867	8sycsF8enM	PxHgYjFpnc
muxH02cGGE	2021-05-19 10:53:24.339+00	2021-05-19 10:53:24.339+00	\N	\N	ecg	0.55859375,0.0231597739768244	8sycsF8enM	PxHgYjFpnc
vgJNcQZnn4	2021-05-19 10:53:24.389+00	2021-05-19 10:53:24.389+00	\N	\N	ecg	0.5625,-0.0807222722533805	8sycsF8enM	PxHgYjFpnc
hpxRvc4zdn	2021-05-19 10:53:24.441+00	2021-05-19 10:53:24.441+00	\N	\N	ecg	0.56640625,-0.0101844006197011	8sycsF8enM	PxHgYjFpnc
ppNzkenJgb	2021-05-19 10:53:24.491+00	2021-05-19 10:53:24.491+00	\N	\N	ecg	0.5703125,0.0237084093192928	8sycsF8enM	PxHgYjFpnc
BBYGOSGGh3	2021-05-19 10:53:24.541+00	2021-05-19 10:53:24.541+00	\N	\N	ecg	0.57421875,-0.0907511717619149	8sycsF8enM	PxHgYjFpnc
GnVwwpG7ld	2021-05-19 10:53:24.594+00	2021-05-19 10:53:24.594+00	\N	\N	ecg	0.578125,-0.0911970637256693	8sycsF8enM	PxHgYjFpnc
vDStl1LIBC	2021-05-19 10:53:24.643+00	2021-05-19 10:53:24.643+00	\N	\N	ecg	0.58203125,-0.0589254128710708	8sycsF8enM	PxHgYjFpnc
yxkPyibpiA	2021-05-19 10:53:24.694+00	2021-05-19 10:53:24.694+00	\N	\N	ecg	0.5859375,-0.0665505101506306	8sycsF8enM	PxHgYjFpnc
WVxsofcBfx	2021-05-19 10:53:24.745+00	2021-05-19 10:53:24.745+00	\N	\N	ecg	0.58984375,-0.00681759073876825	8sycsF8enM	PxHgYjFpnc
c8DpIf6Dsl	2021-05-19 10:53:24.796+00	2021-05-19 10:53:24.796+00	\N	\N	ecg	0.59375,-0.0997773010278427	8sycsF8enM	PxHgYjFpnc
MA2Dj3oZK4	2021-05-19 10:53:24.848+00	2021-05-19 10:53:24.848+00	\N	\N	ecg	0.59765625,0.0829647143113702	8sycsF8enM	PxHgYjFpnc
8OwZpm8p4L	2021-05-19 10:53:24.897+00	2021-05-19 10:53:24.897+00	\N	\N	ecg	0.6015625,0.0603826463996578	8sycsF8enM	PxHgYjFpnc
BqTp8SS0PU	2021-05-19 10:53:24.948+00	2021-05-19 10:53:24.948+00	\N	\N	ecg	0.60546875,-0.0453164990299239	8sycsF8enM	PxHgYjFpnc
PNHAyrGDKk	2021-05-19 10:53:25.001+00	2021-05-19 10:53:25.001+00	\N	\N	ecg	0.609375,0.044699166943504	8sycsF8enM	PxHgYjFpnc
TFzpwG8Bf7	2021-05-19 10:53:25.049+00	2021-05-19 10:53:25.049+00	\N	\N	ecg	0.61328125,-0.0630556407049914	8sycsF8enM	PxHgYjFpnc
KzGwsyi6P0	2021-05-19 10:53:25.103+00	2021-05-19 10:53:25.103+00	\N	\N	ecg	0.6171875,-0.0621335284475862	8sycsF8enM	PxHgYjFpnc
OGZTnHAErJ	2021-05-19 10:53:25.152+00	2021-05-19 10:53:25.152+00	\N	\N	ecg	0.62109375,-0.0488954905998347	8sycsF8enM	PxHgYjFpnc
4FN6HrGb3w	2021-05-19 10:53:25.204+00	2021-05-19 10:53:25.204+00	\N	\N	ecg	0.625,0.0751324462188925	8sycsF8enM	PxHgYjFpnc
Rucz7Stx5h	2021-05-19 10:53:25.253+00	2021-05-19 10:53:25.253+00	\N	\N	ecg	0.62890625,-0.00188934887938398	8sycsF8enM	PxHgYjFpnc
wRCMAEuaAB	2021-05-19 10:53:25.303+00	2021-05-19 10:53:25.303+00	\N	\N	ecg	0.6328125,-0.0265907425432962	8sycsF8enM	PxHgYjFpnc
68jU4yg5tB	2021-05-19 10:53:25.353+00	2021-05-19 10:53:25.353+00	\N	\N	ecg	0.63671875,0.0638525097770323	8sycsF8enM	PxHgYjFpnc
IdJa717PED	2021-05-19 10:53:25.406+00	2021-05-19 10:53:25.406+00	\N	\N	ecg	0.640625,-0.0298996422801941	8sycsF8enM	PxHgYjFpnc
HyKZaWEHC0	2021-05-19 10:53:25.456+00	2021-05-19 10:53:25.456+00	\N	\N	ecg	0.64453125,0.0392370740443337	8sycsF8enM	PxHgYjFpnc
AwKyNo3NvF	2021-05-19 10:53:25.506+00	2021-05-19 10:53:25.506+00	\N	\N	ecg	0.6484375,-0.0371911865037357	8sycsF8enM	PxHgYjFpnc
l1Ble5otPp	2021-05-19 10:53:25.557+00	2021-05-19 10:53:25.557+00	\N	\N	ecg	0.65234375,0.0275619973003453	8sycsF8enM	PxHgYjFpnc
LnsXsnsDil	2021-05-19 10:53:25.606+00	2021-05-19 10:53:25.606+00	\N	\N	ecg	0.65625,-0.0536530681139482	8sycsF8enM	PxHgYjFpnc
TbBBjRqQxa	2021-05-19 10:53:25.659+00	2021-05-19 10:53:25.659+00	\N	\N	ecg	0.66015625,-0.0192728154324219	8sycsF8enM	PxHgYjFpnc
0GfekVCqEb	2021-05-19 10:53:25.71+00	2021-05-19 10:53:25.71+00	\N	\N	ecg	0.6640625,-0.0208584609344444	8sycsF8enM	PxHgYjFpnc
mvrPD8YSIW	2021-05-19 10:53:25.765+00	2021-05-19 10:53:25.765+00	\N	\N	ecg	0.66796875,-0.0505181087801421	8sycsF8enM	PxHgYjFpnc
y86tCZCLTz	2021-05-19 10:53:25.811+00	2021-05-19 10:53:25.811+00	\N	\N	ecg	0.671875,-0.0198608211300341	8sycsF8enM	PxHgYjFpnc
plVuqJg2C8	2021-05-19 10:53:25.863+00	2021-05-19 10:53:25.863+00	\N	\N	ecg	0.67578125,-0.00536604985980523	8sycsF8enM	PxHgYjFpnc
rWQKelb3aY	2021-05-19 10:53:25.915+00	2021-05-19 10:53:25.915+00	\N	\N	ecg	0.6796875,-0.00678395331308003	8sycsF8enM	PxHgYjFpnc
PPWzeQ5g8s	2021-05-19 10:53:25.963+00	2021-05-19 10:53:25.963+00	\N	\N	ecg	0.68359375,-0.0153865043130764	8sycsF8enM	PxHgYjFpnc
FEu9mEjM8S	2021-05-19 10:53:26.015+00	2021-05-19 10:53:26.015+00	\N	\N	ecg	0.6875,0.0826131786726928	8sycsF8enM	PxHgYjFpnc
HuA7nuTzsu	2021-05-19 10:53:26.065+00	2021-05-19 10:53:26.065+00	\N	\N	ecg	0.69140625,-0.0657794922748262	8sycsF8enM	PxHgYjFpnc
EGqTQ9fNaN	2021-05-19 10:53:26.116+00	2021-05-19 10:53:26.116+00	\N	\N	ecg	0.6953125,0.0144229548256896	8sycsF8enM	PxHgYjFpnc
zMJ9aS1k9D	2021-05-19 10:53:26.168+00	2021-05-19 10:53:26.168+00	\N	\N	ecg	0.69921875,0.0964051724313587	8sycsF8enM	PxHgYjFpnc
HFAEisIJid	2021-05-19 10:53:26.22+00	2021-05-19 10:53:26.22+00	\N	\N	ecg	0.703125,-0.0259311850083524	8sycsF8enM	PxHgYjFpnc
uCPx2SEmR7	2021-05-19 10:53:26.269+00	2021-05-19 10:53:26.269+00	\N	\N	ecg	0.70703125,-0.0861710658390892	8sycsF8enM	PxHgYjFpnc
wLDwG0oEbA	2021-05-19 10:53:26.324+00	2021-05-19 10:53:26.324+00	\N	\N	ecg	0.7109375,0.10873990519859	8sycsF8enM	PxHgYjFpnc
hmOGSLa4dl	2021-05-19 10:53:26.371+00	2021-05-19 10:53:26.371+00	\N	\N	ecg	0.71484375,-0.0354368880739339	8sycsF8enM	PxHgYjFpnc
WANhUGVTyo	2021-05-19 10:53:26.422+00	2021-05-19 10:53:26.422+00	\N	\N	ecg	0.71875,0.0111402285344782	8sycsF8enM	PxHgYjFpnc
AhgHNLaoiL	2021-05-19 10:53:26.472+00	2021-05-19 10:53:26.472+00	\N	\N	ecg	0.72265625,-0.0454891613525848	8sycsF8enM	PxHgYjFpnc
bqNlCy5bTg	2021-05-19 10:53:26.523+00	2021-05-19 10:53:26.523+00	\N	\N	ecg	0.7265625,-0.00912257595545842	8sycsF8enM	PxHgYjFpnc
CMUHH1Jv9C	2021-05-19 10:53:26.573+00	2021-05-19 10:53:26.573+00	\N	\N	ecg	0.73046875,-0.0680615864745478	8sycsF8enM	PxHgYjFpnc
6H4IWV5vyt	2021-05-19 10:53:26.624+00	2021-05-19 10:53:26.624+00	\N	\N	ecg	0.734375,0.127996753394931	8sycsF8enM	PxHgYjFpnc
YpnFr9w11k	2021-05-19 10:53:26.675+00	2021-05-19 10:53:26.675+00	\N	\N	ecg	0.73828125,0.0997070419554419	8sycsF8enM	PxHgYjFpnc
LtFt308PEm	2021-05-19 10:53:26.727+00	2021-05-19 10:53:26.727+00	\N	\N	ecg	0.7421875,0.123127027347168	8sycsF8enM	PxHgYjFpnc
R1sfaKuudf	2021-05-19 10:53:26.778+00	2021-05-19 10:53:26.778+00	\N	\N	ecg	0.74609375,0.136732783765027	8sycsF8enM	PxHgYjFpnc
dl24uAaUBP	2021-05-19 10:53:26.827+00	2021-05-19 10:53:26.827+00	\N	\N	ecg	0.75,0.0407842622533523	8sycsF8enM	PxHgYjFpnc
sehRPunmjP	2021-05-19 10:53:26.878+00	2021-05-19 10:53:26.878+00	\N	\N	ecg	0.75390625,0.0864737790014718	8sycsF8enM	PxHgYjFpnc
vxblH5Bf61	2021-05-19 10:53:26.934+00	2021-05-19 10:53:26.934+00	\N	\N	ecg	0.7578125,0.096544835028964	8sycsF8enM	PxHgYjFpnc
uCQfkiTcDs	2021-05-19 10:53:26.986+00	2021-05-19 10:53:26.986+00	\N	\N	ecg	0.76171875,0.119136770566511	8sycsF8enM	PxHgYjFpnc
BEkFALqeFk	2021-05-19 10:53:27.032+00	2021-05-19 10:53:27.032+00	\N	\N	ecg	0.765625,0.101442564498996	8sycsF8enM	PxHgYjFpnc
bQgmo64bKH	2021-05-19 10:53:27.084+00	2021-05-19 10:53:27.084+00	\N	\N	ecg	0.76953125,0.167309437052069	8sycsF8enM	PxHgYjFpnc
pO5PGuOE0B	2021-05-19 10:53:27.139+00	2021-05-19 10:53:27.139+00	\N	\N	ecg	0.7734375,0.0377353079026451	8sycsF8enM	PxHgYjFpnc
qhtDC4Fr8R	2021-05-19 10:53:27.189+00	2021-05-19 10:53:27.189+00	\N	\N	ecg	0.77734375,0.124293133501512	8sycsF8enM	PxHgYjFpnc
Tpdz8F1LdK	2021-05-19 10:53:27.237+00	2021-05-19 10:53:27.237+00	\N	\N	ecg	0.78125,0.134544307493096	8sycsF8enM	PxHgYjFpnc
tPQAxnNGOQ	2021-05-19 10:53:27.289+00	2021-05-19 10:53:27.289+00	\N	\N	ecg	0.78515625,0.178707155894595	8sycsF8enM	PxHgYjFpnc
NUFm4ME1l9	2021-05-19 10:53:27.339+00	2021-05-19 10:53:27.339+00	\N	\N	ecg	0.7890625,0.142802478724873	8sycsF8enM	PxHgYjFpnc
hNhFjGIlcr	2021-05-19 10:53:27.391+00	2021-05-19 10:53:27.391+00	\N	\N	ecg	0.79296875,0.156542060673886	8sycsF8enM	PxHgYjFpnc
CcHnYFVLuC	2021-05-19 10:53:27.44+00	2021-05-19 10:53:27.44+00	\N	\N	ecg	0.796875,0.295925466495326	8sycsF8enM	PxHgYjFpnc
zzMAtcGbY5	2021-05-19 10:53:27.492+00	2021-05-19 10:53:27.492+00	\N	\N	ecg	0.80078125,0.203004111730433	8sycsF8enM	PxHgYjFpnc
8OnOblBREe	2021-05-19 10:53:27.542+00	2021-05-19 10:53:27.542+00	\N	\N	ecg	0.8046875,0.285204581463664	8sycsF8enM	PxHgYjFpnc
B9UKS0FrBn	2021-05-19 10:53:27.593+00	2021-05-19 10:53:27.593+00	\N	\N	ecg	0.80859375,0.277974916147161	8sycsF8enM	PxHgYjFpnc
yftrs9HOOj	2021-05-19 10:53:27.643+00	2021-05-19 10:53:27.643+00	\N	\N	ecg	0.8125,0.334666544429197	8sycsF8enM	PxHgYjFpnc
cZwVqT51YB	2021-05-19 10:53:27.694+00	2021-05-19 10:53:27.694+00	\N	\N	ecg	0.81640625,0.33902974647277	8sycsF8enM	PxHgYjFpnc
OnhDLTC8pa	2021-05-19 10:53:27.744+00	2021-05-19 10:53:27.744+00	\N	\N	ecg	0.8203125,0.204161476587801	8sycsF8enM	PxHgYjFpnc
DDVIlbarD2	2021-05-19 10:53:27.793+00	2021-05-19 10:53:27.793+00	\N	\N	ecg	0.82421875,0.319574367497006	8sycsF8enM	PxHgYjFpnc
xRd0WLZ14k	2021-05-19 10:53:27.845+00	2021-05-19 10:53:27.845+00	\N	\N	ecg	0.828125,0.389379361899809	8sycsF8enM	PxHgYjFpnc
esa4DM92I2	2021-05-19 10:53:27.897+00	2021-05-19 10:53:27.897+00	\N	\N	ecg	0.83203125,0.386061647726	8sycsF8enM	PxHgYjFpnc
xUpOoirS4C	2021-05-19 10:53:27.947+00	2021-05-19 10:53:27.947+00	\N	\N	ecg	0.8359375,0.261831010039264	8sycsF8enM	PxHgYjFpnc
HqBNN9mPzB	2021-05-19 10:53:27.997+00	2021-05-19 10:53:27.997+00	\N	\N	ecg	0.83984375,0.333939310083479	8sycsF8enM	PxHgYjFpnc
A6quezJ045	2021-05-19 10:53:28.048+00	2021-05-19 10:53:28.048+00	\N	\N	ecg	0.84375,0.182305701008605	8sycsF8enM	PxHgYjFpnc
hQERNQyGyi	2021-05-19 10:53:28.099+00	2021-05-19 10:53:28.099+00	\N	\N	ecg	0.84765625,0.292685051987256	8sycsF8enM	PxHgYjFpnc
KqpAVGm83q	2021-05-19 10:53:28.15+00	2021-05-19 10:53:28.15+00	\N	\N	ecg	0.8515625,0.213812050542015	8sycsF8enM	PxHgYjFpnc
eru8dcC9Z5	2021-05-19 10:53:28.2+00	2021-05-19 10:53:28.2+00	\N	\N	ecg	0.85546875,0.285746439122494	8sycsF8enM	PxHgYjFpnc
s0x4fLtFxo	2021-05-19 10:53:28.252+00	2021-05-19 10:53:28.252+00	\N	\N	ecg	0.859375,0.229004321668699	8sycsF8enM	PxHgYjFpnc
pGH7J2IXxx	2021-05-19 10:53:28.3+00	2021-05-19 10:53:28.3+00	\N	\N	ecg	0.86328125,0.250698118914564	8sycsF8enM	PxHgYjFpnc
UPwAknStcv	2021-05-19 10:53:28.351+00	2021-05-19 10:53:28.351+00	\N	\N	ecg	0.8671875,0.28438780443771	8sycsF8enM	PxHgYjFpnc
FYRoVFkXWM	2021-05-19 10:53:28.402+00	2021-05-19 10:53:28.402+00	\N	\N	ecg	0.87109375,0.133227654191309	8sycsF8enM	PxHgYjFpnc
yVtuRFtiME	2021-05-19 10:53:28.456+00	2021-05-19 10:53:28.456+00	\N	\N	ecg	0.875,0.227394325819718	8sycsF8enM	PxHgYjFpnc
okhioXXFlw	2021-05-19 10:53:28.525+00	2021-05-19 10:53:28.525+00	\N	\N	ecg	0.87890625,0.138843107469857	8sycsF8enM	PxHgYjFpnc
Lk6wXBKDC5	2021-05-19 10:53:28.575+00	2021-05-19 10:53:28.575+00	\N	\N	ecg	0.8828125,0.120521307047579	8sycsF8enM	PxHgYjFpnc
VIbbnIMDzK	2021-05-19 10:53:28.624+00	2021-05-19 10:53:28.624+00	\N	\N	ecg	0.88671875,0.162405386679642	8sycsF8enM	PxHgYjFpnc
1PXtOuz7nb	2021-05-19 10:53:28.675+00	2021-05-19 10:53:28.675+00	\N	\N	ecg	0.890625,0.102135385367308	8sycsF8enM	PxHgYjFpnc
cjb0nlA9x8	2021-05-19 10:53:28.729+00	2021-05-19 10:53:28.729+00	\N	\N	ecg	0.89453125,0.033475768741972	8sycsF8enM	PxHgYjFpnc
ffTPe5WSEM	2021-05-19 10:53:28.781+00	2021-05-19 10:53:28.781+00	\N	\N	ecg	0.8984375,0.132676146304381	8sycsF8enM	PxHgYjFpnc
LBnfzzG7XP	2021-05-19 10:53:28.83+00	2021-05-19 10:53:28.83+00	\N	\N	ecg	0.90234375,-0.00705801161508589	8sycsF8enM	PxHgYjFpnc
6r8eI73nWR	2021-05-19 10:53:28.88+00	2021-05-19 10:53:28.88+00	\N	\N	ecg	0.90625,0.0380674905553353	8sycsF8enM	PxHgYjFpnc
FdZrPJFtVq	2021-05-19 10:53:28.931+00	2021-05-19 10:53:28.931+00	\N	\N	ecg	0.91015625,0.0954089623089891	8sycsF8enM	PxHgYjFpnc
wozdAYuD2e	2021-05-19 10:53:28.982+00	2021-05-19 10:53:28.982+00	\N	\N	ecg	0.9140625,0.0685272779988416	8sycsF8enM	PxHgYjFpnc
zJCeW6IELW	2021-05-19 10:53:29.033+00	2021-05-19 10:53:29.033+00	\N	\N	ecg	0.91796875,-0.0131143574994507	8sycsF8enM	PxHgYjFpnc
jJ8MtyqCsB	2021-05-19 10:53:29.083+00	2021-05-19 10:53:29.083+00	\N	\N	ecg	0.921875,0.0845656473768603	8sycsF8enM	PxHgYjFpnc
Fohx8WdLkQ	2021-05-19 10:53:29.133+00	2021-05-19 10:53:29.133+00	\N	\N	ecg	0.92578125,0.0762124643422892	8sycsF8enM	PxHgYjFpnc
AhgJd4062T	2021-05-19 10:53:29.185+00	2021-05-19 10:53:29.185+00	\N	\N	ecg	0.9296875,-0.0724664569693898	8sycsF8enM	PxHgYjFpnc
esKIdK6SR7	2021-05-19 10:53:29.234+00	2021-05-19 10:53:29.234+00	\N	\N	ecg	0.93359375,-0.161498432952839	8sycsF8enM	PxHgYjFpnc
73kbwva96q	2021-05-19 10:53:29.286+00	2021-05-19 10:53:29.286+00	\N	\N	ecg	0.9375,-0.079727714046906	8sycsF8enM	PxHgYjFpnc
6waNP6ORtD	2021-05-19 10:53:29.336+00	2021-05-19 10:53:29.336+00	\N	\N	ecg	0.94140625,-0.183467751182479	8sycsF8enM	PxHgYjFpnc
qushm5r71L	2021-05-19 10:53:29.388+00	2021-05-19 10:53:29.388+00	\N	\N	ecg	0.9453125,-0.144304425275969	8sycsF8enM	PxHgYjFpnc
o8aZfgMKu7	2021-05-19 10:53:29.44+00	2021-05-19 10:53:29.44+00	\N	\N	ecg	0.94921875,-0.163458658403001	8sycsF8enM	PxHgYjFpnc
IjIiD7nnMM	2021-05-19 10:53:29.488+00	2021-05-19 10:53:29.488+00	\N	\N	ecg	0.953125,-0.0711002446953886	8sycsF8enM	PxHgYjFpnc
j41KjLU6xG	2021-05-19 10:53:29.54+00	2021-05-19 10:53:29.54+00	\N	\N	ecg	0.95703125,-0.140922149572985	8sycsF8enM	PxHgYjFpnc
5MiVYjs9YZ	2021-05-19 10:53:29.59+00	2021-05-19 10:53:29.59+00	\N	\N	ecg	0.9609375,0.0844452792869589	8sycsF8enM	PxHgYjFpnc
kwxwcgasPs	2021-05-19 10:53:29.639+00	2021-05-19 10:53:29.639+00	\N	\N	ecg	0.96484375,0.106514860005852	8sycsF8enM	PxHgYjFpnc
nRbOtyvJDo	2021-05-19 10:53:29.691+00	2021-05-19 10:53:29.691+00	\N	\N	ecg	0.96875,0.232933385838573	8sycsF8enM	PxHgYjFpnc
LHPnGLCJzQ	2021-05-19 10:53:29.741+00	2021-05-19 10:53:29.741+00	\N	\N	ecg	0.97265625,0.399347566621186	8sycsF8enM	PxHgYjFpnc
l92tQpl8Ym	2021-05-19 10:53:29.792+00	2021-05-19 10:53:29.792+00	\N	\N	ecg	0.9765625,0.648487264644577	8sycsF8enM	PxHgYjFpnc
ZwnzzHWj0f	2021-05-19 10:53:29.841+00	2021-05-19 10:53:29.841+00	\N	\N	ecg	0.98046875,0.788939387361108	8sycsF8enM	PxHgYjFpnc
mPQeBGiVxe	2021-05-19 10:53:29.893+00	2021-05-19 10:53:29.893+00	\N	\N	ecg	0.984375,1.06321073401698	8sycsF8enM	PxHgYjFpnc
wIfjGtBTVv	2021-05-19 10:53:29.944+00	2021-05-19 10:53:29.944+00	\N	\N	ecg	0.98828125,1.15679534283234	8sycsF8enM	PxHgYjFpnc
pZZNpMEtHh	2021-05-19 10:53:29.994+00	2021-05-19 10:53:29.994+00	\N	\N	ecg	0.9921875,1.08560398945084	8sycsF8enM	PxHgYjFpnc
l4kcfsyzqh	2021-05-19 10:53:30.044+00	2021-05-19 10:53:30.044+00	\N	\N	ecg	0.99609375,1.06583785466464	8sycsF8enM	PxHgYjFpnc
LwrfvRc2su	2021-05-19 10:53:30.095+00	2021-05-19 10:53:30.095+00	\N	\N	ecg	1.0,1.12705852985289	8sycsF8enM	PxHgYjFpnc
N4dHUnEunu	2021-05-19 10:53:30.146+00	2021-05-19 10:53:30.146+00	\N	\N	ecg	1.00390625,1.06244793594112	8sycsF8enM	PxHgYjFpnc
zghipCLrmy	2021-05-19 10:53:30.196+00	2021-05-19 10:53:30.196+00	\N	\N	ecg	1.0078125,0.875759757505777	8sycsF8enM	PxHgYjFpnc
MzPqihl3n0	2021-05-19 10:53:30.248+00	2021-05-19 10:53:30.248+00	\N	\N	ecg	1.01171875,0.823738951746154	8sycsF8enM	PxHgYjFpnc
DUNQdpeH2j	2021-05-19 10:53:30.297+00	2021-05-19 10:53:30.297+00	\N	\N	ecg	1.015625,0.604728179158279	8sycsF8enM	PxHgYjFpnc
lNrP2UfMHG	2021-05-19 10:53:30.353+00	2021-05-19 10:53:30.353+00	\N	\N	ecg	1.01953125,0.450252045996394	8sycsF8enM	PxHgYjFpnc
0I8laM6e9w	2021-05-19 10:53:30.404+00	2021-05-19 10:53:30.404+00	\N	\N	ecg	1.0234375,0.187966012385694	8sycsF8enM	PxHgYjFpnc
fVbVO0aEQy	2021-05-19 10:53:30.454+00	2021-05-19 10:53:30.454+00	\N	\N	ecg	1.02734375,-0.0592836927927862	8sycsF8enM	PxHgYjFpnc
V9avCaiWxw	2021-05-19 10:53:30.505+00	2021-05-19 10:53:30.505+00	\N	\N	ecg	1.03125,-0.233386801821144	8sycsF8enM	PxHgYjFpnc
bSFpF9gLID	2021-05-19 10:53:30.556+00	2021-05-19 10:53:30.556+00	\N	\N	ecg	1.03515625,-0.206492786527422	8sycsF8enM	PxHgYjFpnc
TySI40VioK	2021-05-19 10:53:30.61+00	2021-05-19 10:53:30.61+00	\N	\N	ecg	1.0390625,-0.387907012645616	8sycsF8enM	PxHgYjFpnc
iaHSCjaUqB	2021-05-19 10:53:30.657+00	2021-05-19 10:53:30.657+00	\N	\N	ecg	1.04296875,-0.35693074990372	8sycsF8enM	PxHgYjFpnc
3E9UQd1s7b	2021-05-19 10:53:30.707+00	2021-05-19 10:53:30.707+00	\N	\N	ecg	1.046875,-0.290222265475376	8sycsF8enM	PxHgYjFpnc
u9EwksRMdG	2021-05-19 10:53:30.76+00	2021-05-19 10:53:30.76+00	\N	\N	ecg	1.05078125,-0.192017903885469	8sycsF8enM	PxHgYjFpnc
dU8J6JueEO	2021-05-19 10:53:30.809+00	2021-05-19 10:53:30.809+00	\N	\N	ecg	1.0546875,-0.277527170112164	8sycsF8enM	PxHgYjFpnc
H6BfYmfsWD	2021-05-19 10:53:30.86+00	2021-05-19 10:53:30.86+00	\N	\N	ecg	1.05859375,-0.250093220451493	8sycsF8enM	PxHgYjFpnc
eEbDlT1TWb	2021-05-19 10:53:30.91+00	2021-05-19 10:53:30.91+00	\N	\N	ecg	1.0625,-0.235729070324845	8sycsF8enM	PxHgYjFpnc
BnHhsD9nBp	2021-05-19 10:53:30.963+00	2021-05-19 10:53:30.963+00	\N	\N	ecg	1.06640625,-0.059024185306969	8sycsF8enM	PxHgYjFpnc
MqIjvbKdAd	2021-05-19 10:53:31.016+00	2021-05-19 10:53:31.016+00	\N	\N	ecg	1.0703125,-0.0428235239163977	8sycsF8enM	PxHgYjFpnc
ihlBe9cPSm	2021-05-19 10:53:31.064+00	2021-05-19 10:53:31.064+00	\N	\N	ecg	1.07421875,0.0194783311918042	8sycsF8enM	PxHgYjFpnc
ADKhKrdZym	2021-05-19 10:53:31.114+00	2021-05-19 10:53:31.114+00	\N	\N	ecg	1.078125,-0.131853851051741	8sycsF8enM	PxHgYjFpnc
tlmiAqeL8F	2021-05-19 10:53:31.165+00	2021-05-19 10:53:31.165+00	\N	\N	ecg	1.08203125,-0.0806966713945835	8sycsF8enM	PxHgYjFpnc
sOBIpf5xUC	2021-05-19 10:53:31.216+00	2021-05-19 10:53:31.216+00	\N	\N	ecg	1.0859375,-0.045575810958973	8sycsF8enM	PxHgYjFpnc
BGVkL41uau	2021-05-19 10:53:31.267+00	2021-05-19 10:53:31.267+00	\N	\N	ecg	1.08984375,-0.0498133966754605	8sycsF8enM	PxHgYjFpnc
wvMtHDZnWZ	2021-05-19 10:53:31.319+00	2021-05-19 10:53:31.319+00	\N	\N	ecg	1.09375,0.0286909842798259	8sycsF8enM	PxHgYjFpnc
7BJwJiB17J	2021-05-19 10:53:31.368+00	2021-05-19 10:53:31.368+00	\N	\N	ecg	1.09765625,-0.101691429951695	8sycsF8enM	PxHgYjFpnc
t0gxCEmYlN	2021-05-19 10:53:31.421+00	2021-05-19 10:53:31.421+00	\N	\N	ecg	1.1015625,0.0688875623691073	8sycsF8enM	PxHgYjFpnc
jtb8QBsJeA	2021-05-19 10:53:31.471+00	2021-05-19 10:53:31.471+00	\N	\N	ecg	1.10546875,-0.0341086571432948	8sycsF8enM	PxHgYjFpnc
w0O0Znd93a	2021-05-19 10:53:31.522+00	2021-05-19 10:53:31.522+00	\N	\N	ecg	1.109375,-0.00354894593836948	8sycsF8enM	PxHgYjFpnc
fbpmvA0Rel	2021-05-19 10:53:31.571+00	2021-05-19 10:53:31.571+00	\N	\N	ecg	1.11328125,0.0292451353128132	8sycsF8enM	PxHgYjFpnc
AGB1XuP2Fi	2021-05-19 10:53:31.621+00	2021-05-19 10:53:31.621+00	\N	\N	ecg	1.1171875,-0.00373658554987735	8sycsF8enM	PxHgYjFpnc
R2q8KbtsgL	2021-05-19 10:53:31.673+00	2021-05-19 10:53:31.673+00	\N	\N	ecg	1.12109375,-0.0450412238007426	8sycsF8enM	PxHgYjFpnc
b4uo1ovmnR	2021-05-19 10:53:31.723+00	2021-05-19 10:53:31.723+00	\N	\N	ecg	1.125,0.0992968646039004	8sycsF8enM	PxHgYjFpnc
33a5HW9PO3	2021-05-19 10:53:31.774+00	2021-05-19 10:53:31.774+00	\N	\N	ecg	1.12890625,-0.0210341503077046	8sycsF8enM	PxHgYjFpnc
u5t8jGqxQt	2021-05-19 10:53:31.825+00	2021-05-19 10:53:31.825+00	\N	\N	ecg	1.1328125,0.0671065812014678	8sycsF8enM	PxHgYjFpnc
vOOEUXXbeD	2021-05-19 10:53:31.875+00	2021-05-19 10:53:31.875+00	\N	\N	ecg	1.13671875,0.11481088862095	8sycsF8enM	PxHgYjFpnc
8ZKKrEhcxT	2021-05-19 10:53:31.925+00	2021-05-19 10:53:31.925+00	\N	\N	ecg	1.140625,0.0343380699276404	8sycsF8enM	PxHgYjFpnc
8YSxu3CK7o	2021-05-19 10:53:31.976+00	2021-05-19 10:53:31.976+00	\N	\N	ecg	1.14453125,0.171373661560386	8sycsF8enM	PxHgYjFpnc
7lF97k26IU	2021-05-19 10:53:32.028+00	2021-05-19 10:53:32.028+00	\N	\N	ecg	1.1484375,0.0218884515978358	8sycsF8enM	PxHgYjFpnc
Ox1yvBZ3vL	2021-05-19 10:53:32.078+00	2021-05-19 10:53:32.078+00	\N	\N	ecg	1.15234375,0.135763401042889	8sycsF8enM	PxHgYjFpnc
iSJDFs6bXP	2021-05-19 10:53:32.128+00	2021-05-19 10:53:32.128+00	\N	\N	ecg	1.15625,0.178347881143365	8sycsF8enM	PxHgYjFpnc
quRTgH1mU9	2021-05-19 10:53:32.185+00	2021-05-19 10:53:32.185+00	\N	\N	ecg	1.16015625,0.0700744935663874	8sycsF8enM	PxHgYjFpnc
1cU12UNAGH	2021-05-19 10:53:32.23+00	2021-05-19 10:53:32.23+00	\N	\N	ecg	1.1640625,0.126583310783601	8sycsF8enM	PxHgYjFpnc
aDVaGpr2GP	2021-05-19 10:53:32.282+00	2021-05-19 10:53:32.282+00	\N	\N	ecg	1.16796875,0.250651516668627	8sycsF8enM	PxHgYjFpnc
Ap7aFZsDIR	2021-05-19 10:53:32.331+00	2021-05-19 10:53:32.331+00	\N	\N	ecg	1.171875,0.11405003651	8sycsF8enM	PxHgYjFpnc
fADmBOg6e6	2021-05-19 10:53:32.384+00	2021-05-19 10:53:32.384+00	\N	\N	ecg	1.17578125,0.239882169940308	8sycsF8enM	PxHgYjFpnc
bvMe4Wq6TZ	2021-05-19 10:53:32.431+00	2021-05-19 10:53:32.431+00	\N	\N	ecg	1.1796875,0.159191582015438	8sycsF8enM	PxHgYjFpnc
UoeRFa8C4z	2021-05-19 10:53:32.485+00	2021-05-19 10:53:32.485+00	\N	\N	ecg	1.18359375,0.145765935143261	8sycsF8enM	PxHgYjFpnc
PY0PHCSy2W	2021-05-19 10:53:32.535+00	2021-05-19 10:53:32.535+00	\N	\N	ecg	1.1875,0.204971215889314	8sycsF8enM	PxHgYjFpnc
W6DzsO4CgK	2021-05-19 10:53:32.587+00	2021-05-19 10:53:32.587+00	\N	\N	ecg	1.19140625,0.247349096907832	8sycsF8enM	PxHgYjFpnc
YmNGfGakpE	2021-05-19 10:53:32.636+00	2021-05-19 10:53:32.636+00	\N	\N	ecg	1.1953125,0.37358488367951	8sycsF8enM	PxHgYjFpnc
w9PW6M6GCs	2021-05-19 10:53:32.688+00	2021-05-19 10:53:32.688+00	\N	\N	ecg	1.19921875,0.237401212308442	8sycsF8enM	PxHgYjFpnc
mcJXba4ipr	2021-05-19 10:53:32.738+00	2021-05-19 10:53:32.738+00	\N	\N	ecg	1.203125,0.399070054102479	8sycsF8enM	PxHgYjFpnc
Rncudgio7x	2021-05-19 10:53:32.792+00	2021-05-19 10:53:32.792+00	\N	\N	ecg	1.20703125,0.345663533588839	8sycsF8enM	PxHgYjFpnc
Ts60shq1Ja	2021-05-19 10:53:32.838+00	2021-05-19 10:53:32.838+00	\N	\N	ecg	1.2109375,0.421630562459038	8sycsF8enM	PxHgYjFpnc
q1GnodU7KJ	2021-05-19 10:53:32.889+00	2021-05-19 10:53:32.889+00	\N	\N	ecg	1.21484375,0.408571667473728	8sycsF8enM	PxHgYjFpnc
GvUekHHaD7	2021-05-19 10:53:32.942+00	2021-05-19 10:53:32.942+00	\N	\N	ecg	1.21875,0.326508748625089	8sycsF8enM	PxHgYjFpnc
oyVBGO8i8P	2021-05-19 10:53:32.993+00	2021-05-19 10:53:32.993+00	\N	\N	ecg	1.22265625,0.453684747853945	8sycsF8enM	PxHgYjFpnc
xAtwdHL31R	2021-05-19 10:53:33.042+00	2021-05-19 10:53:33.042+00	\N	\N	ecg	1.2265625,0.402663390443594	8sycsF8enM	PxHgYjFpnc
UfChc24ogA	2021-05-19 10:53:33.092+00	2021-05-19 10:53:33.092+00	\N	\N	ecg	1.23046875,0.454747407531027	8sycsF8enM	PxHgYjFpnc
jDfcnmYZ8c	2021-05-19 10:53:33.144+00	2021-05-19 10:53:33.144+00	\N	\N	ecg	1.234375,0.410165185665853	8sycsF8enM	PxHgYjFpnc
o0xODguRPn	2021-05-19 10:53:33.195+00	2021-05-19 10:53:33.195+00	\N	\N	ecg	1.23828125,0.335879947892884	8sycsF8enM	PxHgYjFpnc
Pz3nCpYPLV	2021-05-19 10:53:33.244+00	2021-05-19 10:53:33.244+00	\N	\N	ecg	1.2421875,0.338521936402238	8sycsF8enM	PxHgYjFpnc
y0MEroCk5e	2021-05-19 10:53:33.294+00	2021-05-19 10:53:33.294+00	\N	\N	ecg	1.24609375,0.480067383046126	8sycsF8enM	PxHgYjFpnc
nKUtZANR6b	2021-05-19 10:53:33.347+00	2021-05-19 10:53:33.347+00	\N	\N	ecg	1.25,0.444931717265355	8sycsF8enM	PxHgYjFpnc
MocZO3HXe0	2021-05-19 10:53:33.398+00	2021-05-19 10:53:33.398+00	\N	\N	ecg	1.25390625,0.420641810193508	8sycsF8enM	PxHgYjFpnc
Xh5witbwxn	2021-05-19 10:53:33.45+00	2021-05-19 10:53:33.45+00	\N	\N	ecg	1.2578125,0.316493445668136	8sycsF8enM	PxHgYjFpnc
IkyGNYKZ3H	2021-05-19 10:53:33.498+00	2021-05-19 10:53:33.498+00	\N	\N	ecg	1.26171875,0.309922380841522	8sycsF8enM	PxHgYjFpnc
reoq7I95ep	2021-05-19 10:53:33.549+00	2021-05-19 10:53:33.549+00	\N	\N	ecg	1.265625,0.279488900817205	8sycsF8enM	PxHgYjFpnc
EDvZ6Rgs7O	2021-05-19 10:53:33.598+00	2021-05-19 10:53:33.598+00	\N	\N	ecg	1.26953125,0.315024095161497	8sycsF8enM	PxHgYjFpnc
X8axRzu5J8	2021-05-19 10:53:33.652+00	2021-05-19 10:53:33.652+00	\N	\N	ecg	1.2734375,0.320330790998883	8sycsF8enM	PxHgYjFpnc
U6SxKX6hzO	2021-05-19 10:53:33.702+00	2021-05-19 10:53:33.702+00	\N	\N	ecg	1.27734375,0.370425008099375	8sycsF8enM	PxHgYjFpnc
OGtT1WXKAF	2021-05-19 10:53:33.753+00	2021-05-19 10:53:33.753+00	\N	\N	ecg	1.28125,0.387059137355977	8sycsF8enM	PxHgYjFpnc
3nQCESASnN	2021-05-19 10:53:33.804+00	2021-05-19 10:53:33.804+00	\N	\N	ecg	1.28515625,0.312637095674988	8sycsF8enM	PxHgYjFpnc
bjcklRAeiG	2021-05-19 10:53:33.855+00	2021-05-19 10:53:33.855+00	\N	\N	ecg	1.2890625,0.294533411534843	8sycsF8enM	PxHgYjFpnc
aAwWBaTqmQ	2021-05-19 10:53:33.905+00	2021-05-19 10:53:33.905+00	\N	\N	ecg	1.29296875,0.302799410682013	8sycsF8enM	PxHgYjFpnc
3RowjHlYDp	2021-05-19 10:53:33.955+00	2021-05-19 10:53:33.955+00	\N	\N	ecg	1.296875,0.179773410836103	8sycsF8enM	PxHgYjFpnc
7ffGYRatNR	2021-05-19 10:53:34.005+00	2021-05-19 10:53:34.005+00	\N	\N	ecg	1.30078125,0.276255214340195	8sycsF8enM	PxHgYjFpnc
c1tmER6fFN	2021-05-19 10:53:34.084+00	2021-05-19 10:53:34.084+00	\N	\N	ecg	1.3046875,0.161100726368793	8sycsF8enM	PxHgYjFpnc
GWbeUltll7	2021-05-19 10:53:34.123+00	2021-05-19 10:53:34.123+00	\N	\N	ecg	1.30859375,0.284264424904188	8sycsF8enM	PxHgYjFpnc
kpqvYaO2UC	2021-05-19 10:53:34.171+00	2021-05-19 10:53:34.171+00	\N	\N	ecg	1.3125,0.198367800813536	8sycsF8enM	PxHgYjFpnc
rXS5pvgndD	2021-05-19 10:53:34.221+00	2021-05-19 10:53:34.221+00	\N	\N	ecg	1.31640625,0.0966300820930321	8sycsF8enM	PxHgYjFpnc
2DVEa48iTE	2021-05-19 10:53:34.273+00	2021-05-19 10:53:34.273+00	\N	\N	ecg	1.3203125,0.0836706917542261	8sycsF8enM	PxHgYjFpnc
a2mRkWWpfQ	2021-05-19 10:53:34.322+00	2021-05-19 10:53:34.322+00	\N	\N	ecg	1.32421875,0.109200631654795	8sycsF8enM	PxHgYjFpnc
jY5onZOjhV	2021-05-19 10:53:34.373+00	2021-05-19 10:53:34.373+00	\N	\N	ecg	1.328125,0.094076257896318	8sycsF8enM	PxHgYjFpnc
feZye1OnkZ	2021-05-19 10:53:34.425+00	2021-05-19 10:53:34.425+00	\N	\N	ecg	1.33203125,0.0340272894121502	8sycsF8enM	PxHgYjFpnc
v1S9GQtI8L	2021-05-19 10:53:34.476+00	2021-05-19 10:53:34.476+00	\N	\N	ecg	1.3359375,0.181006962891072	8sycsF8enM	PxHgYjFpnc
91tuttfkNZ	2021-05-19 10:53:34.526+00	2021-05-19 10:53:34.526+00	\N	\N	ecg	1.33984375,0.166189492901873	8sycsF8enM	PxHgYjFpnc
Oh7fxXj8tb	2021-05-19 10:53:34.576+00	2021-05-19 10:53:34.576+00	\N	\N	ecg	1.34375,-0.0134765328778534	8sycsF8enM	PxHgYjFpnc
5E7GEn1hBm	2021-05-19 10:53:34.628+00	2021-05-19 10:53:34.628+00	\N	\N	ecg	1.34765625,0.154011479402941	8sycsF8enM	PxHgYjFpnc
nqPVjE8fU3	2021-05-19 10:53:34.679+00	2021-05-19 10:53:34.679+00	\N	\N	ecg	1.3515625,0.0554861408141964	8sycsF8enM	PxHgYjFpnc
79HI5siIXU	2021-05-19 10:53:34.731+00	2021-05-19 10:53:34.731+00	\N	\N	ecg	1.35546875,0.0335430313062925	8sycsF8enM	PxHgYjFpnc
KbHxs7x6mj	2021-05-19 10:53:34.783+00	2021-05-19 10:53:34.783+00	\N	\N	ecg	1.359375,-0.0305423381088788	8sycsF8enM	PxHgYjFpnc
CMBEaZzCyz	2021-05-19 10:53:34.831+00	2021-05-19 10:53:34.831+00	\N	\N	ecg	1.36328125,0.0050385631803817	8sycsF8enM	PxHgYjFpnc
H7BXeFJWBw	2021-05-19 10:53:34.882+00	2021-05-19 10:53:34.882+00	\N	\N	ecg	1.3671875,-0.0310119032252117	8sycsF8enM	PxHgYjFpnc
tobdV1rHxG	2021-05-19 10:53:34.932+00	2021-05-19 10:53:34.932+00	\N	\N	ecg	1.37109375,-0.0085589146683882	8sycsF8enM	PxHgYjFpnc
ynwOAcGsEM	2021-05-19 10:53:34.984+00	2021-05-19 10:53:34.984+00	\N	\N	ecg	1.375,-0.0413570845218212	8sycsF8enM	PxHgYjFpnc
KF7T1ZHN2u	2021-05-19 10:53:35.035+00	2021-05-19 10:53:35.035+00	\N	\N	ecg	1.37890625,0.0882271548048075	8sycsF8enM	PxHgYjFpnc
QamHnEPbIk	2021-05-19 10:53:35.085+00	2021-05-19 10:53:35.085+00	\N	\N	ecg	1.3828125,0.00280616873407654	8sycsF8enM	PxHgYjFpnc
XWl0TL6Jlf	2021-05-19 10:53:35.136+00	2021-05-19 10:53:35.136+00	\N	\N	ecg	1.38671875,-0.0736756310882781	8sycsF8enM	PxHgYjFpnc
YJKmy8xNkE	2021-05-19 10:53:35.189+00	2021-05-19 10:53:35.189+00	\N	\N	ecg	1.390625,-0.046991675110333	8sycsF8enM	PxHgYjFpnc
fNfL89T1sH	2021-05-19 10:53:35.242+00	2021-05-19 10:53:35.242+00	\N	\N	ecg	1.39453125,-0.00947655728589637	8sycsF8enM	PxHgYjFpnc
ED20LIR4z4	2021-05-19 10:53:35.289+00	2021-05-19 10:53:35.289+00	\N	\N	ecg	1.3984375,-0.117730609031758	8sycsF8enM	PxHgYjFpnc
E73x5DMDYU	2021-05-19 10:53:35.34+00	2021-05-19 10:53:35.34+00	\N	\N	ecg	1.40234375,-0.120381648711539	8sycsF8enM	PxHgYjFpnc
oqpA06Y6bK	2021-05-19 10:53:35.393+00	2021-05-19 10:53:35.393+00	\N	\N	ecg	1.40625,0.0452457250836829	8sycsF8enM	PxHgYjFpnc
ZfZ6LpYny1	2021-05-19 10:53:35.442+00	2021-05-19 10:53:35.442+00	\N	\N	ecg	1.41015625,-0.13803790404141	8sycsF8enM	PxHgYjFpnc
TZWXMnuFDZ	2021-05-19 10:53:35.494+00	2021-05-19 10:53:35.494+00	\N	\N	ecg	1.4140625,0.022700142726962	8sycsF8enM	PxHgYjFpnc
1DkCmpSziJ	2021-05-19 10:53:35.544+00	2021-05-19 10:53:35.544+00	\N	\N	ecg	1.41796875,-0.121632858316668	8sycsF8enM	PxHgYjFpnc
IeLOkB9imC	2021-05-19 10:53:35.597+00	2021-05-19 10:53:35.597+00	\N	\N	ecg	1.421875,-0.0877866607033838	8sycsF8enM	PxHgYjFpnc
Ujc0xNZRTl	2021-05-19 10:53:35.647+00	2021-05-19 10:53:35.647+00	\N	\N	ecg	1.42578125,-0.142284280941236	8sycsF8enM	PxHgYjFpnc
i4mBRBC7QP	2021-05-19 10:53:35.696+00	2021-05-19 10:53:35.696+00	\N	\N	ecg	1.4296875,-0.0438381338450631	8sycsF8enM	PxHgYjFpnc
L5iJi7UtJv	2021-05-19 10:53:35.748+00	2021-05-19 10:53:35.748+00	\N	\N	ecg	1.43359375,0.021509645885696	8sycsF8enM	PxHgYjFpnc
UQKYDlKMuw	2021-05-19 10:53:35.798+00	2021-05-19 10:53:35.798+00	\N	\N	ecg	1.4375,-0.027263162496985	8sycsF8enM	PxHgYjFpnc
XXfjUDqvUe	2021-05-19 10:53:35.849+00	2021-05-19 10:53:35.849+00	\N	\N	ecg	1.44140625,-0.0585229040973365	8sycsF8enM	PxHgYjFpnc
RKtJ1rAl3d	2021-05-19 10:53:35.9+00	2021-05-19 10:53:35.9+00	\N	\N	ecg	1.4453125,0.0528362007139422	8sycsF8enM	PxHgYjFpnc
EmYAQfhhB6	2021-05-19 10:53:35.95+00	2021-05-19 10:53:35.95+00	\N	\N	ecg	1.44921875,-0.0415359512716529	8sycsF8enM	PxHgYjFpnc
VA4LICGS7U	2021-05-19 10:53:36.001+00	2021-05-19 10:53:36.001+00	\N	\N	ecg	1.453125,-0.0664070847931159	8sycsF8enM	PxHgYjFpnc
UCfMb6W1tD	2021-05-19 10:53:36.053+00	2021-05-19 10:53:36.053+00	\N	\N	ecg	1.45703125,-0.085265913616269	8sycsF8enM	PxHgYjFpnc
5UHA6afaXe	2021-05-19 10:53:36.104+00	2021-05-19 10:53:36.104+00	\N	\N	ecg	1.4609375,0.0170288687324424	8sycsF8enM	PxHgYjFpnc
K7jKqnkKsg	2021-05-19 10:53:36.154+00	2021-05-19 10:53:36.154+00	\N	\N	ecg	1.46484375,-0.0994135063240511	8sycsF8enM	PxHgYjFpnc
NknVOloyQ2	2021-05-19 10:53:36.205+00	2021-05-19 10:53:36.205+00	\N	\N	ecg	1.46875,-0.0914474894169695	8sycsF8enM	PxHgYjFpnc
7QEI1CbxJR	2021-05-19 10:53:36.256+00	2021-05-19 10:53:36.256+00	\N	\N	ecg	1.47265625,0.0573887084220024	8sycsF8enM	PxHgYjFpnc
EL21O4etfL	2021-05-19 10:53:36.306+00	2021-05-19 10:53:36.306+00	\N	\N	ecg	1.4765625,-0.139721554462703	8sycsF8enM	PxHgYjFpnc
QekwZRTZ1E	2021-05-19 10:53:36.356+00	2021-05-19 10:53:36.356+00	\N	\N	ecg	1.48046875,-0.103318531963274	8sycsF8enM	PxHgYjFpnc
iqu1EXiYfE	2021-05-19 10:53:36.408+00	2021-05-19 10:53:36.408+00	\N	\N	ecg	1.484375,0.059615075962462	8sycsF8enM	PxHgYjFpnc
gfz6SEWbeF	2021-05-19 10:53:36.458+00	2021-05-19 10:53:36.458+00	\N	\N	ecg	1.48828125,-0.0937670038975264	8sycsF8enM	PxHgYjFpnc
EmeXte4FdK	2021-05-19 10:53:36.508+00	2021-05-19 10:53:36.508+00	\N	\N	ecg	1.4921875,0.0444557533055442	8sycsF8enM	PxHgYjFpnc
m0HT3X94gr	2021-05-19 10:53:36.563+00	2021-05-19 10:53:36.563+00	\N	\N	ecg	1.49609375,-0.0555677239651816	8sycsF8enM	PxHgYjFpnc
oI45dvFfqn	2021-05-19 10:53:36.609+00	2021-05-19 10:53:36.609+00	\N	\N	ecg	1.5,-0.0158356480141744	8sycsF8enM	PxHgYjFpnc
XhKPDlfBud	2021-05-19 10:53:36.662+00	2021-05-19 10:53:36.662+00	\N	\N	ecg	1.50390625,0.0452806581720361	8sycsF8enM	PxHgYjFpnc
4zKEV9TfGM	2021-05-19 10:53:36.713+00	2021-05-19 10:53:36.713+00	\N	\N	ecg	1.5078125,-0.0971565334284623	8sycsF8enM	PxHgYjFpnc
uhR4CyCrOd	2021-05-19 10:53:36.767+00	2021-05-19 10:53:36.767+00	\N	\N	ecg	1.51171875,-0.0951167169061745	8sycsF8enM	PxHgYjFpnc
eCi1QVthLd	2021-05-19 10:53:36.833+00	2021-05-19 10:53:36.833+00	\N	\N	ecg	1.515625,-0.124630870192969	8sycsF8enM	PxHgYjFpnc
z65vuroy2x	2021-05-19 10:53:36.884+00	2021-05-19 10:53:36.884+00	\N	\N	ecg	1.51953125,0.0558887387699032	8sycsF8enM	PxHgYjFpnc
fZxtyyv0Rj	2021-05-19 10:53:36.934+00	2021-05-19 10:53:36.934+00	\N	\N	ecg	1.5234375,-0.115493469465828	8sycsF8enM	PxHgYjFpnc
SHdr8CbJ7k	2021-05-19 10:53:36.988+00	2021-05-19 10:53:36.988+00	\N	\N	ecg	1.52734375,-0.0677631915313475	8sycsF8enM	PxHgYjFpnc
LOrm5UtuzU	2021-05-19 10:53:37.038+00	2021-05-19 10:53:37.038+00	\N	\N	ecg	1.53125,-0.0858273237588429	8sycsF8enM	PxHgYjFpnc
Dnb6mt1zol	2021-05-19 10:53:37.088+00	2021-05-19 10:53:37.088+00	\N	\N	ecg	1.53515625,-0.0131629912193893	8sycsF8enM	PxHgYjFpnc
ppGWb5B1mH	2021-05-19 10:53:37.144+00	2021-05-19 10:53:37.144+00	\N	\N	ecg	1.5390625,-0.0441037763206974	8sycsF8enM	PxHgYjFpnc
JnDlK8WNjE	2021-05-19 10:53:37.211+00	2021-05-19 10:53:37.211+00	\N	\N	ecg	1.54296875,-0.0898557529407844	8sycsF8enM	PxHgYjFpnc
fZRMbW6M7p	2021-05-19 10:53:37.248+00	2021-05-19 10:53:37.248+00	\N	\N	ecg	1.546875,-0.0363553080942667	8sycsF8enM	PxHgYjFpnc
yw2fUbfGCa	2021-05-19 10:53:37.293+00	2021-05-19 10:53:37.293+00	\N	\N	ecg	1.55078125,-0.0771366935216973	8sycsF8enM	PxHgYjFpnc
KgArkmknNK	2021-05-19 10:53:37.343+00	2021-05-19 10:53:37.343+00	\N	\N	ecg	1.5546875,0.0559029316290867	8sycsF8enM	PxHgYjFpnc
npQkM0jKd1	2021-05-19 10:53:37.395+00	2021-05-19 10:53:37.395+00	\N	\N	ecg	1.55859375,0.0231597739768244	8sycsF8enM	PxHgYjFpnc
HwwezthQC6	2021-05-19 10:53:37.445+00	2021-05-19 10:53:37.445+00	\N	\N	ecg	1.5625,-0.0807222722533805	8sycsF8enM	PxHgYjFpnc
EcHVR2PH0K	2021-05-19 10:53:37.496+00	2021-05-19 10:53:37.496+00	\N	\N	ecg	1.56640625,-0.0101844006197011	8sycsF8enM	PxHgYjFpnc
5Olsz9qohs	2021-05-19 10:53:37.547+00	2021-05-19 10:53:37.547+00	\N	\N	ecg	1.5703125,0.0237084093192928	8sycsF8enM	PxHgYjFpnc
HdTn0VjhwP	2021-05-19 10:53:37.597+00	2021-05-19 10:53:37.597+00	\N	\N	ecg	1.57421875,-0.0907511717619149	8sycsF8enM	PxHgYjFpnc
GucucAukBA	2021-05-19 10:53:37.649+00	2021-05-19 10:53:37.649+00	\N	\N	ecg	1.578125,-0.0911970637256693	8sycsF8enM	PxHgYjFpnc
IrlxAdLM8e	2021-05-19 10:53:37.704+00	2021-05-19 10:53:37.704+00	\N	\N	ecg	1.58203125,-0.0589254128710708	8sycsF8enM	PxHgYjFpnc
rVflCl6BUG	2021-05-19 10:53:37.755+00	2021-05-19 10:53:37.755+00	\N	\N	ecg	1.5859375,-0.0665505101506306	8sycsF8enM	PxHgYjFpnc
PWEZKoDWt4	2021-05-19 10:53:37.807+00	2021-05-19 10:53:37.807+00	\N	\N	ecg	1.58984375,-0.00681759073876825	8sycsF8enM	PxHgYjFpnc
1GEKDJlG0A	2021-05-19 10:53:37.854+00	2021-05-19 10:53:37.854+00	\N	\N	ecg	1.59375,-0.0997773010278427	8sycsF8enM	PxHgYjFpnc
aicLF159hI	2021-05-19 10:53:37.904+00	2021-05-19 10:53:37.904+00	\N	\N	ecg	1.59765625,0.0829647143113702	8sycsF8enM	PxHgYjFpnc
h0eGher2TC	2021-05-19 10:53:37.955+00	2021-05-19 10:53:37.955+00	\N	\N	ecg	1.6015625,0.0603826463996578	8sycsF8enM	PxHgYjFpnc
6C7pJZA3ok	2021-05-19 10:53:38.005+00	2021-05-19 10:53:38.005+00	\N	\N	ecg	1.60546875,-0.0453164990299239	8sycsF8enM	PxHgYjFpnc
UjArYdtnzi	2021-05-19 10:53:38.058+00	2021-05-19 10:53:38.058+00	\N	\N	ecg	1.609375,0.044699166943504	8sycsF8enM	PxHgYjFpnc
tHGBt3kzWj	2021-05-19 10:53:38.106+00	2021-05-19 10:53:38.106+00	\N	\N	ecg	1.61328125,-0.0630556407049914	8sycsF8enM	PxHgYjFpnc
h8hYrA5Uhh	2021-05-19 10:53:38.158+00	2021-05-19 10:53:38.158+00	\N	\N	ecg	1.6171875,-0.0621335284475862	8sycsF8enM	PxHgYjFpnc
c3JPhSIqjN	2021-05-19 10:53:38.209+00	2021-05-19 10:53:38.209+00	\N	\N	ecg	1.62109375,-0.0488954905998347	8sycsF8enM	PxHgYjFpnc
hmqueu6Dfn	2021-05-19 10:53:38.259+00	2021-05-19 10:53:38.259+00	\N	\N	ecg	1.625,0.0751324462188925	8sycsF8enM	PxHgYjFpnc
xAYCu57bAI	2021-05-19 10:53:38.31+00	2021-05-19 10:53:38.31+00	\N	\N	ecg	1.62890625,-0.00188934887938398	8sycsF8enM	PxHgYjFpnc
tCUgM9nsv3	2021-05-19 10:53:38.36+00	2021-05-19 10:53:38.36+00	\N	\N	ecg	1.6328125,-0.0265907425432962	8sycsF8enM	PxHgYjFpnc
8rdUXAFTlJ	2021-05-19 10:53:38.411+00	2021-05-19 10:53:38.411+00	\N	\N	ecg	1.63671875,0.0638525097770323	8sycsF8enM	PxHgYjFpnc
vugQ1o4Xvp	2021-05-19 10:53:38.46+00	2021-05-19 10:53:38.46+00	\N	\N	ecg	1.640625,-0.0298996422801941	8sycsF8enM	PxHgYjFpnc
WOZ7b32pYL	2021-05-19 10:53:38.511+00	2021-05-19 10:53:38.511+00	\N	\N	ecg	1.64453125,0.0392370740443337	8sycsF8enM	PxHgYjFpnc
HjvEZhRTsL	2021-05-19 10:53:38.561+00	2021-05-19 10:53:38.561+00	\N	\N	ecg	1.6484375,-0.0371911865037357	8sycsF8enM	PxHgYjFpnc
GoAplh8MMM	2021-05-19 10:53:38.613+00	2021-05-19 10:53:38.613+00	\N	\N	ecg	1.65234375,0.0275619973003453	8sycsF8enM	PxHgYjFpnc
YC4DA1bCPr	2021-05-19 10:53:38.662+00	2021-05-19 10:53:38.662+00	\N	\N	ecg	1.65625,-0.0536530681139482	8sycsF8enM	PxHgYjFpnc
DjYCPa7JUw	2021-05-19 10:53:38.713+00	2021-05-19 10:53:38.713+00	\N	\N	ecg	1.66015625,-0.0192728154324219	8sycsF8enM	PxHgYjFpnc
3xX9y1OeZH	2021-05-19 10:53:38.763+00	2021-05-19 10:53:38.763+00	\N	\N	ecg	1.6640625,-0.0208584609344444	8sycsF8enM	PxHgYjFpnc
8fruDC9DHA	2021-05-19 10:53:38.814+00	2021-05-19 10:53:38.814+00	\N	\N	ecg	1.66796875,-0.0505181087801421	8sycsF8enM	PxHgYjFpnc
Wx9inLB2F1	2021-05-19 10:53:38.865+00	2021-05-19 10:53:38.865+00	\N	\N	ecg	1.671875,-0.0198608211300341	8sycsF8enM	PxHgYjFpnc
LpZygS2Cpr	2021-05-19 10:53:38.916+00	2021-05-19 10:53:38.916+00	\N	\N	ecg	1.67578125,-0.00536604985980523	8sycsF8enM	PxHgYjFpnc
O7N7cEmx1N	2021-05-19 10:53:38.967+00	2021-05-19 10:53:38.967+00	\N	\N	ecg	1.6796875,-0.00678395331308003	8sycsF8enM	PxHgYjFpnc
Zt30jSQeBd	2021-05-19 10:53:39.017+00	2021-05-19 10:53:39.017+00	\N	\N	ecg	1.68359375,-0.0153865043130764	8sycsF8enM	PxHgYjFpnc
FpFXBV4eSW	2021-05-19 10:53:39.069+00	2021-05-19 10:53:39.069+00	\N	\N	ecg	1.6875,0.0826131786726928	8sycsF8enM	PxHgYjFpnc
D8wUQiQGkS	2021-05-19 10:53:39.12+00	2021-05-19 10:53:39.12+00	\N	\N	ecg	1.69140625,-0.0657794922748262	8sycsF8enM	PxHgYjFpnc
biJmiVlpes	2021-05-19 10:53:39.17+00	2021-05-19 10:53:39.17+00	\N	\N	ecg	1.6953125,0.0144229548256896	8sycsF8enM	PxHgYjFpnc
0NljLFp53j	2021-05-19 10:53:39.221+00	2021-05-19 10:53:39.221+00	\N	\N	ecg	1.69921875,0.0964051724313587	8sycsF8enM	PxHgYjFpnc
TwODmOISBI	2021-05-19 10:53:39.272+00	2021-05-19 10:53:39.272+00	\N	\N	ecg	1.703125,-0.0259311850083524	8sycsF8enM	PxHgYjFpnc
7IGhVPyDpS	2021-05-19 10:53:39.323+00	2021-05-19 10:53:39.323+00	\N	\N	ecg	1.70703125,-0.0861710658390892	8sycsF8enM	PxHgYjFpnc
G5TN4WHDFa	2021-05-19 10:53:39.373+00	2021-05-19 10:53:39.373+00	\N	\N	ecg	1.7109375,0.10873990519859	8sycsF8enM	PxHgYjFpnc
v33OW3HBVb	2021-05-19 10:53:39.424+00	2021-05-19 10:53:39.424+00	\N	\N	ecg	1.71484375,-0.0354368880739339	8sycsF8enM	PxHgYjFpnc
X3UBScMdLD	2021-05-19 10:53:39.474+00	2021-05-19 10:53:39.474+00	\N	\N	ecg	1.71875,0.0111402285344782	8sycsF8enM	PxHgYjFpnc
HDT7Wf8LH6	2021-05-19 10:53:39.525+00	2021-05-19 10:53:39.525+00	\N	\N	ecg	1.72265625,-0.0454891613525848	8sycsF8enM	PxHgYjFpnc
Mfq5sRSG5Y	2021-05-19 10:53:39.576+00	2021-05-19 10:53:39.576+00	\N	\N	ecg	1.7265625,-0.00912257595545842	8sycsF8enM	PxHgYjFpnc
EU3dZA1Cpx	2021-05-19 10:53:39.631+00	2021-05-19 10:53:39.631+00	\N	\N	ecg	1.73046875,-0.0680615864745478	8sycsF8enM	PxHgYjFpnc
0lAZVD3upa	2021-05-19 10:53:39.682+00	2021-05-19 10:53:39.682+00	\N	\N	ecg	1.734375,0.127996753394931	8sycsF8enM	PxHgYjFpnc
xzaTDtSnZk	2021-05-19 10:53:39.732+00	2021-05-19 10:53:39.732+00	\N	\N	ecg	1.73828125,0.0997070419554419	8sycsF8enM	PxHgYjFpnc
3kkG5bKFuS	2021-05-19 10:53:39.781+00	2021-05-19 10:53:39.781+00	\N	\N	ecg	1.7421875,0.123127027347168	8sycsF8enM	PxHgYjFpnc
WnYhlYVR7q	2021-05-19 10:53:39.831+00	2021-05-19 10:53:39.831+00	\N	\N	ecg	1.74609375,0.136732783765027	8sycsF8enM	PxHgYjFpnc
f1c7bh1vNh	2021-05-19 10:53:39.881+00	2021-05-19 10:53:39.881+00	\N	\N	ecg	1.75,0.0407842622533523	8sycsF8enM	PxHgYjFpnc
Ct0JgUmuPr	2021-05-19 10:53:39.933+00	2021-05-19 10:53:39.933+00	\N	\N	ecg	1.75390625,0.0864737790014718	8sycsF8enM	PxHgYjFpnc
6syTpnCKvG	2021-05-19 10:53:39.983+00	2021-05-19 10:53:39.983+00	\N	\N	ecg	1.7578125,0.096544835028964	8sycsF8enM	PxHgYjFpnc
CZx2C48GAG	2021-05-19 10:53:40.033+00	2021-05-19 10:53:40.033+00	\N	\N	ecg	1.76171875,0.119136770566511	8sycsF8enM	PxHgYjFpnc
NqwUriKNtA	2021-05-19 10:53:40.083+00	2021-05-19 10:53:40.083+00	\N	\N	ecg	1.765625,0.101442564498996	8sycsF8enM	PxHgYjFpnc
iloPBZuzxw	2021-05-19 10:53:40.139+00	2021-05-19 10:53:40.139+00	\N	\N	ecg	1.76953125,0.167309437052069	8sycsF8enM	PxHgYjFpnc
6htSBsdjDi	2021-05-19 10:53:40.198+00	2021-05-19 10:53:40.198+00	\N	\N	ecg	1.7734375,0.0377353079026451	8sycsF8enM	PxHgYjFpnc
xNzCQeeos0	2021-05-19 10:53:40.244+00	2021-05-19 10:53:40.244+00	\N	\N	ecg	1.77734375,0.124293133501512	8sycsF8enM	PxHgYjFpnc
IDFVNXDkAE	2021-05-19 10:53:40.295+00	2021-05-19 10:53:40.295+00	\N	\N	ecg	1.78125,0.134544307493096	8sycsF8enM	PxHgYjFpnc
XI4Eeel6MV	2021-05-19 10:53:40.346+00	2021-05-19 10:53:40.346+00	\N	\N	ecg	1.78515625,0.178707155894595	8sycsF8enM	PxHgYjFpnc
AM3Esg0BRe	2021-05-19 10:53:40.401+00	2021-05-19 10:53:40.401+00	\N	\N	ecg	1.7890625,0.142802478724873	8sycsF8enM	PxHgYjFpnc
7IHDkGgnrI	2021-05-19 10:53:40.447+00	2021-05-19 10:53:40.447+00	\N	\N	ecg	1.79296875,0.156542060673886	8sycsF8enM	PxHgYjFpnc
72KzRi0BgE	2021-05-19 10:53:40.497+00	2021-05-19 10:53:40.497+00	\N	\N	ecg	1.796875,0.295925466495326	8sycsF8enM	PxHgYjFpnc
BacvULxxhP	2021-05-19 10:53:40.548+00	2021-05-19 10:53:40.548+00	\N	\N	ecg	1.80078125,0.203004111730433	8sycsF8enM	PxHgYjFpnc
7VaUBxA0Cx	2021-05-19 10:53:40.599+00	2021-05-19 10:53:40.599+00	\N	\N	ecg	1.8046875,0.285204581463664	8sycsF8enM	PxHgYjFpnc
xkAUJsA41A	2021-05-19 10:53:40.649+00	2021-05-19 10:53:40.649+00	\N	\N	ecg	1.80859375,0.277974916147161	8sycsF8enM	PxHgYjFpnc
IT5uqcCeYU	2021-05-19 10:53:40.7+00	2021-05-19 10:53:40.7+00	\N	\N	ecg	1.8125,0.334666544429197	8sycsF8enM	PxHgYjFpnc
vYF6k1By8h	2021-05-19 10:53:40.751+00	2021-05-19 10:53:40.751+00	\N	\N	ecg	1.81640625,0.33902974647277	8sycsF8enM	PxHgYjFpnc
7sAAPifewX	2021-05-19 10:53:40.803+00	2021-05-19 10:53:40.803+00	\N	\N	ecg	1.8203125,0.204161476587801	8sycsF8enM	PxHgYjFpnc
tITZ3CZQV2	2021-05-19 10:53:40.852+00	2021-05-19 10:53:40.852+00	\N	\N	ecg	1.82421875,0.319574367497006	8sycsF8enM	PxHgYjFpnc
DcYi5fOcaF	2021-05-19 10:53:40.902+00	2021-05-19 10:53:40.902+00	\N	\N	ecg	1.828125,0.389379361899809	8sycsF8enM	PxHgYjFpnc
8yWlFPy6pY	2021-05-19 10:53:40.956+00	2021-05-19 10:53:40.956+00	\N	\N	ecg	1.83203125,0.386061647726	8sycsF8enM	PxHgYjFpnc
bunVxgloJM	2021-05-19 10:53:41.005+00	2021-05-19 10:53:41.005+00	\N	\N	ecg	1.8359375,0.261831010039264	8sycsF8enM	PxHgYjFpnc
9CpSn8UZES	2021-05-19 10:53:41.057+00	2021-05-19 10:53:41.057+00	\N	\N	ecg	1.83984375,0.333939310083479	8sycsF8enM	PxHgYjFpnc
BmI9BJo8Py	2021-05-19 10:53:41.107+00	2021-05-19 10:53:41.107+00	\N	\N	ecg	1.84375,0.182305701008605	8sycsF8enM	PxHgYjFpnc
0yB7KZlzJ8	2021-05-19 10:53:41.157+00	2021-05-19 10:53:41.157+00	\N	\N	ecg	1.84765625,0.292685051987256	8sycsF8enM	PxHgYjFpnc
C7EXGBplDQ	2021-05-19 10:53:41.207+00	2021-05-19 10:53:41.207+00	\N	\N	ecg	1.8515625,0.213812050542015	8sycsF8enM	PxHgYjFpnc
MEWHik9OEi	2021-05-19 10:53:41.258+00	2021-05-19 10:53:41.258+00	\N	\N	ecg	1.85546875,0.285746439122494	8sycsF8enM	PxHgYjFpnc
2wMqeo8YN9	2021-05-19 10:53:41.309+00	2021-05-19 10:53:41.309+00	\N	\N	ecg	1.859375,0.229004321668699	8sycsF8enM	PxHgYjFpnc
lZlXXESTHk	2021-05-19 10:53:41.361+00	2021-05-19 10:53:41.361+00	\N	\N	ecg	1.86328125,0.250698118914564	8sycsF8enM	PxHgYjFpnc
9tClN12Elu	2021-05-19 10:53:41.41+00	2021-05-19 10:53:41.41+00	\N	\N	ecg	1.8671875,0.28438780443771	8sycsF8enM	PxHgYjFpnc
HrAwmjFQWj	2021-05-19 10:53:41.461+00	2021-05-19 10:53:41.461+00	\N	\N	ecg	1.87109375,0.133227654191309	8sycsF8enM	PxHgYjFpnc
mPUea2GbqH	2021-05-19 10:53:41.512+00	2021-05-19 10:53:41.512+00	\N	\N	ecg	1.875,0.227394325819718	8sycsF8enM	PxHgYjFpnc
BFAlxRbQbP	2021-05-19 10:53:41.562+00	2021-05-19 10:53:41.562+00	\N	\N	ecg	1.87890625,0.138843107469857	8sycsF8enM	PxHgYjFpnc
kBqALsgX7F	2021-05-19 10:53:41.613+00	2021-05-19 10:53:41.613+00	\N	\N	ecg	1.8828125,0.120521307047579	8sycsF8enM	PxHgYjFpnc
PrmOjEMiFL	2021-05-19 10:53:41.664+00	2021-05-19 10:53:41.664+00	\N	\N	ecg	1.88671875,0.162405386679642	8sycsF8enM	PxHgYjFpnc
ktOfTIJhSg	2021-05-19 10:53:41.715+00	2021-05-19 10:53:41.715+00	\N	\N	ecg	1.890625,0.102135385367308	8sycsF8enM	PxHgYjFpnc
t7MV51ihiY	2021-05-19 10:53:41.765+00	2021-05-19 10:53:41.765+00	\N	\N	ecg	1.89453125,0.033475768741972	8sycsF8enM	PxHgYjFpnc
EpmtiBemGD	2021-05-19 10:53:41.816+00	2021-05-19 10:53:41.816+00	\N	\N	ecg	1.8984375,0.132676146304381	8sycsF8enM	PxHgYjFpnc
CweyHdg7FJ	2021-05-19 10:53:41.867+00	2021-05-19 10:53:41.867+00	\N	\N	ecg	1.90234375,-0.00705801161508589	8sycsF8enM	PxHgYjFpnc
kaDbcbRthE	2021-05-19 10:53:41.918+00	2021-05-19 10:53:41.918+00	\N	\N	ecg	1.90625,0.0380674905553353	8sycsF8enM	PxHgYjFpnc
uqfhBTTUVH	2021-05-19 10:53:41.967+00	2021-05-19 10:53:41.967+00	\N	\N	ecg	1.91015625,0.0954089623089891	8sycsF8enM	PxHgYjFpnc
aom0qadQlK	2021-05-19 10:53:42.018+00	2021-05-19 10:53:42.018+00	\N	\N	ecg	1.9140625,0.0685272779988416	8sycsF8enM	PxHgYjFpnc
2s3SFKGqiP	2021-05-19 10:53:42.069+00	2021-05-19 10:53:42.069+00	\N	\N	ecg	1.91796875,-0.0131143574994507	8sycsF8enM	PxHgYjFpnc
VioTIHpGvV	2021-05-19 10:53:42.12+00	2021-05-19 10:53:42.12+00	\N	\N	ecg	1.921875,0.0845656473768603	8sycsF8enM	PxHgYjFpnc
IUK10bhB7e	2021-05-19 10:53:42.172+00	2021-05-19 10:53:42.172+00	\N	\N	ecg	1.92578125,0.0762124643422892	8sycsF8enM	PxHgYjFpnc
umSuAJhUXk	2021-05-19 10:53:42.226+00	2021-05-19 10:53:42.226+00	\N	\N	ecg	1.9296875,-0.0724664569693898	8sycsF8enM	PxHgYjFpnc
kYK7yYAm3s	2021-05-19 10:53:42.274+00	2021-05-19 10:53:42.274+00	\N	\N	ecg	1.93359375,-0.161498432952839	8sycsF8enM	PxHgYjFpnc
loepzJwcdN	2021-05-19 10:53:42.323+00	2021-05-19 10:53:42.323+00	\N	\N	ecg	1.9375,-0.079727714046906	8sycsF8enM	PxHgYjFpnc
MCCtEiHaKT	2021-05-19 10:53:42.376+00	2021-05-19 10:53:42.376+00	\N	\N	ecg	1.94140625,-0.183467751182479	8sycsF8enM	PxHgYjFpnc
vMdHHo95ai	2021-05-19 10:53:42.425+00	2021-05-19 10:53:42.425+00	\N	\N	ecg	1.9453125,-0.144304425275969	8sycsF8enM	PxHgYjFpnc
J1vZE7gDaI	2021-05-19 10:53:42.476+00	2021-05-19 10:53:42.476+00	\N	\N	ecg	1.94921875,-0.163458658403001	8sycsF8enM	PxHgYjFpnc
fCZm3gtUE9	2021-05-19 10:53:42.526+00	2021-05-19 10:53:42.526+00	\N	\N	ecg	1.953125,-0.0711002446953886	8sycsF8enM	PxHgYjFpnc
Cqoz5CfQ44	2021-05-19 10:53:42.578+00	2021-05-19 10:53:42.578+00	\N	\N	ecg	1.95703125,-0.140922149572985	8sycsF8enM	PxHgYjFpnc
pPfqJ5WwgY	2021-05-19 10:53:42.628+00	2021-05-19 10:53:42.628+00	\N	\N	ecg	1.9609375,0.0844452792869589	8sycsF8enM	PxHgYjFpnc
ztzffeSebk	2021-05-19 10:53:42.679+00	2021-05-19 10:53:42.679+00	\N	\N	ecg	1.96484375,0.106514860005852	8sycsF8enM	PxHgYjFpnc
cWUJvIAmLX	2021-05-19 10:53:42.729+00	2021-05-19 10:53:42.729+00	\N	\N	ecg	1.96875,0.232933385838573	8sycsF8enM	PxHgYjFpnc
Hkzh0kOXIP	2021-05-19 10:53:42.78+00	2021-05-19 10:53:42.78+00	\N	\N	ecg	1.97265625,0.399347566621186	8sycsF8enM	PxHgYjFpnc
61iQgJbQBB	2021-05-19 10:53:42.832+00	2021-05-19 10:53:42.832+00	\N	\N	ecg	1.9765625,0.648487264644577	8sycsF8enM	PxHgYjFpnc
wHbRrfyP9y	2021-05-19 10:53:42.882+00	2021-05-19 10:53:42.882+00	\N	\N	ecg	1.98046875,0.788939387361108	8sycsF8enM	PxHgYjFpnc
gFHeVCGOpj	2021-05-19 10:53:42.934+00	2021-05-19 10:53:42.934+00	\N	\N	ecg	1.984375,1.06321073401698	8sycsF8enM	PxHgYjFpnc
cXTMF3xexi	2021-05-19 10:53:42.984+00	2021-05-19 10:53:42.984+00	\N	\N	ecg	1.98828125,1.15679534283234	8sycsF8enM	PxHgYjFpnc
cDZIwq3DIE	2021-05-19 10:53:43.034+00	2021-05-19 10:53:43.034+00	\N	\N	ecg	1.9921875,1.08560398945084	8sycsF8enM	PxHgYjFpnc
ax5sbC88S2	2021-05-19 10:53:43.086+00	2021-05-19 10:53:43.086+00	\N	\N	ecg	1.99609375,1.06583785466464	8sycsF8enM	PxHgYjFpnc
4mQgOARdIV	2021-05-19 10:53:43.138+00	2021-05-19 10:53:43.138+00	\N	\N	ecg	2.0,1.12705852985289	8sycsF8enM	PxHgYjFpnc
NquT0M2g8w	2021-05-19 10:53:43.188+00	2021-05-19 10:53:43.188+00	\N	\N	ecg	2.00390625,1.06244793594112	8sycsF8enM	PxHgYjFpnc
Aorly8w4EN	2021-05-19 10:53:43.239+00	2021-05-19 10:53:43.239+00	\N	\N	ecg	2.0078125,0.875759757505777	8sycsF8enM	PxHgYjFpnc
WA0mRRiHok	2021-05-19 10:53:43.29+00	2021-05-19 10:53:43.29+00	\N	\N	ecg	2.01171875,0.823738951746154	8sycsF8enM	PxHgYjFpnc
JSyQJkWT8S	2021-05-19 10:53:43.34+00	2021-05-19 10:53:43.34+00	\N	\N	ecg	2.015625,0.604728179158279	8sycsF8enM	PxHgYjFpnc
MIPbdngJGx	2021-05-19 10:53:43.395+00	2021-05-19 10:53:43.395+00	\N	\N	ecg	2.01953125,0.450252045996394	8sycsF8enM	PxHgYjFpnc
EZoOFWFvMW	2021-05-19 10:53:43.442+00	2021-05-19 10:53:43.442+00	\N	\N	ecg	2.0234375,0.187966012385694	8sycsF8enM	PxHgYjFpnc
CJtyX5zPja	2021-05-19 10:53:43.493+00	2021-05-19 10:53:43.493+00	\N	\N	ecg	2.02734375,-0.0592836927927862	8sycsF8enM	PxHgYjFpnc
4nsWF6PYyu	2021-05-19 10:53:43.543+00	2021-05-19 10:53:43.543+00	\N	\N	ecg	2.03125,-0.233386801821144	8sycsF8enM	PxHgYjFpnc
MnB1CUjyBB	2021-05-19 10:53:43.596+00	2021-05-19 10:53:43.596+00	\N	\N	ecg	2.03515625,-0.206492786527422	8sycsF8enM	PxHgYjFpnc
pS6rWvVJPP	2021-05-19 10:53:43.644+00	2021-05-19 10:53:43.644+00	\N	\N	ecg	2.0390625,-0.387907012645616	8sycsF8enM	PxHgYjFpnc
521TB4kRnI	2021-05-19 10:53:43.696+00	2021-05-19 10:53:43.696+00	\N	\N	ecg	2.04296875,-0.35693074990372	8sycsF8enM	PxHgYjFpnc
HoOEI5jX7X	2021-05-19 10:53:43.746+00	2021-05-19 10:53:43.746+00	\N	\N	ecg	2.046875,-0.290222265475376	8sycsF8enM	PxHgYjFpnc
ekDx1zJWbE	2021-05-19 10:53:43.796+00	2021-05-19 10:53:43.796+00	\N	\N	ecg	2.05078125,-0.192017903885469	8sycsF8enM	PxHgYjFpnc
UR9UWfvwaK	2021-05-19 10:53:43.847+00	2021-05-19 10:53:43.847+00	\N	\N	ecg	2.0546875,-0.277527170112164	8sycsF8enM	PxHgYjFpnc
IkXvsxYWdw	2021-05-19 10:53:43.898+00	2021-05-19 10:53:43.898+00	\N	\N	ecg	2.05859375,-0.250093220451493	8sycsF8enM	PxHgYjFpnc
UCpS6t2v3m	2021-05-19 10:53:43.948+00	2021-05-19 10:53:43.948+00	\N	\N	ecg	2.0625,-0.235729070324845	8sycsF8enM	PxHgYjFpnc
jpzY3bGrLE	2021-05-19 10:53:44+00	2021-05-19 10:53:44+00	\N	\N	ecg	2.06640625,-0.059024185306969	8sycsF8enM	PxHgYjFpnc
xBU7Nf3gvB	2021-05-19 10:53:44.051+00	2021-05-19 10:53:44.051+00	\N	\N	ecg	2.0703125,-0.0428235239163977	8sycsF8enM	PxHgYjFpnc
cOH3lT6mNT	2021-05-19 10:53:44.105+00	2021-05-19 10:53:44.105+00	\N	\N	ecg	2.07421875,0.0194783311918042	8sycsF8enM	PxHgYjFpnc
L1SRKQvk9m	2021-05-19 10:53:44.155+00	2021-05-19 10:53:44.155+00	\N	\N	ecg	2.078125,-0.131853851051741	8sycsF8enM	PxHgYjFpnc
ia9x0zXky5	2021-05-19 10:53:44.203+00	2021-05-19 10:53:44.203+00	\N	\N	ecg	2.08203125,-0.0806966713945835	8sycsF8enM	PxHgYjFpnc
CbQZ8A3Pac	2021-05-19 10:53:44.253+00	2021-05-19 10:53:44.253+00	\N	\N	ecg	2.0859375,-0.045575810958973	8sycsF8enM	PxHgYjFpnc
JArVwNDxuv	2021-05-19 10:53:44.304+00	2021-05-19 10:53:44.304+00	\N	\N	ecg	2.08984375,-0.0498133966754605	8sycsF8enM	PxHgYjFpnc
aEvOkiHama	2021-05-19 10:53:44.356+00	2021-05-19 10:53:44.356+00	\N	\N	ecg	2.09375,0.0286909842798259	8sycsF8enM	PxHgYjFpnc
G4XygT7WtI	2021-05-19 10:53:44.405+00	2021-05-19 10:53:44.405+00	\N	\N	ecg	2.09765625,-0.101691429951695	8sycsF8enM	PxHgYjFpnc
U7ATUxyJFu	2021-05-19 10:53:44.457+00	2021-05-19 10:53:44.457+00	\N	\N	ecg	2.1015625,0.0688875623691073	8sycsF8enM	PxHgYjFpnc
AGSDY61shz	2021-05-19 10:53:44.507+00	2021-05-19 10:53:44.507+00	\N	\N	ecg	2.10546875,-0.0341086571432948	8sycsF8enM	PxHgYjFpnc
f7ufcPqPIX	2021-05-19 10:53:44.558+00	2021-05-19 10:53:44.558+00	\N	\N	ecg	2.109375,-0.00354894593836948	8sycsF8enM	PxHgYjFpnc
al2TlKwkl0	2021-05-19 10:53:44.608+00	2021-05-19 10:53:44.608+00	\N	\N	ecg	2.11328125,0.0292451353128132	8sycsF8enM	PxHgYjFpnc
oGi5FrpAvK	2021-05-19 10:53:44.66+00	2021-05-19 10:53:44.66+00	\N	\N	ecg	2.1171875,-0.00373658554987735	8sycsF8enM	PxHgYjFpnc
xdPGeSbDfL	2021-05-19 10:53:44.71+00	2021-05-19 10:53:44.71+00	\N	\N	ecg	2.12109375,-0.0450412238007426	8sycsF8enM	PxHgYjFpnc
P8PlwNXmnQ	2021-05-19 10:53:44.761+00	2021-05-19 10:53:44.761+00	\N	\N	ecg	2.125,0.0992968646039004	8sycsF8enM	PxHgYjFpnc
MpqlEAa4jc	2021-05-19 10:53:44.812+00	2021-05-19 10:53:44.812+00	\N	\N	ecg	2.12890625,-0.0210341503077046	8sycsF8enM	PxHgYjFpnc
LgqV2ecQT3	2021-05-19 10:53:44.861+00	2021-05-19 10:53:44.861+00	\N	\N	ecg	2.1328125,0.0671065812014678	8sycsF8enM	PxHgYjFpnc
OjrhVyQFW1	2021-05-19 10:53:44.914+00	2021-05-19 10:53:44.914+00	\N	\N	ecg	2.13671875,0.11481088862095	8sycsF8enM	PxHgYjFpnc
IwJkB2yrXR	2021-05-19 10:53:44.962+00	2021-05-19 10:53:44.962+00	\N	\N	ecg	2.140625,0.0343380699276404	8sycsF8enM	PxHgYjFpnc
6E01Dy8hiV	2021-05-19 10:53:45.014+00	2021-05-19 10:53:45.014+00	\N	\N	ecg	2.14453125,0.171373661560386	8sycsF8enM	PxHgYjFpnc
DIKG61LPHP	2021-05-19 10:53:45.064+00	2021-05-19 10:53:45.064+00	\N	\N	ecg	2.1484375,0.0218884515978358	8sycsF8enM	PxHgYjFpnc
yoNFPY4DEx	2021-05-19 10:53:45.115+00	2021-05-19 10:53:45.115+00	\N	\N	ecg	2.15234375,0.135763401042889	8sycsF8enM	PxHgYjFpnc
4rRFALHhvh	2021-05-19 10:53:45.165+00	2021-05-19 10:53:45.165+00	\N	\N	ecg	2.15625,0.178347881143365	8sycsF8enM	PxHgYjFpnc
bGlWTLDgmR	2021-05-19 10:53:45.217+00	2021-05-19 10:53:45.217+00	\N	\N	ecg	2.16015625,0.0700744935663874	8sycsF8enM	PxHgYjFpnc
q0pWCjwhq4	2021-05-19 10:53:45.267+00	2021-05-19 10:53:45.267+00	\N	\N	ecg	2.1640625,0.126583310783601	8sycsF8enM	PxHgYjFpnc
9q5DI1nmoM	2021-05-19 10:53:45.318+00	2021-05-19 10:53:45.318+00	\N	\N	ecg	2.16796875,0.250651516668627	8sycsF8enM	PxHgYjFpnc
YCjt4RIsgo	2021-05-19 10:53:45.368+00	2021-05-19 10:53:45.368+00	\N	\N	ecg	2.171875,0.11405003651	8sycsF8enM	PxHgYjFpnc
pgsSw3v3ny	2021-05-19 10:53:45.418+00	2021-05-19 10:53:45.418+00	\N	\N	ecg	2.17578125,0.239882169940308	8sycsF8enM	PxHgYjFpnc
qOxaPPBsqz	2021-05-19 10:53:45.47+00	2021-05-19 10:53:45.47+00	\N	\N	ecg	2.1796875,0.159191582015438	8sycsF8enM	PxHgYjFpnc
QzEDP46YGP	2021-05-19 10:53:45.521+00	2021-05-19 10:53:45.521+00	\N	\N	ecg	2.18359375,0.145765935143261	8sycsF8enM	PxHgYjFpnc
ZBE3h270s6	2021-05-19 10:53:45.571+00	2021-05-19 10:53:45.571+00	\N	\N	ecg	2.1875,0.204971215889314	8sycsF8enM	PxHgYjFpnc
n5XccCGRrw	2021-05-19 10:53:45.622+00	2021-05-19 10:53:45.622+00	\N	\N	ecg	2.19140625,0.247349096907832	8sycsF8enM	PxHgYjFpnc
9hn0zAc67e	2021-05-19 10:53:45.672+00	2021-05-19 10:53:45.672+00	\N	\N	ecg	2.1953125,0.37358488367951	8sycsF8enM	PxHgYjFpnc
LAcrTMcTBy	2021-05-19 10:53:45.722+00	2021-05-19 10:53:45.722+00	\N	\N	ecg	2.19921875,0.237401212308442	8sycsF8enM	PxHgYjFpnc
PGHBAjPSO0	2021-05-19 10:53:45.773+00	2021-05-19 10:53:45.773+00	\N	\N	ecg	2.203125,0.399070054102479	8sycsF8enM	PxHgYjFpnc
9aALTgos3M	2021-05-19 10:53:45.823+00	2021-05-19 10:53:45.823+00	\N	\N	ecg	2.20703125,0.345663533588839	8sycsF8enM	PxHgYjFpnc
AO03WjqVcE	2021-05-19 10:53:45.874+00	2021-05-19 10:53:45.874+00	\N	\N	ecg	2.2109375,0.421630562459038	8sycsF8enM	PxHgYjFpnc
VgF22EIBSV	2021-05-19 10:53:45.924+00	2021-05-19 10:53:45.924+00	\N	\N	ecg	2.21484375,0.408571667473728	8sycsF8enM	PxHgYjFpnc
bQD5URSanz	2021-05-19 10:53:45.975+00	2021-05-19 10:53:45.975+00	\N	\N	ecg	2.21875,0.326508748625089	8sycsF8enM	PxHgYjFpnc
AQWKQVtcgs	2021-05-19 10:53:46.025+00	2021-05-19 10:53:46.025+00	\N	\N	ecg	2.22265625,0.453684747853945	8sycsF8enM	PxHgYjFpnc
3wPHnYfVjB	2021-05-19 10:53:46.076+00	2021-05-19 10:53:46.076+00	\N	\N	ecg	2.2265625,0.402663390443594	8sycsF8enM	PxHgYjFpnc
j0ui6ByB4K	2021-05-19 10:53:46.126+00	2021-05-19 10:53:46.126+00	\N	\N	ecg	2.23046875,0.454747407531027	8sycsF8enM	PxHgYjFpnc
cdPVfC4yol	2021-05-19 10:53:46.177+00	2021-05-19 10:53:46.177+00	\N	\N	ecg	2.234375,0.410165185665853	8sycsF8enM	PxHgYjFpnc
nu1W7T3o7s	2021-05-19 10:53:46.227+00	2021-05-19 10:53:46.227+00	\N	\N	ecg	2.23828125,0.335879947892884	8sycsF8enM	PxHgYjFpnc
NGxXMOFvV6	2021-05-19 10:53:46.279+00	2021-05-19 10:53:46.279+00	\N	\N	ecg	2.2421875,0.338521936402238	8sycsF8enM	PxHgYjFpnc
BQGc7X0OH9	2021-05-19 10:53:46.33+00	2021-05-19 10:53:46.33+00	\N	\N	ecg	2.24609375,0.480067383046126	8sycsF8enM	PxHgYjFpnc
DHfB6uiQMT	2021-05-19 10:53:46.38+00	2021-05-19 10:53:46.38+00	\N	\N	ecg	2.25,0.444931717265355	8sycsF8enM	PxHgYjFpnc
J6oIvyqUoc	2021-05-19 10:53:46.43+00	2021-05-19 10:53:46.43+00	\N	\N	ecg	2.25390625,0.420641810193508	8sycsF8enM	PxHgYjFpnc
IdpfRjsEdq	2021-05-19 10:53:46.482+00	2021-05-19 10:53:46.482+00	\N	\N	ecg	2.2578125,0.316493445668136	8sycsF8enM	PxHgYjFpnc
TWvMKwMLTV	2021-05-19 10:53:46.535+00	2021-05-19 10:53:46.535+00	\N	\N	ecg	2.26171875,0.309922380841522	8sycsF8enM	PxHgYjFpnc
OEOxnfFWkv	2021-05-19 10:53:46.583+00	2021-05-19 10:53:46.583+00	\N	\N	ecg	2.265625,0.279488900817205	8sycsF8enM	PxHgYjFpnc
TA5d3zOToH	2021-05-19 10:53:46.633+00	2021-05-19 10:53:46.633+00	\N	\N	ecg	2.26953125,0.315024095161497	8sycsF8enM	PxHgYjFpnc
znOCRUE4gP	2021-05-19 10:53:46.684+00	2021-05-19 10:53:46.684+00	\N	\N	ecg	2.2734375,0.320330790998883	8sycsF8enM	PxHgYjFpnc
miQb4duMqV	2021-05-19 10:53:46.735+00	2021-05-19 10:53:46.735+00	\N	\N	ecg	2.27734375,0.370425008099375	8sycsF8enM	PxHgYjFpnc
sOWhbDwbGy	2021-05-19 10:53:46.785+00	2021-05-19 10:53:46.785+00	\N	\N	ecg	2.28125,0.387059137355977	8sycsF8enM	PxHgYjFpnc
NF1wVOuBEQ	2021-05-19 10:53:46.835+00	2021-05-19 10:53:46.835+00	\N	\N	ecg	2.28515625,0.312637095674988	8sycsF8enM	PxHgYjFpnc
Hkr515ioWB	2021-05-19 10:53:46.888+00	2021-05-19 10:53:46.888+00	\N	\N	ecg	2.2890625,0.294533411534843	8sycsF8enM	PxHgYjFpnc
UcuirkwqT4	2021-05-19 10:53:46.939+00	2021-05-19 10:53:46.939+00	\N	\N	ecg	2.29296875,0.302799410682013	8sycsF8enM	PxHgYjFpnc
mBVR7VkBwD	2021-05-19 10:53:46.988+00	2021-05-19 10:53:46.988+00	\N	\N	ecg	2.296875,0.179773410836103	8sycsF8enM	PxHgYjFpnc
RH7HDgJASS	2021-05-19 10:53:47.038+00	2021-05-19 10:53:47.038+00	\N	\N	ecg	2.30078125,0.276255214340195	8sycsF8enM	PxHgYjFpnc
FCPnZnc1G4	2021-05-19 10:53:47.089+00	2021-05-19 10:53:47.089+00	\N	\N	ecg	2.3046875,0.161100726368793	8sycsF8enM	PxHgYjFpnc
PHQf4lHlYP	2021-05-19 10:53:47.139+00	2021-05-19 10:53:47.139+00	\N	\N	ecg	2.30859375,0.284264424904188	8sycsF8enM	PxHgYjFpnc
n8ZSAznCFh	2021-05-19 10:53:47.192+00	2021-05-19 10:53:47.192+00	\N	\N	ecg	2.3125,0.198367800813536	8sycsF8enM	PxHgYjFpnc
QiElD0osnR	2021-05-19 10:53:47.245+00	2021-05-19 10:53:47.245+00	\N	\N	ecg	2.31640625,0.0966300820930321	8sycsF8enM	PxHgYjFpnc
p3Q5XEOcAG	2021-05-19 10:53:47.292+00	2021-05-19 10:53:47.292+00	\N	\N	ecg	2.3203125,0.0836706917542261	8sycsF8enM	PxHgYjFpnc
xQQ5kjE5Cq	2021-05-19 10:53:47.342+00	2021-05-19 10:53:47.342+00	\N	\N	ecg	2.32421875,0.109200631654795	8sycsF8enM	PxHgYjFpnc
emlzDhAmjV	2021-05-19 10:53:47.393+00	2021-05-19 10:53:47.393+00	\N	\N	ecg	2.328125,0.094076257896318	8sycsF8enM	PxHgYjFpnc
jXvlJ8Btjo	2021-05-19 10:53:47.443+00	2021-05-19 10:53:47.443+00	\N	\N	ecg	2.33203125,0.0340272894121502	8sycsF8enM	PxHgYjFpnc
EaZtCbKyJ3	2021-05-19 10:53:47.493+00	2021-05-19 10:53:47.493+00	\N	\N	ecg	2.3359375,0.181006962891072	8sycsF8enM	PxHgYjFpnc
15jklMYUUX	2021-05-19 10:53:47.544+00	2021-05-19 10:53:47.544+00	\N	\N	ecg	2.33984375,0.166189492901873	8sycsF8enM	PxHgYjFpnc
Ci10wYWJI4	2021-05-19 10:53:47.596+00	2021-05-19 10:53:47.596+00	\N	\N	ecg	2.34375,-0.0134765328778534	8sycsF8enM	PxHgYjFpnc
IM0mImedaN	2021-05-19 10:53:47.647+00	2021-05-19 10:53:47.647+00	\N	\N	ecg	2.34765625,0.154011479402941	8sycsF8enM	PxHgYjFpnc
SsrHT5jhnv	2021-05-19 10:53:47.699+00	2021-05-19 10:53:47.699+00	\N	\N	ecg	2.3515625,0.0554861408141964	8sycsF8enM	PxHgYjFpnc
swcOM2MguC	2021-05-19 10:53:47.75+00	2021-05-19 10:53:47.75+00	\N	\N	ecg	2.35546875,0.0335430313062925	8sycsF8enM	PxHgYjFpnc
MzdSKZxDr5	2021-05-19 10:53:47.801+00	2021-05-19 10:53:47.801+00	\N	\N	ecg	2.359375,-0.0305423381088788	8sycsF8enM	PxHgYjFpnc
XJ7UbeIsyZ	2021-05-19 10:53:47.85+00	2021-05-19 10:53:47.85+00	\N	\N	ecg	2.36328125,0.0050385631803817	8sycsF8enM	PxHgYjFpnc
DRJ6yJJ3Xo	2021-05-19 10:53:47.903+00	2021-05-19 10:53:47.903+00	\N	\N	ecg	2.3671875,-0.0310119032252117	8sycsF8enM	PxHgYjFpnc
RxlnGHxrt1	2021-05-19 10:53:47.952+00	2021-05-19 10:53:47.952+00	\N	\N	ecg	2.37109375,-0.0085589146683882	8sycsF8enM	PxHgYjFpnc
MbvJ8ylBH7	2021-05-19 10:53:48.003+00	2021-05-19 10:53:48.003+00	\N	\N	ecg	2.375,-0.0413570845218212	8sycsF8enM	PxHgYjFpnc
jNzE1hChHM	2021-05-19 10:53:48.055+00	2021-05-19 10:53:48.055+00	\N	\N	ecg	2.37890625,0.0882271548048075	8sycsF8enM	PxHgYjFpnc
q9psp91JHE	2021-05-19 10:53:48.104+00	2021-05-19 10:53:48.104+00	\N	\N	ecg	2.3828125,0.00280616873407654	8sycsF8enM	PxHgYjFpnc
DffAZHBuuF	2021-05-19 10:53:48.155+00	2021-05-19 10:53:48.155+00	\N	\N	ecg	2.38671875,-0.0736756310882781	8sycsF8enM	PxHgYjFpnc
kcLZB38hL8	2021-05-19 10:53:48.207+00	2021-05-19 10:53:48.207+00	\N	\N	ecg	2.390625,-0.046991675110333	8sycsF8enM	PxHgYjFpnc
NPfLCwMSFP	2021-05-19 10:53:48.257+00	2021-05-19 10:53:48.257+00	\N	\N	ecg	2.39453125,-0.00947655728589637	8sycsF8enM	PxHgYjFpnc
Iesqc1Z07M	2021-05-19 10:53:48.308+00	2021-05-19 10:53:48.308+00	\N	\N	ecg	2.3984375,-0.117730609031758	8sycsF8enM	PxHgYjFpnc
O2EUsYuCXm	2021-05-19 10:53:48.359+00	2021-05-19 10:53:48.359+00	\N	\N	ecg	2.40234375,-0.120381648711539	8sycsF8enM	PxHgYjFpnc
DBpz63rl7h	2021-05-19 10:53:48.412+00	2021-05-19 10:53:48.412+00	\N	\N	ecg	2.40625,0.0452457250836829	8sycsF8enM	PxHgYjFpnc
rcH3QO2oNV	2021-05-19 10:53:48.461+00	2021-05-19 10:53:48.461+00	\N	\N	ecg	2.41015625,-0.13803790404141	8sycsF8enM	PxHgYjFpnc
GM7CJc6uax	2021-05-19 10:53:48.511+00	2021-05-19 10:53:48.511+00	\N	\N	ecg	2.4140625,0.022700142726962	8sycsF8enM	PxHgYjFpnc
gothdsCCwB	2021-05-19 10:53:48.561+00	2021-05-19 10:53:48.561+00	\N	\N	ecg	2.41796875,-0.121632858316668	8sycsF8enM	PxHgYjFpnc
ZiZ6A92yJU	2021-05-19 10:53:48.613+00	2021-05-19 10:53:48.613+00	\N	\N	ecg	2.421875,-0.0877866607033838	8sycsF8enM	PxHgYjFpnc
ruCqDd35Nd	2021-05-19 10:53:48.664+00	2021-05-19 10:53:48.664+00	\N	\N	ecg	2.42578125,-0.142284280941236	8sycsF8enM	PxHgYjFpnc
ZagS5Fr14D	2021-05-19 10:53:48.715+00	2021-05-19 10:53:48.715+00	\N	\N	ecg	2.4296875,-0.0438381338450631	8sycsF8enM	PxHgYjFpnc
nX5XvxkVwn	2021-05-19 10:53:48.766+00	2021-05-19 10:53:48.766+00	\N	\N	ecg	2.43359375,0.021509645885696	8sycsF8enM	PxHgYjFpnc
SBYaEHx7oG	2021-05-19 10:53:48.817+00	2021-05-19 10:53:48.817+00	\N	\N	ecg	2.4375,-0.027263162496985	8sycsF8enM	PxHgYjFpnc
BhWbFgaYTt	2021-05-19 10:53:48.867+00	2021-05-19 10:53:48.867+00	\N	\N	ecg	2.44140625,-0.0585229040973365	8sycsF8enM	PxHgYjFpnc
p9WaJ7iE4l	2021-05-19 10:53:48.919+00	2021-05-19 10:53:48.919+00	\N	\N	ecg	2.4453125,0.0528362007139422	8sycsF8enM	PxHgYjFpnc
7SWyW46aI7	2021-05-19 10:53:48.97+00	2021-05-19 10:53:48.97+00	\N	\N	ecg	2.44921875,-0.0415359512716529	8sycsF8enM	PxHgYjFpnc
tw4dAjdxCf	2021-05-19 10:53:49.02+00	2021-05-19 10:53:49.02+00	\N	\N	ecg	2.453125,-0.0664070847931159	8sycsF8enM	PxHgYjFpnc
SE4TZdWhjO	2021-05-19 10:53:49.07+00	2021-05-19 10:53:49.07+00	\N	\N	ecg	2.45703125,-0.085265913616269	8sycsF8enM	PxHgYjFpnc
tb6OOa1FYQ	2021-05-19 10:53:49.121+00	2021-05-19 10:53:49.121+00	\N	\N	ecg	2.4609375,0.0170288687324424	8sycsF8enM	PxHgYjFpnc
5MzfAyIzvY	2021-05-19 10:53:49.171+00	2021-05-19 10:53:49.171+00	\N	\N	ecg	2.46484375,-0.0994135063240511	8sycsF8enM	PxHgYjFpnc
49P2JoPUMX	2021-05-19 10:53:49.221+00	2021-05-19 10:53:49.221+00	\N	\N	ecg	2.46875,-0.0914474894169695	8sycsF8enM	PxHgYjFpnc
mb0Ve9k2yD	2021-05-19 10:53:49.274+00	2021-05-19 10:53:49.274+00	\N	\N	ecg	2.47265625,0.0573887084220024	8sycsF8enM	PxHgYjFpnc
qvjXmTxqrJ	2021-05-19 10:53:49.323+00	2021-05-19 10:53:49.323+00	\N	\N	ecg	2.4765625,-0.139721554462703	8sycsF8enM	PxHgYjFpnc
CbloHnojkE	2021-05-19 10:53:49.373+00	2021-05-19 10:53:49.373+00	\N	\N	ecg	2.48046875,-0.103318531963274	8sycsF8enM	PxHgYjFpnc
70MB27EfZL	2021-05-19 10:53:49.444+00	2021-05-19 10:53:49.444+00	\N	\N	ecg	2.484375,0.059615075962462	8sycsF8enM	PxHgYjFpnc
HcTr9ajlLQ	2021-05-19 10:53:49.483+00	2021-05-19 10:53:49.483+00	\N	\N	ecg	2.48828125,-0.0937670038975264	8sycsF8enM	PxHgYjFpnc
t1eaKMhEzV	2021-05-19 10:53:49.532+00	2021-05-19 10:53:49.532+00	\N	\N	ecg	2.4921875,0.0444557533055442	8sycsF8enM	PxHgYjFpnc
jK3dKkbCDT	2021-05-19 10:53:49.582+00	2021-05-19 10:53:49.582+00	\N	\N	ecg	2.49609375,-0.0555677239651816	8sycsF8enM	PxHgYjFpnc
s6O7ZRuzva	2021-05-19 10:53:49.632+00	2021-05-19 10:53:49.632+00	\N	\N	ecg	2.5,-0.0158356480141744	8sycsF8enM	PxHgYjFpnc
6gKAyK6kfO	2021-05-19 10:53:49.682+00	2021-05-19 10:53:49.682+00	\N	\N	ecg	2.50390625,0.0452806581720361	8sycsF8enM	PxHgYjFpnc
azCPxLwwhK	2021-05-19 10:53:49.733+00	2021-05-19 10:53:49.733+00	\N	\N	ecg	2.5078125,-0.0971565334284623	8sycsF8enM	PxHgYjFpnc
KqtEs7HfJW	2021-05-19 10:53:49.785+00	2021-05-19 10:53:49.785+00	\N	\N	ecg	2.51171875,-0.0951167169061745	8sycsF8enM	PxHgYjFpnc
mkDU6WODzf	2021-05-19 10:53:49.835+00	2021-05-19 10:53:49.835+00	\N	\N	ecg	2.515625,-0.124630870192969	8sycsF8enM	PxHgYjFpnc
LdrLxrczL2	2021-05-19 10:53:49.885+00	2021-05-19 10:53:49.885+00	\N	\N	ecg	2.51953125,0.0558887387699032	8sycsF8enM	PxHgYjFpnc
CF1FkpMNya	2021-05-19 10:53:49.937+00	2021-05-19 10:53:49.937+00	\N	\N	ecg	2.5234375,-0.115493469465828	8sycsF8enM	PxHgYjFpnc
p7Hswv6ofK	2021-05-19 10:53:49.989+00	2021-05-19 10:53:49.989+00	\N	\N	ecg	2.52734375,-0.0677631915313475	8sycsF8enM	PxHgYjFpnc
kMQFAkhFGf	2021-05-19 10:53:50.037+00	2021-05-19 10:53:50.037+00	\N	\N	ecg	2.53125,-0.0858273237588429	8sycsF8enM	PxHgYjFpnc
f0CqGpNPds	2021-05-19 10:53:50.087+00	2021-05-19 10:53:50.087+00	\N	\N	ecg	2.53515625,-0.0131629912193893	8sycsF8enM	PxHgYjFpnc
Ym3u1WCxhh	2021-05-19 10:53:50.138+00	2021-05-19 10:53:50.138+00	\N	\N	ecg	2.5390625,-0.0441037763206974	8sycsF8enM	PxHgYjFpnc
DltZWeK8Gn	2021-05-19 10:53:50.19+00	2021-05-19 10:53:50.19+00	\N	\N	ecg	2.54296875,-0.0898557529407844	8sycsF8enM	PxHgYjFpnc
er7Hec1DJt	2021-05-19 10:53:50.239+00	2021-05-19 10:53:50.239+00	\N	\N	ecg	2.546875,-0.0363553080942667	8sycsF8enM	PxHgYjFpnc
HFwSJukhqu	2021-05-19 10:53:50.29+00	2021-05-19 10:53:50.29+00	\N	\N	ecg	2.55078125,-0.0771366935216973	8sycsF8enM	PxHgYjFpnc
kQFCstfPvS	2021-05-19 10:53:50.341+00	2021-05-19 10:53:50.341+00	\N	\N	ecg	2.5546875,0.0559029316290867	8sycsF8enM	PxHgYjFpnc
69uYmtWm72	2021-05-19 10:53:50.393+00	2021-05-19 10:53:50.393+00	\N	\N	ecg	2.55859375,0.0231597739768244	8sycsF8enM	PxHgYjFpnc
pGkRMwUPVz	2021-05-19 10:53:50.443+00	2021-05-19 10:53:50.443+00	\N	\N	ecg	2.5625,-0.0807222722533805	8sycsF8enM	PxHgYjFpnc
Ty6hTY0buT	2021-05-19 10:53:50.493+00	2021-05-19 10:53:50.493+00	\N	\N	ecg	2.56640625,-0.0101844006197011	8sycsF8enM	PxHgYjFpnc
ROFePfYXwn	2021-05-19 10:53:50.544+00	2021-05-19 10:53:50.544+00	\N	\N	ecg	2.5703125,0.0237084093192928	8sycsF8enM	PxHgYjFpnc
GJXnMOr8w5	2021-05-19 10:53:50.595+00	2021-05-19 10:53:50.595+00	\N	\N	ecg	2.57421875,-0.0907511717619149	8sycsF8enM	PxHgYjFpnc
cTrTDWwvsD	2021-05-19 10:53:50.645+00	2021-05-19 10:53:50.645+00	\N	\N	ecg	2.578125,-0.0911970637256693	8sycsF8enM	PxHgYjFpnc
wMFxZUsgPk	2021-05-19 10:53:50.698+00	2021-05-19 10:53:50.698+00	\N	\N	ecg	2.58203125,-0.0589254128710708	8sycsF8enM	PxHgYjFpnc
3PsnjdYuMy	2021-05-19 10:53:50.748+00	2021-05-19 10:53:50.748+00	\N	\N	ecg	2.5859375,-0.0665505101506306	8sycsF8enM	PxHgYjFpnc
lkSwtZsHNM	2021-05-19 10:53:50.8+00	2021-05-19 10:53:50.8+00	\N	\N	ecg	2.58984375,-0.00681759073876825	8sycsF8enM	PxHgYjFpnc
0X8TvWkKsK	2021-05-19 10:53:50.849+00	2021-05-19 10:53:50.849+00	\N	\N	ecg	2.59375,-0.0997773010278427	8sycsF8enM	PxHgYjFpnc
jphFyD1JL3	2021-05-19 10:53:50.9+00	2021-05-19 10:53:50.9+00	\N	\N	ecg	2.59765625,0.0829647143113702	8sycsF8enM	PxHgYjFpnc
X3QgIGLTga	2021-05-19 10:53:50.952+00	2021-05-19 10:53:50.952+00	\N	\N	ecg	2.6015625,0.0603826463996578	8sycsF8enM	PxHgYjFpnc
oywOKeWzcA	2021-05-19 10:53:51.001+00	2021-05-19 10:53:51.001+00	\N	\N	ecg	2.60546875,-0.0453164990299239	8sycsF8enM	PxHgYjFpnc
TmdSK0ixiX	2021-05-19 10:53:51.051+00	2021-05-19 10:53:51.051+00	\N	\N	ecg	2.609375,0.044699166943504	8sycsF8enM	PxHgYjFpnc
cU7j7upBNL	2021-05-19 10:53:51.103+00	2021-05-19 10:53:51.103+00	\N	\N	ecg	2.61328125,-0.0630556407049914	8sycsF8enM	PxHgYjFpnc
ZEruEZ9dyW	2021-05-19 10:53:51.154+00	2021-05-19 10:53:51.154+00	\N	\N	ecg	2.6171875,-0.0621335284475862	8sycsF8enM	PxHgYjFpnc
kYH5e1G6u6	2021-05-19 10:53:51.205+00	2021-05-19 10:53:51.205+00	\N	\N	ecg	2.62109375,-0.0488954905998347	8sycsF8enM	PxHgYjFpnc
XoGLwBvqrc	2021-05-19 10:53:51.255+00	2021-05-19 10:53:51.255+00	\N	\N	ecg	2.625,0.0751324462188925	8sycsF8enM	PxHgYjFpnc
GSC3kGONYp	2021-05-19 10:53:51.306+00	2021-05-19 10:53:51.306+00	\N	\N	ecg	2.62890625,-0.00188934887938398	8sycsF8enM	PxHgYjFpnc
iHFIYfLawk	2021-05-19 10:53:51.357+00	2021-05-19 10:53:51.357+00	\N	\N	ecg	2.6328125,-0.0265907425432962	8sycsF8enM	PxHgYjFpnc
47RlcegDVE	2021-05-19 10:53:51.409+00	2021-05-19 10:53:51.409+00	\N	\N	ecg	2.63671875,0.0638525097770323	8sycsF8enM	PxHgYjFpnc
CdFov4mglT	2021-05-19 10:53:51.459+00	2021-05-19 10:53:51.459+00	\N	\N	ecg	2.640625,-0.0298996422801941	8sycsF8enM	PxHgYjFpnc
yC6HVs0JNJ	2021-05-19 10:53:51.509+00	2021-05-19 10:53:51.509+00	\N	\N	ecg	2.64453125,0.0392370740443337	8sycsF8enM	PxHgYjFpnc
fulBEfmR6c	2021-05-19 10:53:51.56+00	2021-05-19 10:53:51.56+00	\N	\N	ecg	2.6484375,-0.0371911865037357	8sycsF8enM	PxHgYjFpnc
iptYke7T1S	2021-05-19 10:53:51.612+00	2021-05-19 10:53:51.612+00	\N	\N	ecg	2.65234375,0.0275619973003453	8sycsF8enM	PxHgYjFpnc
2I4EdmP25X	2021-05-19 10:53:51.663+00	2021-05-19 10:53:51.663+00	\N	\N	ecg	2.65625,-0.0536530681139482	8sycsF8enM	PxHgYjFpnc
OP4sCMWEx9	2021-05-19 10:53:51.713+00	2021-05-19 10:53:51.713+00	\N	\N	ecg	2.66015625,-0.0192728154324219	8sycsF8enM	PxHgYjFpnc
colYNbRHCJ	2021-05-19 10:53:51.765+00	2021-05-19 10:53:51.765+00	\N	\N	ecg	2.6640625,-0.0208584609344444	8sycsF8enM	PxHgYjFpnc
KZA1h0RZBc	2021-05-19 10:53:51.815+00	2021-05-19 10:53:51.815+00	\N	\N	ecg	2.66796875,-0.0505181087801421	8sycsF8enM	PxHgYjFpnc
asKocTHzGB	2021-05-19 10:53:51.866+00	2021-05-19 10:53:51.866+00	\N	\N	ecg	2.671875,-0.0198608211300341	8sycsF8enM	PxHgYjFpnc
wV7l8duEkP	2021-05-19 10:53:51.916+00	2021-05-19 10:53:51.916+00	\N	\N	ecg	2.67578125,-0.00536604985980523	8sycsF8enM	PxHgYjFpnc
AVlQvJBZmN	2021-05-19 10:53:51.967+00	2021-05-19 10:53:51.967+00	\N	\N	ecg	2.6796875,-0.00678395331308003	8sycsF8enM	PxHgYjFpnc
NaidWbej0T	2021-05-19 10:53:52.018+00	2021-05-19 10:53:52.018+00	\N	\N	ecg	2.68359375,-0.0153865043130764	8sycsF8enM	PxHgYjFpnc
5WtFEd5XE1	2021-05-19 10:53:52.067+00	2021-05-19 10:53:52.067+00	\N	\N	ecg	2.6875,0.0826131786726928	8sycsF8enM	PxHgYjFpnc
v3XFVVcRKa	2021-05-19 10:53:52.12+00	2021-05-19 10:53:52.12+00	\N	\N	ecg	2.69140625,-0.0657794922748262	8sycsF8enM	PxHgYjFpnc
FDtAXSCkUV	2021-05-19 10:53:52.169+00	2021-05-19 10:53:52.169+00	\N	\N	ecg	2.6953125,0.0144229548256896	8sycsF8enM	PxHgYjFpnc
6E7nVOmuBJ	2021-05-19 10:53:52.221+00	2021-05-19 10:53:52.221+00	\N	\N	ecg	2.69921875,0.0964051724313587	8sycsF8enM	PxHgYjFpnc
FgvZs67voy	2021-05-19 10:53:52.274+00	2021-05-19 10:53:52.274+00	\N	\N	ecg	2.703125,-0.0259311850083524	8sycsF8enM	PxHgYjFpnc
R7wWjG9P5t	2021-05-19 10:53:52.321+00	2021-05-19 10:53:52.321+00	\N	\N	ecg	2.70703125,-0.0861710658390892	8sycsF8enM	PxHgYjFpnc
TNs2ab7AuJ	2021-05-19 10:53:52.371+00	2021-05-19 10:53:52.371+00	\N	\N	ecg	2.7109375,0.10873990519859	8sycsF8enM	PxHgYjFpnc
0KBx4ZqUXZ	2021-05-19 10:53:52.422+00	2021-05-19 10:53:52.422+00	\N	\N	ecg	2.71484375,-0.0354368880739339	8sycsF8enM	PxHgYjFpnc
Woxb9AIW2k	2021-05-19 10:53:52.474+00	2021-05-19 10:53:52.474+00	\N	\N	ecg	2.71875,0.0111402285344782	8sycsF8enM	PxHgYjFpnc
DLCvBBPwkf	2021-05-19 10:53:52.524+00	2021-05-19 10:53:52.524+00	\N	\N	ecg	2.72265625,-0.0454891613525848	8sycsF8enM	PxHgYjFpnc
ac8a38Jthz	2021-05-19 10:53:52.574+00	2021-05-19 10:53:52.574+00	\N	\N	ecg	2.7265625,-0.00912257595545842	8sycsF8enM	PxHgYjFpnc
HwGPHFE0LC	2021-05-19 10:53:52.624+00	2021-05-19 10:53:52.624+00	\N	\N	ecg	2.73046875,-0.0680615864745478	8sycsF8enM	PxHgYjFpnc
ihaajWUe6D	2021-05-19 10:53:52.675+00	2021-05-19 10:53:52.675+00	\N	\N	ecg	2.734375,0.127996753394931	8sycsF8enM	PxHgYjFpnc
JduC7Va46G	2021-05-19 10:53:52.727+00	2021-05-19 10:53:52.727+00	\N	\N	ecg	2.73828125,0.0997070419554419	8sycsF8enM	PxHgYjFpnc
cFEx5CEPff	2021-05-19 10:53:52.778+00	2021-05-19 10:53:52.778+00	\N	\N	ecg	2.7421875,0.123127027347168	8sycsF8enM	PxHgYjFpnc
kFOCeToLyA	2021-05-19 10:53:52.826+00	2021-05-19 10:53:52.826+00	\N	\N	ecg	2.74609375,0.136732783765027	8sycsF8enM	PxHgYjFpnc
4npgui2gi3	2021-05-19 10:53:52.878+00	2021-05-19 10:53:52.878+00	\N	\N	ecg	2.75,0.0407842622533523	8sycsF8enM	PxHgYjFpnc
jwFqyQ50CH	2021-05-19 10:53:52.928+00	2021-05-19 10:53:52.928+00	\N	\N	ecg	2.75390625,0.0864737790014718	8sycsF8enM	PxHgYjFpnc
YiwJYtoTTi	2021-05-19 10:53:52.978+00	2021-05-19 10:53:52.978+00	\N	\N	ecg	2.7578125,0.096544835028964	8sycsF8enM	PxHgYjFpnc
T6MXu7xsey	2021-05-19 10:53:53.03+00	2021-05-19 10:53:53.03+00	\N	\N	ecg	2.76171875,0.119136770566511	8sycsF8enM	PxHgYjFpnc
Ar4kFhISyl	2021-05-19 10:53:53.08+00	2021-05-19 10:53:53.08+00	\N	\N	ecg	2.765625,0.101442564498996	8sycsF8enM	PxHgYjFpnc
7BjXi5zyfd	2021-05-19 10:53:53.13+00	2021-05-19 10:53:53.13+00	\N	\N	ecg	2.76953125,0.167309437052069	8sycsF8enM	PxHgYjFpnc
e79IEcId26	2021-05-19 10:53:53.18+00	2021-05-19 10:53:53.18+00	\N	\N	ecg	2.7734375,0.0377353079026451	8sycsF8enM	PxHgYjFpnc
L4X2X9XaTt	2021-05-19 10:53:53.231+00	2021-05-19 10:53:53.231+00	\N	\N	ecg	2.77734375,0.124293133501512	8sycsF8enM	PxHgYjFpnc
eLpdraduSY	2021-05-19 10:53:53.283+00	2021-05-19 10:53:53.283+00	\N	\N	ecg	2.78125,0.134544307493096	8sycsF8enM	PxHgYjFpnc
TvT9AfaVO9	2021-05-19 10:53:53.333+00	2021-05-19 10:53:53.333+00	\N	\N	ecg	2.78515625,0.178707155894595	8sycsF8enM	PxHgYjFpnc
7k6JLUeixP	2021-05-19 10:53:53.384+00	2021-05-19 10:53:53.384+00	\N	\N	ecg	2.7890625,0.142802478724873	8sycsF8enM	PxHgYjFpnc
3HP6xNWf9W	2021-05-19 10:53:53.434+00	2021-05-19 10:53:53.434+00	\N	\N	ecg	2.79296875,0.156542060673886	8sycsF8enM	PxHgYjFpnc
lZYbk6eUp2	2021-05-19 10:53:53.484+00	2021-05-19 10:53:53.484+00	\N	\N	ecg	2.796875,0.295925466495326	8sycsF8enM	PxHgYjFpnc
hNDEwHiEIQ	2021-05-19 10:53:53.535+00	2021-05-19 10:53:53.535+00	\N	\N	ecg	2.80078125,0.203004111730433	8sycsF8enM	PxHgYjFpnc
GHDEHBfDeI	2021-05-19 10:53:53.585+00	2021-05-19 10:53:53.585+00	\N	\N	ecg	2.8046875,0.285204581463664	8sycsF8enM	PxHgYjFpnc
cqhmfQhbpe	2021-05-19 10:53:53.636+00	2021-05-19 10:53:53.636+00	\N	\N	ecg	2.80859375,0.277974916147161	8sycsF8enM	PxHgYjFpnc
FtIAywI8m2	2021-05-19 10:53:53.688+00	2021-05-19 10:53:53.688+00	\N	\N	ecg	2.8125,0.334666544429197	8sycsF8enM	PxHgYjFpnc
OiFY1qyh9y	2021-05-19 10:53:53.737+00	2021-05-19 10:53:53.737+00	\N	\N	ecg	2.81640625,0.33902974647277	8sycsF8enM	PxHgYjFpnc
qBwjW9rYez	2021-05-19 10:53:53.788+00	2021-05-19 10:53:53.788+00	\N	\N	ecg	2.8203125,0.204161476587801	8sycsF8enM	PxHgYjFpnc
pzC2xgXd11	2021-05-19 10:53:53.839+00	2021-05-19 10:53:53.839+00	\N	\N	ecg	2.82421875,0.319574367497006	8sycsF8enM	PxHgYjFpnc
jRD9C5QLSg	2021-05-19 10:53:53.889+00	2021-05-19 10:53:53.889+00	\N	\N	ecg	2.828125,0.389379361899809	8sycsF8enM	PxHgYjFpnc
8yzQTLvdmh	2021-05-19 10:53:53.941+00	2021-05-19 10:53:53.941+00	\N	\N	ecg	2.83203125,0.386061647726	8sycsF8enM	PxHgYjFpnc
92MLsqaP8I	2021-05-19 10:53:53.992+00	2021-05-19 10:53:53.992+00	\N	\N	ecg	2.8359375,0.261831010039264	8sycsF8enM	PxHgYjFpnc
reA3FIvQyw	2021-05-19 10:53:54.041+00	2021-05-19 10:53:54.041+00	\N	\N	ecg	2.83984375,0.333939310083479	8sycsF8enM	PxHgYjFpnc
d5dy35e9Rt	2021-05-19 10:53:54.093+00	2021-05-19 10:53:54.093+00	\N	\N	ecg	2.84375,0.182305701008605	8sycsF8enM	PxHgYjFpnc
AtT5cGxo9K	2021-05-19 10:53:54.143+00	2021-05-19 10:53:54.143+00	\N	\N	ecg	2.84765625,0.292685051987256	8sycsF8enM	PxHgYjFpnc
1AASiqspiB	2021-05-19 10:53:54.194+00	2021-05-19 10:53:54.194+00	\N	\N	ecg	2.8515625,0.213812050542015	8sycsF8enM	PxHgYjFpnc
hJQoW1leuO	2021-05-19 10:53:54.243+00	2021-05-19 10:53:54.243+00	\N	\N	ecg	2.85546875,0.285746439122494	8sycsF8enM	PxHgYjFpnc
PZdu83GOun	2021-05-19 10:53:54.295+00	2021-05-19 10:53:54.295+00	\N	\N	ecg	2.859375,0.229004321668699	8sycsF8enM	PxHgYjFpnc
2FU6ese50v	2021-05-19 10:53:54.345+00	2021-05-19 10:53:54.345+00	\N	\N	ecg	2.86328125,0.250698118914564	8sycsF8enM	PxHgYjFpnc
egAA6wuHB3	2021-05-19 10:53:54.396+00	2021-05-19 10:53:54.396+00	\N	\N	ecg	2.8671875,0.28438780443771	8sycsF8enM	PxHgYjFpnc
BCakGHmtCv	2021-05-19 10:53:54.447+00	2021-05-19 10:53:54.447+00	\N	\N	ecg	2.87109375,0.133227654191309	8sycsF8enM	PxHgYjFpnc
KVWa6BaB9j	2021-05-19 10:53:54.497+00	2021-05-19 10:53:54.497+00	\N	\N	ecg	2.875,0.227394325819718	8sycsF8enM	PxHgYjFpnc
uIOd5oUBZN	2021-05-19 10:53:54.548+00	2021-05-19 10:53:54.548+00	\N	\N	ecg	2.87890625,0.138843107469857	8sycsF8enM	PxHgYjFpnc
3o8fIKtGLu	2021-05-19 10:53:54.601+00	2021-05-19 10:53:54.601+00	\N	\N	ecg	2.8828125,0.120521307047579	8sycsF8enM	PxHgYjFpnc
oL0XT5ot3f	2021-05-19 10:53:54.65+00	2021-05-19 10:53:54.65+00	\N	\N	ecg	2.88671875,0.162405386679642	8sycsF8enM	PxHgYjFpnc
7HEp2K2UEL	2021-05-19 10:53:54.7+00	2021-05-19 10:53:54.7+00	\N	\N	ecg	2.890625,0.102135385367308	8sycsF8enM	PxHgYjFpnc
XYuUnrYj8q	2021-05-19 10:53:54.751+00	2021-05-19 10:53:54.751+00	\N	\N	ecg	2.89453125,0.033475768741972	8sycsF8enM	PxHgYjFpnc
ZirJVXAMSn	2021-05-19 10:53:54.804+00	2021-05-19 10:53:54.804+00	\N	\N	ecg	2.8984375,0.132676146304381	8sycsF8enM	PxHgYjFpnc
TJCPBxxL45	2021-05-19 10:53:54.852+00	2021-05-19 10:53:54.852+00	\N	\N	ecg	2.90234375,-0.00705801161508589	8sycsF8enM	PxHgYjFpnc
ekMr0j1qoC	2021-05-19 10:53:54.903+00	2021-05-19 10:53:54.903+00	\N	\N	ecg	2.90625,0.0380674905553353	8sycsF8enM	PxHgYjFpnc
eYQZq540fy	2021-05-19 10:53:54.954+00	2021-05-19 10:53:54.954+00	\N	\N	ecg	2.91015625,0.0954089623089891	8sycsF8enM	PxHgYjFpnc
p1HbeFdJ5R	2021-05-19 10:53:55.004+00	2021-05-19 10:53:55.004+00	\N	\N	ecg	2.9140625,0.0685272779988416	8sycsF8enM	PxHgYjFpnc
fy7oT65tfo	2021-05-19 10:53:55.055+00	2021-05-19 10:53:55.055+00	\N	\N	ecg	2.91796875,-0.0131143574994507	8sycsF8enM	PxHgYjFpnc
sjsYKhnMEf	2021-05-19 10:53:55.108+00	2021-05-19 10:53:55.108+00	\N	\N	ecg	2.921875,0.0845656473768603	8sycsF8enM	PxHgYjFpnc
FGdsPlghAR	2021-05-19 10:53:55.162+00	2021-05-19 10:53:55.162+00	\N	\N	ecg	2.92578125,0.0762124643422892	8sycsF8enM	PxHgYjFpnc
Hjd7jmtXJF	2021-05-19 10:53:55.207+00	2021-05-19 10:53:55.207+00	\N	\N	ecg	2.9296875,-0.0724664569693898	8sycsF8enM	PxHgYjFpnc
Di5IXEauNo	2021-05-19 10:53:55.259+00	2021-05-19 10:53:55.259+00	\N	\N	ecg	2.93359375,-0.161498432952839	8sycsF8enM	PxHgYjFpnc
oEg1OipaBb	2021-05-19 10:53:55.309+00	2021-05-19 10:53:55.309+00	\N	\N	ecg	2.9375,-0.079727714046906	8sycsF8enM	PxHgYjFpnc
irMRIDfVzA	2021-05-19 10:53:55.36+00	2021-05-19 10:53:55.36+00	\N	\N	ecg	2.94140625,-0.183467751182479	8sycsF8enM	PxHgYjFpnc
iAeM8HcE1l	2021-05-19 10:53:55.41+00	2021-05-19 10:53:55.41+00	\N	\N	ecg	2.9453125,-0.144304425275969	8sycsF8enM	PxHgYjFpnc
jGPnwlQRtP	2021-05-19 10:53:55.461+00	2021-05-19 10:53:55.461+00	\N	\N	ecg	2.94921875,-0.163458658403001	8sycsF8enM	PxHgYjFpnc
Fx0DyblEp9	2021-05-19 10:53:55.512+00	2021-05-19 10:53:55.512+00	\N	\N	ecg	2.953125,-0.0711002446953886	8sycsF8enM	PxHgYjFpnc
q0MPVWee7O	2021-05-19 10:53:55.563+00	2021-05-19 10:53:55.563+00	\N	\N	ecg	2.95703125,-0.140922149572985	8sycsF8enM	PxHgYjFpnc
yeTkKror65	2021-05-19 10:53:55.613+00	2021-05-19 10:53:55.613+00	\N	\N	ecg	2.9609375,0.0844452792869589	8sycsF8enM	PxHgYjFpnc
zch1BpPxd9	2021-05-19 10:53:55.664+00	2021-05-19 10:53:55.664+00	\N	\N	ecg	2.96484375,0.106514860005852	8sycsF8enM	PxHgYjFpnc
aQ67GFG2BX	2021-05-19 10:53:55.714+00	2021-05-19 10:53:55.714+00	\N	\N	ecg	2.96875,0.232933385838573	8sycsF8enM	PxHgYjFpnc
IJuF59gQ8S	2021-05-19 10:53:55.764+00	2021-05-19 10:53:55.764+00	\N	\N	ecg	2.97265625,0.399347566621186	8sycsF8enM	PxHgYjFpnc
HPasycLPf0	2021-05-19 10:53:55.815+00	2021-05-19 10:53:55.815+00	\N	\N	ecg	2.9765625,0.648487264644577	8sycsF8enM	PxHgYjFpnc
dfSm3VStET	2021-05-19 10:53:55.866+00	2021-05-19 10:53:55.866+00	\N	\N	ecg	2.98046875,0.788939387361108	8sycsF8enM	PxHgYjFpnc
CctauN2gEq	2021-05-19 10:53:55.916+00	2021-05-19 10:53:55.916+00	\N	\N	ecg	2.984375,1.06321073401698	8sycsF8enM	PxHgYjFpnc
e7p3N4kOXd	2021-05-19 10:53:55.966+00	2021-05-19 10:53:55.966+00	\N	\N	ecg	2.98828125,1.15679534283234	8sycsF8enM	PxHgYjFpnc
BpxZB2FW9n	2021-05-19 10:53:56.017+00	2021-05-19 10:53:56.017+00	\N	\N	ecg	2.9921875,1.08560398945084	8sycsF8enM	PxHgYjFpnc
MzLAAYhCNa	2021-05-19 10:53:56.067+00	2021-05-19 10:53:56.067+00	\N	\N	ecg	2.99609375,1.06583785466464	8sycsF8enM	PxHgYjFpnc
yIQUVYVrsO	2021-05-19 10:53:56.119+00	2021-05-19 10:53:56.119+00	\N	\N	ecg	3.0,1.12705852985289	8sycsF8enM	PxHgYjFpnc
3FP7sbaFpc	2021-05-19 10:53:56.168+00	2021-05-19 10:53:56.168+00	\N	\N	ecg	3.00390625,1.06244793594112	8sycsF8enM	PxHgYjFpnc
Vhk5xxFxrd	2021-05-19 10:53:56.22+00	2021-05-19 10:53:56.22+00	\N	\N	ecg	3.0078125,0.875759757505777	8sycsF8enM	PxHgYjFpnc
GpN4Wnlji8	2021-05-19 10:53:56.27+00	2021-05-19 10:53:56.27+00	\N	\N	ecg	3.01171875,0.823738951746154	8sycsF8enM	PxHgYjFpnc
3ZziSmWVfO	2021-05-19 10:53:56.321+00	2021-05-19 10:53:56.321+00	\N	\N	ecg	3.015625,0.604728179158279	8sycsF8enM	PxHgYjFpnc
0D4jc1J2eo	2021-05-19 10:53:56.371+00	2021-05-19 10:53:56.371+00	\N	\N	ecg	3.01953125,0.450252045996394	8sycsF8enM	PxHgYjFpnc
PO8ARJN9YE	2021-05-19 10:53:56.421+00	2021-05-19 10:53:56.421+00	\N	\N	ecg	3.0234375,0.187966012385694	8sycsF8enM	PxHgYjFpnc
0CUJHR7qzH	2021-05-19 10:53:56.473+00	2021-05-19 10:53:56.473+00	\N	\N	ecg	3.02734375,-0.0592836927927862	8sycsF8enM	PxHgYjFpnc
rYPZKO7ftv	2021-05-19 10:53:56.524+00	2021-05-19 10:53:56.524+00	\N	\N	ecg	3.03125,-0.233386801821144	8sycsF8enM	PxHgYjFpnc
iWIq5syzVJ	2021-05-19 10:53:56.574+00	2021-05-19 10:53:56.574+00	\N	\N	ecg	3.03515625,-0.206492786527422	8sycsF8enM	PxHgYjFpnc
YvrYWHhZlC	2021-05-19 10:53:56.624+00	2021-05-19 10:53:56.624+00	\N	\N	ecg	3.0390625,-0.387907012645616	8sycsF8enM	PxHgYjFpnc
49dE0a49Bq	2021-05-19 10:53:56.676+00	2021-05-19 10:53:56.676+00	\N	\N	ecg	3.04296875,-0.35693074990372	8sycsF8enM	PxHgYjFpnc
MwUpEMoncq	2021-05-19 10:53:56.726+00	2021-05-19 10:53:56.726+00	\N	\N	ecg	3.046875,-0.290222265475376	8sycsF8enM	PxHgYjFpnc
IGwwkNFY0H	2021-05-19 10:53:56.775+00	2021-05-19 10:53:56.775+00	\N	\N	ecg	3.05078125,-0.192017903885469	8sycsF8enM	PxHgYjFpnc
d1qLAP95Hv	2021-05-19 10:53:56.828+00	2021-05-19 10:53:56.828+00	\N	\N	ecg	3.0546875,-0.277527170112164	8sycsF8enM	PxHgYjFpnc
UAQde8dkSa	2021-05-19 10:53:56.877+00	2021-05-19 10:53:56.877+00	\N	\N	ecg	3.05859375,-0.250093220451493	8sycsF8enM	PxHgYjFpnc
BFLSDLuNwv	2021-05-19 10:53:56.928+00	2021-05-19 10:53:56.928+00	\N	\N	ecg	3.0625,-0.235729070324845	8sycsF8enM	PxHgYjFpnc
QGISdIrjkR	2021-05-19 10:53:56.978+00	2021-05-19 10:53:56.978+00	\N	\N	ecg	3.06640625,-0.059024185306969	8sycsF8enM	PxHgYjFpnc
t3ZUvXtj6q	2021-05-19 10:53:57.029+00	2021-05-19 10:53:57.029+00	\N	\N	ecg	3.0703125,-0.0428235239163977	8sycsF8enM	PxHgYjFpnc
gfI3fE0eOQ	2021-05-19 10:53:57.08+00	2021-05-19 10:53:57.08+00	\N	\N	ecg	3.07421875,0.0194783311918042	8sycsF8enM	PxHgYjFpnc
OsloQwWocF	2021-05-19 10:53:57.131+00	2021-05-19 10:53:57.131+00	\N	\N	ecg	3.078125,-0.131853851051741	8sycsF8enM	PxHgYjFpnc
I2euC1UeAg	2021-05-19 10:53:57.181+00	2021-05-19 10:53:57.181+00	\N	\N	ecg	3.08203125,-0.0806966713945835	8sycsF8enM	PxHgYjFpnc
2uTsZlVT3d	2021-05-19 10:53:57.232+00	2021-05-19 10:53:57.232+00	\N	\N	ecg	3.0859375,-0.045575810958973	8sycsF8enM	PxHgYjFpnc
75T8m6dHTS	2021-05-19 10:53:57.287+00	2021-05-19 10:53:57.287+00	\N	\N	ecg	3.08984375,-0.0498133966754605	8sycsF8enM	PxHgYjFpnc
uPl56hPmjy	2021-05-19 10:53:57.333+00	2021-05-19 10:53:57.333+00	\N	\N	ecg	3.09375,0.0286909842798259	8sycsF8enM	PxHgYjFpnc
XCI5tsF8zc	2021-05-19 10:53:57.383+00	2021-05-19 10:53:57.383+00	\N	\N	ecg	3.09765625,-0.101691429951695	8sycsF8enM	PxHgYjFpnc
PSqr5m2kVC	2021-05-19 10:54:09.715+00	2021-05-19 10:54:09.715+00	\N	\N	ecg	0.0,1.12705852985289	8sycsF8enM	PxHgYjFpnc
WoSsxclnVB	2021-05-19 10:54:09.742+00	2021-05-19 10:54:09.742+00	\N	\N	ecg	0.00390625,1.06244793594112	8sycsF8enM	PxHgYjFpnc
pKj7qshgdS	2021-05-19 10:54:09.79+00	2021-05-19 10:54:09.79+00	\N	\N	ecg	0.0078125,0.875759757505777	8sycsF8enM	PxHgYjFpnc
YudDeUiRAO	2021-05-19 10:54:09.838+00	2021-05-19 10:54:09.838+00	\N	\N	ecg	0.01171875,0.823738951746154	8sycsF8enM	PxHgYjFpnc
pQQwgThmJA	2021-05-19 10:54:09.889+00	2021-05-19 10:54:09.889+00	\N	\N	ecg	0.015625,0.604728179158279	8sycsF8enM	PxHgYjFpnc
tLdthT71Mr	2021-05-19 10:54:09.94+00	2021-05-19 10:54:09.94+00	\N	\N	ecg	0.01953125,0.450252045996394	8sycsF8enM	PxHgYjFpnc
i29HUepBx0	2021-05-19 10:54:09.992+00	2021-05-19 10:54:09.992+00	\N	\N	ecg	0.0234375,0.187966012385694	8sycsF8enM	PxHgYjFpnc
EP0ybf8Xxo	2021-05-19 10:54:10.041+00	2021-05-19 10:54:10.041+00	\N	\N	ecg	0.02734375,-0.0592836927927862	8sycsF8enM	PxHgYjFpnc
F3AmHYOg1E	2021-05-19 10:54:10.091+00	2021-05-19 10:54:10.091+00	\N	\N	ecg	0.03125,-0.233386801821144	8sycsF8enM	PxHgYjFpnc
qKQSVVB00A	2021-05-19 10:54:10.141+00	2021-05-19 10:54:10.141+00	\N	\N	ecg	0.03515625,-0.206492786527422	8sycsF8enM	PxHgYjFpnc
JDX5Kd76kk	2021-05-19 10:54:10.192+00	2021-05-19 10:54:10.192+00	\N	\N	ecg	0.0390625,-0.387907012645616	8sycsF8enM	PxHgYjFpnc
wg6F1n6mVl	2021-05-19 10:54:10.242+00	2021-05-19 10:54:10.242+00	\N	\N	ecg	0.04296875,-0.35693074990372	8sycsF8enM	PxHgYjFpnc
XbqJHhKOGR	2021-05-19 10:54:10.294+00	2021-05-19 10:54:10.294+00	\N	\N	ecg	0.046875,-0.290222265475376	8sycsF8enM	PxHgYjFpnc
G2SIP86Uud	2021-05-19 10:54:10.345+00	2021-05-19 10:54:10.345+00	\N	\N	ecg	0.05078125,-0.192017903885469	8sycsF8enM	PxHgYjFpnc
7iG1JHPlms	2021-05-19 10:54:10.394+00	2021-05-19 10:54:10.394+00	\N	\N	ecg	0.0546875,-0.277527170112164	8sycsF8enM	PxHgYjFpnc
lUI2NxaP5S	2021-05-19 10:54:10.445+00	2021-05-19 10:54:10.445+00	\N	\N	ecg	0.05859375,-0.250093220451493	8sycsF8enM	PxHgYjFpnc
cViNhlt9GP	2021-05-19 10:54:10.495+00	2021-05-19 10:54:10.495+00	\N	\N	ecg	0.0625,-0.235729070324845	8sycsF8enM	PxHgYjFpnc
WjzS0oZwT5	2021-05-19 10:54:10.546+00	2021-05-19 10:54:10.546+00	\N	\N	ecg	0.06640625,-0.059024185306969	8sycsF8enM	PxHgYjFpnc
Doh6SzAVwg	2021-05-19 10:54:10.596+00	2021-05-19 10:54:10.596+00	\N	\N	ecg	0.0703125,-0.0428235239163977	8sycsF8enM	PxHgYjFpnc
dQfpHwNKit	2021-05-19 10:54:10.65+00	2021-05-19 10:54:10.65+00	\N	\N	ecg	0.07421875,0.0194783311918042	8sycsF8enM	PxHgYjFpnc
IjMqcl2MaC	2021-05-19 10:54:10.7+00	2021-05-19 10:54:10.7+00	\N	\N	ecg	0.078125,-0.131853851051741	8sycsF8enM	PxHgYjFpnc
JP6gP8xyb9	2021-05-19 10:54:10.75+00	2021-05-19 10:54:10.75+00	\N	\N	ecg	0.08203125,-0.0806966713945835	8sycsF8enM	PxHgYjFpnc
UrO0HZNADZ	2021-05-19 10:54:10.799+00	2021-05-19 10:54:10.799+00	\N	\N	ecg	0.0859375,-0.045575810958973	8sycsF8enM	PxHgYjFpnc
ipxD5HFybO	2021-05-19 10:54:10.85+00	2021-05-19 10:54:10.85+00	\N	\N	ecg	0.08984375,-0.0498133966754605	8sycsF8enM	PxHgYjFpnc
ApS1F5fJue	2021-05-19 10:54:10.9+00	2021-05-19 10:54:10.9+00	\N	\N	ecg	0.09375,0.0286909842798259	8sycsF8enM	PxHgYjFpnc
FGezX7feAx	2021-05-19 10:54:10.951+00	2021-05-19 10:54:10.951+00	\N	\N	ecg	0.09765625,-0.101691429951695	8sycsF8enM	PxHgYjFpnc
oNtgP3T6rT	2021-05-19 10:54:11.002+00	2021-05-19 10:54:11.002+00	\N	\N	ecg	0.1015625,0.0688875623691073	8sycsF8enM	PxHgYjFpnc
gNC4V0llqX	2021-05-19 10:54:11.053+00	2021-05-19 10:54:11.053+00	\N	\N	ecg	0.10546875,-0.0341086571432948	8sycsF8enM	PxHgYjFpnc
Ko0DPzTgmw	2021-05-19 10:54:11.103+00	2021-05-19 10:54:11.103+00	\N	\N	ecg	0.109375,-0.00354894593836948	8sycsF8enM	PxHgYjFpnc
MBXzH53GZl	2021-05-19 10:54:11.155+00	2021-05-19 10:54:11.155+00	\N	\N	ecg	0.11328125,0.0292451353128132	8sycsF8enM	PxHgYjFpnc
7Z3gt5s5wj	2021-05-19 10:54:11.206+00	2021-05-19 10:54:11.206+00	\N	\N	ecg	0.1171875,-0.00373658554987735	8sycsF8enM	PxHgYjFpnc
8YSspJ4Beu	2021-05-19 10:54:11.255+00	2021-05-19 10:54:11.255+00	\N	\N	ecg	0.12109375,-0.0450412238007426	8sycsF8enM	PxHgYjFpnc
4dTc8Fzk9X	2021-05-19 10:54:11.305+00	2021-05-19 10:54:11.305+00	\N	\N	ecg	0.125,0.0992968646039004	8sycsF8enM	PxHgYjFpnc
TqZsRmAbRu	2021-05-19 10:54:11.355+00	2021-05-19 10:54:11.355+00	\N	\N	ecg	0.12890625,-0.0210341503077046	8sycsF8enM	PxHgYjFpnc
8AKkNhnEh0	2021-05-19 10:54:11.409+00	2021-05-19 10:54:11.409+00	\N	\N	ecg	0.1328125,0.0671065812014678	8sycsF8enM	PxHgYjFpnc
DluEBT4Uqq	2021-05-19 10:54:11.458+00	2021-05-19 10:54:11.458+00	\N	\N	ecg	0.13671875,0.11481088862095	8sycsF8enM	PxHgYjFpnc
hmC5llDGdl	2021-05-19 10:54:11.509+00	2021-05-19 10:54:11.509+00	\N	\N	ecg	0.140625,0.0343380699276404	8sycsF8enM	PxHgYjFpnc
VB0lIFyjrp	2021-05-19 10:54:11.559+00	2021-05-19 10:54:11.559+00	\N	\N	ecg	0.14453125,0.171373661560386	8sycsF8enM	PxHgYjFpnc
aeAeEIwt4N	2021-05-19 10:54:11.61+00	2021-05-19 10:54:11.61+00	\N	\N	ecg	0.1484375,0.0218884515978358	8sycsF8enM	PxHgYjFpnc
qOsHzETW2E	2021-05-19 10:54:11.66+00	2021-05-19 10:54:11.66+00	\N	\N	ecg	0.15234375,0.135763401042889	8sycsF8enM	PxHgYjFpnc
QQdyXknXnE	2021-05-19 10:54:11.712+00	2021-05-19 10:54:11.712+00	\N	\N	ecg	0.15625,0.178347881143365	8sycsF8enM	PxHgYjFpnc
KAzKQKODLJ	2021-05-19 10:54:11.764+00	2021-05-19 10:54:11.764+00	\N	\N	ecg	0.16015625,0.0700744935663874	8sycsF8enM	PxHgYjFpnc
BHLywOHCky	2021-05-19 10:54:11.814+00	2021-05-19 10:54:11.814+00	\N	\N	ecg	0.1640625,0.126583310783601	8sycsF8enM	PxHgYjFpnc
iiv5GXH687	2021-05-19 10:54:11.865+00	2021-05-19 10:54:11.865+00	\N	\N	ecg	0.16796875,0.250651516668627	8sycsF8enM	PxHgYjFpnc
Gc4gyaCNbP	2021-05-19 10:54:11.916+00	2021-05-19 10:54:11.916+00	\N	\N	ecg	0.171875,0.11405003651	8sycsF8enM	PxHgYjFpnc
XGcZeu2y8o	2021-05-19 10:54:11.967+00	2021-05-19 10:54:11.967+00	\N	\N	ecg	0.17578125,0.239882169940308	8sycsF8enM	PxHgYjFpnc
2Bi6zRBF9H	2021-05-19 10:54:12.018+00	2021-05-19 10:54:12.018+00	\N	\N	ecg	0.1796875,0.159191582015438	8sycsF8enM	PxHgYjFpnc
Oz8m4GRNJX	2021-05-19 10:54:12.067+00	2021-05-19 10:54:12.067+00	\N	\N	ecg	0.18359375,0.145765935143261	8sycsF8enM	PxHgYjFpnc
xpNRnYsxXL	2021-05-19 10:54:12.118+00	2021-05-19 10:54:12.118+00	\N	\N	ecg	0.1875,0.204971215889314	8sycsF8enM	PxHgYjFpnc
cKq41zohsm	2021-05-19 10:54:12.169+00	2021-05-19 10:54:12.169+00	\N	\N	ecg	0.19140625,0.247349096907832	8sycsF8enM	PxHgYjFpnc
aQiGsLW3Z7	2021-05-19 10:54:12.219+00	2021-05-19 10:54:12.219+00	\N	\N	ecg	0.1953125,0.37358488367951	8sycsF8enM	PxHgYjFpnc
myC8twHxaE	2021-05-19 10:54:12.27+00	2021-05-19 10:54:12.27+00	\N	\N	ecg	0.19921875,0.237401212308442	8sycsF8enM	PxHgYjFpnc
6teygRhvU3	2021-05-19 10:54:12.32+00	2021-05-19 10:54:12.32+00	\N	\N	ecg	0.203125,0.399070054102479	8sycsF8enM	PxHgYjFpnc
rMHEDaa8AZ	2021-05-19 10:54:12.371+00	2021-05-19 10:54:12.371+00	\N	\N	ecg	0.20703125,0.345663533588839	8sycsF8enM	PxHgYjFpnc
zBm9IyByEf	2021-05-19 10:54:12.421+00	2021-05-19 10:54:12.421+00	\N	\N	ecg	0.2109375,0.421630562459038	8sycsF8enM	PxHgYjFpnc
aJyMdIqEzY	2021-05-19 10:54:12.472+00	2021-05-19 10:54:12.472+00	\N	\N	ecg	0.21484375,0.408571667473728	8sycsF8enM	PxHgYjFpnc
qGuZTp319e	2021-05-19 10:54:12.524+00	2021-05-19 10:54:12.524+00	\N	\N	ecg	0.21875,0.326508748625089	8sycsF8enM	PxHgYjFpnc
YclNShF4f5	2021-05-19 10:54:12.573+00	2021-05-19 10:54:12.573+00	\N	\N	ecg	0.22265625,0.453684747853945	8sycsF8enM	PxHgYjFpnc
wwusTu01Wx	2021-05-19 10:54:12.624+00	2021-05-19 10:54:12.624+00	\N	\N	ecg	0.2265625,0.402663390443594	8sycsF8enM	PxHgYjFpnc
PlAGZzJYsk	2021-05-19 10:54:12.675+00	2021-05-19 10:54:12.675+00	\N	\N	ecg	0.23046875,0.454747407531027	8sycsF8enM	PxHgYjFpnc
VV40SM6LUn	2021-05-19 10:54:12.725+00	2021-05-19 10:54:12.725+00	\N	\N	ecg	0.234375,0.410165185665853	8sycsF8enM	PxHgYjFpnc
m7jcQBcZgo	2021-05-19 10:54:12.778+00	2021-05-19 10:54:12.778+00	\N	\N	ecg	0.23828125,0.335879947892884	8sycsF8enM	PxHgYjFpnc
wnIgqMX1UP	2021-05-19 10:54:12.826+00	2021-05-19 10:54:12.826+00	\N	\N	ecg	0.2421875,0.338521936402238	8sycsF8enM	PxHgYjFpnc
oqPEcJEhlb	2021-05-19 10:54:12.878+00	2021-05-19 10:54:12.878+00	\N	\N	ecg	0.24609375,0.480067383046126	8sycsF8enM	PxHgYjFpnc
pMYAbUkayT	2021-05-19 10:54:12.928+00	2021-05-19 10:54:12.928+00	\N	\N	ecg	0.25,0.444931717265355	8sycsF8enM	PxHgYjFpnc
tsrCVR74kq	2021-05-19 10:54:12.978+00	2021-05-19 10:54:12.978+00	\N	\N	ecg	0.25390625,0.420641810193508	8sycsF8enM	PxHgYjFpnc
lFyaeEONm5	2021-05-19 10:54:13.029+00	2021-05-19 10:54:13.029+00	\N	\N	ecg	0.2578125,0.316493445668136	8sycsF8enM	PxHgYjFpnc
AJJGxyjDzI	2021-05-19 10:54:13.081+00	2021-05-19 10:54:13.081+00	\N	\N	ecg	0.26171875,0.309922380841522	8sycsF8enM	PxHgYjFpnc
\.


--
-- Data for Name: Mission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Mission" ("objectId", "createdAt", "updatedAt", _rperm, _wperm, location, status, description, location_string) FROM stdin;
PxHgYjFpnc	2021-05-19 10:45:44.065+00	2021-05-19 10:59:56.174+00	\N	\N	(35.65244315320379,34.12557694556986)	complete	Patient had breathing problems. Did full check up. Is now stable	unnamed road, Byblos 4504
JmueAySmUQ	2021-05-19 11:17:56.865+00	2021-05-19 11:18:34.068+00	\N	\N	(35.64669249707586,34.12504405763549)	active	\N	unnamed road, Byblos 4504
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
8sycsF8enM	2021-05-19 10:46:13.465+00	2021-05-19 11:18:34.011+00	\N	\N	Fred	Saliba	Byblos	2021-05-19 00:00:00+00	Non-Binary	A+	Joseph	76585256	Georgette	03658565
\.


--
-- Data for Name: Worker; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Worker" ("objectId", "createdAt", "updatedAt", _rperm, _wperm, user_id, firstname, lastname, "phoneNb", status, image_file, distrct) FROM stdin;
a28Bm3szmT	2021-05-19 10:33:29.984+00	2021-05-19 11:18:31.302+00	\N	\N	cqhURcBVyz	Elias	Azar	03123456	online	a5283383a08d1ed551b4e45e0e234a07_eliasazar.field.png	Byblos
GcpVfUzOXE	2021-05-19 10:21:45.874+00	2021-05-19 10:22:48.653+00	\N	\N	clgZHlWYTM	John	Smith	03123456	offline	\N	Beirut
4tHW0wZIK2	2021-05-19 10:32:02.645+00	2021-05-19 10:32:02.645+00	\N	\N	QW4iXs4Hha	Melissa	Chehade	03123456	offline	99e44b1e607935c598f75cf1545eb710_melissachehade.field.png	Byblos
52Jqiym4ST	2021-05-19 10:35:44.859+00	2021-05-19 10:39:15.797+00	\N	\N	wyBIZkyHJA	Connor	Cindi	03654321	offline	3d8a2298de1d29ce0348c15b7ccb1d5d_ricardoskywalker.base.png	Byblos
9LnHdJNQev	2021-05-19 10:43:16.111+00	2021-05-19 10:43:16.111+00	\N	\N	AoOrXkhQcJ	Omar	Salem	09875854	offline	590ca01c0c5ced11216676be939041a2_omarsalem.field.png	Byblos
2ye2i4qiMi	2021-05-19 10:44:17.251+00	2021-05-19 10:44:17.251+00	\N	\N	iYGfSImCsw	Sam	Odetta	71654321	offline	7154e13b7f77fa1e9bef155defb7a431_samodetta.base.png	Byblos
uQT12VgmhA	2021-04-06 11:55:36.509+00	2021-05-19 10:44:53.032+00	\N	\N	k5vYFm0Dbd	Steve	Smith	03123456	offline	48019f2e07fe0e09a8a84e3d9479ac28_random-pic-1.jpg	Byblos
WFARTYU9J4	2021-05-19 10:31:07.686+00	2021-05-19 11:16:41.779+00	\N	\N	uB2mzyuMfO	Peter	Sakr	03123456	online	e148dc2de22c58055539c023d68abca2_petersakr.base.png	Byblos
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
WFARTYU9J4	PxHgYjFpnc
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
a28Bm3szmT	PxHgYjFpnc
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
8sycsF8enM	PxHgYjFpnc
8sycsF8enM	JmueAySmUQ
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
uB2mzyuMfO	KFNZkyJZHC
QW4iXs4Hha	VDYmJhwSss
cqhURcBVyz	VDYmJhwSss
wyBIZkyHJA	KFNZkyJZHC
AoOrXkhQcJ	VDYmJhwSss
iYGfSImCsw	KFNZkyJZHC
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
VDYmJhwSss	2021-03-29 14:24:39.544+00	2021-05-19 10:43:15.639+00	field_responder	{*,role:field_responder}	{*,role:field_responder}
KFNZkyJZHC	2021-03-29 14:24:18.304+00	2021-05-19 10:44:17.014+00	base_worker	{*,role:base_worker}	{*,role:base_worker}
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
8kIGFlvVlF	2021-05-19 10:32:02.391+00	2021-05-19 10:32:02.391+00	f	QW4iXs4Hha	8c0de27b-e126-4686-9021-8c92333f6d17	r:77c080a0869ed74ad1f96f8f5400d973	2022-05-19 10:32:02.391+00	{"action": "signup", "authProvider": "password"}	\N	\N
DgmRp4r56I	2021-05-19 10:33:29.752+00	2021-05-19 10:33:29.752+00	f	cqhURcBVyz	8c0de27b-e126-4686-9021-8c92333f6d17	r:3d3268457a1d308d6b8f92b24105ca7d	2022-05-19 10:33:29.752+00	{"action": "signup", "authProvider": "password"}	\N	\N
JRNTHUMVNK	2021-05-19 10:35:44.64+00	2021-05-19 10:35:44.64+00	f	wyBIZkyHJA	8c0de27b-e126-4686-9021-8c92333f6d17	r:9d22a672d147440b4753e9a80040af24	2022-05-19 10:35:44.64+00	{"action": "signup", "authProvider": "password"}	\N	\N
mdqx7smKCy	2021-05-19 10:43:15.617+00	2021-05-19 10:43:15.617+00	f	AoOrXkhQcJ	8c0de27b-e126-4686-9021-8c92333f6d17	r:bfd376f0aff794640f053ac631578f6a	2022-05-19 10:43:15.616+00	{"action": "signup", "authProvider": "password"}	\N	\N
HXbCDBT1my	2021-05-19 10:44:16.988+00	2021-05-19 10:44:16.988+00	f	iYGfSImCsw	8c0de27b-e126-4686-9021-8c92333f6d17	r:36e3f6ca0f878f6e4080e34e662819a1	2022-05-19 10:44:16.988+00	{"action": "signup", "authProvider": "password"}	\N	\N
LsTyCwYlBE	2021-05-19 11:16:22.778+00	2021-05-19 11:16:22.778+00	f	uB2mzyuMfO	8c0de27b-e126-4686-9021-8c92333f6d17	r:b5e0bc080b18ab8af7a81642f1a937a2	2022-05-19 11:16:22.778+00	{"action": "login", "authProvider": "password"}	\N	\N
2WPldInirp	2021-05-19 11:18:31.248+00	2021-05-19 11:18:31.248+00	f	cqhURcBVyz	fb599a81-99e8-4aa5-a63e-331554b603a9	r:a257c39ace25448ad62cfa7edfec4e4c	2022-05-19 11:18:31.248+00	{"action": "login", "authProvider": "password"}	\N	\N
\.


--
-- Data for Name: _User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_User" ("objectId", "createdAt", "updatedAt", username, email, "emailVerified", "authData", _rperm, _wperm, _hashed_password, _email_verify_token_expires_at, _email_verify_token, _account_lockout_expires_at, _failed_login_count, _perishable_token, _perishable_token_expires_at, _password_changed_at, _password_history) FROM stdin;
k5vYFm0Dbd	2021-03-29 14:32:54.523+00	2021-05-19 10:19:17.005+00	admin	joesmith.chief@gmail.com	t	\N	{*,k5vYFm0Dbd,role:district_chief}	{k5vYFm0Dbd,role:district_chief}	$2b$10$M9YaZ1cPEf7HF6mTpU85X.k3XU0.PblJED4vY1bMfMFjZ.cmq1y0G	\N	\N	\N	\N	\N	\N	\N	\N
clgZHlWYTM	2021-05-19 10:20:00.56+00	2021-05-19 10:20:35.638+00	admin.beirut	joesmith.chief.bei@gmail.com	t	\N	{*,clgZHlWYTM}	{clgZHlWYTM}	$2b$10$uMqv0HOkDCyiWsukMc7gjeFEJ4YEZb7JQnL0RUYxZfnWRqHOLEdK2	\N	\N	\N	\N	\N	\N	\N	\N
uB2mzyuMfO	2021-05-19 10:31:07.214+00	2021-05-19 10:31:07.214+00	petersakr.base	peter.sakr@gmail.com	\N	\N	{*,uB2mzyuMfO}	{uB2mzyuMfO}	$2b$10$0smlBXVYqIgvd1iZ0DAaS.6PY4txKnpz/oSvleorBSOC0LX14JX/u	\N	\N	\N	\N	\N	\N	\N	\N
QW4iXs4Hha	2021-05-19 10:32:02.31+00	2021-05-19 10:32:02.31+00	melissachehade.field	melissa.chehade@gmail.com	\N	\N	{*,QW4iXs4Hha}	{QW4iXs4Hha}	$2b$10$D3n.uI4/XalpKgvpcTPs2ucy4wwYc.mEPXs3XmQGSFmeOYguC5Gt6	\N	\N	\N	\N	\N	\N	\N	\N
cqhURcBVyz	2021-05-19 10:33:29.679+00	2021-05-19 10:33:29.679+00	eliasazar.field	elias.azar@gmail.com	\N	\N	{*,cqhURcBVyz}	{cqhURcBVyz}	$2b$10$trA7KpoCBNKYnbRDnEGOlOSE9/YvpAyjN8qBSyNl06DkrVU6hSTaa	\N	\N	\N	\N	\N	\N	\N	\N
wyBIZkyHJA	2021-05-19 10:35:44.554+00	2021-05-19 10:35:44.554+00	ricardoskywalker.base	ricardo.skywalker@gmail.com	\N	\N	{*,wyBIZkyHJA}	{wyBIZkyHJA}	$2b$10$UZPD81BnQXObWOnZqjxHweqK7C2G6KILps5rc0HIzj3L12kr7xVAW	\N	\N	\N	\N	\N	\N	\N	\N
AoOrXkhQcJ	2021-05-19 10:43:15.537+00	2021-05-19 10:43:15.537+00	omarsalem.field	omar.salem@gmail.com	\N	\N	{*,AoOrXkhQcJ}	{AoOrXkhQcJ}	$2b$10$q5lJzq53494nNwwXjhuZbuANrhWTnVVqgCskNEYBsEvxW8tvzkba6	\N	\N	\N	\N	\N	\N	\N	\N
iYGfSImCsw	2021-05-19 10:44:16.906+00	2021-05-19 10:44:16.906+00	samodetta.base	sam.odetta@gmail.com	\N	\N	{*,iYGfSImCsw}	{iYGfSImCsw}	$2b$10$j1OorZ7Qd8uJaXUt1RVD9.HP8eyrvT7Y.DhQBqNjt6PxaU09wnfla	\N	\N	\N	\N	\N	\N	\N	\N
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

