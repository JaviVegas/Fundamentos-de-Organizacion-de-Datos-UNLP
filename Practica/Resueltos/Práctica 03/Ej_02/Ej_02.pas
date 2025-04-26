program ej2;
const
	MARCA_BORRADO = '#';
type
	asistente = record
		nro: integer;
		apellido: string;
		nombre: string;
		email: string;
		telefono: integer;
		dni: integer;
	end;
	
	archivo = file of asistente;


procedure menu_inicio(var i:integer);
begin
	repeat
		writeln();
		writeln('Seleccione una de las siguientes opciones (0 para salir): ');
		writeln();
		writeln('  [1] Generar un archivo de asistentes.');
		writeln('  [2] Borrar asistentes con nro de asistente inferior a 1000.');
		writeln('  [0] Salir.');
		writeln();
		
		readln(i);
	until((i >= 0) and (i <= 2));
end;


procedure leer(var a: asistente);
begin
	write('Ingrese nro de asistente (-1 para terminar): ');
	readln(a.nro);
	write('Ingrese apellido: ');
	readln(a.apellido);
	write('Ingrese nombre: ');
	readln(a.nombre);
	write('Ingrese email: ');
	readln(a.email);
	write('Ingrese telefono: ');
	readln(a.telefono);
	write('Ingrese dni: ');
	readln(a.dni);
end;


procedure crear_archivo(var arch: archivo);
var
	a: asistente;
begin
	leer(a);
	while(a.nro <> -1) do begin
		write(arch, a);
		leer(a);
	end;
end;


procedure borrar_asistentes(var arch: archivo);
var
	a: asistente;
begin
	while not EOF(arch) do begin
	
		read(arch, a);
		if (a.nro < 1000) then begin
				
			//a.apellido:= MARCA_BORRADO + a.apellido;
			a.apellido:= concat(MARCA_BORRADO, a.apellido);
			
			seek(arch, filePos(arch) - 1);
			write(arch, a);
		end;	
	end;
end;


var
	arch: archivo;
	nom_fisico: string;
	i: integer;
begin
	menu_inicio(i);
	
	while (i <> 0) do begin
	
		if (i = 1) then begin
		
			write('Ingrese nombre del archivo a crear: ');
			readln(nom_fisico);
			
			assign(arch, nom_fisico);
			rewrite(arch);
			
			crear_archivo(arch);
			
			close(arch);		
		end
		else if (i = 2) then begin
		
			write('Ingrese nombre del archivo a abrir: ');
			readln(nom_fisico);
			
			assign(arch, nom_fisico);
			reset(arch);
			
			borrar_asistentes(arch);
			
			close(arch);		
		end;
		
		menu_inicio(i);
	end;
end.
