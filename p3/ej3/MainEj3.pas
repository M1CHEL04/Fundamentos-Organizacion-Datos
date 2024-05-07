program ej3;
const
	valor_alto= 9999;
type
	novela=record
		cod:integer;
		genero:string;
		nombre:string;
		duracion:integer;
		director:string;
		precio:real;
	end;
	archivo_novelas= file of novela;

procedure leer_novela (var n: novela);
begin
	writeln('Ingrese el codigo de novela');
	readln(n.cod);
	if(n.cod <> -1)then begin
		writeln('Ingrese el genero');
		readln(n.genero);
		writeln('Ingrese el nombre');
		readln(n.nombre);
		writeln('Ingrese la duracion');
		readln(n.duracion);
		writeln('Ingrese el nombre del director');
		readln(n.director);
		writeln('Ingrese el precio');
		readln(n.precio);
	end;
end;

procedure leer_archivo (var archivo: archivo_novelas; var n: novela);
begin
	if (not EOF(archivo))then
		read(archivo,n)
	else
		n.cod:=valor_alto;
end;

procedure agregar_lista_invertida (var archivo: archivo_novelas; n: novela);
var
	aux:novela;
	index:integer;
begin
	assign(archivo,'archivo_novelas.dat');
	reset(archivo);
	read(archivo,aux);
	if(aux.cod = 0)then begin
		Seek(archivo,FileSize(archivo));
		write(archivo,n);
	end
	else begin
		//convierto el indice negativo a positivo
		index:=aux.cod * -1;
		//me posicione en el indice dado
		seek(archivo,index);
		//lee el contenido de dicho indice para luego poder escribir su info en la pos 0
		read(archivo,aux);
		//Me vuelvo a posicionar para poder escribir y escribo el nuevo contenido
		seek(archivo,filepos(archivo)-1);
		write(archivo,n);
		//me posiciono en el inicio y agrego el codigo de novela que estaba en el lugar que sobreescribi.
		seek(archivo,0);
		write(archivo,aux);
	end;
	close(archivo);
end;

procedure cargar_archivo (var archivo: archivo_novelas);
var
	n:novela;
begin
	assign(archivo,'archivo_novelas.dat');
	rewrite(archivo);
	//agrego el primer elemento (cabecera de la lista invertida)
	n.cod:=0;
	n.genero:=' ';
	n.nombre:=' ';
	n.duracion:=0;
	n.director:=' ';
	n.precio:=0.0;
	write(archivo,n);
	close(archivo);
	//cargo el archivo con el metodo de lista invertida
	leer_novela(n);
	while(n.cod <> -1) do begin
		agregar_lista_invertida(archivo,n);
		leer_novela(n);
	end;
	writeln('El archivo se ha cargado correctamente');
end;

procedure mod_novela_private (var archivo: archivo_novelas; n_mod: novela);
var
	aux:novela;
	encontre: boolean;
begin
	assign(archivo,'archivo_novelas.dat');
	reset(archivo);
	encontre:= false;
	leer_archivo(archivo,aux);
	while ((aux.cod <> valor_alto) and (not encontre)) do begin
		if(aux.cod = n_mod.cod) then begin
			seek(archivo,filepos(archivo)-1);
			write(archivo,n_mod);
			encontre:=true;
		end; 
		leer_archivo(archivo,aux);
	end;
	if(encontre)then
		writeln('Se ha modificado correctamente el contenido de la novela')
	else
		writeln('No se ha encontrado el codigo de novela en el archivo');
	close(archivo);
end;

procedure mod_novela (var archivo: archivo_novelas);
var
	n_mod:novela;
begin
	writeln('Ingrese los datos de la novela a modificar. El codigo debe ser el mismo');
	leer_novela(n_mod);
	mod_novela_private(archivo,n_mod);
end;

procedure baja_logica_private (var archivo: archivo_novelas; cod_buscado: integer);
var
	aux,cabecera,nueva_cabecera: novela;
	encontre:boolean;
	index:integer;
begin
	assign(archivo,'archivo_novelas.dat');
	reset(archivo);
	encontre:=false;
	leer_archivo(archivo,aux);
	while ((aux.cod <> valor_alto) and (not encontre))do begin
		if(aux.cod = cod_buscado) then begin
			//cambio el valor del booleano
			encontre:=true;
			//me guardo el indice para luego sobreescribirlo
			index:= (filepos(archivo) - 1) * -1;
			//cambio los datos de la nueva cabecera
			seek(archivo,0);
			read(archivo,cabecera);
			seek(archivo,0);
			nueva_cabecera:=cabecera;
			nueva_cabecera.cod:=index;
			write(archivo,nueva_cabecera);
			seek(archivo,(index * -1));
			write(archivo,cabecera);
		end;
		leer_archivo(archivo,aux);
	end;
	if(encontre)then
		writeln('La novela ingresada se ha borrado correctamente')
	else
		writeln('No se ha encontrado una novela con el codigo ingresado');
	close(archivo);
end;

procedure baja_logica (var archivo: archivo_novelas);
var
	cod_buscar:integer;
begin
	writeln('Ingrese el codigo de novela que desea eliminar');
	readln(cod_buscar);
	baja_logica_private(archivo,cod_buscar);
end;

procedure add_nueva_novela (var archivo: archivo_novelas);
var
	n: novela;
begin
	writeln('A continuacion se le solcitara ingresar los datos de la novela que desea agregar');
	leer_novela(n);
	agregar_lista_invertida(archivo,n);
end;

procedure imprimir_archivo (var archivo: archivo_novelas);
var
	aux:novela;
begin
	assign(archivo,'archivo_novelas.dat');
	reset(archivo);
	leer_archivo(archivo,aux);
	while(aux.cod <> valor_alto) do begin
		writeln('Nombre: ',aux.nombre,', Genero: ',aux.genero,', Codigo: ',aux.cod);
		leer_archivo(archivo,aux);
	end;
	close(archivo);
end;

 
procedure create_archivo_txt (var archivo: archivo_novelas);
var
	aux: novela;
	txt:text;
begin
	assign(archivo,'archivo_novelas.dat');
	reset(archivo);
	assign(txt,'novelas.txt');
	rewrite(txt);
	leer_archivo(archivo,aux);
	while(aux.cod <> valor_alto) do begin
		writeln(txt,aux. cod,' ',aux.nombre);
		writeln(txt,aux.genero);
		leer_archivo(archivo,aux);
	end;
	writeln('El archivo de texto se ha creado con exito');
	close(archivo);
	close(txt);
end;
 
var
	archivo: archivo_novelas;
	check: boolean;
	option:integer;
begin
	check:= true;
	cargar_archivo(archivo);
	while(check)do begin
		writeln(' 1) Para listar en pantalla los datos de las novelas almacenadas marque 1');
		writeln(' 2) Para modificar los datos de una novela especifica marque 2');
		writeln(' 3) Para agregar una nueva novela marque 3');
		writeln(' 4) Para eliminar una novela especifica marque 4');
		writeln(' 5) Para crear un archivo de texto con el contenido de todo el archivo binario marque 5');
		writeln(' 6) Para finalizar marque 6');
		readln(option);
		case option of
			1: imprimir_archivo(archivo);
			
			2: mod_novela(archivo);
			
			3: add_nueva_novela(archivo);
			
			4: baja_logica(archivo);
			
			5: create_archivo_txt(archivo);
			
			6: begin
				check:= false;
				writeln('Muchas gracias por su consulta');
			end;
		else
			writeln('Opcion no valida, ingrese una de las siguientes');
		end;
	end;
end.
