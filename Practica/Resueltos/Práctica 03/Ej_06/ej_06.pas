program ej6;
type
	prenda = record
		cod: integer;
		desc: string;
		colores: string;
		tipo: string;
		stock: integer;
		precio: real;
	end;
	
	maestro = file of prenda;
	absoletas = file of integer;


procedure actualizar(var maes: maestro; var abs: absoletas);
var
	p: prenda;
	cod_abs: integer;
	encontre: boolean;
begin
	while not EOF(abs) do begin
	
		read(abs, cod_abs);
		encontre:= false;
		while ((not EOF(maes)) and (not encontre)) do begin		
		
			read(maes, p);
			if(p.cod = cod_abs) then
				encontre:= true;		
		end;
		
		if(encontre) then begin
		
			seek(maes, filePos(maes) - 1);
			p.stock:= p.stock * (-1);
			write(maes, p);			
		end;
		
		seek(maes, 0);
	end;
end;


procedure efecutar_bajas(var maes, nue: maestro);
var
	p: prenda;
begin
	while not EOF(maes) do begin
	
		read(maes, p);
		if(p.stock >= 0) then
			write(nue, p);	
	end;
end;


var
	maes, nue: maestro; abs: absoletas;
begin
	assign(maes, 'prendas_maestro.dat');
	assign(abs, 'prendas_absoletas.dat');
	assign(nue, 'nuevo_maestro.dat');
	
	reset(maes); reset(abs);
	actualizar(maes, abs);
	
	close(maes); close(abs);
	
	reset(maes); rewrite(nue);
	efectuar_bajas(maes, nue);
	
	close(maes); close(nue);
	
	rename(nue, 'prendas_maestro.dat');
end.
