--@Autor: Alonso Lopez Daniel, Marcelino Cisneros Eduardo
--@Fecha creación: 16/06/2020
--@Descripción: Simula la carga diaria de archivos Redo Ciudadano

prompt Conectando usuario maal_ciudadano;
connect maal_ciudadano/maal_ciudadano

set serveroutput on;

alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss';

---------------------------------------------------
-------- Redo para la tabla Auto-------------------
--------------------------------------------------

declare
  v_max_id number;
  v_count number;
  cursor cur_insert is
    select auto_seq.nextval as auto_id,auto_seq.currval||substr(placas,4) as placas,
    tarjeta_circulacion, vigencia_tarjeta, titular, titular_anterior
    from auto sample(95) a where rownum <=1800;
  
  cursor cur_update is
    select * from auto sample (95) where rownum <=1700;
begin
   -- insert
   v_count := 0;  
  for r in cur_insert loop
    insert into auto (auto_id, placas, tarjeta_circulacion, 
      vigencia_tarjeta, titular, titular_anterior)
    values(r.auto_id, r.placas,r.tarjeta_circulacion,r.vigencia_tarjeta,
      r.titular,r.titular_anterior);
    v_count := v_count + 1;
  end loop;

  dbms_output.put_line('Registros insertados en AUTO: '||v_count);

  select max(auto_id) into v_max_id
  from auto;
  -- update 
  v_count := 0;
  for r in cur_update loop
      update auto set placas = dbms_random.string('X',3)||substr(r.placas,4), 
        tarjeta_circulacion = r.tarjeta_circulacion, 
        vigencia_tarjeta = r.vigencia_tarjeta, titular = r.titular, 
        titular_anterior = r.titular_anterior
        where auto_id = (select trunc(dbms_random.value(1,v_max_id))from dual);
        v_count := v_count + 1;
  end loop;
  dbms_output.put_line('Registros modificados en AUTO: '||v_count);

end;
/


---------------------------------------------------
-------- Redo para la tabla Reporte_Robo-----------
---------------------------------------------------

declare
  cursor cur_insert is 
    select auto_id from auto a 
    where not exists (
      select 1
      from reporte_robo rr
      where rr.auto_id = a.auto_id
    ) and rownum <= 2300;
  
  v_count number := 0;
  v_reporte_id number;

  cursor cur_update is
    select falta_civica_id from maal_falta_civica.falta_civica sample(95)
    where rownum <= 2300;

   cursor cur_delete is
    select reporte_robo_id from reporte_robo sample(95)
    where rownum <= 2000;
   
begin
  
  select max(reporte_robo_id) into v_reporte_id 
  from reporte_robo;
  -- insert
  for r in cur_insert loop
    select max(reporte_robo_id) into v_reporte_id 
    from reporte_robo;

    insert into reporte_robo(reporte_robo_id,fecha,estado_rep,
      recuperado,auto_id,falta_civica_id)
    values(v_reporte_id+1,sysdate-round(dbms_random.value(1,365)),
        'Yucatan',0,r.auto_id,null);
      v_count := v_count +1;
  end loop;
  dbms_output.put_line('Registros insertados en Reporte_Robo: '||v_count);
  

  --update 
  v_count := 0;
  for r in cur_update loop
      update reporte_robo set falta_civica_id = r.falta_civica_id
        where falta_civica_id = null;
        v_count := v_count + 1;
  end loop;
  dbms_output.put_line('Registros modificados en Reporte_Robo: '||v_count);

  --delete
  v_count := 0;
  for r in cur_delete loop
    delete from reporte_robo where reporte_robo_id = r.reporte_robo_id;
    v_count := v_count +1;
  end loop;
  dbms_output.put_line('Registros eliminados en Reporte_Robo: '||v_count);

end;
/
