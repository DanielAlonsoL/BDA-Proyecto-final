--@Autor: Alonso Lopez Daniel, Marcelino Cisneros Eduardo
--@Fecha creación: 16/06/2020
--@Descripción: crea la funcion read_blobs para cada usuario de los modulos

prompt Conectando maal_ciudadano y creando funcion read_blob
connect maal_ciudadano/maal_ciudadano;

set serveroutput on
create or replace function read_blobs(
	nombre_archivo varchar2
) return BLOB is

	v_bfile bfile;
	v_blob BLOB;
	v_dest_offset number:=1;
	v_src_offset number:=1;
	v_nombre varchar2(100);

	begin
		v_nombre := nombre_archivo;
		v_bfile := bfilename('DATA_DIR',v_nombre);

		dbms_lob.createtemporary(v_blob,TRUE);

		if dbms_lob.fileexists(v_bfile) = 1 and not dbms_lob.isopen(v_bfile) = 1 
			then 
			dbms_lob.open(v_bfile,dbms_lob.lob_readonly);

			dbms_lob.loadblobfromfile(		
				dest_lob => v_blob,
				src_bfile => v_bfile,
				amount => dbms_lob.getlength(v_bfile),
				dest_offset => v_dest_offset,
				src_offset => v_src_offset);
			
			dbms_lob.close(v_bfile);
		
		else

			v_blob := empty_blob();
		
		end if;
		
		return v_blob;
		
	end;
	/
	show errors;


prompt Conectando maal_falta_civica y creando funcion read_blob
connect maal_falta_civica/maal_falta_civica;

set serveroutput on
create or replace function read_blobs(
	nombre_archivo varchar2
) return BLOB is

	v_bfile bfile;
	v_blob BLOB;
	v_dest_offset number:=1;
	v_src_offset number:=1;
	v_nombre varchar2(100);

	begin
		v_nombre := nombre_archivo;
		v_bfile := bfilename('DATA_DIR',v_nombre);

		dbms_lob.createtemporary(v_blob,TRUE);

		if dbms_lob.fileexists(v_bfile) = 1 and not dbms_lob.isopen(v_bfile) = 1 
			then 
			dbms_lob.open(v_bfile,dbms_lob.lob_readonly);

			dbms_lob.loadblobfromfile(		
				dest_lob => v_blob,
				src_bfile => v_bfile,
				amount => dbms_lob.getlength(v_bfile),
				dest_offset => v_dest_offset,
				src_offset => v_src_offset);
			
			dbms_lob.close(v_bfile);
		
		else

			v_blob := empty_blob();
		
		end if;
		
		return v_blob;
		
	end;
	/
	show errors;