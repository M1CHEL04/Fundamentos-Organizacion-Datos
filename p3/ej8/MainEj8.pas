program ej8;
const
	valor_alto=9999;
type
	linux=record
		nombre:string;
		ano:integer;
		version:integer;
		cant_desarrolladores:integer;
		desc:string;
	end;
	archivo_distribuciones= file of linux;

procedure leer_linux (var l: linux);
begin
	writeln('Ingrese la version de la distribucion');
	readln(l.version);
	if(l.version <> -1)then begin
		writeln('Ingrese el nombre de la distribucion');
		readln(l.nombre);
		l.ano:=0;
		l.cant_desarrolladores:=0;
		l.desc:=' ';
	end;
end;

procedure agregar_distribucion (var archivo: archivo_distribuciones; l:linux);
var
	cabecera:linux;
	index:integer;
begin
	assign(archivo,'distribuciones.dat');
	reset(archivo);
	read(archivo,cabecera);
	if(cabecera.version = 0)then begin
		seek(archivo,FileSize(archivo));
		write(archivo,l);
	end
	else begin
		index:=cabecera.version * -1;
		seek(archivo,index);
		read(archivo,cabecera);
		seek(archivo,index);
		write(archivo,l);
		seek(archivo,0);
		write(archivo,cabecera);
	end;
	close(archivo);
end;

procedure cargar_archivo (var archivo: archivo_distribuciones);
var
	l:linux;
begin
	assign(archivo,'distribuciones.dat');
	rewrite(archivo);
	l.version:=0;
	l.nombre:=' ';
	l.ano:=0;
	l.desc:=' ';
	l.cant_desarrolladores:=0;
	write(archivo,l);
	close(archivo);
	
	writeln('Para finalizar la carga del archivo, ingrese la version -1');
	leer_linux(l);
	while(l.version <> -1)do begin
		agregar_distribucion(archivo,l);
		writeln('Para finalizar la carga del archivo, ingrese la version -1');
		leer_linux(l);
	end;
	writeln('El archivo se ha cargado correctamente');
end;

procedure leer_archivo (var archivo: archivo_distribuciones; var l: linux);
begin
	if(not EOF(archivo))then
		read(archivo,l)
	else
		l.version:=valor_alto;
end;

procedure imprimir_archivo (var archivo: archivo_distribuciones);
var
	l: linux;
begin
	assign(archivo,'distribuciones.dat');
	reset(archivo);
	leer_archivo(archivo,l);
	while(l.version <> valor_alto)do begin
		writeln('Nombre: ',l.nombre,', Version: ',l.version);
		leer_archivo(archivo,l);
	end;
	close(archivo);
end;

procedure buscar_distribucion (var archivo: archivo_distribuciones; var encontre: boolean; nombre: string);
var
	l:linux;
begin
	assign(archivo,'distribuciones.dat');
	reset(archivo);
	encontre:=false;
	leer_archivo(archivo,l);
	while ((l.version <> valor_alto) and (not encontre))do begin
		if(l.nombre = nombre)then
			encontre:=true;
		leer_archivo(archivo,l);
	end;
	close(archivo);
end;

procedure ExisteDistribucion (var archivo: archivo_distribuciones);
var
	nombre: string;
	encontre: boolean;
begin
	writeln('Ingrese el nombre de la distribucion que desea saber si se encuentra en el archivo');
	readln(nombre);
	buscar_distribucion(archivo,encontre,nombre);
	if(encontre)then
		writeln('La distribucion ingresada se encuentra en el archivo')
	else
		writeln('La distribucion ingresada no se encuentra en el archivo');
end;

procedure AltaDistribucion (var archivo: archivo_distribuciones);
var
	encontre:boolean;
	l:linux;
begin
	writeln('Ingrese los datos de la distribucion que se desea agregar');
	leer_linux(l);
	//busco si la distribucion ingresada esta en el archivo;
	buscar_distribucion(archivo,encontre,l.nombre);
	if(encontre)then
		writeln('La distribucion ingresada ya se encuentra en el archivo')
	else begin
		agregar_distribucion(archivo,l);
		writeln('Distribucion agregada con exito');
	end;
end;

procedure baja_logica (var archivo: archivo_distribuciones; nombre_baja: string);
var
	l,cabecera,nueva_cabecera: linux;
	index:integer;
begin
	assign(archivo,'distribuciones.dat');
	reset(archivo);
	leer_archivo(archivo,l);
	while(l.nombre <> nombre_baja) do begin
		leer_archivo(archivo,l);
	end;
	index:= FilePos(archivo) -1;
	//me quedo con la cabecera
	seek(archivo,0);
	read(archivo,cabecera);
	// me poscisiono en el principio y modifico la  nueva cabecera
	seek(archivo,0);
	nueva_cabecera:= cabecera;
	nueva_cabecera.version:= index * -1;
	write(archivo,nueva_cabecera);
	//me pocisiono en el archivo a borrar y realizo la baja
	seek(archivo,index);
	cabecera.nombre:= '***';
	write(archivo,cabecera);
	close(archivo);
end;

procedure BajaDistribucion(var archivo: archivo_distribuciones);
var
	nombre_baja:string;
	encontre:boolean;
begin
	writeln('Ingrese el nombre de la distribucion que se desea eliminar');
	readln(nombre_baja);
	
	buscar_distribucion(archivo,encontre,nombre_baja);
	
	if(encontre)then begin
		baja_logica(archivo,nombre_baja);
		writeln('La baja se ha completado con exito');
	end
	else
		writeln('No se ha encontrado la distribucion que desea eliminar');
end;

var
	archivo: archivo_distribuciones;
begin
	cargar_archivo(archivo);
	imprimir_archivo(archivo);
	//se busca una distribucion dada;
	ExisteDistribucion(archivo);
	//se agrega una distribucion
	AltaDistribucion(archivo);
	//imprimo el archivo
	imprimir_archivo(archivo);
	//doy de baja una distribucion
	BajaDistribucion(archivo);
	//imprimo el archivo
	imprimir_archivo(archivo);
	//agrego nueva distribucion
	AltaDistribucion(archivo);
	//imprimo el archivo
	imprimir_archivo(archivo);
end.
