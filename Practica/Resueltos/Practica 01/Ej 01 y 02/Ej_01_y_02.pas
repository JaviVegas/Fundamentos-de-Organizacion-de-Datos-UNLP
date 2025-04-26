program ej_01_y_02;

type
    archivo_enteros = file of integer;

procedure menu_inicio(var i: integer);
begin
	writeln('');
    writeln('Ingrese 1 o 2 para seleccionar una opcion: ');
    writeln('  [1] Crear un nuevo archivo de enteros.');
    writeln('  [2] Abrir y mostrar el contenido de un archivo existente.');
    readln(i);
    
    while (i <> 0) and (i <> 1) and (i <> 2) do begin
        writeln('');
        writeln('Ingrese 1 o 2 para seleccionar una opcion: ');
        writeln('  [1] Crear un nuevo archivo de enteros.');
        writeln('  [2] Abrir y mostrar el contenido de un archivo existente.');
        readln(i);
    end;
end;

procedure cargar_archivo(var arch: archivo_enteros);
var
    nro: integer;
begin
    write('Ingrese un numero entero (30000 para terminar): ');
    readln(nro);
    while nro <> 30000 do begin
        write(arch, nro);
        writeln('¡El numero ', nro, ' se cargo con exito!');
        writeln('');
        write('Ingrese otro numero entero (30000 para terminar): ');
        readln(nro);
        writeln('');
    end;

    writeln(' --- ');
    writeln('FIN CARGA');
    writeln( ' --- ');
end;

procedure listar_archivo(var arch: archivo_enteros);
var
    nro: integer;
begin
    writeln( ' --- ');
    writeln(' CONTENIDO DEL ARCHIVO');
    writeln( ' --- ');
    while not EOF(arch) do begin
        read(arch, nro);
        writeln(nro);
        writeln('');
    end;

    writeln( ' --- ');
end;

// Programa Princiapal.
var
    arch: archivo_enteros;
    nombre_fisico: string;
    i: integer;

begin
    menu_inicio(i);

    while i <> 0 do begin        
        if i = 1 then begin
            write('Ingrese el nombre del archivo a crear: ');
            readln(nombre_fisico);
            Assign(arch, nombre_fisico);
        
            Rewrite(arch);
            cargar_archivo(arch);
        end

        else if i = 2 then begin
            write('Ingrese el nombre del archivo a abrir: ');
            readln(nombre_fisico);
            assign(arch, nombre_fisico);

            reset(arch);
            listar_archivo(arch);
        end;

        close(arch);
        menu_inicio(i);
    end;
end.
