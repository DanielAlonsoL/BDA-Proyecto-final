--Autores: Alonso Lopez Daniel
--		   Marcelino Cisneros Eduardo
--Fecha de creacion: 16/06/2020
--Descripcion: script que crea la base de datos del proyecto final

prompt Conectando al usuario sys
connect / as sysdba
startup nomount;
create spfile from pfile;

whenever sqlerror exit
create database maalproy
	user sys identified by system3
	user system identified by system3
	logfile group 1 (
	'/u01/app/oracle/oradata/MAALPROY/disk_1/redo01a.log',
	'/u01/app/oracle/oradata/MAALPROY/disk_2/redo01b.log',
	'/u01/app/oracle/oradata/MAALPROY/disk_3/redo01c.log') size 50m blocksize 512,
	group 2 (
	'/u01/app/oracle/oradata/MAALPROY/disk_1/redo02a.log',
	'/u01/app/oracle/oradata/MAALPROY/disk_2/redo02b.log',
	'/u01/app/oracle/oradata/MAALPROY/disk_3/redo02c.log') size 50m blocksize 512,
	group 3 (
	'/u01/app/oracle/oradata/MAALPROY/disk_1/redo03a.log',
	'/u01/app/oracle/oradata/MAALPROY/disk_2/redo03b.log',
	'/u01/app/oracle/oradata/MAALPROY/disk_3/redo03c.log') size 50m blocksize 512
	maxloghistory 1
	maxlogfiles 16
	maxlogmembers 3
	maxdatafiles 1024
	character set AL32UTF8
	national character set AL16UTF16
	extent management local
	datafile '/u01/app/oracle/oradata/MAALPROY/disk_1/system01.dbf'
		size 700m reuse autoextend on next 10240k maxsize unlimited
	sysaux datafile '/u01/app/oracle/oradata/MAALPROY/disk_1/sysaux01.dbf'
		size 550m reuse autoextend on next 10240k maxsize unlimited
	default tablespace users
		datafile '/u01/app/oracle/oradata/MAALPROY/disk_1/users01.dbf'
		size 500m reuse autoextend on maxsize unlimited
	default temporary tablespace tempts1
		tempfile '/u01/app/oracle/oradata/MAALPROY/disk_1/temp01.dbf'
		size 20m reuse autoextend on next 640k maxsize unlimited
	undo tablespace undotbs1
		datafile '/u01/app/oracle/oradata/MAALPROY/disk_1/undotbs01.dbf'
		size 200m reuse autoextend on next 5120k maxsize unlimited
	user_data tablespace usertbs
		datafile '/u01/app/oracle/oradata/MAALPROY/disk_1/usertbs01.dbf'
		size 200m reuse autoextend on maxsize unlimited;

alter user sys identified by system3;
alter user system identified by system3;

--------------------------------------
--Crea diccionario de datos
--------------------------------------

prompt Conectando al usuario sys
connect sys/system3 as sysdba

prompt Ejecutando script catalog.sql
@?/rdbms/admin/catalog.sql

prompt Ejecutando script catproc.sql
@?/rdbms/admin/catproc.sql

prompt EJecutando script utlrp.sql
@?/rdbms/admin/utlrp.sql

prompt Conectando al usuario system
connect system/system3

prompt EJecutando script pupbld.sql
@?/sqlplus/admin/pupbld.sql

