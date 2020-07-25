#!/bin/bash
#@Autores: Alonso Lopez Daniel, Marcelino Cisneros Eduardo
#@Fecha de creacion: 16/06/2020
#@Descripcion: script que genera y cambia permisos para directorios de la BD de proyectos
echo "Creando directorio necesario para BD y subdirectorios"
mkdir -p ${ORACLE_BASE}/oradata/MAALPROY
#Multiplexaje
mkdir -p ${ORACLE_BASE}/oradata/MAALPROY/disk_1 #u01
mkdir -p ${ORACLE_BASE}/oradata/MAALPROY/disk_2 #u02
mkdir -p ${ORACLE_BASE}/oradata/MAALPROY/disk_3 #u03
#Archive, FRA, backups
mkdir -p ${ORACLE_BASE}/oradata/MAALPROY/disk_4 #unam-bda

echo "Cambiando dueño"
chown -R oracle:oinstall ${ORACLE_BASE}/oradata/MAALPROY
chown -R oracle:oinstall ${ORACLE_BASE}/oradata/MAALPROY/disk_1
chown -R oracle:oinstall ${ORACLE_BASE}/oradata/MAALPROY/disk_2
chown -R oracle:oinstall ${ORACLE_BASE}/oradata/MAALPROY/disk_3
chown -R oracle:oinstall ${ORACLE_BASE}/oradata/MAALPROY/disk_4

echo "Cambiando permisos de lectura y escritura para directorios"
sudo chmod 755 ${ORACLE_BASE}/oradata/MAALPROY
sudo chmod 755 ${ORACLE_BASE}/oradata/MAALPROY/disk_1
sudo chmod 755 ${ORACLE_BASE}/oradata/MAALPROY/disk_2
sudo chmod 755 ${ORACLE_BASE}/oradata/MAALPROY/disk_3
sudo chmod 755 ${ORACLE_BASE}/oradata/MAALPROY/disk_4

