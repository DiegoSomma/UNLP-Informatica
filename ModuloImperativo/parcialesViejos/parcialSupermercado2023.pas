{

Se lee información de las compras realizadas por los clientes a un supermercado en el ano 2023.De cada compra se lee
el código de cliente, número de factura, número de mes y monto gastado ta lectura finaliza cuando se lee ei chente con
código 0.

a) Realizar un módulo que lea la información de las compras y retorne un arbol de busqueda ordenado por cadigo
de cliente. Para cada código de cliente, se debe almacenar un vector con el monto total gastado por dicho
cliente en cada mes del año 2023.

b) Realizar un módulo que reciba la estructura generada en a) y un codigo de cliente, v retorne el mes con mayor
gasto de dicho cliente.

c) Realizar un módulo que reciba la estructura generada en al y un número de mes, y retorne la cantidad de
clientes que no gastaron nada en dicho mes.

NOTA: Implementar el programa principal, que invoque a los incisos a, b y c

}
program parcialSupermercado2023;

const
	hastaNum =  0;
	
type
	compra = record
		codCliente : integer;
		numFactura : integer;
		mes : integer;
		montoGastado : real;
	end;
	
	vMeses = array [1..12] of real;
	
	rArbol = record
		codCliente : integer;
		meses : vMeses;
	end;
	
	arbol = ^nodoArbol;
	nodoArbol = record
		dato : rArbol;
		HI : arbol;
		HD : arbol;
	end;


procedure leerCompra( var c : compra);
begin
	write('ingrese codigo de cliente: ');readln(c.codCliente);
	if c.codCliente <> hastaNum then
		begin
			write('ingrese numero de factura: ');readln(c.numFactura);
			write('ingrese numero de mes(del 1 al 12: ');readln(c.mes);
			write('ingrese monto gastado: ');readln(c.montoGastado);
		end;
end;


procedure inicializarVector (var vMontos : vMeses);
var
	i : integer;
begin
	for i:= 1 to 12 do
		vMontos[ i ] := 0;
end;


procedure agregar ( var a : arbol ; c :compra );
begin
	if a = nil then
		begin
			new(a);
			 inicializarVector(a^.dato.meses); 
			a^.dato.codCliente := c.codCliente;
			a^.dato.meses[c.mes] := c.montoGastado;
			a^.HI := nil;
			a^.HD := nil;
		end
	else
		if a^.dato.codCliente = c.codCliente then
			a^.dato.meses[c.mes] := a^.dato.meses[c.mes] + c.montoGastado
		else
			if c.codCliente < a^.dato.codCliente then
				agregar(a^.HI, c)
			else
				agregar(a^.HD, c);
end;



procedure cargarArbol (var a : arbol);
var
	c : compra;
begin
	leerCompra(c);
	while c.codCliente <> hastaNum do
		begin
			agregar(a,c);
			leerCompra(c);
		end;
end;




function recorrerVector (v : vMeses) : integer;
var
	i : integer;
	montoMax : real;
	mesMax : integer;
begin
	montoMax := -1;
	for i := 1 to 12 do
		begin
			if v[ i ] > montoMax then
				begin
					montoMax := v[ i ] ;
					mesMax := i;
				end;	
		end;
	recorrerVector := mesMax;
end;


function incisoB ( a : arbol ; cliente : integer) : integer;
begin
	if a = nil then
		incisoB := 0
	else
		if a^.dato.codCliente = cliente then
			incisoB := recorrerVector(a^.dato.meses)
		else
			if a^.dato.codCliente > cliente then
				incisoB := incisoB(a^.HI, cliente)
			else
					incisoB := incisoB(a^.HD, cliente);
end;



function incisoC (a : arbol ; numMes : integer) : integer;
begin
	if a = nil then
		incisoC := 0
	else
		if a^.dato.meses[ numMes ] = 0 then
				incisoC:= 1 + incisoC(a^.HI, numMes) + incisoC(a^.HD, numMes) 
		else
			incisoC:= incisoC(a^.HI, numMes) + incisoC(a^.HD, numMes);
end;




var
 a : arbol;
 codigo : integer;
 mes : integer;

numMes : integer;
begin
	a := nil;
	//inciso A
	cargarArbol(a);

	//inciso B
	write('ingrese codigo de cliente: ');readln(codigo);
	mes := incisoB(a, codigo);
	if mes = 0 then
		write('codigo no encontrado')
	else
		write('mes con mas gasto de ese cliente: ',mes);
	
	
	//inciso C	
	write('ingrese mes: ');
	readln(numMes);
	write('cantidad de clientes que no gastaron el mes ',numMes,': ', incisoC(a, numMes));
	
end.











