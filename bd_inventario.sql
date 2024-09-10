--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 16.2

-- Started on 2024-09-10 16:29:12

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
-- TOC entry 226 (class 1255 OID 253440)
-- Name: actualizar_fecha_verificacion(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.actualizar_fecha_verificacion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.verificado = TRUE THEN
        NEW.fecha_verificacion = CURRENT_DATE;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.actualizar_fecha_verificacion() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 250625)
-- Name: informegeneral; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.informegeneral (
    id_ig integer,
    centro_operacion character varying(50),
    numero_secuencia character varying(50),
    codigo_elemento character varying(50),
    descripcion_elemento character varying(250),
    tipo_almacenamiento character varying(50),
    fecha_ingreso date,
    unidad_medida character varying(50),
    estructura character varying(50),
    espacio character varying(50),
    costo_inicial bigint,
    cedula integer,
    responsable character varying(50)
);


ALTER TABLE public.informegeneral OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 250658)
-- Name: informeindividual; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.informeindividual (
    numero_secuencia character varying(50),
    codigo_elemento character varying(50),
    descripcion_codigo character varying(250),
    fecha_ingreso date,
    medida character varying(50),
    costo_historico character varying(50),
    tipo_partes character varying(100),
    serie character varying(50),
    plaqueta character varying(50),
    fecha_toma_fisica date,
    placa character varying(50),
    codigo_barras character varying(50),
    observaciones character varying(256)
);


ALTER TABLE public.informeindividual OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 253432)
-- Name: inventario_verificado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventario_verificado (
    id integer NOT NULL,
    centro_operacion character varying(50),
    secuencia character varying(50),
    codigo_barras character varying(50),
    codigo_elemento character varying(50),
    serie character varying(50),
    placa character varying(50),
    descripcion_elemento character varying(250),
    tipo_parte character varying(100),
    tipo_almacenamiento character varying(50),
    fecha_ingreso date,
    costo character varying(50),
    cedula_resp integer,
    responsable_inventario character varying(50),
    responsable_uso character varying(50),
    estado_elemento character varying(50),
    ub_2023 character varying(50),
    ub_verificada_2024 character varying(50),
    verificado boolean,
    fecha_verificacion date
);


ALTER TABLE public.inventario_verificado OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 253431)
-- Name: inventario_verificado_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventario_verificado_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventario_verificado_id_seq OWNER TO postgres;

--
-- TOC entry 3372 (class 0 OID 0)
-- Dependencies: 224
-- Name: inventario_verificado_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventario_verificado_id_seq OWNED BY public.inventario_verificado.id;


--
-- TOC entry 215 (class 1259 OID 250585)
-- Name: personal_litoteca; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personal_litoteca (
    id_nombre integer,
    nombre character varying(50) NOT NULL,
    cedula integer
);


ALTER TABLE public.personal_litoteca OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 243907)
-- Name: toma_fisica_062023; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toma_fisica_062023 (
    id_r integer,
    cen_operacion text,
    numero_secuencia integer,
    codigo_elemento text,
    descripcion_codigo text,
    fecha_ingreso text,
    medida text,
    estructura text,
    espacio text,
    costo_historico numeric,
    tipo_partes text,
    serie text,
    plaqueta text,
    "fecha_toma_física" integer,
    placa text,
    codigo_barras text,
    observaciones text,
    litoteca_piso integer,
    litoteca_ubicado text,
    ubicacion_2023i character varying(50)
);


ALTER TABLE public.toma_fisica_062023 OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 250602)
-- Name: toma_fisica_062024; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toma_fisica_062024 (
    codigo_barras character varying(50) NOT NULL,
    cedula integer,
    responsable_uso character varying(50),
    estado_elemento character varying(50),
    ubicacion_litoteca character varying(50),
    id integer NOT NULL,
    CONSTRAINT chk_estado_elemento CHECK (((estado_elemento)::text = ANY ((ARRAY['Bueno'::character varying, 'Inservible'::character varying])::text[])))
);


ALTER TABLE public.toma_fisica_062024 OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 250669)
-- Name: toma_fisica_062024_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.toma_fisica_062024_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.toma_fisica_062024_id_seq OWNER TO postgres;

--
-- TOC entry 3373 (class 0 OID 0)
-- Dependencies: 220
-- Name: toma_fisica_062024_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.toma_fisica_062024_id_seq OWNED BY public.toma_fisica_062024.id;


