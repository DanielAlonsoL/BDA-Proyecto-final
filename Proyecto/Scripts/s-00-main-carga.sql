--si ocurre un error, se hace rollback de los datos y
--se sale de SQL *Plus
whenever sqlerror exit rollback
@@s-12-carga-ciudadano.sql;
@@s-13-carga-faltas.sql;
@@s-14-carga-reporte-robo.sql;