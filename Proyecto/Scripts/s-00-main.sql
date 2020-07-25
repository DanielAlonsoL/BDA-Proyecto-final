--si ocurre un error, se hace rollback de los datos y
--se sale de SQL *Plus
whenever sqlerror exit rollback
@@s-05-crea-usuarios.sql;
@@s-08-crea-ddl.sql;
@@s-09-tr-ciudadano.sql;
@@s-10-tr-faltas-civicas.sql;
@@s-11-fx-lee-blob.sql;
@@s-00-main-carga.sql;