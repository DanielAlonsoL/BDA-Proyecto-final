--@Autor: Alonso Lopez Daniel, Marcelino Cisneros Eduardo
--@Fecha creación: 22/06/2020
--@Descripción: crea DDL para ambos usuarios

prompt Creando objetos de maal_ciudadano
@@s-06-ciudadano-ddl.sql

prompt Creando objetos de maal_falta_civica
@@s-07-falta-civica-ddl.sql

connect maal_ciudadano/maal_ciudadano

create table reporte_robo(
	reporte_robo_id		number(10,0),
	fecha 				date 			default sysdate,
	estado_rep			varchar2(20)	not null,
	recuperado 			number(1,0)		not null,
	auto_id				number(10,0)	not null,
	falta_civica_id 	number(10,0)	null,
	constraint reporte_robo_pk primary key(reporte_robo_id)
	using index(
		create unique index reporte_robo_pk on reporte_robo(reporte_robo_id)
		tablespace indices_ciudadanos_autos_tbs
	),
	constraint rr_auto_id_fk foreign key(auto_id)
	references auto(auto_id),
	constraint rr_falta_civica_id_fk foreign key(falta_civica_id)
	references maal_falta_civica.falta_civica(falta_civica_id)
) tablespace autos_tbs;

create index rr_auto_ix on reporte_robo(auto_id)
	tablespace indices_ciudadanos_autos_tbs;

create index rr_falta_civica_ix on reporte_robo(falta_civica_id)
	tablespace indices_ciudadanos_autos_tbs;