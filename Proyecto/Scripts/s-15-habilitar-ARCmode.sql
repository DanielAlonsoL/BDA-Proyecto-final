--@Autor: Alonso Lopez Daniel, Marcelino Cisneros Eduardo
--@Fecha creación: 19/06/2020
--@Descripción: Habilitacion de modo ARCmode

prompt Conectando sys y Habilitacion modo Archive
connect sys/system3 as sysdba


alter system set log_archive_max_processes = 5 scope=spfile;
alter system set log_archive_format = 'arch_maalproy_%t_%s_%r.arc' scope=spfile;
alter system set log_archive_dest_1='LOCATION=/u01/app/oracle/oradata/MAALPROY/disk_1/archivelogs MANDATORY' scope=spfile;

shutdown;
startup mount;
alter database archivelog;
alter database open;


archive log list;