-- INVENTARIO LITOTECA NACIONAL

-- 1. Crear BD Inventario 


--- 2. TABLE public.informegeneral, reporte informe general devolutivos sin partes

CREATE TABLE public.informegeneral (
	id_ig int4 NULL,
	centro_operacion varchar(50) NULL,
	numero_secuencia varchar(50) NULL,
	codigo_elemento varchar(50) NULL,
	descripcion_elemento varchar(250) NULL,
	tipo_almacenamiento varchar(50) NULL,
	fecha_ingreso date NULL,
	unidad_medida varchar(50) NULL,
	estructura varchar(50) NULL,
	espacio varchar(50) NULL,
	costo_inicial int8 NULL,
	cedula int4 NULL,
	responsable varchar(50) NULL
);

-- Permissions

ALTER TABLE public.informegeneral OWNER TO postgres;
GRANT ALL ON TABLE public.informegeneral TO postgres;

TRUNCATE TABLE public.informegeneral; -- Eliminar datos


CREATE TABLE public.informeindividual_2024 AS 
SELECT * FROM public.informeindividual;
---- 4500 registros

DELETE FROM public.informeindividual;


CREATE TABLE public.informegeneral_2024 AS 
SELECT * FROM public.informegeneral;
---- 4.361 registros

DELETE FROM public.informegeneral;


--- Insertar datos a partir de la consulta en websafi, ajustando en archivo plano.

ALTER TABLE public.informegeneral 
ALTER COLUMN costo_inicial TYPE NUMERIC(15,2) USING costo_inicial::NUMERIC(15,2);


TRUNCATE TABLE public.informegeneral cascade; 

COPY public.informegeneral(
	id_ig,
	centro_operacion,
	numero_secuencia,
	codigo_elemento,
	descripcion_elemento,
	tipo_almacenamiento,
	fecha_ingreso,
	unidad_medida,
	estructura,
	espacio,
	costo_inicial,
	cedula,
	responsable)
FROM 'D:/SGC_2025/INVENTARIO/00_REPORTES/informe_general_devolutivos.csv'
DELIMITER ';'
CSV HEADER;

--- 4.409 registros

--- b) crear tabla informeindividual extraida de informe individual devolutivos



---- DROP TABLE public.informeindividual;

CREATE TABLE public.informeindividual (
	numero_secuencia varchar(50) NULL,
	codigo_elemento varchar(50) NULL,
	descripcion_codigo varchar(250) NULL,
	fecha_ingreso date NULL,
	medida varchar(50) NULL,
	costo_historico varchar(50) NULL,
	tipo_partes varchar(100) NULL,
	serie varchar(50) NULL,
	plaqueta varchar(50) NULL,
	fecha_toma_fisica date NULL,
	placa varchar(50) NULL,
	codigo_barras varchar(50) NULL,
	observaciones varchar(256) NULL
);


---- Permissions

ALTER TABLE public.informeindividual OWNER TO postgres;
GRANT ALL ON TABLE public.informeindividual TO postgres;



TRUNCATE TABLE public.informeindividual; -- Eliminar datos

--- Insertar datos a partir de la consulta en websafi, ajustando en archivo plano.

COPY public.informeindividual(
	numero_secuencia,
	codigo_elemento,
	descripcion_codigo,
	fecha_ingreso,
	medida,
	costo_historico,
	tipo_partes,
	serie,
	plaqueta,
	fecha_toma_fisica,
	placa,
	codigo_barras,
	observaciones)
FROM 'D:/SGC_2025/INVENTARIO/00_REPORTES/informe_individual_devolutivos.csv'
DELIMITER ';'
CSV HEADER;

DROP INDEX unique_codigo_barras_not_null;
ALTER TABLE informeindividual 
ALTER COLUMN observaciones TYPE TEXT;

-- 4673 CARACTERES

UPDATE informeindividual 
SET codigo_barras = TRANSLATE(codigo_barras, 'P_', '');


--- c) Tabla personal_litoteca 



---- DROP TABLE public.personal_litoteca;

CREATE TABLE public.personal_litoteca (
	id_nombre int4 NULL,
	nombre varchar(50) NULL,
	cedula int4 NULL
);

---- Permissions

ALTER TABLE public.personal_litoteca OWNER TO postgres;
GRANT ALL ON TABLE public.personal_litoteca TO postgres;


--- d) Tabla toma_fisica_062024, levantada con lectora de codido de barras



---- DROP TABLE public.toma_fisica_062024;

CREATE TABLE public.toma_fisica_062024 (
	codigo_barras varchar(50) NULL,
	cedula_responsable int4 NULL,
	responsable varchar(50) NULL,
	estado_elemento varchar(50) NULL,
	ubicacion_litoteca varchar(50) NULL
);


---- Permissions

ALTER TABLE public.toma_fisica_062024 OWNER TO postgres;
GRANT ALL ON TABLE public.toma_fisica_062024 TO postgres;


--- e) toma_fisica_062023 tabla entregada por Rodrigo 



---- DROP TABLE public.toma_fisica_062023;


CREATE TABLE public.toma_fisica_062023 (
	id_r int4 NULL,
	cen_operacion text NULL,
	numero_secuencia int4 NULL,
	codigo_elemento text NULL,
	descripcion_codigo text NULL,
	fecha_ingreso text NULL,
	medida text NULL,
	estructura text NULL,
	espacio text NULL,
	costo_historico numeric NULL,
	tipo_partes text NULL,
	serie text NULL,
	plaqueta text NULL,
	fecha_toma_física int4 NULL,
	placa text NULL,
	codigo_barras text NULL,
	observaciones text NULL,
	litoteca_piso int4 NULL,
	litoteca_ubicado text NULL
);


---- Permissions

ALTER TABLE public.toma_fisica_062023 OWNER TO postgres;
GRANT ALL ON TABLE public.toma_fisica_062023 TO postgres;


---- Tabla.ubicaciones_litoteca, realizada a partir de plano arquitectonico de la LN


---- DROP TABLE public.ubicaciones_litoteca;

CREATE TABLE public.ubicaciones_litoteca (
	id_ub varchar(50) NULL,
	ubicaciones_litoteca varchar(64) NULL
);

---- Permissions

