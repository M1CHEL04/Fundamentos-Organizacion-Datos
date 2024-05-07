program ej2;
const
	valor_alto= 9999;
type
	asistente= record
		nro_asistente:integer;
		apellido: string;
		nombre: string;
		email: string;
		telefono: integer;
		dni: integer;
	end;
	file_asistente= file of asistente;
procedure lectura_asistente (var a: asistente);
begin
	writeln('Ingrese el numero de asistente');
	readln(a.nro_asistente);
	if(a.nro_asistente <> -1) then begin
		writeln('Ingrese el apellido');
		readln(a.apellido);
		writeln('Ingrese el nombre');
		readln(a.nombre);
		writeln('Ingrese el email');
		readln(a.email);
		writeln('Ingrese el telefono');
		readln(a.telefono);
		writeln('Ingrese el dni');
		readln(a.dni);
	end; 
end;

procedure cargar_archivo (var archivo: file_asistente);
var
	a:asistente;
begin
	assign (archivo,'archivo_asistentes.dat');
	rewrite(archivo);
	lectura_asistente(a);
	while(a.nro_asistente <> -1)do begin
		write(archivo,a);
		lectura_asistente(a);
	end;
	close(archivo);
end;

procedure leer_archivo (var archivo: file_asistente; var a:asistente);
begin
	if(not EOF(archivo))then
		read(archivo,a)
	else
		a.dni:= valor_alto;
end;

procedure baja_logica (var archivo: file_asistente);
var
	a:asistente;
begin
	assign(archivo,'archivo_asistentes.dat');
	reset(archivo);
	writeln('A continuacion se hara una baja logica de todos los asistente con numero de asistente mayor a 1000');
	leer_archivo(archivo,a);
	while(a.dni <> valor_alto) do begin
		if (a.nro_asistente > 1000) then begin
			a.apellido:= '***';
			a.nombre:= '***';
			seek(archivo,filepos(archivo)-1);
			write(archivo,a);
		end;
		leer_archivo(archivo,a);
	end;
	close(archivo);
	writeln('Las bajas se han realizado correctamente');
end;

procedure imprimir_archivo (var archivo: file_asistente);
var
	a:asistente;
begin
	assign(archivo,'archivo_asistentes.dat');
	reset(archivo);
	leer_archivo(archivo,a);
	while(a.dni <> valor_alto) do begin
		writeln('nro asistente: ', a.nro_asistente, ', Apelldio y nombre :', a.apellido,', ',a.nombre);
		leer_archivo(archivo,a);
	end;
	close(archivo);
end;

var
	archivo: file_asistente;
begin
	cargar_archivo(archivo);
	imprimir_archivo(archivo);
	baja_logica(archivo);
	imprimir_archivo(archivo);
end.
