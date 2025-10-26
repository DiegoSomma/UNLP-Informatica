{

Una empresa de transportes de encomiendas desea analizar la información de las encomiendas transportadas durante
2025, De cada encomienda transportada se conoce: DNI del emisor, DNI del receptor, ciudad de destino y peso de la
encomienda en gramos. Realice un programa que contenga e invoque a:

Final Taller de Programación - Práctico - Módulo Imperativo

a. Un módulo que lea la información de las encomiendas y retorne una estructura eficiente para buscar por ciudad de
destino, que guarde para cada ciudad la suma de los pesos de todos las encomiendas y la cantidad total de
encomiendas. La lectura finaliza al leer una encomienda con peso 0.

b. Un módulo que reciba la estructura generada en a) y un valor X, y retorne una lista con toda la información de las
ciudades cuya cantidad total de encomiendas recibidas sea mayor a X. La lista debe quedar ordenada por suma de pesos

c. Un módulo que reciba la estructura generada en a) y un nombre N, y retorne toda la información de la ciudad
llamada N. Considere que el nombre de ciudad puede no existir y que no existen dos ciudades con el mismo nombre.

}

program parcialEncomiendas;

const
	hastaNum = 0;

type
	encomienda = record
		dniEmisor : integer;
		dniReceptor : integer;
		destino : string;
		pesoGr : real;
	end;
	
	regArbLis = record
		destino : string;
		sumaDePesos : real;
		cantEncomiendas : integer;
	end;
	
	
	arbol = ^nodoArbol; 
	nodoArbol = record
		dato : regArbLis;
		HI : arbol;
		HD : arbol;
	end;
	
	lista = ^nodoLista;
	nodoLista = record
		dato : regArbLis;
		sig : lista;
	end;
	
	
procedure leerEncomienda (var e : encomienda);
begin
	write('ingrese peso');readln(e.pesoGr);
	if (e.pesoGr <> hastaNum) then
		begin
			write('ingrese dni del emisor: ');readln(e.dniEmisor);
			write('ingrese dni del receptor: ');readln(e.dniReceptor);
			write('ingrese destino: ');readln(e.destino);
		end;
end;

	
procedure agregar (var a : arbol ; e : encomienda);
begin
	if a = nil then
		begin
			new(a);
			a^.dato.destino := e.destino;
			a^.dato.sumaDePesos := e.pesoGr;
			a^.dato.cantEncomiendas := 1;
			a^.HI := nil;
			a^.HD := nil;
		end
	else
		if a^.dato.destino = e.destino then
			begin
				a^.dato.sumaDePesos := a^.dato.sumaDePesos +  e.pesoGr;
				a^.dato.cantEncomiendas := a^.dato.cantEncomiendas + 1;
			end
		else
			if a^.dato.destino > e.destino then
				agregar(a^.HI, e)
			else
				agregar(a^.HD, e);
end;


procedure cargarArbol (var a : arbol);
var
	e : encomienda;
begin
	leerEncomienda(e);
	while (e.pesoGr <> hastaNum) do
		begin
			agregar(a, e);
			leerEncomienda(e);
		end;
end;


procedure incisoB (a : arbol ; x : integer ; var l : lista);
begin
	if a <> nil then
		begin
			incisoB(a^.HI, x, l);
			
			if (a^.dato.cantEncomiendas > x) then
				insertarOrdenado(a^.dato, l);
				
			incisoB(a^.HD, x, l);
		end;
end;
	


function incisoC (a : arbol ; nombre : string ) : arbol;
begin
	if a = nil then
		incisoC := nil
	else
		if a^.dato.destino = nombre then
			incisoC := a
		else
			if  a^.dato.destino > nombre then
				incisoC := incisoC(a^.HI, nombre)
			else
				incisoC := incisoC(a^.HD, nombre);
end;



var
	a : arbol;
	l : lista; 
	x : integer;
	destino : string;
	a2 : arbol;
begin
	a := nil;
	l := nil;
	cargarArbol(a);
	
	//inciso B
	write('ingrese valor: ');readln(x);
	incisoB(a, x, l);
	
	//inciso C
	write('ingrese destino: ');readln(destino);
	a2 := incisoC(a, destino);
	if a2 = nil then
		write('no se encontró destino')
	else
		begin
			write('datos del destino ingresado: ');
			write('destino: ',a2^.dato.destino);
			write('suma de los pesos: ',a2^.dato.sumaDePesos);
			write('cantidad de encomiendas: ',a2^.dato.cantEncomiendas);
		end;
end.














