#!/bin/bash
#@Autores: Alonso Lopez Daniel, Marcelino Cisneros Eduardo
#@Fecha de creacion: 16/06/2020
#@Descripcion: script que genera el archivo de parametros y el archivo de passwords

export ORACLE_SID=maalproy

pwd_file=""${ORACLE_HOME}"/dbs/orapwmaalproy"
param_file=""${ORACLE_HOME}"/dbs/initmaalproy.ora"

echo " Creando archivo de passwords nuevo"
orapwd FILE=${pwd_file} SYS=password

echo "Creando archivo de parametros nuevo"
echo \
"db_name='maalproy' 
memory_target=768M
control_files=(/u01/app/oracle/oradata/MAALPROY/disk_1/control01.ctl,
				/u01/app/oracle/oradata/MAALPROY/disk_2/control02.ctl,
				/u01/app/oracle/oradata/MAALPROY/disk_3/control03.ctl)
	" > ${param_file}
