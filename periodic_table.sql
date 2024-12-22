--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0 (Postgres.app)
-- Dumped by pg_dump version 17.0 (Postgres.app)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: elements; Type: TABLE; Schema: public; Owner: emd
--

CREATE TABLE public.elements (
    atomic_number integer NOT NULL,
    symbol character varying(2) NOT NULL,
    name character varying(40) NOT NULL
);


ALTER TABLE public.elements OWNER TO emd;

--
-- Name: properties; Type: TABLE; Schema: public; Owner: emd
--

CREATE TABLE public.properties (
    atomic_number integer NOT NULL,
    atomic_mass numeric NOT NULL,
    melting_point_celsius numeric NOT NULL,
    boiling_point_celsius numeric NOT NULL,
    type_id integer NOT NULL
);


ALTER TABLE public.properties OWNER TO emd;

--
-- Name: types; Type: TABLE; Schema: public; Owner: emd
--

CREATE TABLE public.types (
    type_id integer NOT NULL,
    type character varying(20) NOT NULL
);


ALTER TABLE public.types OWNER TO emd;

--
-- Data for Name: elements; Type: TABLE DATA; Schema: public; Owner: emd
--

COPY public.elements (atomic_number, symbol, name) FROM stdin;
1	H	Hydrogen
2	He	Helium
3	Li	Lithium
4	Be	Beryllium
5	B	Boron
6	C	Carbon
7	N	Nitrogen
8	O	Oxygen
9	F	Fluorine
10	Ne	Neon
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: public; Owner: emd
--

COPY public.properties (atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) FROM stdin;
3	6.94	180.54	1342	0
4	9.0122	1287	2470	0
5	10.81	2075	4000	1
1	1.008	-259.1	-252.9	2
2	4.0026	-272.2	-269	2
6	12.011	3550	4027	2
7	14.007	-210.1	-195.8	2
8	15.999	-218	-183	2
9	18.998	-220	-188.1	2
10	20.18	-248.6	-246.1	2
\.


--
-- Data for Name: types; Type: TABLE DATA; Schema: public; Owner: emd
--

COPY public.types (type_id, type) FROM stdin;
0	metal
1	metalloid
2	nonmetal
\.


--
-- Name: elements elements_atomic_number_key; Type: CONSTRAINT; Schema: public; Owner: emd
--

ALTER TABLE ONLY public.elements
    ADD CONSTRAINT elements_atomic_number_key UNIQUE (atomic_number);


--
-- Name: elements elements_name_unique; Type: CONSTRAINT; Schema: public; Owner: emd
--

ALTER TABLE ONLY public.elements
    ADD CONSTRAINT elements_name_unique UNIQUE (name);


--
-- Name: elements elements_pkey; Type: CONSTRAINT; Schema: public; Owner: emd
--

ALTER TABLE ONLY public.elements
    ADD CONSTRAINT elements_pkey PRIMARY KEY (atomic_number);


--
-- Name: elements elements_symbol_unique; Type: CONSTRAINT; Schema: public; Owner: emd
--

ALTER TABLE ONLY public.elements
    ADD CONSTRAINT elements_symbol_unique UNIQUE (symbol);


--
-- Name: properties properties_atomic_number_key; Type: CONSTRAINT; Schema: public; Owner: emd
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_atomic_number_key UNIQUE (atomic_number);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: public; Owner: emd
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (atomic_number);


--
-- Name: types types_pkey; Type: CONSTRAINT; Schema: public; Owner: emd
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_pkey PRIMARY KEY (type_id);


--
-- Name: properties properties_atomic_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emd
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_atomic_number_fkey FOREIGN KEY (atomic_number) REFERENCES public.elements(atomic_number);


--
-- Name: properties properties_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emd
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.types(type_id);


--
-- PostgreSQL database dump complete
--

