{

Se desea procesar las pólizas de una compañía de seguros. De cada póliza se conoce: DNI del
cliente, suma asegurada, valor cuota y fecha de vencimiento. Un cliente puede tener más de una
póliza. Las pólizas se comenzaron a emitir a partir del 2000 y finalizaron de emitirse en 2023.
Realice un programa que contenga:

a) Un módulo que lea pólizas, hasta leer una póliza con DNI -1, y las almacene en una
estructura eficiente para la búsqueda por suma asegurada.
b) Un módulo que reciba la estructura generada en a) y devuelva otra estructura con las
pólizas cuya suma asegurada sea menor a un valor recibido por parámetro. Esta
estructura debe estar agrupada por año de vencimiento y ordenada por DNI de cliente.
c) Un módulo que reciba la estructura generada en b) y devuelva la cantidad de pólizas de
un cliente cuyo DNI se recibe por parámetro.

}

program parcialPolizas;

const
	hastaNum = -1;
	anioMin = 2000;
	anioMax = 2023;

type
	rangoAnios = anioMin..anioMax;
	fechas = record
		dia, mes : integer;
		anio : rangoAnios;
	end;
	
	poliza = record
		dniCliente : integer;
		sumaAsegurada : real;
		valorCuota : integer;
		vencimiento : fechas;
	end;
	
	arbol = ^nodoArbol;
	nodoArbol = record
		dato : poliza;
		HI : arbol;
		HD : arbol;
	end;
	
	lista = ^nodoLista;
	
	nodoLista = record
		dato : poliza;
		sig : lista;
	end;
	
	vector = array [rangoAnios] of lista;
	
	
	
procedure agregar (var a : arbol; p : poliza);
begin
	if a = nil then
		begin
			new(a);
			a^.dato := p;
			a^.HI := nil;
			a^.HD := nil;
		end
	else
		if a^.dato.sumaAsegurada <= p.sumaAsegurada then
			agregar(a^.HD, p)
		else
			agregar(a^.HI, p);
end;

procedure leerPoliza (var p :poliza);
begin
	write('ingree dni del cliente: '); readln(p.dniCliente);
	if (p.dniCliente <> hastaNum) then
		begin
			write('ingrese suma asegurada: ');readln(p.sumaAsegurada);
			write('ingrese valor de la cuota: ');readln(p.valorCuota);
			write('ingrese dia de vencimiento: ');readln(p.vencimiento.dia);
			write('ingrese mes de vencimiento: ');readln(p.vencimiento.mes);
			write('ingrese anio de vencimiento: ');readln(p.vencimiento.anio);
		end;
end;

	
procedure cargarArbol (var a : arbol);
var
	p : poliza; 
begin
	leerPoliza(p);
	while (p.dniCliente <> hastaNum) do
		begin
			agregar(a, p);
			leerPoliza(p);
		end;
end;




procedure incisoB (a : arbol; var v : vector ; valor : integer);
begin
	if a <> nil then 
		if a^.dato.sumaAsegurada < valor then
			begin
				agregarOrdenado(a^.dato, v[ a^.dato.vencimiento.anio]);
				incisoB(a^.HI, v, valor);
				incisoB(a^.HD, v, valor);
			end
		else
			incisoB(a^.HI, v, valor);
end;

procedure inicializarVector (var v : vector);
var
	i : rangoAnios;
begin
	for i := anioMin to anioMax do
		v[ i ] := nil;
end;




function recorrerLista (l : lista ; dni : integer) : integer;
var
	conteoDniIgual : integer;
begin
	conteoDniIgual := 0;
	
	while (l <> nil) and (l^.dato.dniCliente <= dni) do
		begin
			if l^.dato.dniCliente = dni then
				conteoDniIgual := conteoDniIgual + 1;
			l := l^.sig;
		end;
	recorrerLista := conteoDniIgual;
end;




function incisoC ( v : vector ; dni : integer) : integer;
var
	conteo : integer;
	i : rangoAnios;
begin
	conteo := 0;
	for i := anioMin to anioMax do
		begin
			if v[ i ] <> nil then
				conteo := conteo + recorrerLista(v[ i ], dni);
		end;
	incisoC := conteo;
end;




var
a : arbol;

v : vector;
valor : integer;

dni : integer;
begin
	a := nil;
	cargarArbol(a);
	
	//inciso B
	inicializarVector(v);
	write('ingrese valor: ');readln(valor);
	incisoB(a, v, valor);
	
	//inciso C
	write('ingrese dni: ');readln(dni);
	write('el dni ',dni,' tiene ',incisoC(v, dni),' polizas');
	
end.







