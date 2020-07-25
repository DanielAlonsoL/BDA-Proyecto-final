--@Autor: Alonso Lopez Daniel, Marcelino Cisneros Eduardo
--@Fecha creación: 16/06/2020
--@Descripción: Creación de tablas del modulo falta civica

prompt Conectando usuario y creando tablas
connect maal_falta_civica/maal_falta_civica

-- 
-- sequence: seq_historico_status
--
create sequence seq_historico_status
    start with 1
    increment by 1
    nominvalue
    nomaxvalue
    cache 20
    noorder
;

-- 
-- sequence: seq_evidencia
--
create sequence seq_evidencia
    start with 1
    increment by 1
    nominvalue
    nomaxvalue
    cache 20
    noorder
;

create sequence seq_falta_civica
	start with 2801
	increment by 1
	nominvalue
	nomaxvalue
	cache 20
	noorder
;

create table status_falta_civica(
	status_falta_civica_id number(10,0),
	clave 				   varchar2(15)		not null,
	descripcion			   varchar2(50) 	not null,
	constraint status_falta_civica_pk primary key(status_falta_civica_id)
	using index(
		create unique index status_fc_pk on status_falta_civica(status_falta_civica_id)
		tablespace indices_civicas_tbs
	)
) tablespace faltas_civicas_tbs;


create table falta_civica(
	falta_civica_id 		number(10,0),
	fecha_ocurrencia 		date 			not null,
	puntos_negativos 		number(2,0) 	not null,
	fecha_limite 			date 			not null,
	placas 					varchar2(10) 	not null,
	es_pasarse_alto			number(1,0) 	not null,
	es_exceso_velocidad		number(1,0) 	not null,
	es_edo_inconveniente 	number(1,0) 	not null,
	numero_falta			number(3,0)		not null,
	status_falta_civica_id 	number(10,0) 	not null,
	ciudadano_id 			number(10,0)	not null,
	constraint falta_civica_pk primary key(falta_civica_id)
	using index(
		create unique index falta_civica_pk on falta_civica(falta_civica_id)
		tablespace indices_civicas_tbs),
	constraint fc_status_falta_id_fk foreign key(status_falta_civica_id)
	references status_falta_civica(status_falta_civica_id),
	constraint fc_ciudadano_id_fk foreign key(ciudadano_id)
	references maal_ciudadano.ciudadano(ciudadano_id),
	constraint falta_civica_tipo_chk check(
		(es_edo_inconveniente !=0 or es_exceso_velocidad !=0 or es_pasarse_alto !=0)),
	constraint falta_civica_puntos_chk check(
		(puntos_negativos > 0 and puntos_negativos < 11))
) tablespace faltas_civicas_tbs;

grant references on falta_civica to maal_ciudadano;

create table historico_status(
	historico_status_id 	number(10,0),
	fecha_status 			date 			not null,
	status_falta_civica_id 	number(10,0) 	not null,
	falta_civica_id 		number(10,0) 	not null,
	constraint historico_status_pk primary key(historico_status_id)
	using index(
		create unique index hist_stat_pk on historico_status(historico_status_id)
		tablespace indices_civicas_tbs
	),
	constraint hs_status_falta_civica_id_fk foreign key(status_falta_civica_id)
	references status_falta_civica(status_falta_civica_id),
	constraint hs_falta_civica_id_fk foreign key(falta_civica_id)
	references falta_civica(falta_civica_id)
) tablespace faltas_civicas_tbs;

create table evidencia(
	evidencia_id 	number(10,0),
	tipo		 	char(1)	  		not null,
	archivo 	 	BLOB		  	not null,
	falta_civica_id number(10,0) 	not null,
	constraint evidencia_pk primary key(evidencia_id)
	using index(
		create unique index evidencia_pk on evidencia(evidencia_id)
		tablespace indices_civicas_tbs
	),
	constraint ev_falta_civica_id_fk foreign key(falta_civica_id)
	references falta_civica(falta_civica_id),
	constraint evidencia_tipo_chk check(
		tipo in('V','F')
	)
) tablespace faltas_civicas_tbs
	lob (archivo) store as securefile seg_archivo (tablespace BLOB_civicas_tbs
		index archivo_blob_ix (tablespace BLOB_civicas_tbs));

create table pasarse_alto(
	falta_civica_id		number(10,0),
	nombre_crucero 		varchar2(100) 	not null,
	folio_dispositivo 	varchar2(13) 	not null,
	constraint pasarse_alto_pk primary key(falta_civica_id)
	using index(
		create unique index pasarse_alto_pk on pasarse_alto(falta_civica_id)
		tablespace indices_civicas_tbs
	),
	constraint pasar_alto_folio_disp_uk unique(folio_dispositivo),
	constraint pa_falta_civica_id_fk foreign key(falta_civica_id)
	references falta_civica(falta_civica_id)
) tablespace faltas_civicas_tbs;

create table exceso_velocidad(
	falta_civica_id 	number(10,0),
	coord_latitud 		varchar2(15) 	not null,
	coord_longitud 		varchar2(15) 	not null,
	clave_sensor 		varchar2(8) 	not null,
	vel_max_km_h 		number(10,0) 	not null,
	vel_reportada 		number(10,0) 	not null,
	constraint exceso_velocidad_pk primary key(falta_civica_id)
	using index(
		create unique index exceso_velocidad_pk on exceso_velocidad(falta_civica_id)
		tablespace indices_civicas_tbs
	),
	constraint excvel_falta_civica_id_fk foreign key(falta_civica_id)
	references falta_civica(falta_civica_id)
) tablespace faltas_civicas_tbs;

create table estado_inconveniente(
	falta_civica_id 	number(10,0),
	num_alcoholimetro	number(2,0)		not null,
	nivel_alcohol 		number(1,0) 	not null,
	centro_detencion 	varchar2(100) 	not null,
	constraint estado_inconveniente_pk primary key(falta_civica_id)
	using index(
		create unique index edo_incon_pk on estado_inconveniente(falta_civica_id)
		tablespace indices_civicas_tbs
	),
	constraint edoin_falta_civica_id_fk foreign key(falta_civica_id)
	references falta_civica(falta_civica_id),
	constraint edoin_nivel_alcohol_chk check(
		nivel_alcohol>0 and nivel_alcohol < 6
	)
) tablespace faltas_civicas_tbs;

-- 
-- Indices Modulo Civicas
--
create index fc_placas_iuk on falta_civica(placas)
	tablespace indices_civicas_tbs;

create index fc_status_falta_ix on falta_civica(status_falta_civica_id)
	tablespace indices_civicas_tbs;

create index fc_ciudadano_ix on falta_civica(ciudadano_id)
	tablespace indices_civicas_tbs;

create index e_falta_civica_ix on evidencia(falta_civica_id)
	tablespace indices_civicas_tbs;

create index hs_status_falta_ix on historico_status(status_falta_civica_id)
	tablespace indices_civicas_tbs;
	
create index hs_falta_civica_ix on historico_status(falta_civica_id)
	tablespace indices_civicas_tbs;

grant references on falta_civica to maal_ciudadano;
grant select on falta_civica to maal_ciudadano;