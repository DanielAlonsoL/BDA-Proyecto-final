--@Autor: Alonso Lopez Daniel, Marcelino Cisneros Eduardo
--@Fecha creación: 19/06/2020
--@Descripción: Habilitacion de la FRA

prompt Conectando sys y Habilitacion de la FRA
connect sys/system3 as sysdba


alter system set db_recovery_file_dest_size = 1540 M scope=both;
alter system set db_recovery_file_dest = '/u01/app/oracle/oradata/MAALPROY/disk_4/FRA' scope=both;
alter system set db_flashback_retention_target = 1440 scope=both;
alter system set log_archive_dest_2='LOCATION=/u01/app/oracle/oradata/MAALPROY/disk_4/FRA/Archivelogs MANDATORY' scope=spfile;

shutdown;
startup;

--Tamaño copia base = 583 MB
--Tamaño backup incremental = 17 MB
--Tamaño Archivelogs en 1 dia = 32 MB
--Tamaño de archive logs en N+1 dias = 225 MB
--Tamaño Backup de archivo de control = 18 MB
--Tamaño de Flashback logs = 32-40 MB
--Tamaño de 1 miembro de redo en N+1 dias = 350 MB
--Suma = 1265
--Tamaño estimado de la FRA = 1400 MB
	