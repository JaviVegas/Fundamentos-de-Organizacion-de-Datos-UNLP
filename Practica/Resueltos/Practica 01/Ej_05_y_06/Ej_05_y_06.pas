program Ej_05_y_06;
type

	linea1 = record
		cod: integer; precio: real; marca: string;
	end;
	
	linea2 = record
		stock_act: integer;	stock_min: integer;	desc: string;
	end;

	celular = record
		linea_1: linea1;
		linea_2: linea2;
		linea_3: string;
	end;
	
	archivo_celulares = file of celular;


procedure listar_todos(var arch: archivo_celulares);
var
	c: celular;
begin
	while not EOF(arch) do begin
		
		read(arch, c);
		writeln(c.linea_1.cod, ' - ', c.linea_1.precio:0:2, ' - ', c.linea_1.marca);
		writeln(c.linea_2.stock_act, ' - ', c.linea_2.stock_min, ' - ', c.linea_2.desc);
		writeln(c.linea_3);
		writeln(' --- ');
		
	end;
	
	writeln('--- FIN LISTA ---');
end;


procedure menu_inicio(var i: integer);
begin
	writeln('Seleccione una opcion ("0" para salir): ');
	
	writeln('  [1] Crear un nuevo archivo de celulares a partir de un archivo de texto existente.');
	writeln('  [2] Listar celulares con stock menor al stock minimo.');
	writeln('  [3] Buscar y listar celulares por descripcion.');
	writeln('  [4] Exportar el archivo de celulares a un archivo de texto.');
	writeln('  [5] Agregar uno o mas celulares al archivo.');
	writeln('  [6] Modificar el stock de un celular especifico.');
	writeln('  [7] Exportar a un archivo de texto los celulares sin stock.');
	writeln('  [0] Salir.');
	
	readln(i); writeln('');
	
	while (i < 0) and (i > 7) do begin
		writeln('Seleccione una opcion ("0" para salir): ');
	
		writeln('  [1] Crear un nuevo archivo de celulares a partir de un archivo de texto existente.');
		writeln('  [2] Listar celulares con stock menor al stock minimo.');
		writeln('  [3] Buscar y listar celulares por descripcion.');
		writeln('  [4] Exportar el archivo de celulares a un archivo de texto.');
		writeln('  [5] Agregar uno o mas celulares al archivo.');
		writeln('  [6] Modificar el stock de un celular especifico.');
		writeln('  [7] Exportar a un archivo de texto los celulares sin stock.');
		writeln('  [0] Salir.');
		
		readln(i); writeln('');
	end;
end;


procedure crear_archivo(var arch: archivo_celulares; var arch_text: Text);
var
	celu1: linea1; celu2: linea2; celu3: string;
	c: celular;
begin
	while not EOF(arch_text) do begin
		
		read(arch_text, celu1.cod, celu1.precio, celu1.marca);
		read(arch_text, celu2.stock_act, celu2.stock_min, celu2.desc);
		read(arch_text, celu3);
		
		c.linea_1:= celu1; c.linea_2:= celu2; c.linea_3:= celu3;
		write(arch, c);
	end;
	
	writeln('  Archivo cargado con exito!');
end;


procedure listar_stock(var arch: archivo_celulares);
var
	//celu1: linea1; celu2: linea2; celu3: string;
	c: celular;
	encontre: boolean;
begin
	encontre:= false;
	while not EOF(arch) do begin
		read(arch, c);
		
		if (c.linea_2.stock_act < c.linea_2.stock_min) then begin
			writeln(c.linea_1.cod, ' ', c.linea_1.precio:0:2, ' ', c.linea_1.marca);
			writeln(c.linea_2.stock_act, ' ', c.linea_2.stock_min, ' ', c.linea_2.desc);
			writeln(c.linea_3);
		end;		
	end;
	
	if encontre = true then
		writeln('--- FIN LISTA ---')
	else
		writeln('  No se encontraron celulares con stock actual por debajo del stock minimo.');
end;


procedure listar_descripcion(var arch: archivo_celulares);
var
	c: celular; cadena: string;
	encontre: boolean;
begin
	write('Ingrese texto para buscar: ');
	readln(cadena);
	
	encontre:= false;
	while not EOF(arch) do begin		
		
		read(arch, c);					
		if(c.linea_2.desc = cadena) then begin
			
			writeln(c.linea_1.cod, ' ', c.linea_1.precio:0:2, ' ', c.linea_1.marca);
			writeln(c.linea_2.stock_act, ' ', c.linea_2.stock_min, ' ', c.linea_2.desc);
			writeln(c.linea_3);
			writeln('');
		end;
	
	if not encontre then
		writeln('  No se encontraron celulares que contengan esa descripcion.');
	end;
end;


procedure exportar_celulares(var arch: archivo_celulares; var arch_text: Text);
var
	celu1: linea1; celu2: linea2; celu3: string;
	c: celular;
begin
	while not EOF(arch) do begin
	
		read(arch, c);
		celu1:= c.linea_1; celu2:= c.linea_2; celu3:= c.linea_3;
		
		write(arch_text, celu1.cod, celu1.precio:0:2); writeln(arch_text, celu1.marca);
		write(arch_text, celu2.stock_act, celu2.stock_min); writeln(arch_text, celu2.desc);
		writeln(arch_text, celu3);
	end;
	
	writeln('  Exportado con exito!');