ALTER TABLE public.ubicaciones_litoteca OWNER TO postgres;
GRANT ALL ON TABLE public.ubicaciones_litoteca TO postgres;


---- Permissions

GRANT ALL ON SCHEMA public TO pg_database_owner;
GRANT USAGE ON SCHEMA public TO public;


-- 2) Consultas

SELECT 
    ig.numero_secuencia AS cod_secuencia,
    ii.codigo_barras,
    ig.codigo_elemento,
    ii.serie,
    ii.placa,
    ig.descripcion_elemento,
    ii.tipo_partes AS tipo_parte,
    ig.tipo_almacenamiento,
    ig.fecha_ingreso,
    ig.costo_inicial,
    ii.costo_historico,
    ig.responsable,
    ii.fecha_toma_fisica AS toma_fisica
   
FROM 
    informegeneral ig
FULL OUTER JOIN 
    informeindividual ii ON ig.numero_secuencia = ii.numero_secuencia
ORDER BY 
    ig.descripcion_elemento,
    ii.tipo_partes;
      
--- codigo de barra sin secuencia
SELECT 
    ig.numero_secuencia AS cod_secuencia,
    ii.codigo_barras,
    ig.codigo_elemento,
    ii.serie,
    ii.placa,
    ig.descripcion_elemento,
    ii.tipo_partes AS tipo_parte,
    ig.tipo_almacenamiento,
    ig.fecha_ingreso,
    ig.costo_inicial,
    ii.costo_historico,
    ig.responsable,
    ii.fecha_toma_fisica AS toma_fisica
FROM 
    informegeneral ig
FULL OUTER JOIN 
    informeindividual ii ON ig.numero_secuencia = ii.numero_secuencia
WHERE 
    ii.numero_secuencia IS NULL OR ii.numero_secuencia = ''
ORDER BY 
    COALESCE(ig.descripcion_elemento, ''),
    ii.tipo_partes;
   
---- o registros.
SELECT 
    ig.numero_secuencia AS cod_secuencia,
    ii.codigo_barras,
    ig.codigo_elemento,
    ii.serie,
    ii.placa,
    ig.descripcion_elemento,
    ii.tipo_partes AS tipo_parte,
    ig.tipo_almacenamiento,
    ig.fecha_ingreso,
    ig.costo_inicial,
    ii.costo_historico,
    ig.responsable,
    ii.fecha_toma_fisica AS toma_fisica
FROM 
    informegeneral ig
FULL OUTER JOIN 
    informeindividual ii ON ig.numero_secuencia = ii.numero_secuencia
WHERE 
    ii.codigo_barras IS NULL OR ii.codigo_barras = ''
ORDER BY 
    COALESCE(ig.descripcion_elemento, ''),
    ii.tipo_partes;
   

---- 62 Registros que no tiene asignado un codigo de barras.


-- 3) Verificacion tablas
   
--- Toma fisica junio del 2023, realizada por rodrigo.
   select distinct
   tf.ubicacion_2023i,
   ul.ubicaciones_litoteca
   from toma_fisica_062023 tf
   left join ubicaciones_litoteca ul  on tf.ubicacion_2023i = ul.ubicaciones_litoteca;  
   
--- Toma fisica junio del 2023, realizada por todos los responsables de inventario
   select distinct
   tf.ubicacion_2023ii,
   ul.ubicaciones_litoteca
   from toma_fisica_112023 tf
   left join ubicaciones_litoteca ul  on tf.ubicacion_2023ii = ul.ubicaciones_litoteca
   where ul.ubicaciones_litoteca is null;  
  
  
   select distinct
   tf.responsable_2023,
   pl.nombre
   
   from toma_fisica_112023 tf
   left join personal_litoteca pl on tf.responsable_2023  = pl.nombre
   where pl.nombre is null; 
  
  
  
  --- Toma fisica junio del 2024, realizada por Jorge con pistola
  ---- Validación Ubicaciones
   select distinct
   tf.ubicacion_litoteca,
   ul.ubicaciones_litoteca
   from toma_fisica_062024 tf
   left join ubicaciones_litoteca ul  on tf.ubicacion_litoteca = ul.ubicaciones_litoteca
   where ul.ubicaciones_litoteca is null;  
  
  ---- Validación de nombres  
   select distinct
   tf.responsable_uso,
   pl.nombre
   from toma_fisica_062024 tf
   left join personal_litoteca pl on tf.responsable_uso  = pl.nombre
   where pl.nombre is null; 
  
   select distinct
   tf.cedula,
   pl.cedula
   from toma_fisica_062024 tf
   left join personal_litoteca pl on tf.cedula  = pl.cedula 
   where pl.cedula is null; 
  
  --- informe genral, websafi
  ---- Validación Ubicaciones
   select distinct
   ig.responsable,
   pl.nombre
   from informegeneral ig 
   left join personal_litoteca pl on ig.responsable = pl.nombre
   where pl.nombre is null;  
  
  

select distinct
   i.*
from informeindividual i
full join toma_fisica_112023 tf on i.codigo_barras = tf.codigo_barras 
where tf.codigo_barras is null;
  



  ---- Validación de nombres  
   select distinct
   tf.responsable_uso,
   pl.nombre
   
   from toma_fisica_062024 tf
   left join personal_litoteca pl on tf.responsable_uso  = pl.nombre
   where pl.nombre is null; 
  

 ---- Insertar datos 
  
/*INSERT INTO toma_fisica_062024 (codigo_barras, cedula, responsable_uso, estado_elemento, ubicacion_litoteca)
SELECT 
    i.codigo_barras, 
    '71112776', 
    'GUSTAVO ALBERTO GOMEZ GOMEZ', 
    'Bueno', 
    'Piso 1 - Sala de Conferencias'
FROM 
    informeindividual i 
WHERE 
    i.descripcion_codigo LIKE '%AUDITORIO%'
   returning *;*/


/*INSERT INTO toma_fisica_062024 (codigo_barras, cedula, responsable_uso, estado_elemento, ubicacion_litoteca)
VALUES
('006249', 80903390, 'JORGE ANDRES MELO MAYORGA', 'Inservible', 'Piso 3 - Bodega');*/
  
  

