{

Correo Argentino desea analizar la información de los paquetes enviados durante 2024. De cada paquete enviado se
conoce: código de envío, tipo de envío (1 .. 4), DNI del emisor, DNI del receptor y su peso en gramos.
Realice un programa que contenga e invoque a:
a. Un módulo que lea la información de paquetes enviados y retorne una estructura que agrupe los paquetes enviados
según el tipo de envío. Para cada tipo de envio, se requiere que la búsqueda por peso en gromos sea lo más
eficiente posible. La lectura finaliza al leer un paquete con código de envio 0.
b. Un módulo que reciba la estructura generada en a) y un tipo de envio X, y retorne toda la información del paquete
con mayor peso del tipo de envío X.
c. Un módulo que reciba la estructura generada en a), un tipo de envio X y un DNI D, y retorne la cantidad total de
paquetes enviados por el emisor con DNI D, bajo el tipo de envio X.

}
program parcialCorreo2025;

const
	hastaNum = 0;
	tipoMin = 1;
	tipoMax = 4;

type
	rangoTipos = tipoMin..tipoMax;
	
	paquete = record
		codEnvio : integer;
		tipoEnvio : rangoTipos;
		dniEmisor : integer;
		dniReceptor : integer;
		pesoGr : real;
	end;
	
	arbol = ^nodoArbol;
	
	nodoArbol = record
		dato : paquete;
		HI : arbol;
		HD : arbol;
	end;
	
	vector = array [ rangoTipos ] of arbol;
	

procedure inicializarVector (var v : vector);
var
	i : integer;
begin
	for i := tipoMin to tipoMax do v[ i ]:= nil;
end;


procedure leerPaquete (var p : paquete);
begin
	p.codEnvio := random(101);
	if (p.codEnvio <> hastaNum) then
		begin
			p.tipoEnvio := 1 + random(4);
			p.dniEmisor := 9 + random(50);
			p.dniReceptor := 6 + random(50);
			p.pesoGr := 100 + random(1000);
		end;
end;


procedure agregarAlArbol (var a : arbol ; p : paquete);
begin
	if a = nil then
		begin
			new(a);
			a^.dato := p;
			a^.HI := nil;
			a^.HD := nil;
		end
	else
		if a^.dato.pesoGr >= p.pesoGr then
			agregarAlArbol(a^.HI, p)
		else
			if a^.dato.pesoGr < p.pesoGr then
				agregarAlArbol(a^.HD, p);
end;

procedure cargarVectorArboles (var v : vector);
var
	p : paquete;
begin
	inicializarVector(v);
	leerPaquete(p);
	while (p.codEnvio <> hastaNum) do
		begin
			agregarAlArbol(v[ p.tipoEnvio ], p);
			leerPaquete(p);
		end;
end;



function buscarPesoMax(a : arbol) : arbol;
begin
	if (a = nil) or (a^.HD = nil) then
		buscarPesoMax := a
	else
		buscarPesoMax := buscarPesoMax(a^.HD);
end;

function incisoB ( v : vector ; x : integer) : arbol;
begin
	if v[ x ] = nil then
		incisoB := nil
	else
		incisoB := buscarPesoMax(v[ x ]);
end;



function conteoDeEnviosC (a : arbol ; d : integer) : integer;
begin
	if a = nil then
		conteoDeEnviosC :=0
	else
		if a^.dato.dniEmisor = d then
			conteoDeEnviosC := 1 + conteoDeEnviosC(a^.HI, d) + conteoDeEnviosC(a^.HD, d)
		else
			conteoDeEnviosC := conteoDeEnviosC(a^.HI, d) + conteoDeEnviosC(a^.HD, d)
end;


function incisoC (v : vector ; x, d : integer) : integer;
begin
	if v[ x ] = nil then
		incisoC := 0
	else
		incisoC := conteoDeEnviosC(v[ x ],d);
end;






var
v : vector;
tipoX, tipoD : integer;
a : arbol;

begin
	//inciso A
	cargarVectorArboles(v);
	
	//inciso B
	repeat
	write('ingrese tipo de envio(del 1 al 4): ');readln(tipoX);
	until (tipoX >= 1) and (tipoX <= 4);
	
	a := incisoB(v, tipoX);
	if a <> nil then
		begin
			writeln('datos del paquete con mayor peso del tipo ',tipoX);
			writeln('dni del emisor: ',a^.dato.dniEmisor);
			writeln('dni del receptor: ',a^.dato.dniReceptor);
			writeln('peso (en gramos): ',a^.dato.pesoGr);
		end
	else
		writeln('No se encontraron paquetes del tipo de envío ', tipoX);
		
	//inciso C	
	repeat
	write('ingrese tipo de envio(del 1 al 4): ');readln(tipoX);
	until (tipoX >= 1) and (tipoX <= 4);
	
	write('ingrese dni: ');readln(tipoD);
	
	write('el emisor con dni ',tipoD,' realizó ',incisoC(v, tipoX, tipoD),' envios');
	
	
end.


	
