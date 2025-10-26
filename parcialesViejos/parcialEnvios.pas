{El Correo Argentino necesita procesar los envios entregados durante el mes de Julio de 2024. De cada envio se conoce el
código del cliente, dia, código postal y peso del paquete.
a) Implementar un módulo que lea envios, genere y retorne un árbol binario de búsqueda ordenado por código
postal, donde para cada código postal se almacenen en una lista todos los envios (código de cliente, día y peso del
paquete) correspondientes. La lectura finaliza con código de cliente 0. Se sugiere utilizar el móduio leerEnvio ().
b) Implementar un módulo que reciba la estructura generada en a) y un código postal, y retorne todos los envíos de
dicho código postal.
c) Realizar un módulo recursivo que reciba la estructura que retorna el Inciso b) y retorne los dos códigos de cliente
correspondientes al envio con mayor y menor peso.}

program parcialCorreos; 

const
	hastaNum = 0;

type
	sub_dia = 1..30;
	
	envio = record
		cod_cliente : integer;
		dia : sub_dia;
		peso : real;
	end;
	
	listaPostales = ^nodoListaPostales;
	
	nodoListaPostales = record
		dato : envio;
		sig : listaPostales;
	end;
	
	arbolEnvios = ^nodoArbolEnvios;
	
	nodoArbolEnvios = record
		codPostal : integer;
		lista : listaPostales;
		HI : arbolEnvios;
		HD : arbolEnvios;
	end;
	
	
procedure leerEnvio (var e : envio);
begin
	e.cod_cliente := random(10000);
	if (e.cod_cliente <> hastaNum) then
		begin
			e.dia := random(30) + 1;
			e.peso := random(20000) / (random(10) + 1);
			 writeln('Generado - Cliente: ', e.cod_cliente, ', Día: ', e.dia, ', Peso: ', e.peso:0:2);
		end;
end;


procedure agregarAdelante (var l : listaPostales ; e : envio);
var
	nue : listaPostales;
begin
	new(nue);
	nue^.dato := e;
	nue^.sig := l;
	l := nue;
end;


procedure agregarArbol (var a : arbolEnvios ; e : envio ; postal : integer);
begin
	if a = nil then
		begin
			new(a);
			a^.codPostal := postal;
			a^.lista := nil;
			agregarAdelante(a^.lista, e);
			a^.HI := nil;
			a^.HD := nil;
		end
	else
		if a^.codPostal = postal then
			agregarAdelante(a^.lista, e)
		else
			if a^.codPostal > postal then
				agregarArbol(a^.HI, e, postal)
			else
				agregarArbol(a^.HD, e, postal);
end;



procedure cargarArbol (var a : arbolEnvios);
var
	e : envio;
	postal : integer;
begin
	leerEnvio(e);
	while e.cod_cliente <> hastaNum do
		begin
			write('ingrese codigo postal ','del cliente ',e.cod_cliente,': ');
			readln(postal);
			agregarArbol(a, e, postal);
			leerEnvio(e);
		end;
end;
		
		
procedure incisoB (a : arbolEnvios ; postal : integer ; var listaB : listaPostales);
begin
	if a = nil then
		listaB := nil
	else
			if a^.codPostal = postal then
				listaB := a^.lista
			else
				if  a^.codPostal > postal then
					incisoB(a^.HI, postal, listaB)
				else
					incisoB(a^.HD, postal, listaB)
				

end;
	
		
procedure buscarIncisoC (LB : listaPostales ; var codPesoMax,codPesoMin : integer;  var pesoMax,pesoMin : real);
begin
	if LB <> nil then
		begin
			if LB^.dato.peso > pesoMax then
				begin
					codPesoMax := LB^.dato.cod_cliente;
					pesoMax := LB^.dato.peso;
				end;
				
			if LB^.dato.peso < pesoMin then
				begin
					codPesoMin := LB^.dato.cod_cliente;
					pesoMin := LB^.dato.peso;
				end;
			buscarIncisoC(LB^.sig, codPesoMax, codPesoMin, pesoMax, pesoMin);
		end;
end;
		
		
var
a : arbolEnvios;
LB : listaPostales;
codigoPesoMax,codigoPesoMin : integer;
pesoMax, pesoMin : real;
postal : integer;

begin
	randomize;
	a := nil;
	LB := nil;
	
	
	//inciso A 
	cargarArbol (a);
	
	//inciso B
	write('ingrese codigo postal para buscar lista con ese numero: ');
	readln(postal);
	incisoB(a, postal, LB);
	
	//inciso C
	if LB <> nil then
		begin
			codigoPesoMax := -1;
			codigoPesoMin := 10001;
			pesoMax := -1;
			pesoMin := 10001;
			
			buscarIncisoC(LB, codigoPesoMax, codigoPesoMin, pesoMax, pesoMin);
			
			writeln('Cliente con envio de mayor peso: ', codigoPesoMax, ' (', pesoMax:0:2, ' kg)');
			writeln('Cliente con envio de menor peso: ', codigoPesoMin, ' (', pesoMin:0:2, ' kg)');

		end
	else
		writeln('No se encontraron envíos para ese código postal.');
end.
		
		
		
		
		
		
		
		
