{
La Feria del Libro necesita un sistema para obtener estadisticas sobre los libros presentados.
a) Implementar un módulo que lea información de los libros. De cada libro se conoce: ISBN, código del autor y
código del género (1: literario, 2: filosofia, 3: biologia, 4: arte, 5: computación, 6: medicina, 7: ingenieria)
lectura finaliza con el valor 0 para el ISBN. Se sugiere utizar el módulo leerLibro(). El módulo deber retornar dos
estructuras:

1. Un árbol binario de búsqueda ordenado por código de autor. Para cada código de autor debe almacenarse la
cantidad de libros correspondientes al código.
iL Un vector que almacene para cada género, el código del género y la cantidad de libros del género.

b) Implementar un módulo que reciba el vector generado en a), lo ordene por cantidad de libros de mayor a menor
y retorne el nombre de género con mayor cantidad cantidad de libros

c) implementar un módulo que reciba el árbol generado en a) y dos códigos. El módulo debe retornar la cantidad
total de libros correspondientes a los códigos de autores entre los dos códigos ingresados [incluidos ambos).

}

program parcialFeriaLibros;

const
	hastaNum = 0;
	generoMin = 1;
	generoMax = 7;
	df = generoMax;
type
	rangoGeneros = generoMin..generoMax;
	
	libro = record
		ISBN : integer;
		codAutor : integer;
		codGenero : integer;
	end;
	
	arbol = ^nodoArbol;
	
	nodoArbol = record
		codAutor : integer;
		cantLibros : integer;
		HI : arbol;
		HD : arbol;
	end;
	
	genero = record
		codGenero : integer;
		cantLibros : integer;
	end;
	vectorGeneros = array [rangoGeneros] of genero;
	 
	 vNombres = array[rangoGeneros] of string;

	
	
procedure inicializarVector	(var vG : vectorGeneros);
var
	i : integer;
begin
	for i := generoMin to generoMax do 
		begin
			vG [ i ].codGenero := i;
			vG [ i ].cantLibros := 0;
		end;
end;
	
	
procedure leerLibro	(var l : libro);
begin
	write('ingrese ISBN(0 para terminar): ');readln(l.ISBN);
	if (l.ISBN <> hastaNum) then
		begin
			write('ingrese codigo del autor: ');readln(l.codAutor);
			repeat
			write('ingrese codigo del genero(del 1 al 7): ');readln(l.codGenero);
			until (l.codGenero >= 1) and  (l.codGenero <= 7);
		end;
end;
	

procedure agregar (var a : arbol ; l : libro);
begin
	if a = nil then
		begin
			new(a);
			a^.codAutor := l.codAutor;
			a^.cantLibros := 1;
			a^.HI := nil;
			a^.HD := nil;
		end
	else
		if a^.codAutor = l.codAutor then
			a^.cantLibros := a^.cantLibros + 1
		else
			if a^.codAutor > l.codAutor then agregar(a^.HI, l)
			
			else	agregar(a^.HD, l);
			
end;



	
procedure cargarArbol (var a : arbol ; var vG : vectorGeneros);
var
	l : libro;
begin
	inicializarVector(vG);
	leerLibro(l);
	while (l.ISBN <> hastaNum) do
		begin
			agregar(a, l);
			vG[ l.codGenero ].cantLibros :=  vG[ l.codGenero ].cantLibros + 1;
			leerLibro(l);
		end;
end;



procedure ordenarVectorPorSeleccion (var vG : vectorGeneros; dimLog : integer);
var
	i, j, pos : integer;
	item : genero;
begin
	for i := 1 to dimLog - 1 do
		begin
			pos := i;
			for j := i + 1 to dimLog do
				if vG[ j ].cantLibros > vG[ pos ].cantLibros then pos := j;
			
			item := vG[ pos ];
			vG[ pos ] := vG[ i ];
			vG[ i ] := item;
		end;
end;




procedure incisoB (var vG : vectorGeneros ; vN : vNombres ; var nombre : string);
begin
	ordenarVectorPorSeleccion(vG, df);
	if vG[ 1 ].cantLibros <> 0 then
		nombre := vN[ vG[ 1 ].codGenero ]
	else
		writeln('el vector se encuentra vacio') ;
end;


procedure cargarVectorNombre (var vN : vNombres);
begin
    vN[1] := 'literario';
    vN[2] := 'filosofia';
    vN[3] := 'biologia';
    vN[4] := 'arte';
    vN[5] := 'computacion';
    vN[6] := 'medicina';
    vN[7] := 'ingenieria';
end;



function conteoLibrosEnRango (a : arbol	; cod1, cod2 : integer) : integer;
begin
	if a = nil then
		conteoLibrosEnRango := 0
	else
		if (a^.codAutor >= cod1) and (a^.codAutor <= cod2) then
			conteoLibrosEnRango := a^.cantLibros + conteoLibrosEnRango(a^.HI,cod1, cod2) + conteoLibrosEnRango(a^.HD,cod1, cod2)
		else
			conteoLibrosEnRango := conteoLibrosEnRango(a^.HI,cod1, cod2) + conteoLibrosEnRango(a^.HD,cod1, cod2)
end;


var
	a : arbol;
	vN: vNombres;
	 vG : vectorGeneros;
	 nombre : string;
	 cod1, cod2, aux : integer;
begin
	a := nil;
	cargarVectorNombre(vN);
	
	cargarArbol(a, vG);
	
	incisoB(vG, vN, nombre);
	if vG[1].cantLibros > 0 then
		writeln('El género con más libros es: ', nombre)
	else
		writeln('No se ingresaron libros.');
		

		
	if a <> nil then
		begin
			write('ingrese codigo de autor: ') ;readln(cod1);
			write('ingrese codigo de autor: ') ;readln(cod2);
			
			if cod1 > cod2 then
				begin
					aux := cod2;
					cod2 := cod1;
					cod1 := aux;
				end;
				
			writeln('cantidad de libros total con los generos ingresados: ' , conteoLibrosEnRango(a, cod1, cod2));	
			
		end;
end.
	
	
	
		
