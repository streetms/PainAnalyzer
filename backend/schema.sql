--
-- PostgreSQL database dump
--

-- Dumped from database version 18.4 (Ubuntu 18.4-1.pgdg24.04+1)
-- Dumped by pg_dump version 18.4
SET search_path to thema,public;
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY thema.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_tokens_id_fk;
ALTER TABLE IF EXISTS ONLY thema.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_auth_sessions_id_fk;
ALTER TABLE IF EXISTS ONLY thema.patient_profile DROP CONSTRAINT IF EXISTS patient_profile_users_id_fk;
ALTER TABLE IF EXISTS ONLY thema.pain_episodes DROP CONSTRAINT IF EXISTS pain_episodes_patient_profile_id_fk;
ALTER TABLE IF EXISTS ONLY thema.pain_episode_features DROP CONSTRAINT IF EXISTS pain_episode_features_pain_episodes_id_fk;
ALTER TABLE IF EXISTS ONLY thema.pain_episode_features DROP CONSTRAINT IF EXISTS pain_episode_features_episode_features_id_fk;
ALTER TABLE IF EXISTS ONLY thema.magic_links DROP CONSTRAINT IF EXISTS magic_links_tokens_id_fk;
ALTER TABLE IF EXISTS ONLY thema.magic_links DROP CONSTRAINT IF EXISTS magic_links_auth_identities_id_fk;
ALTER TABLE IF EXISTS ONLY thema.episode_features DROP CONSTRAINT IF EXISTS episode_features_patient_profile_id_fk;
ALTER TABLE IF EXISTS ONLY thema.doctor_profile DROP CONSTRAINT IF EXISTS doctor_profile_users_id_fk;
ALTER TABLE IF EXISTS ONLY thema.doctor_patient DROP CONSTRAINT IF EXISTS doctor_patient_users_id_fk;
ALTER TABLE IF EXISTS ONLY thema.auth_sessions DROP CONSTRAINT IF EXISTS auth_sessions_users_id_fk;
ALTER TABLE IF EXISTS ONLY thema.auth_identities DROP CONSTRAINT IF EXISTS auth_identities_users_id_fk;
DROP INDEX IF EXISTS thema.auth_tokens_token_hash_uindex;
ALTER TABLE IF EXISTS ONLY thema.users DROP CONSTRAINT IF EXISTS users_pk;
ALTER TABLE IF EXISTS ONLY thema.tokens DROP CONSTRAINT IF EXISTS tokens_pk;
ALTER TABLE IF EXISTS ONLY thema.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_pk;
ALTER TABLE IF EXISTS ONLY thema.patient_profile DROP CONSTRAINT IF EXISTS patient_profile_pk;
ALTER TABLE IF EXISTS ONLY thema.pain_episodes DROP CONSTRAINT IF EXISTS pain_episodes_pk;
ALTER TABLE IF EXISTS ONLY thema.pain_episode_features DROP CONSTRAINT IF EXISTS pain_episode_features_pk;
ALTER TABLE IF EXISTS ONLY thema.magic_links DROP CONSTRAINT IF EXISTS magic_links_pk;
ALTER TABLE IF EXISTS ONLY thema.episode_features DROP CONSTRAINT IF EXISTS episode_features_pk_2;
ALTER TABLE IF EXISTS ONLY thema.episode_features DROP CONSTRAINT IF EXISTS episode_features_pk;
ALTER TABLE IF EXISTS ONLY thema.doctor_profile DROP CONSTRAINT IF EXISTS doctor_profile_pk;
ALTER TABLE IF EXISTS ONLY thema.doctor_patient DROP CONSTRAINT IF EXISTS doctor_patient_pk;
ALTER TABLE IF EXISTS ONLY thema.tokens DROP CONSTRAINT IF EXISTS auth_tokens_pk;
ALTER TABLE IF EXISTS ONLY thema.auth_sessions DROP CONSTRAINT IF EXISTS auth_sessions_pk;
ALTER TABLE IF EXISTS ONLY thema.auth_identities DROP CONSTRAINT IF EXISTS auth_identities_pk_3;
ALTER TABLE IF EXISTS ONLY thema.auth_identities DROP CONSTRAINT IF EXISTS auth_identities_pk_2;
ALTER TABLE IF EXISTS ONLY thema.auth_identities DROP CONSTRAINT IF EXISTS auth_identities_pk;
DROP TABLE IF EXISTS thema.users;
DROP TABLE IF EXISTS thema.refresh_tokens;
DROP TABLE IF EXISTS thema.patient_profile;
DROP TABLE IF EXISTS thema.pain_episodes;
DROP TABLE IF EXISTS thema.pain_episode_features;
DROP TABLE IF EXISTS thema.magic_links;
DROP TABLE IF EXISTS thema.episode_features;
DROP TABLE IF EXISTS thema.doctor_profile;
DROP TABLE IF EXISTS thema.doctor_patient;
DROP TABLE IF EXISTS thema.tokens;
DROP TABLE IF EXISTS thema.auth_sessions;
DROP TABLE IF EXISTS thema.auth_identities;
DROP TYPE IF EXISTS thema.user_role;
DROP TYPE IF EXISTS thema.token_type;
DROP TYPE IF EXISTS thema.link_type;
DROP TYPE IF EXISTS thema.identifier_type;
DROP TYPE IF EXISTS thema.feature_type;
DROP SCHEMA IF EXISTS thema;
--
-- Name: thema; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA thema;


