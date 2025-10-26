program parcialFinales2025;

const
	hastaNum = -1;
	anioMin = 2011;
	anioMax = 2024;
	
type
	rangoAnios = anioMin..anioMax;
	fechas = record
		dia : integer;
		mes : integer;
		anio : rangoAnios;
	end;
	
	final = record
		legajo : integer;
		nota : real;
		fecha : fechas;
	end;
	

	
	lista = ^nodoLista; 
	nodoLista = record
		dato : final;
		sig : lista;
	end;
	
	  arbol = ^nodoArbol;
  nodoArbol = record
    legajo: integer;
    examenes: lista; 
    HI, HD: arbol;
  end;
  
	
	vector = array [ rangoAnios ] of lista;
	
	
procedure leerFinal (var fin : final);
begin
	write('ingrese numero de legajo: ');readln(fin.legajo);
	if fin.legajo <> hastaNum then
		begin
			write('ingrese nota: ');readln(fin.nota);
			write('ingrese dia: ');readln(fin.fecha.dia);
			write('ingrese mes: ');readln(fin.fecha.mes);
			write('ingrese año: ');readln(fin.fecha.anio);
		end;
end;
	
procedure inicializarVector (var v : vector);	
var
	i : integer;
begin
	for i := anioMin to anioMax do
		v[ i ] := nil;
end;
	

procedure agregarOrdenado (var l : lista ; fin : final);
var
	nuevo, ant, act : lista;
begin
	new(nuevo);
	nuevo^.dato := fin;
	act := l;
	while (act <> nil) and (act^.dato.nota < fin.nota) do
		begin
			ant := act;
			act := act^.sig;
		end;
	if (act = l) then
		l := nuevo
	else
		ant^.sig:= nuevo;
	nuevo^.sig :=act;
end;
	
	
procedure cargarVector (var v : vector);
var
	fin : final;
begin
	inicializarVector(v);
	leerFinal(fin);
	while fin.legajo <> hastaNum do
		begin
			agregarOrdenado(v[ fin.fecha.anio ], fin);
			leerFinal(fin);
		end;
end;



procedure agregarALista(var l: lista; fin: final);
var
  nuevo: lista;
begin
  new(nuevo);
  nuevo^.dato := fin;
  nuevo^.sig := l;
  l := nuevo;
end;



procedure agregarAlArbol(var a: arbol; fin: final);
begin
  if a = nil then
  begin
    new(a);
    a^.legajo := fin.legajo;
    a^.HI := nil;
    a^.HD := nil;
    a^.examenes := nil;
    agregarALista(a^.examenes, fin);
  end
  else if fin.legajo < a^.legajo then
    agregarAlArbol(a^.HI, fin)
  else if fin.legajo > a^.legajo then
    agregarAlArbol(a^.HD, fin)
  else
    agregarALista(a^.examenes, fin);
end;


procedure recorrerLista(l: lista; var a: arbol; nota: real);
begin
  while (l <> nil) and (l^.dato.nota > nota) do
  begin
    agregarAlArbol(a, l^.dato);
    l := l^.sig;
  end;
end;





procedure cargarArbol(v: vector; var a: arbol; nota: real);
var
  i: rangoAnios;
begin
  for i := anioMin to anioMax do
    recorrerLista(v[i], a, nota);
end;


function incisoC (a : arbol ; legajo : integer): integer;
begin
	if a = nil then	
		incisoC := 0
	else
		if a^.dato.legajo = legajo then
			incisoC := incisoC(a^.HI,legajo) + 1
		else
			if a^.dato.legajo > legajo then
				incisoC := incisoC(a^.HI,legajo)
			else
				incisoC := incisoC(a^.HD, legajo);
end;




var
	v : vector;
	a : arbol;
	nota : real;
	legajo : integer;
	
begin
	a := nil;
	
	cargarVector(v);
	write('ingrese nota: ');readln(nota);
	cargarArbol(v,a,nota);
	
	write('ingrese legajo: ');readln(legajo);
	write('cantidad de examenes que rindió ese legajo: ',incisoC(a, legajo));
end.



	
	
	
	
	
