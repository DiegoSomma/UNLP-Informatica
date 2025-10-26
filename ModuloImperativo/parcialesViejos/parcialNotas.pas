{

Se desea analizar los exámenes finales de una cátedra. De cada final se conoce: legajo del
alumno, nota (un real entre 0 y 100) y fecha del examen. Un mismo alumno haber rendido más
de un final. Los exámenes a analizar son todos los que se tomaron entre 2011 y 2024, ambos
inclusive. Realice un programa que contenga:

a) Un módulo que lea exámenes, hasta leer un examen con legajo -1, y los almacene en
una estructura eficiente para la búsqueda por nota.
b) Un módulo que reciba la estructura generada en a) y devuelva otra estructura con los
exámenes cuya nota sea menor a un valor recibido por parámetro. Esta estructura debe
estar agrupada por año y ordenado por legajo.
c) Un módulo que reciba la estructura generada en b) y devuelva la cantidad de exámenes
que rindió un alumno cuyo legajo se recibe por parámetro.

}

program parcialNotas;

const
	hastaLegajo = 0;
	anioMin = 2011;
	anioMax = 2024;

type
	rangoAnio = anioMin..anioMax;
	
	fechas = record
		dia, mes, anio : integer;
	end;
	
	examen = record
		legajo : integer;
		nota : integer;
		fecha : fechas;
	end;
	
	arbol = ^nodoArbol;
	
	nodoArbol = record
		dato : examen;
		HI : arbol;
		HD : arbol;
	end;
	
	listaExamenes = ^nodoLista;
	nodoLista = record
		dato : examen;
		sig : listaExamenes;
	end;
	
	vector = array [ rangoAnio ] of listaExamenes;
	
//INCISO A	
procedure leerExamen (var e : examen);
begin
	e.legajo := random(10000) - 1;
	if e.legajo <> hastaLegajo then
		begin
			e.nota := random(12) - 1;
			e.fecha.dia := random (28) + 1;
			e.fecha.mes := random (11) + 1;
			e.fecha.anio := random (14) + 2011;
		end;
end;


procedure agregar (var a : arbol ; exa : examen);
begin
	if a = nil then
		begin
			new(a);
			a^.dato := exa;
			a^.HI := nil;
			a^.HD := nil;
		end
	else
		if a^.dato.nota >= exa.nota then
			agregar(a^.HI, exa)
		else
			agregar(a^.HD, exa);
end;


procedure cargarArbol (var a : arbol);	
var
	exa : examen;
begin
	leerExamen(exa);
	while exa.legajo <> hastaLegajo do
		begin
			agregar(a, exa);
			leerExamen(exa);
		end;
end;

//INCISO B

procedure insertarOrdenado (var pri : listaExamenes ; exa : examen);
var
	ant, nue, act : listaExamenes;
begin
	new(nue);
	nue^.dato := exa;
	act := pri;
	ant := pri;
	while (act <> nil) and (act^.dato.legajo < exa.legajo) do 
		begin
			ant := act;
			act := act^.sig;
		end;
	if (ant = act) then
		pri := nue
	else
		ant^.sig := nue;
	
	nue^.sig := act;
end;



procedure cargarVector(a : arbol ; v : vector ; nota : integer);
begin
	if a <> nil then
		begin
			if a^.dato.nota < nota then
				begin
				insertarOrdenado(v[ a^.dato.fecha.anio ], a^.dato);
				cargarVector(a^.HI, v, nota);
				cargarVector(a^.HD, v, nota);
				end
			else
				cargarVector(a^.HI, v, nota);
		end;
end;


//inciso C 

function recorrerLista (l : listaExamenes ; legajo : integer) : integer;
var
	conteo : integer;
begin
	conteo :=0;
	while (l <> nil) and (l^.dato.legajo <= legajo) do
		begin
			if l^.dato.legajo = legajo then
				conteo := conteo + 1;
			l := l^.sig;
		end;
	recorrerLista := conteo;
end;


function incisoC (v : vector ; legajo : integer) : integer;
var
	conteo : integer;
	i : integer;
begin
	conteo := 0;
	for i := anioMin to anioMax do
		begin
			if v[ i ] <> nil then
				conteo := conteo +  recorrerLista(v[ i ],legajo);	
			end;
	incisoC := conteo;
end; 


procedure inicializarVector (var v : vector);
var
	i : integer;
begin
	for i := anioMin to anioMax do
		v[ i ] := nil;
end;

var
	a : arbol;
	v : vector;
	legajo : integer;
	nota : integer;
begin
	a := nil;
	inicializarVector(v);
	cargarArbol(a);
	
	//inciso B
	write('ingrese nota:');
	readln(nota);
	cargarVector(a, v, nota);
	
	//inciso C
	write('ingrese legajo: ');
	readln(legajo);
	write('cantidad de examenes del legajo ',legajo,': ',incisoC(v, legajo));
	
end.
	
	
	
	
	
	
	
		
