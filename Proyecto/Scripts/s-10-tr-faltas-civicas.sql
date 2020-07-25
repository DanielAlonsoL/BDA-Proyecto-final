--@Autor: Alonso Lopez Daniel, Marcelino Cisneros Eduardo
--@Fecha creación: 19/06/2020
--@Descripción: Triggers del Modulo Faltas Civicas
prompt Conectando maal_falta_civica y triggers
connect maal_falta_civica/maal_falta_civica

-----------------------------------------------------------
--Trigger que inserta en el historico por cada vez
--que insertan una falta civica o que actualizan una
-----------------------------------------------------------
prompt Creando trigger tr_historico
create or replace trigger tr_historico
	after insert or update of status_falta_civica_id
	on falta_civica
	for each row
declare
v_seq_hist number(10,0);
v_fecha_status date;
v_status_falta_civica_id number(10,0);
v_falta_civica_id number(10,0);

begin
	select seq_historico_status.nextval into v_seq_hist from dual;
	case
		when inserting then
			v_fecha_status:= sysdate;
			v_status_falta_civica_id := :new.status_falta_civica_id;
			v_falta_civica_id := :new.falta_civica_id;

			insert into historico_status (historico_status_id, fecha_status, status_falta_civica_id, falta_civica_id)
			values (v_seq_hist, v_fecha_status, v_status_falta_civica_id, v_falta_civica_id);

		when updating('status_falta_civica_id') then
			v_fecha_status:= sysdate;
			v_status_falta_civica_id := :new.status_falta_civica_id;
			v_falta_civica_id := :new.falta_civica_id;

			insert into historico_status (historico_status_id, fecha_status, status_falta_civica_id, falta_civica_id)
			values (v_seq_hist, v_fecha_status, v_status_falta_civica_id, v_falta_civica_id);
	end case;
end;
/ 
show errors 

-----------------------------------------------------------
--Trigger que inserta un registro random
--al subtipo estado_inconveniente, si la falta civica 
--tiene el atributo es_edo_inconveniente = 1
-----------------------------------------------------------
create or replace trigger estado_inconveniente_trigger
	after insert on falta_civica
	for each row
	
	declare
	v_falta_id number(10,0);
	v_es_edo_inconveniente number(1,0);

	v_num_alcoholimetro number(10,0);
	v_nivel_alcohol number(1,0);
	v_centro_detencion varchar2(100);

	type centros_array is varray(15) of varchar2(100);
	centros centros_array;

	begin

		centros := centros_array('7 Donald Court','0 Kedzie Crossing','5 Badeau Center','213 Kedzie Park','43732 Scott Point',
			'0119 Maryland Place','72 Annamark Parkway','1200 Waxwing Alley','4 Tennessee Avenue','3 Browning Avenue','47589 Kinsman Place',
			'5 Evergreen Circle','57 Cambridge Place','8223 Maryland Circle','07 Forster Alley');

		v_falta_id := :new.falta_civica_id;
		v_es_edo_inconveniente := :new.es_edo_inconveniente;

		if v_es_edo_inconveniente = 1 then
			v_centro_detencion := centros(round(dbms_random.value(1,15)));
			v_num_alcoholimetro := round(dbms_random.value(1,99));
			v_nivel_alcohol := round(dbms_random.value(1,5));
			dbms_output.put_line('insertando en estado_inconveniente, falta_civica_id: ' || v_falta_id);
			-- inserta en el histórico
			insert into estado_inconveniente
				(falta_civica_id,num_alcoholimetro,nivel_alcohol,centro_detencion)
				values(v_falta_id,v_num_alcoholimetro,v_nivel_alcohol,v_centro_detencion);
		end if;
	end;
/ 
show errors 

-----------------------------------------------------------
--Trigger que inserta un registro random
--al subtipo exceso_velocidad, si la falta civica 
--tiene el atributo es_exceso_velocidad = 1
-----------------------------------------------------------
create or replace trigger exceso_vel_trigger
	after insert on falta_civica
	for each row
	
	declare
	v_falta_id number(10,0);
	v_es_exceso_vel number(1,0);
	v_latitud varchar2(15);
	v_longitud varchar2(15);
	v_clave_sensor varchar2(8);
	v_vel_max number(10,0);
	v_vel_reportada number(10,0);

	type orientacion_array is varray(4) of varchar2(10);
	orientaciones orientacion_array;

	begin

		orientaciones := orientacion_array('Norte','Sur','Este','Oeste');
		v_falta_id := :new.falta_civica_id;
		v_es_exceso_vel := :new.es_exceso_velocidad;

		if v_es_exceso_vel = 1 then
			v_latitud := round(dbms_random.value(1,50)) || '° '||round(dbms_random.value(1,50))||' '||orientaciones(round(dbms_random.value(1,4)));
			v_longitud := round(dbms_random.value(1,50)) || '° '||round(dbms_random.value(1,50))||' '||orientaciones(round(dbms_random.value(1,4)));
			v_clave_sensor := dbms_random.string('X',8);
			v_vel_max := 80;
			v_vel_reportada := round(dbms_random.value(80,280));
			dbms_output.put_line('insertando en exceso_velocidad, falta_civica_id: ' || v_falta_id);
			-- inserta en el histórico
			insert into exceso_velocidad
				(falta_civica_id,coord_latitud,coord_longitud,clave_sensor,vel_max_km_h,vel_reportada)
				values(v_falta_id,v_latitud,v_longitud,v_clave_sensor,v_vel_max,v_vel_reportada);
		end if;
	end;
/ 
show errors 

-----------------------------------------------------------
--Trigger que inserta un registro random
--al subtipo pasarse_alto, si la falta civica 
--tiene el atributo es_pasarse_alto = 1
-----------------------------------------------------------
create or replace trigger pasarse_alto_trigger
	after insert on falta_civica
	for each row
	
	declare
	v_falta_id number(10,0);
	v_es_pasarse_alto number(1,0);

	v_crucero varchar2(100);
	v_folio	varchar2(13);

	type crucero_array is varray(15) of varchar2(100);
	cruceros crucero_array;

	begin

		cruceros := crucero_array('6234 Susan Pass','964 Fallview Parkway','8790 Boyd Center','97 Vahlen Alley','775 Calypso Terrace',
			'81 Sunfield Way','0 Morningstar Drive','481 Starling Parkway','00 Westerfield Center','1 High Crossing Plaza','134 Redwing Alley',
			'9 Graceland Trail','523 Anniversary Court','73 Springview Terrace','25827 Golf Alley');

		v_falta_id := :new.falta_civica_id;
		v_es_pasarse_alto := :new.es_pasarse_alto;

		if v_es_pasarse_alto = 1 then
			v_crucero := cruceros(round(dbms_random.value(1,15)));
			v_folio := dbms_random.string('X',13);
			dbms_output.put_line('insertando en pasarse_alto, falta_civica_id: ' || v_falta_id);
			insert into pasarse_alto
				(falta_civica_id,nombre_crucero,folio_dispositivo)
				values(v_falta_id,v_crucero,v_folio);
		end if;
	end;
/ 
show errors 