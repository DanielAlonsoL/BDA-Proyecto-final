--@Autor: Alonso Lopez Daniel, Marcelino Cisneros Eduardo
--@Fecha creación: 19/06/2020
--@Descripción: Creación de tablespaces para los modulos creados

--Modulo Falta
create tablespace faltas_civicas_tbs
datafile '/u01/app/oracle/oradata/MAALPROY/disk_1/faltas_civicas01.dbf' size 30M
autoextend on next 5M maxsize 100M
extent management local autoallocate
segment space management auto
online;

create tablespace indices_civicas_tbs
datafile '/u01/app/oracle/oradata/MAALPROY/disk_1/indices_civicas01.dbf' size 15M
autoextend on next 5M maxsize 50M
extent management local autoallocate
segment space management auto
online;

create tablespace BLOB_civicas_tbs
datafile '/u01/app/oracle/oradata/MAALPROY/disk_1/blob_civicas01.dbf' size 100M
autoextend on next 50M maxsize 200M
extent management local autoallocate
segment space management auto
online;


--Modulo ciudadanos
create tablespace ciudadanos_tbs
datafile '/u01/app/oracle/oradata/MAALPROY/disk_1/ciudadanos01.dbf' size 30M
autoextend on next 5M maxsize 100M
extent management local autoallocate
segment space management auto
online;

create tablespace autos_tbs
datafile '/u01/app/oracle/oradata/MAALPROY/disk_1/autos01.dbf' size 30M
autoextend on next 5M maxsize 100M
extent management local autoallocate
segment space management auto
online;

create tablespace indices_ciudadanos_autos_tbs
datafile '/u01/app/oracle/oradata/MAALPROY/disk_1/indices_ciudadanos_autos01.dbf' size 15M
autoextend on next 5M maxsize 50M
extent management local autoallocate
segment space management auto
online;

create tablespace BLOB_ciudadanos_tbs
datafile '/u01/app/oracle/oradata/MAALPROY/disk_1/blob_ciudadanos01.dbf' size 100M
autoextend on next 50M maxsize 200M
extent management local autoallocate
segment space management auto
online;