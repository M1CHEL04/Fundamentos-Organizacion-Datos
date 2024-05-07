program main;
type
	empleado=record
		num:integer;
		apellido:string;
		nombre:string;
		edad:integer;
		dni:integer;
	end;
	file_empleados= file of empleado;

procedure lectura (var e: empleado);
begin
	writeln('Ingrese el apellido del empleado');
	readln(e.apellido);
	if(e.apellido <> 'fin')then begin
		writeln('Ingrese el nombre del empleado');
		readln(e.nombre);
		writeln('Ingrese el numero de empleado');
		readln(e.num);
		writeln('Ingrese la edad del empleado');
		readln(e.edad);
		writeln('Ingrese el DNI del empleado');
		readln(e.dni);
	end;
end; 

procedure cargar_archivo (var archivo: file_empleados);
var
	e: empleado;
begin
	assign(archivo,'file_empleados.dat');
	rewrite(archivo);
	lectura(e);
	while(e.apellido <> 'fin')do begin
		write(archivo,e);
		lectura(e);
	end;
	close(archivo);
end;

procedure buscar_empleado_especifico (var archivo: file_empleados; apellido_buscar: string);
var
	e: empleado;
begin
	assign(archivo,'file_empleados.dat');
	reset(archivo);
	while (not EOF(archivo))do begin
		read(archivo,e);
		if(e.apellido = apellido_buscar)then 
			writeln('El nombre del empleado es: ',e.nombre,' ',e.apellido, ' con ',e.edad,' anios de edad. DNI: ',e.dni);
	end;
	close(archivo);
end;

procedure listar_empleados (var archivo: file_empleados);
var
	e:empleado;
begin
	assign(archivo,'file_empleados.dat');
	reset(archivo);
	while(not EOF(archivo))do begin
		read(archivo,e);
		writeln('El nombre del empleado es: ',e.nombre,' ',e.apellido, ' con ',e.edad,' anios de edad. DNI: ',e.dni);
	end;
	close(archivo);
end;

procedure listar_mayor_70 (var archivo: file_empleados);
var
	e: empleado;
begin
	assign(archivo,'file_empleados.dat');
	reset(archivo);
	while(not EOF(archivo))do begin
		read(archivo,e);
		if(e.edad >= 70) then
			writeln('El nombre del empleado es: ',e.nombre,' ',e.apellido, ' con ',e.edad,' anios de edad. DNI: ',e.dni);
	end;
	close(archivo);
end;

procedure baja_logica (var archivo: file_empleados; num_buscar: integer; encontre:boolean);
var
	e: empleado;
begin
	assign(archivo,'file_empleados.dat');
	reset(archivo);
	encontre:=false;
	while((not EOF(archivo)) and (not encontre)) do begin
		read(archivo,e);
		if(e.num = num_buscar)then begin
			encontre:=true;
			e.apellido:='***';
			seek(archivo,filepos(archivo)-1);
			write(archivo,e);
		end;
	end;
	close(archivo);
end;

procedure baja_definitiva (var archivo:file_empleados);
var
	e: empleado;
	aux:empleado;
begin
	assign(archivo,'file_empleados.dat');
	reset(archivo);
	//Guardo en una variable el ultimo elemento del archivo
	seek(archivo,filesize(archivo)-1);
	read(archivo,aux);
	seek(archivo,0);
	read(archivo,e);
	while(e.apellido <> '***') do begin
		read(archivo,e);
	end;
	
end;

var
	archivo:file_empleados;
	check:boolean;
	opcion: integer;
	aux: string;
begin
	check:= true;
	cargar_archivo(archivo);
	while (check) do begin
		writeln(' 1) Para listar en pantalla los datos de un empleado especifico marque 1');
		writeln(' 2) Para listar todos los empleados de a uno marque 2');
		writeln(' 3) Para listar los empleados mayores a 70 anios marque 3');
		writeln(' 4) Para eliminar un empleado del archivo marque 4');
		writeln(' 5) Para finalizar marque 5');
		readln(opcion);
		case opcion of 
			1:begin
				writeln('Ingrese el apellido de el/los empleados que desea listar');
				readln(aux);
				buscar_empleado_especifico(archivo,aux);
			end;
			2:begin
				writeln('El listado de empleados de la empresa es el siguiente:');
				listar_empleados(archivo);
			end;
			3:begin
				writeln('Los empleados con 70 anios o mas son:');
				listar_mayor_70(archivo);
			end;
			4:begin
				
			end;
			5:begin
				writeln('Muchas gracias por su consulta');
				check:= false;
			end;
		else
			writeln('Opcion no valida, ingrese una de las siguientes');
		end;
	end;
end.