/*INSERT INTO public.toma_fisica_062024 (codigo_barras, cedula, responsable_uso, estado_elemento, ubicacion_litoteca)
VALUES 
('058706', 80903390, 'JORGE ANDRES MELO MAYORGA', 'Bueno', 'Piso 3 - Bodega'),
('058690', 80903390, 'JORGE ANDRES MELO MAYORGA', 'Bueno', 'Piso 3 - Bodega'),
('058701', 80903390, 'JORGE ANDRES MELO MAYORGA', 'Bueno', 'Piso 3 - Bodega'),
('058689', 80903390, 'JORGE ANDRES MELO MAYORGA', 'Bueno', 'Piso 3 - Bodega'),
('058682', 80903390, 'JORGE ANDRES MELO MAYORGA', 'Bueno', 'Piso 3 - Bodega'),
('058687', 80903390, 'JORGE ANDRES MELO MAYORGA', 'Bueno', 'Piso 3 - Bodega'),
('058703', 80903390, 'JORGE ANDRES MELO MAYORGA', 'Bueno', 'Piso 3 - Bodega');

  
INSERT INTO public.toma_fisica_062024 (codigo_barras, cedula, responsable_uso, estado_elemento, ubicacion_litoteca)
VALUES 
('016772', 80903390, 'JORGE ANDRES MELO MAYORGA', 'Inservible', 'Piso 3 - Bodega'),
('016773', 80903390, 'JORGE ANDRES MELO MAYORGA', 'Inservible', 'Piso 3 - Bodega'),
('016746', 80903390, 'JORGE ANDRES MELO MAYORGA', 'Inservible', 'Piso 3 - Bodega'),
('016737', 80903390, 'JORGE ANDRES MELO MAYORGA', 'Inservible', 'Piso 3 - Bodega'),
('001187', 80903390, 'JORGE ANDRES MELO MAYORGA', 'Inservible', 'Piso 3 - Bodega'),
('016731', 80903390, 'JORGE ANDRES MELO MAYORGA', 'Inservible', 'Piso 3 - Bodega');;*/

  
--- Traer ubicaciones del año 2023. 

  
/*INSERT INTO toma_fisica_062024 (codigo_barras, cedula, responsable_uso, estado_elemento, ubicacion_litoteca)
SELECT 
    tf.codigo_barras,
    '80903390' as cedula,
    'JORGE ANDRES MELO MAYORGA' as responsable_uso, 
    'Bueno' as estado_elemento,
    tf.ubicacion_2023i as ubicacion_litoteca
FROM 
    toma_fisica_062023 tf
WHERE 
    tf.codigo_barras NOT IN (SELECT codigo_barras FROM toma_fisica_062024);

INSERT INTO toma_fisica_062024 (codigo_barras, cedula, responsable_uso, estado_elemento, ubicacion_litoteca)
select 
il.codigo_barras,
'80903390' as cedula,
'JORGE ANDRES MELO MAYORGA' as responsable_uso, 
'Bueno' as estado_elemento,
il.ub_2023 
from inventario_ln il
where il.ub_2023 is not null
and ub_verificada_2024 is null;
  

select *
from toma_fisica_062023 tf
where tf.codigo_barras not in (SELECT codigo_barras FROM toma_fisica_062024);;*/
    

INSERT INTO toma_fisica_062024 (codigo_barras, cedula, responsable_uso, estado_elemento, ubicacion_litoteca)

SELECT codigo_barras,
'80903390',
'JORGE ANDRES MELO MAYORGA',
'Bueno',
'Piso 3 - Bodega'

FROM inventario_LN 
WHERE 
    ub_verificada_2024 IS NULL 
    AND cedula_resp = '80903390'
    AND descripcion_elemento ILIKE '%TAMIZ%'
returning *;   
  
  
UPDATE toma_fisica_062024
SET estado_elemento = REPLACE(estado_elemento, 'Inservible', 'Bueno')
WHERE ubicacion_litoteca = 'Piso 3 - Bodega'
RETURNING *;
  

DELETE FROM varios;
WHERE condición;



INSERT INTO toma_fisica_062024 (codigo_barras, estado_elemento, ubicacion_litoteca, cedula, responsable_uso)
SELECT 
    v.codigo_barras,
    v.estado,
    v.ubicacion,
    '80903390',
    'JORGE ANDRES MELO MAYORGA'
FROM 
    varios v
WHERE 
    NOT EXISTS (
        SELECT 1 
        FROM toma_fisica_062024 tf
        WHERE tf.codigo_barras = v.codigo_barras
    )
RETURNING *;



UPDATE toma_fisica_062024 tf
SET 
    cedula = '80903390',
    responsable_uso = 'JORGE ANDRES MELO MAYORGA',
    estado_elemento = v.estado,
    ubicacion_litoteca = v.ubicacion
FROM varios v
WHERE tf.codigo_barras = v.codigo_barras
returning *;


UPDATE inventario_verificado iv
SET 
    estado_elemento = v.estado,
    ub_verificada_2024 = v.ubicacion,
    verificado = true,
    fecha_verificacion = '2024-10-05'
FROM varios v
WHERE iv.codigo_barras = v.codigo_barras
RETURNING *;


UPDATE inventario_verificado iv
SET 
    estado_elemento = v.estado_elemento,
    ub_verificada_2024 = v.ub_verificada_2024,
    verificado = v.verificado,
    fecha_verificacion = v.fecha_verificacion 
FROM inventario_ver_2024i v
WHERE iv.codigo_barras = v.codigo_barras and iv.ub_verificada_2024 is null
RETURNING *;


-- 4 ) Tabla y Vista


--- A) Tabla

-- Crear la tabla con el identificador y la fecha de verificación
DROP TABLE public.inventario_verificado CASCADE;



-- Crear la tabla con el identificador y la fecha de verificación
CREATE TABLE public.inventario_verificado (
    id SERIAL PRIMARY KEY,
    centro_operacion varchar(50) NULL,
    secuencia varchar(50) NULL,
    codigo_barras varchar(50) NULL,
    codigo_elemento varchar(50) NULL,
    serie varchar(50) NULL,
    placa varchar(50) NULL,
    descripcion_elemento varchar(250) NULL,
    tipo_parte varchar(100) NULL,
    tipo_almacenamiento varchar(50) NULL,
    fecha_ingreso date NULL,
    costo varchar(50) NULL,
    cedula_resp int4 NULL,
    responsable_inventario varchar(50) NULL,
    responsable_uso varchar(50) NULL,
    estado_elemento varchar(50) NULL,
    ub_2023 varchar(50) NULL,
    ub_verificada_2024 varchar(50) NULL,
    verificado bool NULL,
    fecha_verificacion DATE
);


