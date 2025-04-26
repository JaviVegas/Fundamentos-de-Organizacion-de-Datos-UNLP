program ej5;
const
	sucursales = 30;
	valor_corte = -1;
type
	producto = record
		cod: integer;
		nombre: string;
		desc: string;
		stock_act: integer;
		stock_min: integer;
		precio: real;
	end;
	
	venta = record
		cod: integer;
		cant_ventas: integer;
	end;
	
	maestro = file of producto;
	detalle = file of venta;

	vector = array[1..sucursales] of detalle;


procedure cargar_detalles(var v_det: vector);
var
	i: integer;
begin
	for i:= 1 to sucursales do begin
		assign(v_det[i], 'arch_det.dat');		
		reset(v_det[i]);
	end;
end;


procedure leer(var det: detalle; var v: venta);
begin
	if not EOF(det) then
		read(det, v)
	else
		v.cod:= valor_corte;
end;


procedure actualizar_maestro(var maes: maestro; var v_det: vector);
var
	i, total_ventas: integer;
	p: producto;
	v, v_aux: venta;
begin
	for i:= 1 to sucursales do begin
		
		leer(v_det[i], v);
		while(v.cod <> valor_corte) do begin
			
			v_aux:= v;
			total_ventas:= 0;			
			while (v.cod <> valor_corte) and (v.cod = v_aux.cod) do begin
				total_ventas:= total_ventas + v.cant_ventas;
				leer(v_det[i], v);			
			end;
			
			repeat
				read(maes, p);
			until(v_aux.cod = p.cod);
			
			seek(maes, filePos(maes) - 1);
			
			p.stock_act:= p.stock_act - total_ventas;
			write(maes, p);			
		end;
	end;
end;	


procedure crear_texto(var maes: maestro; var txt: Text);
var
	p: producto;
begin
	while not EOF(maes) do begin
		read(maes, p);
		
		if(p.stock_act < p.stock_min) then begin
			write(txt, p.precio, p.stock_act, p.nombre); writeln(txt, p.desc);
		end;
	end;
end;


var
	maes: maestro; v_det: vector; txt: Text;
begin
	cargar_detalles(v_det);
	
	assign(maes, 'arch_productos.dat');
	assign(txt, 'prod_bajo_stock.txt');
	
	reset(maes); rewrite(txt);
	
	actualizar_maestro(maes, v_det);
	crear_texto(maes, txt);
end.
