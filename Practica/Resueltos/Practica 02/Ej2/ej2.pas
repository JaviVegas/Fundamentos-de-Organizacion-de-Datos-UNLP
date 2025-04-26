program ej2;
const
	valor_corte = -1;

type	
	alumno = record
		cod: integer;
		apellido: string;
		nombre: string;
		cant_solo_cursada: integer;
		cant_con_final: integer;
	end;
	
	info_alumno = record
		cod: integer;
		final_aprob: boolean;
	end;
	
	maestro = file of alumno;
	detalle = file of info_alumno;


procedure selec_opcion(var i: integer);
begin
	repeat
		write('Ingrese una de las siguientes opciones (0 para salir): ');
		readln(i);
		writeln('');
		writeln('  [1] Actualizar el archivo de alumnos con la informacion del archivo detalle.');
		writeln('  [2] Listar en un archivo de texto los alumnos que tengan mas materias con finales aprobados que sin finales aprobados.');
		writeln('  [0] Salir.');
		writeln('');		
	until ((i = 0) or (i = 1) or (i = 2));
end;


procedure leer(var det: detalle; var a: info_alumno);
begin
	if not EOF(det) then
		read(det, a)
	else
		a.cod:= valor_corte;
end;


procedure actualizar_maestro(var maes: maestro; var det: detalle);
var
	a, aux: info_alumno;
	alu_maes: alumno;
	total_cursadas, total_finales: integer;
begin
	leer(det, a);
	while (a.cod <> valor_corte) do begin
	
		aux:= a;
		total_cursadas:= 0; total_finales:= 0;
		
		while ((a.cod <> valor_corte) and (a.cod = aux.cod)) do begin
			
			if(a.final_aprob) then begin
				total_finales:= total_finales + 1;
				total_cursadas:= total_cursadas - 1
			end
			else
				total_cursadas:= total_cursadas + 1;
			
			leer(det, a);
		end;
		
		// Busco el alumno a actualizar en el maestro.
		read(maes, alu_maes);
		while alu_maes.cod <> aux.cod do
			read(maes, alu_maes);
		
		seek(maes, filePos(maes) - 1);
		
		// Actualizo la informacion de las materias aprobadas para ese alumno.
		alu_maes.cant_solo_cursada:= alu_maes.cant_solo_cursada + total_cursadas;
		alu_maes.cant_con_final:= alu_maes.cant_con_final + total_finales;
		
		write(maes, alu_maes);
		
		// Avanzo en el maestro, porque estoy parado en el que acabo de
		// escribir. Ya no aparecera en el detalle (están ordenados por cod).
		// Hace falta o se puede obviar???
		if not EOF(maes) then
			read(maes, alu_maes);
	end;
	
	writeln('  Archivo de alumnos actualizado con exito!');
end;


procedure crear_texto(var maes: maestro; var texto: Text);
var
	a: alumno;
begin
	while not EOF(maes) do begin
		
		read(maes, a);
		
		if(a.cant_con_final > a.cant_solo_cursada) then begin
			
			write(texto, a.cod, a.cant_con_final, a.cant_solo_cursada, a.apellido); writeln(texto, a.nombre);
		
		end;
	end;
	
	writeln('  Archivo de texto exportado con exito!');
end;


var
	maes: maestro; det: detalle;
	arch_texto: Text;
	i: integer;
begin
	selec_opcion(i);
	
	if(i = 1) then begin
		assign(maes, 'arch_alumnos.dat');
		assign(det, 'arch_detalle.dat');
		
		reset(maes); reset(det);
		
		actualizar_maestro(maes, det);
	end
	else if(i = 2) then begin
		assign(maes, 'arch_alumnos.dat');
		assign(arch_texto, 'lista_mas_finales.txt');
		
		reset(maes); rewrite(arch_texto);
		
		crear_texto(maes, arch_texto);
	end;
end.
