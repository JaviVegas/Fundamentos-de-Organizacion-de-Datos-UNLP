program ej11;
const
	valor_corte = -1;

type
	fecha = record
		dia: integer;
		mes: integer;
		anio: integer;
	end;
	
	acceso = record
		fecha: fecha;
		id: integer;
		tiempo: integer;
	end;
	
	archivo = file of acceso;


procedure leer(var arch: archivo; var a: acceso);
begin
	if not EOF(arch) then
		read(arch, a)
	else
		a.fecha.anio:= valor_corte;
end;


procedure generar_informe(var arch: archivo; anio: integer);
var
	a, aux: acceso;
	tiempo_id, tiempo_dia, tiempo_mes, tiempo_anio: integer;
begin
	repeat
		leer(arch, a);
	until (a.fecha.anio = valor_corte) or (a.fecha.anio = anio);
	
	if (a.fecha.anio = anio) then begin
		
		writeln('Anio: ', a.fecha.anio);
		aux.fecha.anio:= a.fecha.anio;
		tiempo_anio:= 0;
		
		while (a.fecha.anio <> valor_corte) and (a.fecha.anio = anio) do begin
		
			writeln('Mes: ', a.fecha.mes);
			aux.fecha.mes:= a.fecha.mes;			
			tiempo_mes:= 0;
			
			while (a.fecha.anio <> valor_corte) and (a.fecha.anio = anio) and (a.fecha.mes = aux.fecha.mes) do begin
				
				writeln('Dia: ', a.fecha.dia);
				aux.fecha.dia:= a.fecha.dia;
				tiempo_dia:= 0;
				
				while (a.fecha.anio <> valor_corte) and (a.fecha.anio = anio) and (a.fecha.mes = aux.fecha.mes) and (a.fecha.dia = aux.fecha.dia) do begin
									
					aux.id:= a.id;
					tiempo_id:= 0;
					
					while (a.fecha.anio <> valor_corte) and (a.fecha.anio = anio) and (a.fecha.mes = aux.fecha.mes) and (a.fecha.dia = aux.fecha.dia) and (a.id = aux.id) do begin
						
						tiempo_id:= tiempo_id + a.tiempo;
						leer(arch, a);
					end;
					
					writeln('idUsuario ', aux.id, ' Tiempo total de acceso en el dia ', aux.fecha.dia, ' mes ', aux.fecha.mes);
					tiempo_dia:= tiempo_dia + tiempo_id;					
				end;
				
				writeln('Tiempo total acceso dia ', aux.fecha.dia, ' mes ', aux.fecha.mes);
				writeln(tiempo_dia);
				tiempo_mes:= tiempo_mes + tiempo_dia;
			end;
			
			writeln('Total tiempo de acceso mes ', aux.fecha.mes);
			writeln(tiempo_mes);
			tiempo_anio:= tiempo_anio + tiempo_mes;
		end;
		
		writeln('Total tiempo de acceso anio ', aux.fecha.anio);
	end
	else
		writeln('  [!] Anio no encontrado.');
end;



var
	arch: archivo;
	anio: integer;
begin
	assign(arch, 'archivo_accesos.dat');
	reset(arch);
	
	write('Ingrese el anio del cual desea un informe: ');
	read(anio);
	generar_informe(arch, anio);
	
	close(arch);	
end.
