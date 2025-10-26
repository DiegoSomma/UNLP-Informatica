{Un supermercado quiere llevar un registro de todas sus ventas, de cada venta se lee el codigo, dni del cliente, suscursal en la que compró (1..5) y monto gastado, la lectura se detiene con el código de venta 0, se pide:

A- crear una estructura eficiente para la busqueda por dni de cliente, de cada cliente se guarda el monto gastado en cada sucursal

B-un módulo que reciba la estructura generada en A y un número de sucursal y retorne la cantidad de clientes que no gastaron nada en la sucursal

C-un modulo que reciba la estructura generara en A y un dni y retorne el monto total general gastado por dicho dni (es decir, la suma de los montos de todas las sucursales)

}

program parcialSupermercado;

const
	hastaNum = 0;
	df = 5;
	
type
	rangoSucursales = 1..df;
	vectorMontos = array [1..df] of real;
	
	venta = record
		codigo : integer;
		dniCliente : integer;
		sucursal : integer;
		montoGastado : real;
	end;
	
	arbol = ^nodoArbol;
	nodoArbol = record
		dni : integer;
		vMontos : vectorMontos;
		HI : arbol;
		HD : arbol;
	end;
	

procedure inicializarVector (var vM : vectorMontos);
var
	i : integer;
begin
	for i:= 1 to df do vM[ i ] := 0;
end;
	
	
	
procedure agregarAlarbol (var a : arbol ; v : venta);
begin
	if (a = nil) then
		begin
			new(a);
			a^.dni := v.dniCliente;
			inicializarVector(a^.vMontos);
			a^.vMontos[ v.sucursal ] := a^.vMontos[ v.sucursal ] + v.montoGastado;
			a^.HI := nil;
			a^.HD := nil;
		end
	else
		if a^.dni = v.dniCliente then
				a^.vMontos[ v.sucursal ] := a^.vMontos[ v.sucursal ] + v.montoGastado
		else
			if a^.dni > v.dniCliente then agregarAlarbol(a^.HI, v)
			else	agregarAlarbol(a^.HD, v);
			
end;

procedure leerVenta (var v : venta);
begin
	write('ingrese codigo de la venta (0 para terminar) : ');readln(v.codigo);
	if v.codigo <> hastaNum then
		begin
			write('ingrese DNI del cliente: ');readln(v.dniCliente);
			
			repeat
			write('ingrese numero de la sucursal (del 1 al 5): ');readln(v.sucursal);
			until (v.sucursal >= 1) and (v.sucursal <= 5);
			
			write('ingrese monto de la venta: ');readln(v.montoGastado);
		end;
	
end;

procedure cargarArbol (var a : arbol);
var 
	v : venta;
begin
	leerVenta(v);
	while v.codigo <> hastaNum do
		begin
			agregarAlarbol(a,v);
			leerVenta(v);
		end;
end;

//inciso B
function cantClientesSucursal (a : arbol ; sucursal : integer) : integer;
begin
	if a = nil then
		cantClientesSucursal := 0
	else
		begin
			if a^.vMontos[ sucursal ] = 0 then
				cantClientesSucursal := 1 + cantClientesSucursal(a^.HI, sucursal) + cantClientesSucursal(a^.HD, sucursal)
			else
				cantClientesSucursal := cantClientesSucursal(a^.HI, sucursal) + cantClientesSucursal(a^.HD, sucursal)
				
		end;
end;


function sumarMontosDni (a : arbol ; dni : integer) : real;
var
	sumaSucursales : real;
	i : integer;
begin
	if a = nil then
		sumarMontosDni := 0
	else
		if a^.dni = dni then
			begin
				sumaSucursales := 0;
				for i := 1 to df do sumaSucursales := sumaSucursales + a^.vMontos [ i ];
				sumarMontosDni := sumaSucursales
			end
		else
			if dni < a^.dni then sumarMontosDni := sumarMontosDni(a^.HI, dni)
			else sumarMontosDni := sumarMontosDni(a^.HD, dni)
end;

var
	a : arbol;
	sucursal : integer;
	dni : integer;
begin
	a := nil;
	//inciso A
	cargarArbol(a);
	
	//inciso B
	write('ingrese numero de la sucursal: ');
	readln(sucursal);
	write('cantidad de clientes que no gastaron nada en la sucursal ',sucursal,': (',cantClientesSucursal(a,sucursal),')' );
	
	//inciso C
	write('ingrese dni: ');readln(dni);
	write('el dni ',dni,' gastó ',sumarMontosDni(a,dni),' pesos' );
	
end.




