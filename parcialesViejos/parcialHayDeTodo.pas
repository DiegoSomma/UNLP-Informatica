{
El supermercado HayDeTodo necesita un sistema para procesar la información de sus ventas. De cada venta se conoce:
DNI de cliente, código de sucursal (1 a 10), número de factura y monto.
a) Implementar un módulo que lea información de las ventas (la lectura finaliza al ingresar código de cliente 0 y
retorne:
i. Una estructura de datos eficiente para la búsqueda por DNI de cliente. Para cada DNI debe almacenarse una
lista de todas sus compras (número de factura y monto).
ii. Una estructura de datos que almacene la cantidad de ventas de cada sucursal.
b) Realizar un módulo que reciba la estructura generada en el inciso a) i, un monto y un DNI. El módulo debe retornar
la cantidad de facturas cuyo monto es superior al monto ingresado para el DNI ingresado.
c) Realizar un módulo recursivo que reciba la estructura generada en inciso a)ii y retorne el código de sucursal con
mayor cantidad de ventas ..

}
program parcialHayDeTodo;

const
	hastaNum = 0;
	codMin = 1;
	codMax = 10;
	
type
	rangoCodigos = codMin..codMax;
	
	venta = record
		dniCliente : integer;
		codSucursal : rangoCodigos;
		numFactura : integer;
		monto : real;
	end;
	
	
	lista = ^nodoLista;
	nodoLista = record
		numFactura : integer;
		monto : real;
		sig : lista;
	end;
	
	rArbol = record
		dniCliente : integer;
		compras : lista;
	end;
	
	arbol = ^nodoArbol;
	nodoArbol = record
		dato : rArbol;
		HI : arbol;
		HD : arbol;
	end;
	
	
	vector = array [rangoCodigos ] of integer;
	
	
procedure leerVenta(var ven : venta);
begin
	ven.dniCliente := random(5000) ;
	if ven.dniCliente <> hastaNum then
		begin
			ven.codSucursal := random(10) + 1;
			ven.numFactura := random(10000) + 1;
			ven.monto := random(2000) / (random(10) + 1);
		end;
end;
	
	
procedure agregarAdelante (var l : lista ; factura : integer; monto : real);
var
	nue : lista;
begin
	new(nue);
	nue^.numFactura := factura;
	nue^.monto := monto;
	nue^.sig := l;
	l := nue;
end;
	
procedure agregar (var a : arbol ; ven : venta);
begin
	if a = nil then
		begin
			new(a);
			a^.dato.dniCliente := ven.dniCliente;
			a^.dato.compras := nil;
			agregarAdelante(a^.dato.compras, ven.numFactura, ven.monto);
			a^.HI := nil;
			a^.HD := nil;
		end
	else
		if a^.dato.dniCliente = ven.dniCliente then
			agregarAdelante(a^.dato.compras, ven.numFactura, ven.monto)
		else
			if a^.dato.dniCliente > ven.dniCliente then
				agregar(a^.HI, ven)
			else
				agregar(a^.HD, ven);
end;	
	
procedure inicializarVector (var vec : vector);
var
	i : rangoCodigos;
begin
	for i:= codMin to codMax do
		vec[ i ] := 0;
end;
	
	
procedure cargarEstructuras (var a : arbol;var  vec : vector);
var
	ven : venta;
begin
	inicializarVector(vec);
	leerVenta(ven);
	while ven.dniCliente <> hastaNum do
		begin
			agregar(a, ven);
			vec[ ven.codSucursal ] := vec[ ven.codSucursal ] + 1;
			leerVenta(ven);
		end;
end;
	
	
function recorrerLista (l : lista ; monto : real): integer;
var
	cumpleCond : integer;
begin
	cumpleCond := 0;
	while l <> nil do
		begin
			if l^.monto > monto then
				cumpleCond := cumpleCond +1 ;
			l:= l^.sig;	
		end;
	recorrerLista := cumpleCond;
end;

	
function incisoB (a : arbol ; monto : real; dni : integer) : integer;	
begin
	if a = nil then
		incisoB := 0
	else
		if a^.dato.dniCliente = dni then
			incisoB := recorrerLista(a^.dato.compras, monto)
		else
			if a^.dato.dniCliente > dni then
				incisoB := incisoB(a^.HI, monto, dni)
			else
				incisoB := incisoB(a^.HD, monto, dni)
end;
	


procedure incisoC (vec : vector ; var codigoMax,CantMax : integer; i : integer);
begin
	if i <=  codMax then
		begin
			if vec[ i ] > CantMax then
				begin
					codigoMax := i;
					CantMax := vec[ i ] ;
				end;
				incisoC(vec,codigoMax,cantMax,i + 1);
		end;
end;



var
	a :arbol ;
	vec : vector;
	monto : real;
	dni : integer;

	codigoMax : integer;
	CantMax : integer;
begin
	a := nil;
	//inciso A 
	cargarEstructuras(a, vec);
	
	//inciso B 
	write('ingrese monto: ');readln(monto);
	write('ingrese dni: ');readln(dni);
	write('cantidad de factura con ese dni mayores al monto ingresado: ',incisoB(a, monto, dni));


	//inciso C
	codigoMax := 0;
	CantMax := -1;
	incisoC(vec, codigoMax,cantMax, codMin);
	
	if codigoMax <> 0 then
		writeln('Código de sucursal con más ventas: ', codigoMax, ' (', vec[codigoMax], ' ventas)')
	else
		writeln('El vector estaba vacío.');
end.
	
	
	
	
