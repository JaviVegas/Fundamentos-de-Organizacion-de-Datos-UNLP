program ej3;
type
	novela = record
		cod: integer;
		genero: string;
		nombre: string;
		duracion: integer;
		director: string;
		precio: real;
	end;

	archivo = file of novela;
	

procedure menu_inicio(var i:integer);
begin
	repeat
		writeln();
		writeln('Seleccione una de las siguientes opciones (0 para salir): )');
		writeln();
		writeln('  [1] Crear un nuevo archivo de novelas.');
		writeln('  [2] Abrir un archivo existente de novelas.');
		writeln('  [3] Listar todas las novelas del archivo en un archivo de texto.');
		writeln('  [0] Salir.');
		writeln();
		
		readln(i);
	until((i >= 0) and (i <= 3));
end;


procedure menu_abrir(var j:integer);
begin
	repeat
		writeln();
		writeln('Seleccione una de las siguientes opciones (0 para volver): )');
		writeln();
		writeln('  [1] Dar de alta una nueva novela.');
		writeln('  [2] Modificar los datos de una novela existente.');
		writeln('  [3] Eliminar una novela.');
		writeln('  [0] Volver al menu anterior.');
		writeln();
		
		readln(j);
	until((j >= 0) and (j <= 3));
end;


procedure leer(var n: novela);
begin
	write('Ingrese codigo: ');
	readln(n.cod);
	write('Ingrese genero: ');
	readln(n.genero);
	write('Ingrese nombre: ');
	readln(n.nombre);
	write('Ingrese duracion: ');
	readln(n.duracion);
	write('Ingrese director: ');
	readln(n.director);
	write('Ingrese precio: ');
	readln(n.precio);
end;


procedure cargar_archivo(var arch: archivo);
var
	n: novela;
begin
	// Almaceno la cabecera de la lista invertida en el primer registro del archivo.
	n.cod:= 0;
	write(arch, n);
	
	leer(n);
	while (n.cod <> -1) do begin	
		write(arch, n);
		leer(n);
	end;
end;


procedure alta_novela(var arch:archivo);
var
	n, nue: novela;
	pos: integer;
begin
	leer(nue);
	
	// Leo la cabecera.
	read(arch, n);
	if(n.cod < 0) then begin
		// Me muevo a la posicion que indica la cabecera.
		pos:= n.cod * (-1);
		seek(arch, pos);
		
		// Leo la 2da entrada de la lista invertida, y luego guardo ahí mismo el nuevo registro.
		read(arch, n);
		seek(arch, filePos(arch) - 1);
		write(arch, nue);
		
		// Vuelvo a la cabecera y la actualizo.
		seek(arch, 0);		
		write(arch, n);
		
	end	
	else begin
		seek(arch, fileSize(arch));
		write(arch, nue);
	end;

end;


procedure leer_modif(var n: novela);
begin
	write('Ingrese genero: ');
	readln(n.genero);
	write('Ingrese nombre: ');
	readln(n.nombre);
	write('Ingrese duracion: ');
	readln(n.duracion);
	write('Ingrese director: ');
	readln(n.director);
	write('Ingrese precio: ');
	readln(n.precio);
end;


procedure modificar_novela(var arch: archivo);
var
	n, nue: novela;
	encontre: boolean;
begin
	encontre:= false;
	write('Ingrese el codigo de la novela que desea modificar: ');
	readln(nue.cod);
	
	// Leo la cabecera.
	read(arch, n);

	while ((not EOF(arch)) and (not encontre)) do begin
		read(arch, n);
		if(n.cod = nue.cod) then
			encontre:= true;
	end;
	
	if (encontre) then begin
		seek(arch, filePos(arch) - 1);
		write(arch, nue);
	end		
	else
		writeln('  [!] No se encontro ninguna novela con ese codigo.');
end;


procedure eliminar_novela(var arch: archivo);
var
	n, nue, n_cab: novela;
	encontre: boolean;
	pos: integer;
begin
	encontre:= false;
	write('Ingrese el codigo de la novela que desea eliminar: ');
	readln(nue.cod);
	
	// Leo la cabecera.
	read(arch, n_cab);
	
	while ((not EOF(arch)) and (not encontre)) do begin
		read(arch, n);
		if(n.cod = nue.cod) then
			encontre:= true;
	end;
	
	if (encontre) then begin
		
		seek(arch, filePos(arch) - 1);
		pos:= filePos(arch); // Me guardo la posicion del registro a borrar.
		
		// En el registro a borrar, pongo el codigo del cabecera viejo.
		n.cod:= n_cab.cod;
		write(arch, n);
		
		// Luego, actualizo el codigo del cabecera viejo para que apunte al que acabo de borrar.
		seek(arch, 0);
		n_cab.cod:= pos * (-1); // Lo tengo que poner negativo.
		write(arch, n_cab);
	end
	else
		writeln(' [!] No se encontro ninguna novela con ese codigo.');
end;


procedure crear_texto(var arch: archivo; var txt: Text);
var
	n: novela;
begin
	while not EOF(arch) do begin
		read(arch, n);
		write(txt, n.cod, n.genero, n.nombre, n.duracion, n.director, n.precio); // Arreglar.
	end;
end;


var
	arch: archivo; txt: Text;
	nom_fisico: string;
	i, j: integer;
begin
	menu_inicio(i);
	
	while (i <> 0) do begin
	
		if (i = 1) then begin
			
			write('Ingrese nombre del archivo a crear: ');
			readln(nom_fisico);
			
			assign(arch, nom_fisico);
			rewrite(arch);
			
			cargar_archivo(arch);
			
			close(arch);
		end
		else if (i = 2) then begin
			
			write('Ingrese nombre del archivo a abrir: ');
			readln(nom_fisico);
			
			assign(arch, nom_fisico);
			
			menu_abrir(j);
			
			while (j <> 0) do begin
				
				reset(arch);
				
				if (j = 1) then
					alta_novela(arch)
					
				else if (j = 2) then
					modificar_novela(arch)
				
				else if (j = 3) then
					eliminar_novela(arch);				
				
				close(arch);
				
				menu_abrir(j);
			end;
			
		end
		else if (i = 3) then begin
			
			write('Ingrese nombre del archivo a abrir: ');
			readln(nom_fisico);
			
			assign(arch, nom_fisico);
			assign(txt, 'novelas.txt');
			reset(arch);
			rewrite(txt);
			
			crear_texto(arch, txt);
			
			close(arch); close(txt);	
		end;
		
		menu_inicio(i);	
	end;
end.
