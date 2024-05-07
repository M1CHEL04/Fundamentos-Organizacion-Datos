program ej4_ej5 ;
const
	valor_alto=9999;
type
	reg_flor=record
		nombre: string;
		cod:integer;
	end;
	archivo_flores= file of reg_flor;

procedure leer_archivo (var archivo: archivo_flores; var f: reg_flor);
begin
	if(not EOF(archivo))then
		read(archivo,f)
	else
		f.cod:=valor_alto;
end;

procedure leer_flor (var f: reg_flor);
begin
	writeln('Ingrese el codigo de flor');
	readln(f.cod);
	if(f.cod <> -1)then begin
		writeln('Ingrese el nombre');
		readln(f.nombre);
	end;
end;

procedure agregar_flor (var archivo: archivo_flores; f: reg_flor);
var
	cabecera: reg_flor;
	index:integer;
begin
	assign(archivo,'archivo_flores.dat');
	reset(archivo);
	read(archivo,cabecera);
	if(cabecera.cod = 0) then begin
		seek(archivo,FileSize(archivo));
		write(archivo,f);
	end
	else begin
		//convierto el indice negativo a positivo
		index:= cabecera.cod * -1;
		//me posicione en el indice dado
		seek(archivo,index);
		//lee el contenido de dicho indice para luego poder escribir su info en la pos 0
		read(archivo,cabecera);
		//Me vuelvo a posicionar para poder escribir y escribo el nuevo contenido
		seek(archivo,filepos(archivo)-1);
		write(archivo,f);
		//me posiciono en el inicio y agrego el codigo de novela que estaba en el lugar que sobreescribi.
		seek(archivo,0);
		write(archivo,cabecera);
	end;
	close(archivo);
end;

procedure cargar_archivo (var archivo: archivo_flores);
var
	f: reg_flor;
begin
	assign(archivo,'archivo_flores.dat');
	rewrite(archivo);
	//escribo la cabecera del archivo
	f.cod:=0;
	f.nombre:=' ';
	write(archivo,f);
	close(archivo);
	//realizo la carga del archvio.
	writeln('Para finalizar la carga ingrese el codigo de flor -1');
	leer_flor(f);
	while(f.cod <> -1)do begin
		agregar_flor(archivo,f);
		writeln('Para finalizar la carga ingrese el codigo de flor -1');
		leer_flor(f);
	end;
end;

procedure imprimir_archivo (var archivo: archivo_flores);
var
	f:reg_flor;
begin
	assign(archivo,'archivo_flores.dat');
	reset(archivo);
	leer_archivo(archivo,f);
	while(f.cod <> valor_alto)do begin
		if (f.nombre <> '***')then
			writeln('Codigo: ',f.cod,', Nombre: ',f.nombre);
		leer_archivo(archivo,f);
	end;
	close(archivo);
end;


//Este modulo es parte del ejercicio 5
procedure eliminar_flor (var archivo: archivo_flores; flor_eliminar: reg_flor);
var
	f,cabecera,cabecera_nueva: reg_flor;
	encontre:boolean;
	index:integer;
begin
	assign(archivo,'archivo_flores.dat');
	reset(archivo);
	encontre:=false;
	leer_archivo(archivo,f);
	while ((f.cod <> valor_alto) and (not encontre))do begin
		if (f.cod = flor_eliminar.cod)then begin
			//cambio el valor del boolean
			encontre:= true;
			//me gauardo el indice para poder escribirlo luego
			index:= (FilePos(archivo) -1 );
			//cambio los datos de la nueva cabecera;
			seek(archivo,0);
			read(archivo,cabecera);
			seek(archivo,0);
			cabecera_nueva:=cabecera;
			cabecera_nueva.cod:= index * -1;
			write(archivo,cabecera_nueva);
			seek(archivo,index);
			cabecera.nombre:= '***';
			write(archivo,cabecera);
		end;
		leer_archivo(archivo,f);
	end;
	if(encontre)then
		writeln('La flor ingresada se ha borrado correctamente')
	else
		writeln('No se ha encontrado en el archivo la flor ingresada');
	close(archivo);
end;

var
	archivo: archivo_flores;
	f: reg_flor;
begin
	cargar_archivo(archivo);
	imprimir_archivo(archivo);
	writeln('Ingrese una flor que se desee eliminar');
	leer_flor(f);
	eliminar_flor(archivo,f);
	imprimir_archivo(archivo);
	writeln('Ingrese una nueva flor para agregar al archivo');
	leer_flor(f);
	agregar_flor(archivo,f);
	imprimir_archivo(archivo);
end.
