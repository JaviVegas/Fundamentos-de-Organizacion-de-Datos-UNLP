program ejericio16;
Uses sysutils; 
const
	valor_alto= 9999; 
	dimF= 10;
type 	
	rango= 1..dimF; 
	moto= record
		codigo: integer; 
		nombre: string; 
		descripcion: string; 
		modelo: string; 
		marca: string; 
		stock_actual: integer; 
	end; 
	reg_detalle= record
		codigo: integer; 
		precio: Integer; 
		fecha: string; 
	end; 

	archivo_detalle= file of reg_detalle; 
	archivo_maestro= file of moto; 
	
	vectorDetalleSEmpleados= array[rango] of Text; 
	
	vector_motos= array[rango] of reg_detalle; 
{
procedure leerMoto(var det: archivo_detalle; var r: reg_detalle);
begin
	if (not eof(det)) then 
		read(det, r)
	else
		r.codigo_moto:= valor_alto; 
end; 
}
procedure leerMoto(var det: Text; var r:reg_detalle); 
begin 
	if (not eof(det)) then 
		with r do begin
			readln(det, codigo); 
			writeln('aca esta el problem');
			
			readln(det, precio); 
			readln(det, fecha); 
			

		//para impresion
			
			writeln('codigo: ', codigo); 
		end
	else
		r.codigo:= valor_alto; 
	end; 
procedure leerMotoMaestroTxt(var txt: text; var m: moto); 
begin 
	with m do begin 
		readln(txt, codigo); 
		readln(txt, nombre); 
		readln(txt, descripcion); 
		readln(txt, modelo); 
		readln(txt, marca); 
		readln(txt, stock_actual); 
		
		//para impresion
		writeln('codigo: ', codigo); 
		writeln('stock actual: ',stock_actual); 
	end; 
end; 
	
		
procedure importarMaestro(var txt:Text; var arch: archivo_maestro); 
var
	m: moto; 
begin
	reset(txt); 
	rewrite(arch);
	while (not eof (txt)) do begin 
		leerMotoMaestroTxt(txt, m); 
		write(arch, m); 
	end; 
	close(txt); 
	close(arch); 
end; 

procedure importarDetalles (var vec: vectorDetalleSEmpleados; var vecMotos: vector_motos); 
var 
	i: integer; 
	ruta:string; 
begin 
	writeln('importando detalles');
	for i:= 1 to dimF do begin 
	//	Assign (vec[i], 'detalles/detalle'+ IntToStr(i)+'.txt');
		ruta:='detalles\detalle'+IntToStr(i)+'.txt';
		writeln(ruta);
		assign(vec[i],ruta);
		reset(vec[i]); 
		leerMoto(vec[i], vecMotos[i]); 

	end; 
	writeln('       TERMINE DE IMPORTAR DETALLES ');
end; 
procedure minimo( var vec: vectorDetalleSEmpleados; var vec_motos: vector_motos; var min: reg_detalle); 
var 
	 min_pos: integer; 
	 i:rango; 
begin 
	writeln('en el minimo');
	min.codigo:= valor_alto; 

	for i:=1 to dimF do begin
		if (vec_motos[i].codigo <= min.codigo) then begin
			min:= vec_motos[i]; 
			min_pos:=i; 
		end; 
		writeln('----------------------------------------'); 
		writeln('MINIMO: ', min.codigo); 
	end; 
	if (min.codigo<> valor_alto )then
		leerMoto(vec[min_pos], vec_motos[min_pos]); 
		writeln('ya lei'); 
end; 
			

procedure merge(var mae:archivo_maestro; var vec_det: vectorDetalleSEmpleados; var vec_motos: vector_motos); 
var
	min, aux, maxMoto: reg_detalle; 
	actual: moto; 
	//vec_motos: vector_motos;
	max, total, i:integer;
begin 
	//rewrite(mae); 
	writeln('en el merge'); 
	//importarDetalles(vec_det, vec_motos); 
	minimo(vec_det, vec_motos, min); 
	reset(mae); 
	max:=-9999; 
	//writeln('actual: ', actual.codigo); 
	//writeln('minimo ',min.codigo); 
	while (min.codigo <> valor_alto) do begin 
		{while (min.codigo<> actual.codigo) do 
			// si no esta en ningun detalle es pq no fue vendida -> no modifico el stock
			read(mae, actual); }
		total:=0;
		aux:= min;
		while (min.codigo <> valor_alto) and (min.codigo = aux.codigo) do begin 
			total:= total +1; 
			minimo(vec_det, vec_motos, min); 
			writeln('actualizacion: ' , total, ' ',actual.stock_actual) ; 
		end; 
		
		if (total> max) then begin
			max:= total; 
			maxMoto:=aux; 
			writeln('actualizacion: ' , total, ' ',actual.stock_actual) ; 
		end;
		
		read(mae, actual);
		while (aux.codigo <> actual.codigo) do 
			read(mae, actual); 
		
		
		seek(mae, filepos(mae)-1);
		actual.codigo:= actual.codigo -total; 
		write(mae, actual); 
		writeln('ya escribi en mae'); 
		
	end; 
	for i:= 1 to dimF do 
		close(vec_det[i]);
	
	close(mae); 
	writeln('la moto mas vendida fue la moto con codigo: ', maxMoto.codigo); 
		
	
end;
procedure exportarAtxt (var mae:archivo_maestro; var maeTxt:Text);
var
	mot: moto; 
begin
	reset (mae); 
	rewrite(maeTxt); 
	assign(maeTxt, 'maestro.txt'); 
	while (not eof(mae)) do begin 
		read(mae, mot); 
		writeln(maeTxt, mot.codigo); 
		writeln(maeTxt, mot.nombre); 
		writeln(maeTxt, mot.descripcion); 
		writeln(maeTxt, mot.modelo); 
		writeln(maeTxt, mot.marca); 
		writeln(maeTxt, mot.stock_actual); 
	end; 
	close(mae);
	close(maeTxt); 	
end;
{programa principal}
var
	maeTxt: Text; 
	maeDat: archivo_maestro; 
	vecDetalles:vectorDetalleSEmpleados;
	vec_motos: vector_motos; 

	
begin
	//recupero la informacion del txt para sobreescribir lo necesario (puede haber motos que no hayan sido vendidas, entonces NO las modifico)
	Assign (maeTxt, 'maestro.txt');
	Assign (maeDat, 'maestro.dat');
	importarMaestro(maeTxt, maeDat);
	importarDetalles(vecDetalles, vec_motos); 
	//genero un maestro pero solo piso lo nuevo
	merge(maeDat, vecDetalles, vec_motos); 
	exportarAtxt(maeDat, maeTxt); 
end.