TRUNCATE TABLE public.inventario_verificado CASCADE;

-- Crear función para actualizar la fecha cuando 'verificado' sea TRUE
CREATE OR REPLACE FUNCTION actualizar_fecha_verificacion() 
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.verificado = TRUE THEN
        NEW.fecha_verificacion = CURRENT_DATE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger que llama a la función cuando se actualiza 'verificado'
CREATE TRIGGER trigger_actualizar_fecha
BEFORE UPDATE OF verificado ON public.inventario_verificado
FOR EACH ROW
EXECUTE FUNCTION actualizar_fecha_verificacion();


--- Insertar valores

INSERT INTO public.inventario_verificado (
    centro_operacion, 
    secuencia, 
    codigo_barras, 
    codigo_elemento, 
    serie, 
    placa, 
    descripcion_elemento, 
    tipo_parte, 
    tipo_almacenamiento, 
    fecha_ingreso, 
    cedula_resp, 
    responsable_inventario, 
    responsable_uso, 
    estado_elemento, 
    ub_2023, 
    ub_verificada_2024, 
    verificado,
    fecha_verificacion 
)
SELECT DISTINCT 
    ig.centro_operacion,    
    ig.numero_secuencia AS secuencia,
    ii.codigo_barras,
    ig.codigo_elemento,
    ii.serie,
    ii.placa,
    ig.descripcion_elemento,
    ii.tipo_partes AS tipo_parte,
    ig.tipo_almacenamiento,
    ig.fecha_ingreso,
    ig.cedula AS cedula_resp,
    ig.responsable AS responsable_inventario,
    tf.responsable_uso,
    tf.estado_elemento,
    tf2.ubicacion_2023ii AS ub_2023,
    tf.ubicacion_litoteca AS ub_verificada_2024,
    CASE 
        WHEN tf.ubicacion_litoteca IS NOT NULL AND tf.ubicacion_litoteca <> '' THEN TRUE
        ELSE FALSE
    END AS verificado,
    CASE 
       WHEN tf.ubicacion_litoteca IS NOT NULL AND tf.ubicacion_litoteca <> '' THEN '2024-06-28'::DATE
        ELSE NULL
    END AS fecha_verificacion
   
FROM 
    informegeneral ig
FULL OUTER JOIN 
    informeindividual ii ON ig.numero_secuencia = ii.numero_secuencia
FULL OUTER JOIN 
    toma_fisica_112023 tf2 ON ii.codigo_barras = tf2.codigo_barras
FULL OUTER JOIN  
    toma_fisica_062024 tf ON ii.codigo_barras = tf.codigo_barras
ORDER BY 
    ig.descripcion_elemento,
    ii.tipo_partes;

---- 4.763 elementos insertados.
   
   
--- B) Vista

DROP VIEW public.inventario_ln;
   
CREATE OR REPLACE VIEW public.inventario_LN AS
SELECT DISTINCT 
    ig.centro_operacion,    
    ig.numero_secuencia AS secuencia,
    ii.codigo_barras,
    ig.codigo_elemento,
    ii.serie,
    ii.placa,
    ig.descripcion_elemento,
    ii.tipo_partes AS tipo_parte,
    ig.tipo_almacenamiento,
    ig.fecha_ingreso,
    ig.cedula as cedula_resp,
    ig.responsable AS responsable_inventario,
    tf.responsable_uso,
    tf.estado_elemento,
    tf2.ubicacion_2023ii as ub_2023,
    tf.ubicacion_litoteca as ub_verificada_2024
FROM 
    informegeneral ig
FULL OUTER JOIN 
    informeindividual ii ON ig.numero_secuencia = ii.numero_secuencia
FULL OUTER JOIN  
    toma_fisica_062024 tf ON ii.codigo_barras = tf.codigo_barras
FULL OUTER JOIN 
    toma_fisica_112023 tf2 ON ii.codigo_barras = tf2.codigo_barras
ORDER BY 
    ig.descripcion_elemento,
    ii.tipo_partes;
   
   
   
CREATE OR REPLACE VIEW public.inventario_ln
AS SELECT DISTINCT COALESCE(ig.centro_operacion) AS centro_operacion,
    COALESCE(ig.numero_secuencia) AS secuencia,
    COALESCE(ii.codigo_barras, tf.codigo_barras, tf2.codigo_barras) AS codigo_barras,
    COALESCE(ig.codigo_elemento) AS codigo_elemento,
    ii.serie,
    ii.placa,
    COALESCE(ig.descripcion_elemento) AS descripcion_elemento,
    ii.tipo_partes AS tipo_parte,
    COALESCE(ig.tipo_almacenamiento) AS tipo_almacenamiento,
    COALESCE(ig.fecha_ingreso) AS fecha_ingreso,
    COALESCE(ii.costo_historico) as costo, 
    COALESCE(ig.cedula) AS cedula_resp,
    COALESCE(ig.responsable) AS responsable_inventario,
    tf.responsable_uso,
    tf.estado_elemento,
    tf2.ubicacion_2023ii AS ub_2023,
    tf.ubicacion_litoteca AS ub_verificada_2024
   FROM informegeneral ig
     FULL JOIN informeindividual ii ON ig.numero_secuencia::text = ii.numero_secuencia::text
     FULL JOIN toma_fisica_062024 tf ON ii.codigo_barras::text = tf.codigo_barras::text
     FULL JOIN toma_fisica_112023 tf2 ON ii.codigo_barras::text = tf2.codigo_barras::text
  ORDER BY (COALESCE(ig.descripcion_elemento)), ii.tipo_partes;

 
CREATE TABLE public.inventario_ln_tabla AS
SELECT *,
       FALSE AS verificado  -- Columna de tipo booleano con valor inicial FALSE
FROM public.inventario_ln;

-- 5) Consulta Usuarios
   
--- a) Consulta usuario Diego Ibañez '13923177'


   
SELECT DISTINCT 
    iln.*
FROM 
    public.inventario_ln iln
