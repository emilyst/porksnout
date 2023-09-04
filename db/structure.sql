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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: porkbun_certificate_bundles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.porkbun_certificate_bundles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    private_key character varying,
    public_key character varying,
    certificate_chain character varying,
    intermediate_certificate character varying,
    porkbun_domains_id uuid NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: TABLE porkbun_certificate_bundles; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.porkbun_certificate_bundles IS 'Let''s Encrypt SSL certificate bundle';


--
-- Name: porkbun_configurations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.porkbun_configurations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    url character varying DEFAULT 'https://porkbun.com/api/json/v3/'::character varying NOT NULL,
    api_key character varying NOT NULL,
    secret_key character varying NOT NULL,
    nameservers character varying[] DEFAULT '{curitiba.ns.porkbun.com,fortaleza.ns.porkbun.com,maceio.ns.porkbun.com,salvador.ns.porkbun.com}'::character varying[],
    cooldown integer,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: TABLE porkbun_configurations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.porkbun_configurations IS 'API configuration for a Porkbun account';


--
-- Name: COLUMN porkbun_configurations.url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.porkbun_configurations.url IS 'API base URL';


--
-- Name: COLUMN porkbun_configurations.api_key; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.porkbun_configurations.api_key IS 'API key';


--
-- Name: COLUMN porkbun_configurations.secret_key; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.porkbun_configurations.secret_key IS 'Secret key';


--
-- Name: COLUMN porkbun_configurations.nameservers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.porkbun_configurations.nameservers IS 'Default nameservers for domains';


--
-- Name: COLUMN porkbun_configurations.cooldown; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.porkbun_configurations.cooldown IS 'Seconds to wait between requests';


--
-- Name: porkbun_domains; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.porkbun_domains (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    nameservers character varying[] DEFAULT '{curitiba.ns.porkbun.com,fortaleza.ns.porkbun.com,maceio.ns.porkbun.com,salvador.ns.porkbun.com}'::character varying[],
    dynamic_dns boolean DEFAULT false NOT NULL,
    porkbun_configurations_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: TABLE porkbun_domains; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.porkbun_domains IS 'Domain known to Porkbun';


--
-- Name: COLUMN porkbun_domains.nameservers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.porkbun_domains.nameservers IS 'Nameservers for domain';


--
-- Name: COLUMN porkbun_domains.dynamic_dns; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.porkbun_domains.dynamic_dns IS 'Should we automatically update the domain''s A record?';


--
-- Name: porkbun_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.porkbun_records (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type character varying DEFAULT 'A'::character varying NOT NULL,
    name character varying DEFAULT '@'::character varying NOT NULL,
    content character varying NOT NULL,
    previous_content character varying,
    ttl integer,
    prio integer,
    porkbun_external_id integer,
    porkbun_domains_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: TABLE porkbun_records; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.porkbun_records IS 'Individual DNS records known to Porkbun';


--
-- Name: COLUMN porkbun_records.type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.porkbun_records.type IS 'DNS record type; defaults to A record';


--
-- Name: COLUMN porkbun_records.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.porkbun_records.name IS '`@` for root domain; `*` for wildcard; other for subdomain';


--
-- Name: COLUMN porkbun_records.content; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.porkbun_records.content IS 'Answer configured for this record';


--
-- Name: COLUMN porkbun_records.previous_content; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.porkbun_records.previous_content IS 'Previous answer configured for this record';


--
-- Name: COLUMN porkbun_records.ttl; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.porkbun_records.ttl IS 'Time in seconds this value may be cached by a nameserver';


--
-- Name: COLUMN porkbun_records.prio; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.porkbun_records.prio IS 'Priority value, if supported';


--
-- Name: COLUMN porkbun_records.porkbun_external_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.porkbun_records.porkbun_external_id IS 'Record ID assigned at Porkbun; may be null if unknown or unset';


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: porkbun_certificate_bundles porkbun_certificate_bundles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.porkbun_certificate_bundles
    ADD CONSTRAINT porkbun_certificate_bundles_pkey PRIMARY KEY (id);


--
-- Name: porkbun_configurations porkbun_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.porkbun_configurations
    ADD CONSTRAINT porkbun_configurations_pkey PRIMARY KEY (id);


--
-- Name: porkbun_domains porkbun_domains_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.porkbun_domains
    ADD CONSTRAINT porkbun_domains_pkey PRIMARY KEY (id);


--
-- Name: porkbun_records porkbun_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.porkbun_records
    ADD CONSTRAINT porkbun_records_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_porkbun_certificate_bundles_on_porkbun_domains_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_porkbun_certificate_bundles_on_porkbun_domains_id ON public.porkbun_certificate_bundles USING btree (porkbun_domains_id);


--
-- Name: index_porkbun_domains_on_porkbun_configurations_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_porkbun_domains_on_porkbun_configurations_id ON public.porkbun_domains USING btree (porkbun_configurations_id);


--
-- Name: index_porkbun_records_on_porkbun_domains_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_porkbun_records_on_porkbun_domains_id ON public.porkbun_records USING btree (porkbun_domains_id);


--
-- Name: index_porkbun_records_on_porkbun_external_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_porkbun_records_on_porkbun_external_id ON public.porkbun_records USING btree (porkbun_external_id);


--
-- Name: porkbun_certificate_bundles fk_rails_27f86157f0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.porkbun_certificate_bundles
    ADD CONSTRAINT fk_rails_27f86157f0 FOREIGN KEY (porkbun_domains_id) REFERENCES public.porkbun_domains(id);


--
-- Name: porkbun_domains fk_rails_b481532742; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.porkbun_domains
    ADD CONSTRAINT fk_rails_b481532742 FOREIGN KEY (porkbun_configurations_id) REFERENCES public.porkbun_configurations(id);


--
-- Name: porkbun_records fk_rails_ca1a143fca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.porkbun_records
    ADD CONSTRAINT fk_rails_ca1a143fca FOREIGN KEY (porkbun_domains_id) REFERENCES public.porkbun_domains(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20230904054622'),
('20230904054658'),
('20230904054707'),
('20230904063857');


