program ej_03_y_04;

const

	EDAD_LIMITE = 70;

type

	empleado = record
		nro: integer;
		apellido: string;
		nombre: string;
		edad: integer;
		dni: integer;
	end;
	
	archivo_empleados = file of empleado;


procedure menu_inicio(var i: integer);
begin
	writeln('Seleccione una de las siguientes opciones [0-2]: ');
	writeln('');
	writeln('  [1] Crear un nuevo archivo de empleados.');
	writeln('  [2] Abrir un archivo de empleados existente.');
	writeln('  [0] Salir.');
	writeln('');
	
	readln(i);
	
	while (i <> 0) and (i <> 1) and (i <> 2) do begin
		writeln('Seleccione una de las siguientes opciones [0-2]: ');
		writeln('');
		writeln('  [1] Crear un nuevo archivo de empleados.');
		writeln('  [2] Abrir un archivo de empleados existente.');
		writeln('  [0] Salir.');
		writeln('');
		
		readln(i);
	end;
end;


procedure menu_abrir(var j: integer);
begin
	writeln('Seleccione una de las siguientes opciones [0-7]: ');
	writeln('');
	writeln('  [1] Listar en pantalla solo los datos de empleados que tengan un nombre o apellido determinado.');
	writeln('  [2] Listar en pantalla todos los empleados.');
	writeln('  [3] Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.');
	writeln('  [4] Agregar empleados al archivo.');
	writeln('  [5] Modificar la edad de un empleado.');
	writeln('  [6] Exportar contenido a un archivo de texto.');
	writeln('  [7] Exportar a un archivo de texto los empleados que no tengan cargado su DNI.');
	writeln('  [0] Volver atras.');
	writeln('');
	
	readln(j);
	
	while (j < 0) and (j > 7) do begin
		writeln('Seleccione una de las siguientes opciones [0-7]: ');
		writeln('');
		writeln('  [1] Listar en pantalla solo los datos de empleados que tengan un nombre o apellido determinado.');
		writeln('  [2] Listar en pantalla todos los empleados.');
		writeln('  [3] Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.');
		writeln('  [4] Agregar empleados al archivo.');
		writeln('  [5] Modificar la edad de un empleado.');
		writeln('  [6] Exportar contenido a un archivo de texto.');
		writeln('  [7] Exportar a un archivo de texto los empleados que no tengan cargado su DNI.');
		writeln('  [0] Volver atras.');
		writeln('');
		
		readln(j);
	end;
end;


procedure leer_empleado(var e: empleado);
begin
	writeln('Ingrese apellido ("fin" para terminar): '); readln(e.apellido);
	if e.apellido <> 'fin' then begin
		writeln('Ingrese nombre: '); readln(e.nombre);
		writeln('Ingrese numero: '); readln(e.nro);
		writeln('Ingrese dni: '); readln(e.dni);
		writeln('Ingrese edad: '); readln(e.edad);
		writeln('');
	end;
end;


procedure imprimir_empleado(e: empleado);
begin
	writeln('Apellido: ', e.apellido);
	writeln('Nombre: ', e.nombre);
	writeln('Numero: ', e.nro);
	writeln('Dni: ', e.dni);
	writeln('Edad: ', e.edad);
	writeln('');
end;


procedure crear_archivo(var arch: archivo_empleados);
var
	e: empleado;
begin
	leer_empleado(e);
	while e.apellido <> 'fin' do begin		
		write(arch, e);
		leer_empleado(e);
	end;
	writeln('--- FIN CARGA ---');
	writeln();
end;


procedure listar_con_nombre(var arch: archivo_empleados);
var
	e: empleado;
	nom_empleado: string;
	cant_encontrados: integer;
begin
	write('Ingrese un nombre o un apellido de los empleados que desea buscar: ');
	readln(nom_empleado);
	writeln('');
	cant_encontrados:= 0;
	while not EOF(arch) do begin
		
		read(arch, e);
		if (e.nombre = nom_empleado) or (e.apellido = nom_empleado) then begin
			
			imprimir_empleado(e);
			cant_encontrados:= cant_encontrados + 1;
		
		end;
	end;
	
	if cant_encontrados = 0 then
		writeln('No se encontraron empleados con nombre o con apellido igual a ', nom_empleado, '.')
	else
		writeln('--- FIN LISTA ---');
end;


procedure listar_todos(var arch: archivo_empleados);
var
	e: empleado;
begin
	while not EOF(arch) do begin
		
		read(arch, e);
		write(e.nombre, ' - ', e.apellido, ' - ', e.nro, ' - ', e.dni, ' - '); writeln(e.edad);
		
	end;
	
	writeln('--- FIN LISTA ---');
end;


procedure listar_mayores(var arch: archivo_empleados);
var
	e: empleado;
	cant_encontrados: integer;
