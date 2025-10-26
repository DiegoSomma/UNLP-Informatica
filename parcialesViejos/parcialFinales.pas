{

Una facultad requiere procesar los resultados de cada final rendido por sus estudiantes.
a) Implementar un módulo que lea resultados de exámenes finales. De cada resultado se lee: legajo del estudiante,
código de la materia (entre 101 y 135), mes, año y nota. La lectura finaliza con el código de materia 0. Se sugiere utilizar
el módulo leer_resultado(). El módulo deber retornar dos estructuras:
Ci. Un árbol binario de búsqueda ordenado ordenado por legajo del estudiante. En el árbol, para cada legajo del
estudiante se debe almacenar una lista con código de materia, mes, año y nota.
ii. Un vector que almacene la cantidad de aplazos que posee cada materia.
b) Implementar un módulo que reciba el árbol generado en i) y un legajo del estudiante. El módulo debe retornar el
promedio sin aplazos (se aprueba con nota 4 o superior) para el legajo recibido.
c) Implementar un módulo recursivo que reciba el vector generado en ii). El módulo debe retornar el código de
materia con mayor cantidad de aplazos.

}


program parcialFinales2024;

const
	hastaNum = 0;
	codMateriaMin = 101;
	codMateriaMax = 135;

type
	rangoMaterias = codMateriaMin..codMateriaMax;
	
	examen = record
		legajo : integer;
		codMateria : rangoMaterias;
		mes : integer;
		anio : integer;
		nota : integer;
	end;
	
		
	lista = ^nodoLista;
	nodoLista = record
		dato : examen;
		sig : lista;
	end;
	
	
	arbol = ^nodoArbol;
	nodoArbol = record
		legajo: integer; 
		dato : lista;
		HI : arbol;
		HD : arbol;
	end;

	vector = array [ rangoMaterias ] of integer;


procedure leerExamen (var e : examen);
begin
	write('ingrese codigo de materia: ');readln(e.codMateria);
	if (e.codMateria <> hastaNum) then
		begin
			write('ingrese legajo: ');readln(e.legajo);
			write('ingrese mes: ');readln(e.mes);
			write('ingrese anio: ');readln(e.anio);
			write('ingrese nota: ');readln(e.nota);
		end;
end;

procedure agregarAdelante (var l : lista ; e : examen);
var
	nue : lista;
begin
	new(nue);
	nue^.dato := e;
	nue^.sig := l;
	l := nue;
end;


procedure agregar (var a : arbol ; e : examen);
begin
	if a = nil then
		begin
			new(a);
			a^.legajo := e.legajo;
			a^.dato := nil;
			agregarAdelante(a^.dato, e);
			a^.HI := nil;
			a^.HD := nil;
		end
	else
		if a^.legajo = e.legajo then
			agregarAdelante(a^.dato, e)
		else
			if e.legajo < a^.legajo then
				agregar(a^.HI, e)
			else
				agregar(a^.HD, e);
end;


procedure iniciarVector (var v : vector);
var
	i : rangoMaterias;
begin
	for i := codMateriaMin to codMateriaMax do
		v[ i ] := 0;
end;


procedure cargarEstructuras( var a : arbol ; var v : vector);
var
	e : examen;
begin
	iniciarVector(v);
	leerExamen(e);
	while (e.legajo <> hastaNum) do
		begin
			agregar(a, e);
			if (e.nota <= 3) then
				v[ e.codMateria ] := v[ e.codMateria ] + 1;
			leerExamen(e);
		end;
end;


function calcularPromedio ( l : lista) : real;
var
	cantMaterias : integer;
	sumaNotas : integer;
begin
	cantMaterias := 0;
	sumaNotas := 0;
	while l <> nil do
		begin
			if l^.dato.nota >= 4 then
				begin
					cantMaterias := cantMaterias + 1;
					sumaNotas := sumaNotas + l^.dato.nota;
				end;
			l := l^.sig;
		end;
	if cantMaterias = 0 then
		calcularPromedio := 0
	else
		calcularPromedio := sumaNotas / cantMaterias;
end;



function incisoB (a : arbol; legajo : integer) : real;
begin
	if a = nil then
		incisoB := 0
	else
		if a^.legajo = legajo  then
			incisoB := calcularPromedio(a^.dato)
		else
			if  a^.legajo > legajo then
				incisoB := incisoB(a^.HI, legajo)
			else
				incisoB := incisoB(a^.HD, legajo)
end;


function incisoC(v: vector; i: integer): integer;
var
  codMaxResto: integer;
begin
  if i = codMateriaMax then
    incisoC := i
  else
  begin
    codMaxResto := incisoC(v, i + 1);
    if v[i] >= v[codMaxResto] then
      incisoC := i
    else
      incisoC := codMaxResto;
  end;
end;


var
	a : arbol;
	v : vector;
	legajo : integer;
	
begin
	a := nil;
	//inciso A
	cargarEstructuras(a, v);
	
	//inciso B
	write('legajo: ');readln(legajo);
	write('promedio: ',incisoB(a, legajo));
	
	//inciso C
	write('codigo de materia con mas aplazos: ',incisoC(v, codMateriaMin));
end.
	
	