WHERE 
    iln.cedula_resp = 13923177
    and responsable_uso <> 'DIEGO GERARDO IBAÑEZ ALMEIDA'
    and estado_elemento <> 'Inservible'
   -- and tipo_almacenamiento <> 'MENOR CUANTIA - SERVICIO'

order by responsable_uso;
---- 8 Elementos para encontrar
   
SELECT DISTINCT 
    iln.*
FROM 
    public.inventario_ln iln
WHERE 
    iln.cedula_resp = 13923177 
    and ub_verificada_2024 = 'Piso 1 - Laboratorio de Placas, Modulo 1' 
    
order by iln.secuencia,
ub_verificada_2024; 

---- 5 Elementos inventario




 --- b) Consulta usuario Luis Valdivieso '1095950390'

SELECT DISTINCT 
    iln.*
FROM 
    public.inventario_ln iln
WHERE secuencia  in ('9020994');
---- Puesto de trabajo.

SELECT DISTINCT 
    iln.*
FROM 
    public.inventario_ln iln
WHERE 
    iln.cedula_resp = 10959503
    and ub_verificada_2024 is null
    --and tipo_almacenamiento = 'MENOR CUANTIA - SERVICIO'
    --and estado_elemento <> 'Inservible'
    --and responsable_uso = 'GUSTAVO ALBERTO GOMEZ GOMEZ'
    --and secuencia not in ('9020882', '9020707','9020994','9036200')
    
order by tipo_almacenamiento,
secuencia asc;

  
  SELECT DISTINCT 
    iln.*
FROM 
    public.inventario_ln iln
WHERE 
    iln.cedula_resp = 1095950390
    and ub_verificada_2024 is not null
    and responsable_uso  <> 'GUSTAVO ALBERTO GOMEZ GOMEZ'
    and estado_elemento = 'Inservible'
    and ub_verificada_2024 = 'Piso 3 - Bodega'
    and tipo_almacenamiento = 'MENOR CUANTIA - SERVICIO'
    
   order by secuencia asc;
  

UPDATE toma_fisica_062024 tf
SET estado_elemento = REPLACE(tf.estado_elemento, 'Bueno', 'Inservible')
FROM inventario_ln iln
WHERE tf.codigo_barras = iln.codigo_barras 
  AND tf.ubicacion_litoteca = 'Piso 3 - Bodega' 
  AND iln.cedula_resp = 1095950390
RETURNING *;



SELECT DISTINCT 
    ig.numero_secuencia,
    ii.codigo_barras,
    ig.codigo_elemento,;
    --ii.placa,
    ig.descripcion_elemento,
    ii.tipo_partes,
    ig.tipo_almacenamiento,
    tf.ubicacion_litoteca,
    tr.litoteca_ubicado
FROM 
    informegeneral ig
LEFT JOIN 
    informeindividual ii ON ig.numero_secuencia = ii.numero_secuencia
LEFT JOIN 
    toma_fisica_062024 tf ON ii.codigo_barras = tf.codigo_barras
LEFT JOIN 
    toma_fisica_062023 tr ON ii.codigo_barras = tr.codigo_barras 
WHERE 
    ig.cedula = 1095950390
order by ig.descripcion_elemento;


SELECT DISTINCT 
    ig.numero_secuencia,
    ii.codigo_barras,
    ig.codigo_elemento,
    --ii.placa,
    ig.descripcion_elemento,
    ii.tipo_partes,
    ig.tipo_almacenamiento,
    tf.ubicacion_litoteca,
    tr.litoteca_ubicado
FROM 
    informegeneral ig
LEFT JOIN 
    informeindividual ii ON ig.numero_secuencia = ii.numero_secuencia
LEFT JOIN 
    toma_fisica_062024 tf ON ii.codigo_barras = tf.codigo_barras
LEFT JOIN 
    toma_fisica_062023 tr ON ii.codigo_barras = tr.codigo_barras 
WHERE 
    ig.cedula = 1095950390 and tf.ubicacion_litoteca is null and ig.descripcion_elemento not like 'SILLA FIJA TIPO AUDITORIO.'
order by ig.descripcion_elemento;


--- Sillas de auditorio, 62 registros
SELECT DISTINCT 
    ig.numero_secuencia,
    ii.codigo_barras,
    ig.codigo_elemento,
    --ii.placa,
    ig.descripcion_elemento,
    ii.tipo_partes,
    ig.tipo_almacenamiento,
    tf.ubicacion_litoteca,
    tr.litoteca_ubicado
FROM 
    informegeneral ig
LEFT JOIN 
    informeindividual ii ON ig.numero_secuencia = ii.numero_secuencia
LEFT JOIN 
    toma_fisica_062024 tf ON ii.codigo_barras = tf.codigo_barras
LEFT JOIN 
    toma_fisica_062023 tr ON ii.codigo_barras = tr.codigo_barras 
WHERE 
    ig.cedula = 1095950390 and ig.descripcion_elemento like 'SILLA FIJA TIPO AUDITORIO.'
order by ig.descripcion_elemento;


-- 5) Consulta elementos

SELECT * 
FROM inventario_ln il
where il.codigo_barras in ('033329', '035152', '058688', '058704', '058711', '057680');

--OJO

SELECT * 
FROM inventario_LN 
WHERE 
    ub_verificada_2024 IS NULL 
    AND cedula_resp IN ('80903390', '71112776');, 


   
--- Reporte 211 elementos suceptibles mantenimiento

select 
COUNT (il.codigo_elemento)
FROM inventario_ln il;

---- Elementos suceptibles mantenimiento, 156 registros.
select
codigo_elemento,
secuencia,
codigo_barras,
descripcion_elemento,
tipo_parte,
fecha_ingreso,
costo,
cedula_resp as responsable,
ub_verificada_2024 as toma_fisica_2024

