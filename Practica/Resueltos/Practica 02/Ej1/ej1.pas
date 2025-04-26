program ej1;
const
	valor_corte = -1;

type
	ingreso = record
		cod: integer;
		nombre: string;
		monto: real;
	end;
	
	archivo = file of ingreso;


procedure leer(var arch_ingreso: archivo; var i: ingreso);
begin
	if not EOF(arch_ingreso) then
		read(arch_ingreso, i)
	else
		i.cod:= valor_corte;
end;


procedure cargar_arch_final(var arch_final: archivo; var arch_ingreso: archivo);
var
	aux, i: ingreso;
	monto_total: real;
begin

	leer(arch_ingreso, i);
	while (i.cod <> valor_corte) do begin
			
		aux:= i;
		monto_total:= 0;
		
		while (i.cod <> valor_corte) and (i.cod = aux.cod) do begin
			monto_total:= monto_total + aux.monto;
			leer(arch_ingreso, i);
		end;
		
		aux.monto:= monto_total;
		write(arch_final, aux);
		
	end;
end;


var
	arch_final, arch_ingreso: archivo;

begin
	assign(arch_final, 'arch_final.dat');
	assign(arch_ingreso, 'arch_ingreso.dat');
	
	rewrite(arch_final); reset(arch_ingreso);
	cargar_arch_final(arch_final, arch_ingreso);
	
	writeln('  Archivo creado y cargado con exito.');
	
	close(arch_final); close(arch_ingreso);
end.
