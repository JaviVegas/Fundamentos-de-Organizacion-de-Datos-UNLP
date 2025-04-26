program ej6;
const
	maquinas = 5;
	valor_corte = 'ZZZ';
	
type
	log = record
		cod: integer;
		fecha: string;
		tiempo: integer;
	end;
	
	archivo = file of log;
	
	vector_det = array[1..maquinas] of archivo;
	vector_logs = array[1..maquinas] of log;


procedure leer(var det: archivo; var l: log);
begin
	if not EOF(det) then
		read(det, l)
	else
		l.fecha:= valor_corte;
end;


procedure cargar_detalles(var v_det: vector_det; var v_log: vector_logs);
var
	i: integer;
begin

	for i:= 1 to maquinas do begin
		assign(v_det[i], 'archivo_logs.dat');
		reset(v_det[i]);
		leer(v_det[i], v_log[i]);
	end;
end;


procedure calcular_min(var v_det: vector_det; var v_log: vector_logs; var min: log);
var
	i, min_pos: integer;
begin
	min.fecha:= valor_corte; // Inicializo con el valor de corte. Si encuentro un nuevo min, se va a reemplazar
	min.cod:= 9999;
	for i:= 1 to maquinas do begin
		if(v_log[i].fecha < min.fecha) or ((v_log[i].fecha = min.fecha) and (v_log[i].cod < min.cod)) then begin
			min:= v_log[i];
			min_pos:= i;
		end;		
	end;
	
	if(min.fecha <> valor_corte) then
		leer(v_det[min_pos], v_log[min_pos]);
		
end;


procedure merge(var maes: archivo; var v_det: vector_det; v_log: vector_logs);
var
	min, aux_log: log;
	tiempo_total: integer;
begin
	calcular_min(v_det, v_log, min);
	while(min.fecha <> valor_corte) do begin
		
		aux_log:= min;
		tiempo_total:= 0;
		
		while(min.fecha <> valor_corte) and ((min.fecha = aux_log.fecha) and (min.cod = aux_log.cod)) do begin		
			tiempo_total:= tiempo_total + min.tiempo;
			calcular_min(v_det, v_log, min);		
		end;
		
		aux_log.tiempo:= tiempo_total;
		write(maes, aux_log);		
	end;
end;

	
var
	maes: archivo; v_det: vector_det;
	v_log: vector_logs;
	i: integer;
begin
	cargar_detalles(v_det, v_log);
	
	assign(maes, 'var/log/logs_maestro.dat'); // Se hace así?????
	rewrite(maes);
	
	merge(maes, v_det, v_log);
	
	close(maes);
	
	for i:= 1 to maquinas do
		close(v_det[i]);
end.