FROM inventario_ln il
where codigo_elemento in ('02AH00424', '02AH00151', '02AH00418', '02AH00420', '02AH00232', '02AI01491', '02AI01709', '02AK00379', 
'02AK00272', '02AI00018', '02AI01704', '02AI01141', '02AH00416', '02AH00416', '02AK00056',
'02AH00337', '02AC00522',  '02AH00421', '02AH00423', '02AH00431', '02AH00419', '02AK00383', '02AH00432', '02AC00458', '02AN00164', 
'02AI01208', '02AI01784', '02AH00406', '02AI01514', '02AI01442', '02AI01927', '02AI01833', '02AE00596', '02AI01729', '02AI01687', 
'02AI01934', '02AG00402', '02AH00422', '02AI01714', '02AH00112', '02AH00033', '02AH00032', '02AH00099', '02AH00100', '02AH00401', 
'02AI01781', '07AB00363', '02AJ00400', '02AI01782', '02AI01916', '02AH00333', '02AI01640', '02AI01786', '02AN00163', '02AJ00153',
'02AI01894', '02AE00562', '07AB00304', '02AI01895', '07AB00356', '07AB00220', '02AI01918', '02AI01905', '02AH00417', '02AI01783', '9043257') 
and cedula_resp not in ('30309914','91296385', '41723660' ) 
order by 4;

-- 53 tipos elemento suceptibles mantenimiento
select distinct 
codigo_elemento,
descripcion_elemento

FROM inventario_ln il
where codigo_elemento in ('02AH00424', '02AH00151', '02AH00418', '02AH00420', '02AH00232', '02AI01491', '02AI01709', '02AK00379', 
'02AK00272', '02AI00018', '02AI01704', '02AI01141', '02AH00416', '02AH00416', '02AK00056',
'02AH00337', '02AC00522',  '02AH00421', '02AH00423', '02AH00431', '02AH00419', '02AK00383', '02AH00432', '02AC00458', '02AN00164', 
'02AI01208', '02AI01784', '02AH00406', '02AI01514', '02AI01442', '02AI01927', '02AI01833', '02AE00596', '02AI01729', '02AI01687', 
'02AI01934', '02AG00402', '02AH00422', '02AI01714', '02AH00112', '02AH00033', '02AH00032', '02AH00099', '02AH00100', '02AH00401', 
'02AI01781', '07AB00363', '02AJ00400', '02AI01782', '02AI01916', '02AH00333', '02AI01640', '02AI01786', '02AN00163', '02AJ00153',
'02AI01894', '02AE00562', '07AB00304', '02AI01895', '07AB00356', '07AB00220', '02AI01918', '02AI01905', '02AH00417', '02AI01783', '9043257') 
and cedula_resp not in ('30309914','91296385', '41723660' )
order by 2;

select il.centro_operacion, il.secuencia, il.codigo_barras, 
il.serie, il.placa, il.descripcion_elemento, il.tipo_parte, 
il.tipo_almacenamiento, il.fecha_ingreso, il.costo, il.cedula_resp,
il.responsable_inventario, il.responsable_uso, il.estado_elemento, 
il.ub_verificada_2024
from inventario_ln il;

--- Fin


-- Consulta Contraloria 

--- Crear tabla
---- DROP TABLE public.cgr_bienesvericar;

CREATE TABLE public.cgr_bienesvericar (
	"Sec." int4 NULL,
	código varchar(50) NULL,
	"Descripción Elemento" varchar(50) NULL,
	linea varchar(10) NULL,
	"Descripción línea" varchar(100) NULL,
	clase varchar(50) NULL,
	"Descripción clase" varchar(100) NULL,
	plaqueta varchar(10) NULL,
	serie varchar(50) NULL,
	"Codigo Barras" varchar(10) NULL,
	observaciones varchar(250) NULL,
	"Cen. Op." varchar(50) NULL,
	estructura varchar(50) NULL,
	espacio varchar(50) NULL,
	"Tip. Almacenamiento" varchar(50) NULL,
	"Grupo Almacenamiento" varchar(50) NULL,
	área varchar(100) NULL,
	"No Doc." int4 NULL,
	responsable varchar(50) NULL,
	"Tipo Responsable" varchar(50) NULL,
	"Tipo Origen" varchar(50) NULL,
	"Fecha Ingreso" varchar(50) NULL,
	"No. Comprobante" varchar(10) NULL,
	antecedente varchar(50) NULL,
	"No Doc. Proveedor" varchar(10) NULL,
	proveedor varchar(50) NULL
);

--- Insertar tabla 

/*
COPY cgr_bienesvericar 
(Sec.,Código,Descripción Elemento,Linea,Descripción línea,Clase,Descripción clase,Plaqueta,Serie,Codigo Barras,Observaciones,Cen. Op.,Estructura,Espacio,Tip. Almacenamiento,Grupo Almacenamiento,Área,No Doc.,Responsable,Tipo Responsable,Tipo Origen,Fecha Ingreso,No. Comprobante,Antecedente,No Doc. Proveedor,Proveedor)
D:/SGC_2024/03_INVENTARIO/16_Contraloria/CGR_BienesVericar.csv
DELIMITER ';'
CSV HEADER;


UPDATE cgr_bienesvericar
SET observaciones = REPLACE(REPLACE(observaciones, CHR(13), ''), CHR(10), '')
WHERE observaciones ILIKE '%MARCA HP. REFERENCIA%';

UPDATE cgr_bienesvericar
SET observaciones = TRANSLATE(observaciones, 'áéíóúÁÉÍÓÚ', 'aeiouAEIOU');
*/


SELECT column_name
FROM information_schema.columns
WHERE table_name = 'cgr_bienesvericar';

ALTER TABLE public.cgr_bienesvericar RENAME COLUMN "Sec." TO secuencia;
ALTER TABLE public.cgr_bienesvericar RENAME COLUMN código TO codigo_elemento;
ALTER TABLE public.cgr_bienesvericar RENAME COLUMN "Descripción Elemento" TO descripcion_elemento;
ALTER TABLE public.cgr_bienesvericar RENAME COLUMN "Descripción línea" TO descripcion_linea;
ALTER TABLE public.cgr_bienesvericar RENAME COLUMN "Descripción clase" TO descripcion_clase;
ALTER TABLE public.cgr_bienesvericar RENAME COLUMN "Codigo Barras" TO codigo_barras;
ALTER TABLE public.cgr_bienesvericar RENAME COLUMN "Cen. Op." to centro_operacion;
ALTER TABLE public.cgr_bienesvericar RENAME COLUMN "Tip. Almacenamiento" to tipo_almacenamiento;
ALTER TABLE public.cgr_bienesvericar RENAME COLUMN "No Doc. Proveedor" TO no_proveedor;
ALTER TABLE public.cgr_bienesvericar RENAME COLUMN "No. Comprobante" TO num_comprobante;
ALTER TABLE public.cgr_bienesvericar RENAME COLUMN "Fecha Ingreso" TO fecha_ingreso;
ALTER TABLE public.cgr_bienesvericar RENAME COLUMN "Tipo Origen" TO tipo_origen;
ALTER TABLE public.cgr_bienesvericar RENAME COLUMN "Tipo Responsable" TO tipo_responsable;
ALTER TABLE public.cgr_bienesvericar RENAME COLUMN "No Doc." TO num_responsable;
ALTER TABLE public.cgr_bienesvericar RENAME COLUMN no_proveedor TO num_proveedor;
ALTER TABLE public.cgr_bienesvericar RENAME COLUMN "Grupo Almacenamiento" TO grupo_almacenamiento;
ALTER TABLE public.cgr_bienesvericar RENAME COLUMN área TO area;

