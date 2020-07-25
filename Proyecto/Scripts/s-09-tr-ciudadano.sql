--@Autor: Alonso Lopez Daniel, Marcelino Cisneros Eduardo
--@Fecha creación: 19/06/2020
--@Descripción: Triggers del Modulo Ciudadano

prompt Conectando maal_ciudadano y creando triggers
connect maal_ciudadano/maal_ciudadano

-----------------------------------------------------------
--Trigger que actualiza la fecha fin de vigencia
--para las licencias en las que su atributo
--tipo_vigencia sea igual a 'T'
-----------------------------------------------------------
prompt Creando trigger tr_licencia_vig
create or replace trigger tr_licencia_vig
	for update  of tipo_vigencia
	on licencia_conducir
	compound trigger 
	v_licencia_id number;
	v_tipo_vigencia varchar2(1);
	v_fecha_vigencia date;
	before each row is
	begin

		v_licencia_id := :new.licencia_conducir_id;
		v_tipo_vigencia:= :new.tipo_vigencia;

		if v_tipo_vigencia = 'T' then
			v_fecha_vigencia := sysdate+round(dbms_random.value(365,600));
			dbms_output.put_line('insertando en fecha_vigencia, licencia_conducir_id: ' || v_licencia_id);
			update licencia_conducir set fecha_vigencia =v_fecha_vigencia where licencia_conducir_id=v_licencia_id;
		end if;
	end before each row;
	end;
/ 
show errors 
