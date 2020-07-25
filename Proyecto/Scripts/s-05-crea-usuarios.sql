--@Autor(es):       Alonso López Daniel, Marcelino Cisneros Eduardo
--@Fecha creación:  17/06/2020
--@Descripción:     Creación de usuarios para proyecto final BDA

Prompt Indicar el password de sys 
connect sys/system3 as sysdba
whenever sqlerror exit rollback

prompt limpiando
declare
  v_count number(1,0);
begin
  select count(*) into v_count
  from dba_users where username='MAAL_FALTA_CIVICA';
  if v_count > 0 then
	execute immediate 'drop user maal_falta_civica cascade';
  end if;
end;
/

prompt creando usuario maal_falta_civica

create user maal_falta_civica identified by maal_falta_civica 
	quota unlimited on faltas_civicas_tbs 
	quota unlimited on BLOB_civicas_tbs
	quota unlimited on indices_civicas_tbs
	default tablespace faltas_civicas_tbs;

grant create session, create table, create sequence, create trigger, create procedure to maal_falta_civica;

prompt limpiando

declare
  v_count number(1,0);
begin
  select count(*) into v_count
  from dba_users where username='MAAL_CIUDADANO';
  if v_count > 0 then
	execute immediate 'drop user maal_ciudadano cascade';
  end if;
end;
/

prompt creando usuario maal_ciudadano

create user maal_ciudadano identified by maal_ciudadano 
	quota unlimited on ciudadanos_tbs
	quota unlimited on BLOB_ciudadanos_tbs
	quota unlimited on autos_tbs
	quota unlimited on indices_ciudadanos_autos_tbs
	default tablespace ciudadanos_tbs;

grant create session, create table, create sequence, create trigger, create procedure to maal_ciudadano;

prompt limpiando

declare
  v_count number(1,0);
begin
  select count(*) into v_count
  from dba_users where username='MAAL_BACKUP';
  if v_count > 0 then
	execute immediate 'drop user maal_backup cascade';
  end if;
end;
/

prompt creando usuario maal_backup

create user maal_backup identified by maal_backup quota unlimited on users;
grant sysbackup, create session to maal_backup;
------------------------------------------
--Cambiar de acuerdo al usuario del S.O
--
--Se crea para almacenar datos blob
------------------------------------------
create or replace directory data_dir as '/home/Daniel/Desktop/BDA/Proyecto/Blobs';
grant read,write on directory data_dir to maal_ciudadano;
grant read,write on directory data_dir to maal_falta_civica;