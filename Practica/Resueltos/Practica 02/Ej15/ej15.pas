program ejercicio15; 
Uses sysutils; 

const
	valor_alto='ZZZ'; 
	dimF=100; 

type
	rango= 1..dimF; 
	emision= record
		fecha: string; 
		codigo: integer; 
		nombre: string; 
		descripcion: string; 
		precio: real; 
		total_ejemplares: integer;
		total_vendidos: integer; 
	end; 
	
	venta= record
		fecha: string; 
		codigo: integer; 
		cantidad: integer; 
	end; 
	
	maestro= file of emision; 
	detalle= file of venta; 
	
	vDet= array [rango] of detalle; 
	vVentas= array[rango] of venta; 
	
	
procedure leer(var det: detalle; var v: venta); 
begin
	if (not eof(det))then 
		read(det, v)
	else
		v.fecha:= valor_alto; 
end; 

procedure leerDetalles (var vec: vDet; var ventas: vVentas); 
var
	i: integer; 
	ruta:string; 
begin
	for i:=1 to dimF do begin 
		ruta:='detalles\detalle'+IntToStr(i)+'.dat';
		Assign (vec[i], ruta); 
		reset(vec[i]);
		leer(vec[i], ventas[i]); 
	end; 
end; 

procedure calcularMinimo(var vecDet: vDet; var ventas: vVentas; var min: venta);
var
	i, min_pos: integer; 
begin
	min.fecha:= valor_alto; 
	min.codigo:=9999; 
	for (i:=1 to dimF) do 
		if (ventas[i].fecha < min.fecha) or ((ventas[i].fecha=  min.fecha) and (ventas[i].codigo< min.codigo) )then begin
			min:= ventas[i]; 
			min_pos:= i; 
		end;
	if(min.fecha <> valor_alto) then
		leer(vecDet[min_pos], ventas[min_pos]); 
end; 
			
	

procedure merge(var mae: maestro; var vecDet: vDet; ventas: vecVentas); 
var
	min, aux:venta;
	actual: emision; 
	minEmision, maxEmision: emision; 
	minVentas, maxVentas, total: integer;  

begin
	minVentas:=9999; 
	maxVentas:=-9999; 
	calcularMinimo(vecDet, ventas, min); 
	while(min.fecha <> valor_alto) do begin
		aux:= min;
		total:=0;
		while (min.fecha <> valor_alto) and (aux.fecha= min.fecha) and (aux.codigo= min.codigo) do begin
			total:= total + min.ventas; 
			calcularMinimo(vecDet, ventas, min);
		end; 
		
		read(mae, actual); 
		while (actual.fecha<> min.fecha) and (actual.codigo <>min.codigo) do 
			read(mae, actual); 

		actual.total_vendidos:= actual.total_vendidos+ total; 
		actual.total_ejemplares:= actual.total_ejemplares -total; 
		
		if (actual.total_vendidos > maxVentas) then begin
			maxVentas:= actual.total_vendidos; 
			maxEmision:= actual; 
		end
		else
			if (actual.total_vendidos < minVentas) then begin
				minVentas:= actual.total_vendidos; 
				minEmision:= actual; 
			end;
		
		seek(mae, filepos(mae)-1); 
		write(mae, actual); 		
	
	end;

	writeln('Min: ', minEmision.codigo, minEmision.fecha);
end;

var
	mae: maestro; 
	vecDet: vDet; 
	vecVentas: vVentas; 
begin
	Assign(mae, 'maestro.dat); 
	reset(mae); 
	leerDetalles(vecDet, vecVentas); 
	merge(mae, vecDet, vecVentas); 
end.
