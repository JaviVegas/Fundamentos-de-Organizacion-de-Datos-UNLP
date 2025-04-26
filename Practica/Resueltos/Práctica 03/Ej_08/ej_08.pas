program ej8;
type
	distribucion = record
		nombre: string;
		anio: integer;
		ver: string;
		devs: integer;
		desc: string;
	end;

	archivo = file of distribucion;


function existe_distribucion(var arch: archivo; nom: string): boolean;
var
	d: distribucion;
	encontre: boolean;
begin
	encontre:= false;
	while((not EOF(arch)) and (not encontre)) do begin
		
		read(arch, d);
		if(d.nombre = nom) then
			encontre:= true;
	end;
	
	existe_distribucion:= encontre;
end;


procedure leer(var d: distribucion);
begin
	readln(d.nombre);
	readln(d.anio);
	readln(d.ver);
	readln(d.devs);
	readln(d.desc);
end;


procedure alta_distribucion(var arch: archivo);
var
	d, d_cab, nue_cab: distribucion;
	pos: integer;
begin
	read(arch, d_cab); // Leo la cabecera.

	leer(d);
	if(not existe_distribucion(arch, d.nombre)) then begin
		
		if(d_cab.devs <> 0) then begin
			
			// Voy a la pos que indica la cabecera.
			pos:= d_cab.devs * (-1);
			seek(arch, filePos(pos));
			
			// Me guardo la nueva cabecera antes de escribir en esa pos.
			read(arch, nue_cab);
			seek(arch, filePos(arch) - 1);
			write(arch, d);
			
			// Vuelvo a la cabecera y la actualizo.
			seek(arch, 0);
			write(arch, nue_cab);
		end
		else begin
			
			// Si no hay espacios libres, grego al final.
			seek(arch, fileSize(arch) - 1);
			write(arch, d);
		end;
	end
	else
		writeln('Ya existe la distribucion.');
end;


procedure baja_distribucion(var arch: archivo);
var
	d, d_cab: distribucion;
	nom: string;
	pos: integer;
begin
	read(arch, d_cab); // Leo la cabecera.

	leer(nom);
	if(existe_distribucion(arch, nombre)) then begin
		
		// Voy uno para atras (porque lei en la funcion).
		seek(arch, filePos(arch) - 1);
		
		// Me guardo la pos del que voy a borrar y el reg.
		pos:= filePos(arch);
		read(arch, d);

		// Voy uno para atras de nuevo y sobreescribo con la cabecera.
		seek(arch, pos);
		write(arch, d_cab);
		
		// Voy a la cabecera, actualizo el valor de devs, y escribo la nueva cabecera.
		seek(arch, 0);
		d.devs:= pos * (-1);
		write(arch, d);				
		
	end
	else
		writeln('Distribucion no existente.');
end;


var
	arch: archivo;
	nom: string;
	existe: boolean;
begin
	assign(arch, 'distribuciones_linux.dat');
	
	reset(arch);
	
	alta_distribucion(arch);
end.