begin
	cant_encontrados:= 0;
	while not EOF(arch) do begin
		
		read(arch, e);
		if (e.edad > EDAD_LIMITE) then begin
			imprimir_empleado(e);
		end;
		
	end;
	if cant_encontrados = 0 then
		writeln('No se encontraron empleados con edad mayor a ', EDAD_LIMITE, '.')
	else
		writeln('--- FIN LISTA ---');
end;


procedure agregar_empleados(var arch: archivo_empleados);
var
	emp_nuevo, emp_existente: empleado;
	existe: boolean;
begin
	leer_empleado(emp_nuevo);		
	while emp_nuevo.apellido <> 'fin' do begin
				
		existe:= false;
		while not EOF(arch) do begin
			
			read(arch, emp_existente);
			if (not existe) and (emp_nuevo.nro = emp_existente.nro) then begin
				existe:= true
			end;			
		end;
		
		if not existe then begin
			write(arch, emp_nuevo);
			writeln('  Agregado con exito!');
		end
		else
			writeln('  [!] Ya existe el empleado... No se pudo agregar.');
		
		seek(arch, 0);
		leer_empleado(emp_nuevo);
	end;
end;


procedure modificar_edad(var arch: archivo_empleados);
var
	nro, nueva_edad: integer;
	e: empleado;
	encontre: boolean;
begin
	write('Ingrese el nro del empleado al que quiere modificar: ');
	readln(nro);
	
	write('Ingrese la nueva edad del empleado: ');
	readln(nueva_edad);
	
	encontre:= false;
	while not EOF(arch) and (not encontre) do begin
		
		read(arch, e);
		
		if (not encontre) and (nro = e.nro) then
			encontre:= true;
	end;
	
	if encontre then begin
		
		e.edad:= nueva_edad;
		seek(arch, filePos(arch) - 1);
		
		write(arch, e);
		writeln('  Modificado con exito!');
	end
	else
		writeln('  [!] No se encontro el empleado con nro ', nro, '. No se pudo modificar.');
end;


procedure crear_texto(var arch: archivo_empleados; var arch_text: Text);
var
	e: empleado;
begin
	while not EOF(arch) do begin
		read(arch, e);
		write(arch_text, e.nro, ' ', e.apellido, ' ', e.nombre, ' ', e.edad, ' '); writeln(arch_text, e.dni);
	end;
	
	writeln('  Exportado con exito!');
end;


procedure falta_dni(var arch: archivo_empleados; var arch_text: Text);
var
	e: empleado;
begin
	while not EOF(arch) do begin
		read(arch, e);
		if (e.dni = 00) then begin
			write(arch_text, e.nro, ' ', e.apellido, ' ', e.nombre, ' ', e.edad, ' '); writeln(arch_text, e.dni);
		end;
	end;
	
	writeln('  Exportado con exito!');
end;


// Programa Principal.
var
	arch : archivo_empleados; arch_text : Text;
	nom_fisico, continuar : string;
	i, j : integer;
begin
	menu_inicio(i);
	
	while i <> 0 do begin
	
		if i = 1 then begin
		
			write('Ingrese el nombre del archivo a crear: ');
			readln(nom_fisico);
			
			assign(arch, nom_fisico);
			rewrite(arch);
			
			writeln('Archivo creado con exito.');
			
			crear_archivo(arch);
			close(arch);
			
		end
		else if i = 2 then begin
			
			
			write('Ingrese el nombre del archivo a abrir: ');
			readln(nom_fisico);
		
			assign(arch, nom_fisico);
			reset(arch);
		
			writeln('Archivo abierto con exito.');
			menu_abrir(j);		
				
			while j <> 0 do begin
			
				if j = 1 then begin
					listar_con_nombre(arch);
					close(arch)
				end
				else if j = 2 then begin
					listar_todos(arch);
					close(arch)
				end	
				else if j = 3 then begin
					listar_mayores(arch);
					close(arch)
				end
				else if j = 4 then begin
					agregar_empleados(arch);
					close(arch)
				end
				else if j = 5 then begin
					modificar_edad(arch);
					close(arch)
				end
				else if j = 6 then begin					
					assign(arch_text, 'todos_empleados.txt');
					rewrite(arch_text);
					
					crear_texto(arch, arch_text);
					
					close(arch); close(arch_text);
				end
				else if j = 7 then begin
					assign(arch_text, 'faltaDNIEmpleado.txt');
					rewrite(arch_text);
					
					falta_dni(arch, arch_text);
					
					close(arch); close(arch_text);
				end;
					
				
				writeln('');
				write(' Continuar? [S/N] ');
				readln(continuar);
				writeln('');
				
				if (continuar = 's') or (continuar = 'S') then begin
					
					write('Ingrese el nombre del archivo a abrir: ');
					readln(nom_fisico);
			
					assign(arch, nom_fisico);
					reset(arch);
			
					writeln('Archivo abierto con exito.');
					menu_abrir(j)
				end
				else
					j:= 0;
			
			end;			
		
		end;
		
		menu_inicio(i);
		
	end;
end.
