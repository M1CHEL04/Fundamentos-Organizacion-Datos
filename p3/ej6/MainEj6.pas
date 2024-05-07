program ej6;
const
	valor_alto= 9999;
type
	prenda=record
		cod:integer;
		desc:string;
		color:string;
		tipo:string;
		stock:integer;
		precio:real;
	end;
	archivo_prendas= file of prenda;

procedure leer_prenda (var p: prenda);
begin
	writeln('Ingrese el codigo de prenda');
	readln(p.cod);
	if(p.cod <> -1 )then begin
		writeln('Ingrese el tipo de prenda');
		readln(p.tipo);
		writeln('Ingrese la descripcion de la prenda');
		readln(p.desc);
		writeln('Ingrese el color de la prenda');
		readln(p.color);
		writeln('Ingrese el stock de la prenda');
		readln(p.stock);
		writeln('Ingrese el precio unitario de la prenda');
		readln(p.precio);
	end;
end;

procedure cargar_archivo (var archivo: archivo_prendas; path: string);
var
	p:prenda;
begin
	assign(archivo,path);
	rewrite(archivo);
	writeln('Para finalizar ingrese la prenda con codigo -1');
	leer_prenda(p);
	while(p.cod <> -1)do begin
		write(archivo,p);
		leer_prenda(p);
	end;
	close(archivo);
end;

procedure leer_archivo (var archivo: archivo_prendas; var p: prenda);
begin
	if(not EOF (archivo))then
		read(archivo,p)
	else
		p.cod:=valor_alto;
end;

procedure bajas_maestro (var mae: archivo_prendas; var det: archivo_prendas);
var
	reg_mae,reg_det:prenda;
begin
	assign(mae,'maestro_prendas.dat');
	reset(mae);
	assign(det,'detalle_prendas.dat');
	reset(det);
	leer_archivo(det,reg_det);
	while (reg_det.cod <> valor_alto) do begin
		leer_archivo(mae,reg_mae);
		//asumo que el codigo que se almacena en el detalle esta en el maestro
		while (reg_mae.cod <> reg_det.cod)do 
			leer_archivo(mae,reg_mae);
		//hago la baja logica
		reg_mae.stock:= reg_mae.stock *-1;
		seek(mae,FilePos(mae)-1);
		write(mae,reg_mae);
		//me posiciono de nuevo en el inicio del maestro
		seek(mae,0);
		//leeo un nuevo registro del detalle
		leer_archivo(det,reg_det);
	end;
	close(mae);
	close(det);
end;

procedure efectivizar_bajas (var maestro: archivo_prendas; var nuevo_maestro: archivo_prendas);
var
	p:prenda;
begin
	assign(maestro,'maestro_prendas.dat');
	reset(maestro);
	assign(nuevo_maestro,'nuevo_maestro_prendas.dat');
	rewrite(nuevo_maestro);
	leer_archivo(maestro,p);
	while (p.cod <> valor_alto)do begin
		if(p.stock > 0)then 
			write(nuevo_maestro,p);
		leer_archivo(maestro,p);
	end;
	writeln('Se han efectivizado correctamente las bajas');
	close(maestro);
	close(nuevo_maestro);
end;

procedure imprimir_archivo (var archivo: archivo_prendas; path: string);
var
	p:prenda;
begin
	assign(archivo,path);
	reset(archivo);
	leer_archivo(archivo,p);
	while(p.cod <> valor_alto) do begin
		writeln('Codigo: ',p.cod,', Tipo: ',p.tipo,', Stock: ',p.stock);
		leer_archivo(archivo,p);
	end;
	close(archivo);
end;

var
	maestro, nuevo_maestro, detalle: archivo_prendas;
begin
	//creo el maestro de prendas actuales;
	writeln('A continuacion se creara el archivo con las prendas actuales');
	cargar_archivo(maestro,'maestro_prendas.dat');
	writeln('El maestro con prendas actuales se ha cargado correctamente. Y es el siguiente: ');
	imprimir_archivo(maestro,'maestro_prendas.dat');
	//creo el detalle con las prendas desactualizadas;
	writeln('A continuacion se crear el archivo con las prendas fuera de temporada');
	cargar_archivo(detalle,'detalle_prendas.dat');
	writeln('El detalle con prendas desactualizadas se ha creado correctamente. Y es el siguiente');
	imprimir_archivo(detalle,'detalle_prendas.dat');
	//hago las bajas de prendas desactualizadas sobre el maestro
	bajas_maestro(maestro,detalle);
	writeln('El maestro con las bajas sin efectivizar es:');
	imprimir_archivo(maestro,'maestro_prendas.dat');
	//efectivizo las bajas en el maestro
	efectivizar_bajas(maestro,nuevo_maestro);
	writeln('El nuevo maestro es el siguiente:');
	imprimir_archivo(nuevo_maestro,'nuevo_maestro_prendas.dat');
end.