ALTER TABLE public.cgr_bienesvericar ALTER COLUMN secuencia TYPE varchar(50) USING secuencia::varchar;



INSERT INTO public.cgr_bienesvericar (
    secuencia,
    codigo_elemento,
    descripcion_elemento,
    linea,
    descripcion_linea,
    clase,
    descripcion_clase,
    plaqueta,
    serie,
    codigo_barras,
    observaciones,
    centro_operacion,
    estructura,
    espacio,
    tipo_almacenamiento,
    grupo_almacenamiento,
    area,
    num_responsable,
    responsable,
    tipo_responsable,
    tipo_origen,
    fecha_ingreso,
    num_comprobante,
    antecedente,
    num_proveedor,
    proveedor
)
SELECT
    iv.secuencia,
    iv.codigo_elemento,
    iv.descripcion_elemento,
    NULL AS linea,
    NULL AS descripcion_linea,
    NULL AS clase,
    NULL AS descripcion_clase,
    iv.placa AS plaqueta,
    iv.serie,
    iv.codigo_barras,
    NULL AS observaciones,
    iv.centro_operacion,
    'LITOTECA TIERRA DE PAZ PIEDECUESTA' AS estructura,
    'UBICACION GENERAL' AS espacio,
    iv.tipo_almacenamiento,
    iv.tipo_almacenamiento AS grupo_almacenamiento,
    NULL AS area,
    iv.cedula_resp AS num_responsable,
    iv.responsable_inventario AS responsable,
    NULL AS tipo_responsable,
    NULL AS tipo_origen,
    CAST(iv.fecha_ingreso AS VARCHAR) AS fecha_ingreso,
    NULL AS num_comprobante,
    NULL AS antecedente,
    NULL AS num_proveedor,
    NULL AS proveedor
FROM public.inventario_verificado iv
WHERE iv.secuencia IN ('9043861', '9042364', '9042363', '9043388', '9043865', '9043515', '9044113', '9043396', '9043397', '9043398', '9043395', '9043392', '9043393', '9043394')
  AND iv.codigo_barras NOT IN (
    SELECT codigo_barras 
    FROM public.cgr_bienesvericar
)
RETURNING *;

---- 31 registros 

INSERT INTO public.cgr_bienesvericar (
    secuencia,
    codigo_elemento,
    descripcion_elemento,
    linea,
    descripcion_linea,
    clase,
    descripcion_clase,
    plaqueta,
    serie,
    codigo_barras,
    observaciones,
    centro_operacion,
    estructura,
    espacio,
    tipo_almacenamiento,
    grupo_almacenamiento,
    area,
    num_responsable,
    responsable,
    tipo_responsable,
    tipo_origen,
    fecha_ingreso,
    num_comprobante,
    antecedente,
    num_proveedor,
    proveedor
)
SELECT
    iv.secuencia,
    iv.codigo_elemento,
    iv.descripcion_elemento,
    NULL AS linea,
    NULL AS descripcion_linea,
    NULL AS clase,
    NULL AS descripcion_clase,
    iv.placa AS plaqueta,
    iv.serie,
    iv.codigo_barras,
    NULL AS observaciones,
    iv.centro_operacion,
    'LITOTECA TIERRA DE PAZ PIEDECUESTA' AS estructura,
    'UBICACION GENERAL' AS espacio,
    iv.tipo_almacenamiento,
    iv.tipo_almacenamiento AS grupo_almacenamiento,
    NULL AS area,
    iv.cedula_resp AS num_responsable,
    iv.responsable_inventario AS responsable,
    NULL AS tipo_responsable,
    NULL AS tipo_origen,
    CAST(iv.fecha_ingreso AS VARCHAR) AS fecha_ingreso,
    NULL AS num_comprobante,
    NULL AS antecedente,
    NULL AS num_proveedor,
    NULL AS proveedor
FROM public.inventario_verificado iv
WHERE iv.secuencia IN ('9043388', '9043396', '9043398', '9043394', '9043861', '9020879', '9021218', '9020097', '9020916',
'9021347', '9021348')
  AND iv.codigo_barras NOT IN (
    SELECT codigo_barras 
    FROM public.cgr_bienesvericar
)
RETURNING *;

--- 6 Registros

select distinct 
antecedente
from public.cgr_bienesvericar;



UPDATE public.cgr_bienesvericar
SET 
    num_comprobante = '50',
    antecedente = 'CONTRATO SGC No. 1097 de 2021'
WHERE secuencia = '9043861';

UPDATE public.cgr_bienesvericar
SET 
    num_comprobante = '188',
    antecedente = 'CONTRATO SGC No. 1102 de 2021'
WHERE secuencia = '9042364';

UPDATE public.cgr_bienesvericar
SET 
    num_comprobante = '188',
    antecedente = 'CONTRATO SGC No. 1102 de 2021'
WHERE secuencia = '9042363';

UPDATE public.cgr_bienesvericar
SET 
    num_comprobante = '22',
    antecedente = 'CONTRATO SGC No. 1102 de 2021'
WHERE secuencia = '9043388';


UPDATE public.cgr_bienesvericar
SET 
    num_comprobante = '52',
    antecedente = 'CONTRATO SGC No. 1102 de 2021'
WHERE secuencia = '9043865';

UPDATE public.cgr_bienesvericar
SET 
    num_comprobante = '21',
    antecedente = 'CONTRATO SGC No. 1102 de 2021'
