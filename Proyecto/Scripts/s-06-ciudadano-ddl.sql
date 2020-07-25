--@Autor: Alonso Lopez Daniel, Marcelino Cisneros Eduardo
--@Fecha creación: 16/06/2020
--@Descripción: Creación de tablas del modulo ciudadano

prompt Conectando usuario y creando tablas
connect maal_ciudadano/maal_ciudadano

-- 
-- sequence: seq_biometricos
--
create sequence seq_biometricos
    start with 1
    increment by 1
    nominvalue
    nomaxvalue
    cache 20
    noorder
;

create sequence auto_seq
    start with 3001
    increment by 1
    nominvalue
    nomaxvalue
    cache 20
    noorder
;

create table ciudadano(
	ciudadano_id	 number(10,0),
	nombre 		     varchar2(40) 		not null,
	ap_paterno	     varchar2(40) 		not null,
	ap_materno	     varchar2(40) 		not null,
	curp		     varchar2(18) 		not null,
	domicilio	     varchar2(50) 		not null,
	telefono	     number(15,0) 		not null,
	telefono_opcional number(15,0) 		null,
	correo_electronico			varchar2(50)		null,
	constraint ciudadano_pk primary key (ciudadano_id)
	using index(
		create unique index ciudadano_pk on ciudadano(ciudadano_id)
		tablespace indices_ciudadanos_autos_tbs
	),
	constraint ciudadano_email_chk check(
		correo_electronico like '%@%'
	)
) tablespace ciudadanos_tbs;

create table licencia_conducir(
	licencia_conducir_id 	number(10,0),
	folio 					varchar2(10)	not null,
	tipo_vigencia			char(1)			not null,
	fecha_expedicion		date			not null,
	fecha_vigencia			date			null,
	ciudadano_id 			number(10,0)    not null,
	constraint licencia_conducir_pk primary key(licencia_conducir_id)
	using index(
		create unique index licencia_conducir_pk on licencia_conducir(licencia_conducir_id)
		tablespace indices_ciudadanos_autos_tbs	
	),
	constraint lc_ciudadano_id_fk foreign key(ciudadano_id)
	references ciudadano(ciudadano_id),
	constraint lic_tipo_vigencia_chk check(
		tipo_vigencia in('P','T')
	)
) tablespace ciudadanos_tbs;

create table trabajo_comunitario(
	trabajo_comunitario_id	number(10,0),
	clave 					varchar2(2)		not null,
	nombre 					varchar2(30)	not null,
	descripcion				varchar2(100)	not null,
	constraint trabajo_comunitario_pk primary key (trabajo_comunitario_id)
	using index(
		create unique index trabajo_comunitario_pk on trabajo_comunitario(trabajo_comunitario_id)
		tablespace indices_ciudadanos_autos_tbs	
	)
) tablespace ciudadanos_tbs;

create table ciudadano_trabajo(
	ciudadano_trabajo_id 	number(10,0),
	horas 				 	number(5,2)		not null,
	puntos_recuperados	  	number(2,0)		not null,
	ciudadano_id 		  	number(10,0)	not null,
	trabajo_comunitario_id	number(10,0)	not null,
	constraint ciudadano_trabajo_pk primary key(ciudadano_trabajo_id)
	using index(
		create unique index ciudadano_trabajo_pk on ciudadano_trabajo(ciudadano_trabajo_id)
		tablespace indices_ciudadanos_autos_tbs
	),
	constraint ct_ciudadano_id_fk	foreign key(ciudadano_id)
	references ciudadano(ciudadano_id),
	constraint ct_trabajo_comunitario_id_fk foreign key(trabajo_comunitario_id)
	references trabajo_comunitario(trabajo_comunitario_id)
) tablespace ciudadanos_tbs;

create table auto(
	auto_id				number(10,0),
	placas				varchar2(12)	not null,
	tarjeta_circulacion	varchar2(15)	not null,
	vigencia_tarjeta	date			not null,
	titular				number(10,0)	not null,
	titular_anterior	number(10,0)	null,
	constraint auto_pk primary key(auto_id)
	using index(
		create unique index auto_pk on auto(auto_id)
		tablespace indices_ciudadanos_autos_tbs
	),
	constraint auto_titular_fk	foreign key(titular)
	references ciudadano(ciudadano_id),
	constraint auto_titular_anterior_id_fk	foreign key(titular_anterior)
	references ciudadano(ciudadano_id)
) tablespace autos_tbs;