--
-- Name: SCHEMA thema; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA thema IS 'standard thema schema';


--
-- Name: feature_type; Type: TYPE; Schema: thema; Owner: -
--

CREATE TYPE public.feature_type AS ENUM (
    'trigger',
    'symptom',
    'aura',
    'pain_type'
);


--
-- Name: identifier_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.identifier_type AS ENUM (
    'email'
);


--
-- Name: link_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.link_type AS ENUM (
    'register_patient'
);


--
-- Name: token_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.token_type AS ENUM (
    'magic_link'
);


--
-- Name: user_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_role AS ENUM (
    'patient',
    'doctor'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auth_identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_identities (
    id bigint NOT NULL,
    type public.identifier_type NOT NULL,
    identifier public.citext NOT NULL,
    user_id public.ulid
);


--
-- Name: auth_identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_identities ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.auth_identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_sessions (
    id bigint NOT NULL,
    user_id public.ulid,
    created_at timestamp with time zone
);


--
-- Name: auth_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_sessions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.auth_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tokens (
    id bigint NOT NULL,
    token_hash bytea NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL
);


--
-- Name: auth_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.tokens ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.auth_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: doctor_patient; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.doctor_patient (
    created_at timestamp with time zone DEFAULT now(),
    doctor_id public.ulid DEFAULT public.gen_ulid() NOT NULL,
    patient_id public.ulid DEFAULT public.gen_ulid() NOT NULL
);


--
-- Name: doctor_profile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.doctor_profile (
    fullname character varying,
    user_id public.ulid DEFAULT public.gen_ulid() NOT NULL
);


--
-- Name: episode_features; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.episode_features (
    id public.ulid DEFAULT public.gen_ulid() NOT NULL,
    name public.citext NOT NULL,
    type public.feature_type NOT NULL,
    patient_id public.ulid
);


--
-- Name: magic_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.magic_links (
    token_id bigint NOT NULL,
    type public.link_type,
    identity_id bigint,
    used_at timestamp with time zone
);


--
-- Name: pain_episode_features; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pain_episode_features (
    pain_episode_id public.ulid NOT NULL,
    episode_features_id public.ulid
);


--
-- Name: pain_episodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pain_episodes (
    id public.ulid NOT NULL,
    patient_id public.ulid NOT NULL,
    started_at timestamp with time zone NOT NULL,
    intensity smallint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: patient_profile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.patient_profile (
    fullname character varying,
    birthday date,
    height integer,
    weight integer,
    user_id public.ulid NOT NULL,
    id public.ulid DEFAULT public.gen_ulid() NOT NULL
);


--
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refresh_tokens (
    token_id bigint NOT NULL,
    used_at timestamp with time zone,
    session_id bigint,
    revoked_at timestamp with time zone
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    role public.user_role NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    id public.ulid DEFAULT public.gen_ulid() NOT NULL
);


--
-- Name: auth_identities auth_identities_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_identities
    ADD CONSTRAINT auth_identities_pk PRIMARY KEY (id);


--
-- Name: auth_identities auth_identities_pk_2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_identities
    ADD CONSTRAINT auth_identities_pk_2 UNIQUE (identifier);


--
-- Name: auth_identities auth_identities_pk_3; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_identities
    ADD CONSTRAINT auth_identities_pk_3 UNIQUE (type, identifier);


--
-- Name: auth_sessions auth_sessions_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_sessions
    ADD CONSTRAINT auth_sessions_pk PRIMARY KEY (id);


--
-- Name: tokens auth_tokens_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT auth_tokens_pk PRIMARY KEY (id);


--
-- Name: doctor_patient doctor_patient_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctor_patient
    ADD CONSTRAINT doctor_patient_pk PRIMARY KEY (doctor_id, patient_id);


--
-- Name: doctor_profile doctor_profile_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctor_profile
    ADD CONSTRAINT doctor_profile_pk PRIMARY KEY (user_id);


--
-- Name: episode_features episode_features_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.episode_features
    ADD CONSTRAINT episode_features_pk PRIMARY KEY (id);


--
-- Name: episode_features episode_features_pk_2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.episode_features
    ADD CONSTRAINT episode_features_pk_2 UNIQUE (name, type, patient_id);


--
-- Name: magic_links magic_links_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.magic_links
    ADD CONSTRAINT magic_links_pk PRIMARY KEY (token_id);


--
-- Name: pain_episode_features pain_episode_features_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pain_episode_features
    ADD CONSTRAINT pain_episode_features_pk UNIQUE (pain_episode_id, episode_features_id);


--
-- Name: pain_episodes pain_episodes_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pain_episodes
    ADD CONSTRAINT pain_episodes_pk PRIMARY KEY (id);


--
-- Name: patient_profile patient_profile_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patient_profile
    ADD CONSTRAINT patient_profile_pk PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pk PRIMARY KEY (token_id);


--
-- Name: tokens tokens_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pk UNIQUE (token_hash);


--
-- Name: users users_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pk PRIMARY KEY (id);


--
-- Name: auth_tokens_token_hash_uindex; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX auth_tokens_token_hash_uindex ON public.tokens USING btree (token_hash);


--
-- Name: auth_identities auth_identities_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_identities
    ADD CONSTRAINT auth_identities_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: auth_sessions auth_sessions_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_sessions
    ADD CONSTRAINT auth_sessions_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: doctor_patient doctor_patient_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctor_patient
    ADD CONSTRAINT doctor_patient_users_id_fk FOREIGN KEY (doctor_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: doctor_profile doctor_profile_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctor_profile
    ADD CONSTRAINT doctor_profile_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: episode_features episode_features_patient_profile_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.episode_features
    ADD CONSTRAINT episode_features_patient_profile_id_fk FOREIGN KEY (patient_id) REFERENCES public.patient_profile(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: magic_links magic_links_auth_identities_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.magic_links
    ADD CONSTRAINT magic_links_auth_identities_id_fk FOREIGN KEY (identity_id) REFERENCES public.auth_identities(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: magic_links magic_links_tokens_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.magic_links
    ADD CONSTRAINT magic_links_tokens_id_fk FOREIGN KEY (token_id) REFERENCES public.tokens(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: pain_episode_features pain_episode_features_episode_features_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pain_episode_features
    ADD CONSTRAINT pain_episode_features_episode_features_id_fk FOREIGN KEY (episode_features_id) REFERENCES public.episode_features(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pain_episode_features pain_episode_features_pain_episodes_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pain_episode_features
    ADD CONSTRAINT pain_episode_features_pain_episodes_id_fk FOREIGN KEY (pain_episode_id) REFERENCES public.pain_episodes(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pain_episodes pain_episodes_patient_profile_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pain_episodes
    ADD CONSTRAINT pain_episodes_patient_profile_id_fk FOREIGN KEY (patient_id) REFERENCES public.patient_profile(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: patient_profile patient_profile_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patient_profile
    ADD CONSTRAINT patient_profile_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_auth_sessions_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_auth_sessions_id_fk FOREIGN KEY (session_id) REFERENCES public.auth_sessions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_tokens_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_tokens_id_fk FOREIGN KEY (token_id) REFERENCES public.tokens(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--