WHERE secuencia = '9043515';

UPDATE public.cgr_bienesvericar
SET 
    num_comprobante = '67',
    antecedente = 'CONTRATO SGC No. 1102 de 2021'
WHERE secuencia = '9044113';


UPDATE public.cgr_bienesvericar
SET 
    num_comprobante = '25',
    antecedente = 'CONTRATO SGC No. 1044 de 2021'
WHERE secuencia IN ('9043392', '9043393','9043394','9043395', '9043396', '9043397', '9043398');


--- actualizar ubciaciones wms

UPDATE public.inventario_pallets ip
SET ubicacion = l.ubicacion
FROM public.location l
WHERE ip.id_pallet = l.pallet;





--- Consulta
CREATE TABLE public.inv_cgr_verificar AS
SELECT 
    iv.centro_operacion,
    iv.codigo_elemento,
    iv.secuencia,
    iv.codigo_barras,
    iv.serie,
    iv.placa,
    iv.descripcion_elemento,
    iv.tipo_parte,
    iv.tipo_almacenamiento,
    iv.cedula_resp,
    iv.responsable_inventario,
    UPPER(cg.antecedente) AS contrato_oc,
    cg.tipo_origen,
    cg.fecha_ingreso,
    cg.num_comprobante,
    cg.num_proveedor,
    cg.proveedor,
    UPPER(cg.observaciones) AS observacion,
    COALESCE(
        CASE 
            WHEN iv.descripcion_elemento = 'ESTANTE METALICO' THEN ip.ubicacion
            ELSE iv.ub_verificada_2024
        END,
        iv.ub_verificada_2024
    ) AS ubicacion,
    NULL::boolean AS verificado, -- Nueva columna verificado
    NULL::timestamp AS fecha_verificacion -- Nueva columna fecha_verificacion con fecha y hora
FROM cgr_bienesvericar cg
LEFT JOIN inventario_verificado iv ON cg.codigo_barras = iv.codigo_barras
LEFT JOIN inventario_pallets ip ON iv.codigo_barras = ip.placa_sgc
ORDER BY iv.ub_verificada_2024 DESC;

--- Funciones Fecha
UPDATE inv_cgr_verificar
SET verificado = false;
WHERE verificado = TRUE;

CREATE OR REPLACE FUNCTION actualizar_fecha_verificacion()
RETURNS TRIGGER AS $$
BEGIN
    -- Solo actualizamos la fecha si el valor de "verificado" ha cambiado
    IF NEW.verificado IS DISTINCT FROM OLD.verificado THEN
        NEW.fecha_verificacion := NOW(); -- Establece la fecha y hora actuales
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_actualizar_fecha_verificacion
BEFORE UPDATE ON inv_cgr_verificar
FOR EACH ROW
EXECUTE FUNCTION actualizar_fecha_verificacion();

-- FIN



-- DELETE FROM inv_cgr_verificar;
-- importar datos

UPDATE inv_cgr_verificar
SET 
    verificado = TRUE,
    fecha_verificacion = '2024-10-08'
WHERE ubicacion LIKE 'A-%'
RETURNING *;


UPDATE public.inventario_verificado iv
SET 
    ub_verificada_2024 = cgr.ubicacion,
    verificado = cgr.verificado,
    fecha_verificacion = cgr.fecha_verificacion 
FROM inv_cgr_verificar cgr
WHERE iv.codigo_barras = cgr.codigo_barras
  AND cgr.verificado = true
 returning *;

select distinct descripcion_elemento, codigo_elemento, COUNT (id)
from inventario_verificado iv
where descripcion_elemento ilike '%ESTANTE%'
group by 1,2
order by 1 asc;



SELECT 
    i.numero_secuencia, 
    i.codigo_elemento,
    concat ('cod: '||ii.codigo_barras),
    --ii.placa,
    ii.serie,
    i.descripcion_elemento,
    ii.tipo_partes as elemento,
    i.fecha_ingreso 
FROM 
    informegeneral i
LEFT JOIN 
    informeindividual ii 
    ON i.numero_secuencia = ii.numero_secuencia 
WHERE 
    i.codigo_elemento IN (
        '03AA00682', '03AA00684', '03AA01020', '03AA01167', '03AA01170', '03AA01326' 
        '03AA01327', '03AA01465', '03AA01495', '03AA01567', '03AA01568', 
        '03AA01569', '03AA01620', '03AA01621', '03AA01622', '03AA01668', 
        '03AA01684', '03AA01685', '03AA01722', '03AA01784'
    ) 
    AND i.cedula NOT IN (
        '13923177', '91237677', '41723660', '1032427438', '91296385', 
        '91068279', '30309914', '1098706999'
    ) 
    AND ii.tipo_partes NOT IN (
        'BATERIA', 'CERTIFICADO DE AUTENTICIDAD', 'DISCO DURO', 
        'GUAYA DE SEGURIDAD.', 'MALETIN', 'MONITOR', 'MOUSE', 
        'TECLADO', 'UNIDAD DE CD'
    ) 
    AND i.tipo_almacenamiento ILIKE '%SERVICIO%'
    AND i.numero_secuencia not in ('90151')
   order by i.numero_secuencia asc;




where descripcion_elemento ilike '%COMPUTADOR%' 
and descripcion_elemento ilike '%CPU.%' 
and descripcion_elemento ilike '%CPU.%'
and descripcion_elemento ilike '%EQUIPO DE COMPUTO TODO EN UNO%'
and descripcion_elemento ilike '%EQUIPO HP%'
and descripcion_elemento ilike '%ESTACION DE TRABAJO%'

select distinct descripcion_elemento, codigo_elemento  
from informegeneral i
order by codigo_elemento asc;


--
select i.numero_secuencia,
ii.codigo_barras,
i.codigo_elemento,
ii.placa, 
i.descripcion_elemento,
i.tipo_almacenamiento,
i.fecha_ingreso,
ii.descripcion_codigo,
ii.medida,
ii.tipo_partes,
ii.serie,
ii.observaciones 
from informegeneral i 
left join informeindividual ii  on i.numero_secuencia = ii.numero_secuencia 
where tipo_almacenamiento = 'BODEGA DE USADOS EN PROCESO DE BAJA '
