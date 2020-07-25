--@Autor: Alonso Lopez Daniel, Marcelino Cisneros Eduardo
--@Fecha creación: 16/06/2020
--@Descripción: Simula la carga diaria de archivos Redo Faltas

prompt conectando con usuario maal_ciudadano
connect maal_falta_civica/maal_falta_civica;

set serveroutput on;

alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss';

--------------------------------------------------
-------- Redo para la tabla Falta_civica----------
--------------------------------------------------

declare
  
  cursor cur_insert is
    select c.ciudadano_id, a.placas
    from maal_ciudadano.ciudadano c, maal_ciudadano.auto a
    where c.ciudadano_id = a.titular
    and rownum <= 3000;
  
  cursor cur_update is
    select falta_civica_id, status_falta_civica_id from falta_civica sample(90)
    where status_falta_civica_id in(1,2)
    and rownum <= 2700;

  v_count number;
  v_falta_id number;

begin
  v_count := 0;

  --insert 
  for r in cur_insert loop
    select seq_falta_civica.nextval into v_falta_id from dual;
    insert into falta_civica(falta_civica_id, fecha_ocurrencia, puntos_negativos, fecha_limite, placas, es_pasarse_alto, 
      es_exceso_velocidad, es_edo_inconveniente, numero_falta, status_falta_civica_id, ciudadano_id)
      values(v_falta_id,sysdate+round(dbms_random.value(1,364)),round(dbms_random.value(1,10)),sysdate+round(dbms_random.value(1,364)),
        r.placas,round(dbms_random.value(0,1)),round(dbms_random.value(0,1)),1,round(dbms_random.value(1,10)),1,r.ciudadano_id);
    v_count := v_count +1;
  end loop;
  dbms_output.put_line('Registros insertados en FALTA_CIVICA: '||v_count);
  
  v_count := 0;
  ---update
  for r in cur_update loop
    update falta_civica set 
      status_falta_civica_id = 4
    where falta_civica_id = r.falta_civica_id;
    
    v_count := v_count +1;
  end loop;
  dbms_output.put_line('Registros modificados en FALTA_CIVICA: '||v_count);

  v_count := 0;

end;
/


--------------------------------------------------
-------- Redo para la tabla Evidencia-------------
--------------------------------------------------


declare

	cursor cur_delete is
    select falta_civica_id from evidencia sample(90)
    where rownum <= 1700;
  
	v_count number;
 	v_evidencia_f varchar2(100);
	v_evidencia_v varchar2(100);
	v_tipo varchar2(2);
	v_seq_evidencia number;

	type tipos_array is varray(2) of varchar2(2);
	tipo_evidencia tipos_array;

   
begin

  -- insert
	v_count := 0; 
	tipo_evidencia := tipos_array('V','F');
	
	for i in 1..2800 loop

		select seq_evidencia.nextval into v_seq_evidencia from dual;
		v_tipo := tipo_evidencia(round(dbms_random.value(1,2)));

		if v_tipo = 'F' then
			v_evidencia_f := '/home/Daniel/Desktop/BDA/Proyecto/Blobs/evidencia_f_'|| round(dbms_random.value(1,5))||'.jpg';
			
			insert into evidencia(evidencia_id,tipo,archivo,falta_civica_id)
				values (v_seq_evidencia,v_tipo,read_blobs(v_evidencia_f),round(dbms_random.value(1,2700)));

		elsif v_tipo = 'V' then
			v_evidencia_v := '/home/Daniel/Desktop/BDA/Proyecto/Blobs/evidencia_f_'||round(dbms_random.value(1,5))||'.jpg';
			insert into evidencia(evidencia_id,tipo,archivo,falta_civica_id)
				values (v_seq_evidencia,v_tipo,read_blobs(v_evidencia_v),round(dbms_random.value(1,2700)));
		end if;
		v_count := v_count + sql%rowcount;
	end loop;
	dbms_output.put_line('Registros insertados en Evidencia: '||v_count);

  --delete
  	v_count := 0;
  	for r in cur_delete loop
    	delete from evidencia where falta_civica_id = r.falta_civica_id;
    	v_count := v_count +1;
  	end loop;
  	dbms_output.put_line('Registros eliminados en Evidencia: '||v_count);
end;
/