end;


procedure leer_celular(var c: celular);
begin
	write('Ingrese codigo (-1 para terminar): ');
	readln(c.linea_1.cod);
	
	if(c.linea_1.cod <> -1) then begin
		write('Ingrese precio: ');
		readln(c.linea_1.precio);
		
		write('Ingrese marca: ');
		readln(c.linea_1.marca);
		
		write('Ingrese stock actual: ');
		readln(c.linea_2.stock_act);
		
		write('Ingrese stock minimo: ');
		readln(c.linea_2.stock_min);
		
		write('Ingrese descripcion: ');
		readln(c.linea_2.desc);
		
		write('Ingrese nombre: ');
		readln(c.linea_3);
	end;
end;

procedure agregar_celulares(var arch: archivo_celulares);
var
	c, c_aux: celular;
begin
	leer_celular(c);
	while c.linea_1.cod <> -1 do begin
		
		while not EOF(arch) do begin
			read(arch, c_aux);
		end;
		
		write(arch, c);
		seek(arch, 0);
		
		writeln('');
		writeln('  Agregado con exito!');
		writeln('');		
		
		leer_celular(c);		
	end;
end;


procedure modificar_stock(var arch: archivo_celulares);
var
	c: celular;
	nombre_celu: string;
	encontre: boolean;
	nuevo_stock: integer;
begin
	write('Ingrese el nombre del celular cuyo stock desea modificar: ');
	readln(nombre_celu);
	
	encontre:= false;
	while(not EOF(arch)) and (not encontre) do begin
		
		read(arch, c);
		if(nombre_celu = c.linea_3) then
			encontre:= true;
	end;
	
	if encontre then begin
	
		seek(arch, filePos(arch) - 1);
		writeln('  Se encontro el celular.');
		write('Ingrese el nuevo stock: ');
		readln(nuevo_stock);
		
		c.linea_2.stock_act:= nuevo_stock;
		write(arch, c);
		
		writeln('  Celular modificado con exito.');
	end
	else
		writeln('  [!] No se encontro ningun celular con ese nombre.');
end;


procedure exportar_sin_stock(var arch: archivo_celulares; var arch_text: Text);
var
	celu1: linea1; celu2: linea2; celu3: string;
	c: celular;
begin
	while not EOF(arch) do begin
		
		read(arch, c);
		if(c.linea_2.stock_act > 0) then begin
			
			celu1:= c.linea_1; celu2:= c.linea_2; celu3:= c.linea_3;
		
			write(arch_text, celu1.cod, celu1.precio:0:2); writeln(arch_text, celu1.marca);
			write(arch_text, celu2.stock_act, celu2.stock_min); writeln(arch_text, celu2.desc);
			writeln(arch_text, celu3);
		end;
	end;
	
	writeln('  Exportado con exito!');
end;


var
	arch: archivo_celulares; arch_text: Text;
	nom_arch: string;
	i: integer;
begin
	menu_inicio(i);
	
	while(i <> 0) do begin
	
		if(i = 1) then begin
			
			write('Ingrese el nombre del archivo a crear: ');
			readln(nom_arch);
			
			assign(arch, nom_arch);
			assign(arch_text, 'celulares.txt');
			
			rewrite(arch);
			reset(arch_text);
			
			crear_archivo(arch, arch_text);
			
			close(arch); close(arch_text)			
		end
		else if(i = 2) then begin
			write('Ingrese el nombre del archivo a abrir: ');
			readln(nom_arch);
			
			assign(arch, nom_arch);
			
			reset(arch);
			
			listar_stock(arch);
			
			close(arch)
		end
		else if(i = 3) then begin
			write('Ingrese el nombre del archivo a abrir: ');
			readln(nom_arch);
			
			assign(arch, nom_arch);
			
			reset(arch);
			
			listar_descripcion(arch);
			
			close(arch);
		end
		else if(i = 4) then begin
			
			write('Ingrese el nombre del archivo a abrir: ');
			readln(nom_arch);
			
			assign(arch, nom_arch);
			assign(arch_text, 'celulares.txt');
			
			reset(arch);
			reset(arch_text);
			
			exportar_celulares(arch, arch_text);
			
			close(arch); close(arch_text)
		end
		else if(i = 5) then begin
			write('Ingrese el nombre del archivo a abrir: ');
			readln(nom_arch);
			
			assign(arch, nom_arch);
			
			reset(arch);
			
			agregar_celulares(arch);
			
			close(arch);
		end
		else if(i = 6) then begin
			write('Ingrese el nombre del archivo a abrir: ');
			readln(nom_arch);
			
			assign(arch, nom_arch);
			
			reset(arch);
			
			modificar_stock(arch);
			
			close(arch);
		end
		else if(i = 7) then begin
			write('Ingrese el nombre del archivo a abrir: ');
			readln(nom_arch);
			
			assign(arch, nom_arch);
			assign(arch_text, 'SinStock.txt');
			
			reset(arch);
			rewrite(arch_text);
			
			exportar_sin_stock(arch, arch_text);
			
			close(arch);
		end;
		
		menu_inicio(i);
	
	end;
end.
