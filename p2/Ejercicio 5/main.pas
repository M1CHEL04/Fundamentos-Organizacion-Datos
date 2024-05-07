program ej5Main;
const
	valor_alto=9999
type
	rango= 1..30;
	prod=record
		codP:integer;
		nombre:string;
		desc:String;
		stockAct:integer;
		stockMin:integer;
		precio:real;
	end;
	ventas=record
		codP:integer;
		cantVendidas:integer;
	end;
	 file_maestro= file of prod;
	 file_detalle= file of ventas;
	 
	 //vector con archivos detalle
	 vect_file_detalle= array [rango] of file_detalle; 
	 
	 //vector con registros de ventas
	 vect_ventas= array[rango] of ventas;
	 
procedure leer (var ar: file_detalle; var aux: ventas);
begin
	if not EOF(ar)then
		read(ar,aux)
	else
		aux.codP:=valor_alto;
end;

procedure import_maestro(var mae: file_maestro);
var
	mae_txt:text;
	aux:prod;
begin
	assign(mae,'maestro.dat');
	rewtrite(mae);
	assign(mae_txt,'maestro.txt');
	reset(mae_txt);
	while(not EOF(mar_txt))do begin
		readln(mae_txt,aux.codP,aux.precio,aux.stockMin,aux.stockAct,aux.nombre);
		readln(mae_txt,aux.desc);
		write(mae,aux);
	end;
	writeln('Archivo maestro creado.');
	close(mae);
	close(mae_txt);
end;

procedure import_detalle (var det: file_detalle);
var
	aux:venta;
	path:string;
	det_txt:text;
begin
	writeln('Ingrese la ruta del archivo binario detalle');
	readln(path);
	assign(det,path);
	rewrite(det);
	
	writeln('Ingrese la ruta del archivo de texto detalle');
	readln(path);
	assign(det_txt,path);
	reset(det_txt);
	
	while(not EOF(det_txt))do begin
		readl(det_txt,aux.codP,aux.cantVendidas);
		write(det,aux);
	end;
	
	writeln('Archivo detalle cargado');
	close(det);
	close(det_txt);
end;

procedure cargar_vect_detalle(var vect: vect_file_detalle);
var
	i:integer;
begin
	for i:= 1 to 3 do 
		import_detalle(vect[i]);
end;