--
-- TOC entry 222 (class 1259 OID 250739)
-- Name: toma_fisica_112023; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toma_fisica_112023 (
    id integer NOT NULL,
    codigo_barras character varying(50) NOT NULL,
    secuencia character varying(50) NOT NULL,
    cedula integer,
    responsable_2023 character varying(50),
    estado_elemento character varying(50),
    u_litoteca_2023ii character varying(50),
    ubicacion_2023ii character varying(50)
);


ALTER TABLE public.toma_fisica_112023 OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 250738)
-- Name: toma_fisica_112023_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.toma_fisica_112023_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.toma_fisica_112023_id_seq OWNER TO postgres;

--
-- TOC entry 3374 (class 0 OID 0)
-- Dependencies: 221
-- Name: toma_fisica_112023_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.toma_fisica_112023_id_seq OWNED BY public.toma_fisica_112023.id;


--
-- TOC entry 216 (class 1259 OID 250588)
-- Name: ubicaciones_litoteca; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ubicaciones_litoteca (
    id_ub character varying(50),
    ubicaciones_litoteca character varying(64)
);


ALTER TABLE public.ubicaciones_litoteca OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 250803)
-- Name: varios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.varios (
    codigo_barras character varying,
    cedula integer,
    responsable_uso character varying(50),
    estado character varying(50),
    ubicacion character varying(50)
);


ALTER TABLE public.varios OWNER TO postgres;

--
-- TOC entry 3210 (class 2604 OID 253435)
-- Name: inventario_verificado id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario_verificado ALTER COLUMN id SET DEFAULT nextval('public.inventario_verificado_id_seq'::regclass);


--
-- TOC entry 3208 (class 2604 OID 250683)
-- Name: toma_fisica_062024 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toma_fisica_062024 ALTER COLUMN id SET DEFAULT nextval('public.toma_fisica_062024_id_seq'::regclass);


--
-- TOC entry 3209 (class 2604 OID 250742)
-- Name: toma_fisica_112023 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toma_fisica_112023 ALTER COLUMN id SET DEFAULT nextval('public.toma_fisica_112023_id_seq'::regclass);


--
-- TOC entry 3220 (class 2606 OID 253439)
-- Name: inventario_verificado inventario_verificado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario_verificado
    ADD CONSTRAINT inventario_verificado_pkey PRIMARY KEY (id);


--
-- TOC entry 3218 (class 2606 OID 250682)
-- Name: toma_fisica_062024 toma_fisica_062024_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toma_fisica_062024
    ADD CONSTRAINT toma_fisica_062024_pkey PRIMARY KEY (codigo_barras);


--
-- TOC entry 3213 (class 2606 OID 250685)
-- Name: personal_litoteca unique_cedula; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_litoteca
    ADD CONSTRAINT unique_cedula UNIQUE (cedula);


--
-- TOC entry 3215 (class 2606 OID 250687)
-- Name: personal_litoteca unique_nombre; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_litoteca
    ADD CONSTRAINT unique_nombre UNIQUE (nombre);


--
-- TOC entry 3216 (class 1259 OID 250679)
-- Name: idx_codigo_barras; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_codigo_barras ON public.toma_fisica_062024 USING btree (codigo_barras);


--
-- TOC entry 3224 (class 2620 OID 253441)
-- Name: inventario_verificado trigger_actualizar_fecha; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_actualizar_fecha BEFORE UPDATE OF verificado ON public.inventario_verificado FOR EACH ROW EXECUTE FUNCTION public.actualizar_fecha_verificacion();


--
-- TOC entry 3221 (class 2606 OID 250718)
-- Name: toma_fisica_062024 fk_cedula; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toma_fisica_062024
    ADD CONSTRAINT fk_cedula FOREIGN KEY (cedula) REFERENCES public.personal_litoteca(cedula);


--
-- TOC entry 3222 (class 2606 OID 250772)
-- Name: toma_fisica_062024 fk_responsable; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toma_fisica_062024
    ADD CONSTRAINT fk_responsable FOREIGN KEY (responsable_uso) REFERENCES public.personal_litoteca(nombre);


--
-- TOC entry 3223 (class 2606 OID 250777)
-- Name: toma_fisica_112023 fk_responsable_23; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toma_fisica_112023
    ADD CONSTRAINT fk_responsable_23 FOREIGN KEY (responsable_2023) REFERENCES public.personal_litoteca(nombre);


-- Completed on 2024-09-10 16:29:12

--
-- PostgreSQL database dump complete
--

