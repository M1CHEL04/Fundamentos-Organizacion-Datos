program ej7;
type
	novela= record
		codNovela: integer;
		precio: real;
		genero: string;
		nombre: string;
	end;
	archivo_novela= file of novela;
	
procedure impBinario (var arB: archivo_novela);
var
	arTxt: text;
	aux: novela;
begin
	assign(arTxt,'novelas.txt');
	reset (arTxt);
	rewrite(arB);
	while(not EOF(arTxt))do begin
		readln(arTxt,aux.codNovela,aux.precio,aux.genero);
		readln(arTxt,aux.nombre);
		write(arB,aux);
	end;
	close(arB);
	close(arTxt);
end;

procedure leer (var n:novela);
begin
	writeln('ingrese el codigo de la novela');
	readln(n.codNovela);
	writeln('Ingrese el precio de la novela');
	readln(n.precio);
	writeln('Ingrese el genero de la novela');
	readln(n.genero);
	writeln('Ingrese el nombre de la novela');
	readln(n.nombre);
end;

procedure addNovela (var arB: archivo_novela);
var
	aux: novela;
	
begin
	reset(arB);
	seek(arB,fileSize(arB));
	leer(aux);
	write(arB,aux);
	close(arB);
end;

procedure cambiarPrecio (var arB: archivo_novela; codBuscar: integer);
var
	aux:novela;
	precio:real;
	encontre: boolean;
begin
	encontre:=false;
	writeln('Ingrese el nuevo precio');
	readln(precio);
	reset(arB);
	while(not EOF (arB)and(not encontre))do begin
		read(arB,aux);
		if(aux.codNovela=codBuscar)then begin
			aux.precio:=precio;
			seek(arB,filePos(arB)-1);
			write(arB,aux);
			encontre:= true;
		end;
	end;
end;

procedure imprimir (var arB: archivo_novela);
var
	aux: novela;
begin
	reset(arB);
	while(not EOF (arB))do begin
		read(arB,aux);
		writeln('La novela es: ', aux.nombre,' y tiene un precio de: ',aux.precio);
	end;
end;	

var
	arB: archivo_novela;
begin
	assign(arB,'novelas.dat');
	impBinario(arB);
	addNovela(arB);
	imprimir(arB);
	cambiarPrecio(arB,12);
	imprimir(arB);
end.