create table biometricos(
	biometricos_id	number(10,0),
	firma					BLOB			not null,
	foto 					BLOB			not null,
	dedo_1					BLOB			null,
	dedo_2					BLOB			null,
	dedo_3					BLOB			null,
	dedo_4					BLOB			null,
	dedo_5					BLOB			null,
	dedo_6					BLOB			null,
	dedo_7					BLOB			null,
	dedo_8					BLOB			null,
	dedo_9					BLOB			null,
	dedo_10					BLOB			null,
	licencia_conducir_id 	number(10,0)	not null,
	constraint biometricos_pk primary key(biometricos_id)
	using index(
		create unique index biometricos_pk on biometricos(biometricos_id)
		tablespace indices_ciudadanos_autos_tbs
	),
	constraint bio_licencia_conducir_id_fk	foreign key(licencia_conducir_id)
	references licencia_conducir(licencia_conducir_id)
) tablespace ciudadanos_tbs
	lob (dedo_1) store as securefile seg_dedo_1 (tablespace BLOB_ciudadanos_tbs
		index dedo1_blob_ix (tablespace BLOB_ciudadanos_tbs))
	lob (dedo_2) store as securefile seg_dedo_2 (tablespace BLOB_ciudadanos_tbs
		index dedo2_blob_ix (tablespace BLOB_ciudadanos_tbs))
	lob (dedo_3) store as securefile seg_dedo_3 (tablespace BLOB_ciudadanos_tbs
		index dedo3_blob_ix (tablespace BLOB_ciudadanos_tbs))
	lob (dedo_4) store as securefile seg_dedo_4 (tablespace BLOB_ciudadanos_tbs
		index dedo4_blob_ix (tablespace BLOB_ciudadanos_tbs))
	lob (dedo_5) store as securefile seg_dedo_5 (tablespace BLOB_ciudadanos_tbs
		index dedo5_blob_ix (tablespace BLOB_ciudadanos_tbs))
	lob (dedo_6) store as securefile seg_dedo_6 (tablespace BLOB_ciudadanos_tbs
		index dedo6_blob_ix (tablespace BLOB_ciudadanos_tbs))
	lob (dedo_7) store as securefile seg_dedo_7 (tablespace BLOB_ciudadanos_tbs
		index dedo7_blob_ix (tablespace BLOB_ciudadanos_tbs))
	lob (dedo_8) store as securefile seg_dedo_8 (tablespace BLOB_ciudadanos_tbs
		index dedo8_blob_ix (tablespace BLOB_ciudadanos_tbs))
	lob (dedo_9) store as securefile seg_dedo_9 (tablespace BLOB_ciudadanos_tbs
		index dedo9_blob_ix (tablespace BLOB_ciudadanos_tbs))
	lob (dedo_10) store as securefile seg_dedo_10 (tablespace BLOB_ciudadanos_tbs
		index dedo10_blob_ix (tablespace BLOB_ciudadanos_tbs))
	lob (foto) store as securefile seg_foto (tablespace BLOB_ciudadanos_tbs
		index foto_blob_ix (tablespace BLOB_ciudadanos_tbs))
	lob (firma) store as securefile seg_firma (tablespace BLOB_ciudadanos_tbs
		index firma_blob_ix (tablespace BLOB_ciudadanos_tbs));

-- 
-- Indices Modulo Civicas
--
create unique index lc_folio_iuk on licencia_conducir(folio)
	tablespace indices_ciudadanos_autos_tbs;

create unique index a_placas_iuk on auto(placas)
	tablespace indices_ciudadanos_autos_tbs;

create unique index c_CURP_iuk on ciudadano(CURP)
	tablespace indices_ciudadanos_autos_tbs;

create index lc_ciudadano_ix on licencia_conducir(ciudadano_id)
	tablespace indices_ciudadanos_autos_tbs;

create index ct_ciudadano_ix on ciudadano_trabajo(ciudadano_id)
	tablespace indices_ciudadanos_autos_tbs;

create index ct_trabajo_comunitario_ix on ciudadano_trabajo(trabajo_comunitario_id)
	tablespace indices_ciudadanos_autos_tbs;

create index b_licencia_conducir_ix on biometricos(licencia_conducir_id)
	tablespace indices_ciudadanos_autos_tbs;

create index a_titular_ix on auto(titular)
	tablespace indices_ciudadanos_autos_tbs;

create index a_titurar_ant_ix on auto(titular_anterior)
	tablespace indices_ciudadanos_autos_tbs;

grant references on ciudadano to maal_falta_civica;
grant select on ciudadano to maal_falta_civica;
grant select on auto to maal_falta_civica;