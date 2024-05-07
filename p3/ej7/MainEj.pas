program ej7;
const
	valor_alto=9999;
type
	ave= record
		cod:integer;
		nombre:string;
		familia:string;
		desc:string;
		zona_geografica:string;
	end;
	archivo_aves=file of ave;
	archivo_codes= file of integer;

procedure leer_ave (var a: ave);
begin
	writeln('Ingrese el codigo de ave');
	readln(a.cod);
	if(a.cod <> -1)then begin
		writeln('Ingrese el nombre');
		readln(a.nombre);
		writeln('Ingrese el nombre de la familia');
		readln(a.familia);
		writeln('Ingrese la descripcion');
		readln(a.desc);
		writeln('Ingrese la zona geografica');
		readln(a.zona_geografica);
	end;
end;

procedure leer_archivo_aves (var archivo: archivo_aves; var a: ave);
begin
	if (not EOF(archivo))then
		read(archivo,a)
	else
		a.cod:=valor_alto;
end;

procedure leer_archivo_bajas (var archivo: archivo_codes; var code: integer);
begin
	if(not EOF(archivo))then
		read(archivo,code)
	else
		code:=valor_alto;
end;

procedure cargar_archivo_aves (var archivo: archivo_aves);
var
	a: ave;
begin
	assign(archivo,'archivo_aves.dat');
	rewrite(archivo);
	writeln('Para finalizar la carga ingrese el codigo -1');
	leer_ave(a);
	while(a.cod <> -1) do begin
		write(archivo, a);
		writeln('Para finalizar la carga ingrese el codigo -1');
		leer_ave(a);
	end;
	writeln('Archivo cargado con exito');
	close(archivo);
end;

procedure cargar_archivo_bajas (var archivo: archivo_codes);
var
	code: integer;
begin
	assign(archivo,'bajas.dat');
	rewrite(archivo);
	writeln('Para finalizar la carga ingrese el codigo -1');
	writeln('Ingrese el codigo del ave que se desea eleminar');
	readln(code);
	while(code <> -1)do begin
		write(archivo,code);
		writeln('Para finalizar la carga ingrese el codigo -1');
		writeln('Ingrese el codigo del ave que se desea eleminar');
		readln(code);
	end;
	writeln('Archivo cargado con exito');
	close(archivo);
end;

procedure bajas_logicas (var maestro: archivo_aves; var bajas: archivo_codes);
var
	a: ave;
	cod:integer;
begin
	assign(maestro,'archivo_aves.dat');
	reset(maestro);
	assign(bajas,'bajas.dat');
	reset(bajas);
	leer_archivo_bajas(bajas,cod);
	while(cod <> valor_alto)do begin
		leer_archivo_aves(maestro,a);
		//asumo que el codigo de ave que se desea elmimar esta en el archivo de aves
		while(a.cod <> cod) do
			leer_archivo_aves(maestro,a);
		//hago la baja logica
		a.nombre:='***';
		seek(maestro,FilePos(maestro)-1);
		write(maestro,a);
		//me posiciono de nuevo en el comienzo del archivo de aves
		seek(maestro,0);
		//leeo un nuevo codigo ave para borrar
		leer_archivo_bajas(bajas,cod);
	end;
	writeln('Se han borrado correctamente las aves indicadas');
	close(maestro);
	close(bajas);
end;

procedure imprimir_archivo_aves (var archivo: archivo_aves; path:string);
var
	a: ave;
begin
	assign(archivo,path);
	reset(archivo);
	leer_archivo_aves(archivo,a);
	while(a.cod <> valor_alto)do begin
		writeln('Codigo: ',a.cod,', Nombre: ',a.nombre);
		leer_archivo_aves(archivo,a);
	end;
	close(archivo);
end;

procedure imprimir_archivo_bajas (var archivo: archivo_codes);
var
	code: integer;
begin
	assign(archivo,'bajas.dat');
	reset(archivo);
	leer_archivo_bajas(archivo,code);
	while (code <> valor_alto) do begin
		writeln('Codigo de ave a elimnar: ',code);
		leer_archivo_bajas(archivo,code);
	end;
	close(archivo);
end;

procedure baja_fisica (var maestro: archivo_aves; var maestro_nuevo: archivo_aves);
var
	a: ave;
	cant,i,pos: integer;
begin
	assign (maestro,'archivo_aves.dat');
	reset(maestro);
	leer_archivo_aves(maestro,a);
	cant:=0;
	while(a.cod <> valor_alto)do begin
		if (a.nombre = '***')then begin
			//poscion donde se hizo la baja
			pos:=FilePos(maestro)-1;
			//sumo la cantidad de bajas
			cant:= cant+1;
			//me posiciono en el ultimo registro valido y leo su informacion
			seek(maestro,FileSize(maestro)-cant);
			read(maestro,a);
			//me posiciono en la poscion que se va a hacer la baja fisica y escribo el registro que lei anteriormente
			seek(maestro,pos);
			write(maestro,a);
		end;
		leer_archivo_aves(maestro,a);
	end;
	//pongo en el incio el archivo maestro
	seek(maestro,0);
	//creo el nuevo archivo maestro
	assign(maestro_nuevo,'nuevo_archivo_aves.dat');
	rewrite(maestro_nuevo);
	for i:= 1 to (FileSize(maestro)-cant)do begin
		read(maestro,a);
		write(maestro_nuevo,a);
	end;
	close(maestro);
	close(maestro_nuevo);	
end;

var
	maestro,nuevo_maestro: archivo_aves;
	bajas: archivo_codes;
begin
	//creo el archivo con la informacion de las aves
	writeln('A continuacion se cargara el archivo con todas las aves');
	cargar_archivo_aves(maestro);
	imprimir_archivo_aves(maestro,'archivo_aves.dat');
	//creo el archivo con los codigos de aves a elimar
	writeln('A continuacion se cargara el archivo con los codigos de las aves que se desea eliminar');
	cargar_archivo_bajas(bajas);
	imprimir_archivo_bajas(bajas);
	//realizo las bajas logicas de las aves indicadas
	bajas_logicas(maestro,bajas);
	imprimir_archivo_aves(maestro,'archivo_aves.dat');
	//realizo las bajas definitivas del archivo
	baja_fisica(maestro,nuevo_maestro);
	writeln('El archivo final es el siguiente');
	imprimir_archivo_aves(nuevo_maestro,'nuevo_archivo_aves.dat');
end.

