program parte_2_ej1;
const
	valor_alto=9999;
type
	producto=record
		cod:integer;
		nombre:string;
		precio:real;
		stock:integer;
		stock_min:integer;
	end;
	
	venta= record
		cod:integer;
		ventas:integer;
	end;
	
	archivo_productos= file of producto;
	
	archivo_ventas= file of venta;
	
procedure leer_producto (var p: producto);
begin
	writeln('Ingrese el codigo de producto');
	readln(p.cod);
	if(p.cod <> -1)then begin
		writeln('Ingrese el nombre');
		readln(p.nombre);
		writeln('Ingrese el precio');
		readln(p.precio);
		writeln('Ingrese el stock');
		readln(p.stock);
		writeln('Ingrese el stock minimo');
		readln(p.stock_min);
	end;
end;

procedure leer_venta (var v: venta);
begin
	writeln('Ingrese el codigo del producto');
	readln(v.cod);
	if(v.cod <> -1)then begin
		writeln('Ingrese la cantidad de unidades vendidas');
		readln(v.ventas);
	end;
end;

procedure cargar_maestro (var maestro: archivo_productos);
var
	p:producto;
begin
	assign(maestro,'maestro.dat');
	rewrite(maestro);
	writeln('Para finalizar la carga ingrese el codigo -1');
	leer_producto(p);
	while(p.cod <> -1)do begin
		write(maestro,p);
		writeln('Para finalizar la carga ingrese el codigo -1');
		leer_producto(p);
	end;
	writeln('El archivo maestro se ha cargado con exito');
	close(maestro);
end;

procedure cagar_detalle (var detalle: archivo_ventas);
var
	v: venta;
begin
	assign(detalle,'detalle.dat');
	rewrite(detalle);
	writeln('Para finalizar la carga ingrese el codigo -1');
	leer_venta(v);
	while(v.cod <> -1)do begin
		write(detalle,v);
		writeln('Para finalizar la carga ingrese el codigo -1');
		leer_venta(v);
	end;
	writeln('El archivo detalle se ha cargado con exito');
	close(detalle);
end;

procedure leer_maestro (var archivo: archivo_productos; var p: producto);
begin
	if ( not EOF(archivo))then
		read(archivo,p)
	else
		p.cod:=valor_alto;
end;

procedure leer_detalle (var archivo: archivo_ventas; var v: venta);
begin
	if( not EOF(archivo))then
		read(archivo,v)
	else
		v.cod:=valor_alto;
end;

procedure imprimir_maestro (var archivo: archivo_productos);
var
	p: producto;
begin
	assign(archivo,'maestro.dat');
	reset(archivo);
	leer_maestro(archivo,p);
	while(p.cod <> valor_alto) do begin
		writeln('Cod: ',p.cod,', Nombre: ',p.nombre,', stock: ',p.stock,', stock minimo: ',p.stock_min);
		leer_maestro(archivo,p);
	end;
	close(archivo);
end;

procedure imprimir_detalle(var archivo: archivo_ventas);
var
	v: venta;
begin
	assign(archivo,'detalle.dat');
	reset(archivo);
	leer_detalle(archivo,v);
	while (v.cod <> valor_alto)do begin
		writeln('Cod: ', v.cod,', unidades vendidas: ',v.ventas);
		leer_detalle(archivo,v);
	end;
	close(archivo);
end;

procedure act_maestro (var mae:archivo_productos; var det:archivo_ventas);
var
	p:producto;
	v:venta;
begin
	assign(mae,'maestro.dat');
	reset(mae);
	assign(det,'detalle.dat');
	reset(det);
	leer_detalle(det,v);
	while(v.cod <> valor_alto)do begin
		leer_maestro(mae,p);
		//asumo que el codigo almacenado en el detalle esta en el maestro.
		while(v.cod <> p.cod)do 
			leer_maestro(mae,p);
		p.stock:= p.stock - v.ventas;
		seek(mae,FilePos(mae)-1);
		write(mae,p);
		seek(mae,0);
		leer_detalle(det,v);
	end;
	writeln('Se ha actualizado correctamente el archivo maestro');
	close(mae);
	close(det);
end;

var
	maestro: archivo_productos;
	detalle: archivo_ventas;
begin
	writeln('A continuacion se cargara el archivo maestro');
	cargar_maestro(maestro);
	writeln('A continuacion se cargara el archivo detalle');
	cagar_detalle(detalle);
	writeln('El archivo maestro es el siguiente');
	imprimir_maestro(maestro);
	writeln('El archivo detalle es el siguiente');
	imprimir_detalle(detalle);
	writeln('A continuacion se actualizara el archivo maestro con los datos del archivo detalle');
	act_maestro(maestro,detalle);
	writeln('El archivo maestro actualizado es: ');
	imprimir_maestro(maestro);
end.

