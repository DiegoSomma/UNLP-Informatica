{
Una biblioteca necesita un sistema para procesar la información de los libros. De cada libro se conoce: ISBN, afio de
edición, código del autor y código de género (1 a 15).

a) Implementar un módulo que lea información de los libros y retorne una estructura de datos eficiente para la
búsqueda por código de autor que contenga código de autor y una lista de todos sus libros. La lectura finaliza al
ingresar el valor O para un ISBN.
b) Realizar un módulo que reciba la estructura generada en el inciso a) y un código. El módulo debe retornar una
lista con código de autor y su cantidad de libros, para cada autor con código superior al código ingresado.
c) Realizar un módulo recursivo que reciba la estructura generada en inciso b) y retorne cantidad y código de autor
con mayor cantidad de libros.
}


program parcialBiblioteca;

const
	hastaNum = 0; // valor del corte de la lectura de libro
	
type
	libro = record //declaro registro de libros
		ISBN : integer;
		anioEdicion : integer;
		codAutor : integer;
		codGenero : integer;
	end;
	
	listaLibros = ^PLista;
	PLista = record
		dato : libro;
		sig : listaLibros;
	end;
	
	arbol = ^nodoArbol;
	nodoArbol = record
		codAutor : integer;
		libros : listaLibros;
		HI : arbol;
		HD : arbol;
	end;
	
	listaB =^nodoListaB;
	
	perAutor = record
		codAutor : integer;
		totalLibros : integer;
	end;
	
	nodoListaB = record
		dato : perAutor;
		sig : listaB;
	end;

procedure agregarAdelante (var l : listaLibros ; lib : libro);
var
	nue : listaLibros;
begin
	new(nue);
	nue^.dato := lib;
	nue^.sig := l;
	l := nue;
end;

procedure agregar (var a : arbol ; lib : libro);
begin
	if a = nil then
		begin
			new(a);
			a^.codAutor := lib.codAutor;
			a^.libros := nil;
			agregarAdelante(a^.libros, lib);
			a^.HI := nil;
			a^.HD := nil;
		end
	else if a^.codAutor = lib.codAutor then
				agregarAdelante(a^.libros, lib)          //quiere decir que ese autor ya está en el arbol y le agrego el libro a la lista
				
			else	
					if lib.codAutor < a^.codAutor  
						then agregar(a^.HI, lib)
					
					else agregar(a^.HD, lib)
			
						
end;

procedure leerLibro(var lib : libro);
begin
	write('ingrese ISBN (0 para terminar): ');
	readln(lib.ISBN);
	if (lib.ISBN <> hastaNum) then
		begin
			write('ingrese año de edicion: ');
			readln(lib.anioEdicion);
			
			write('ingrese codigo del autor: ');
			readln(lib.codAutor);
			
			repeat
			write('ingrese codigo del genero (del 1 al 15): ');
			readln(lib.codGenero);
			until (lib.codGenero >= 1) and (lib.codGenero <= 15);
		end;
end;




procedure crearArbol (var a : arbol);
var
	lib : libro;
begin
	leerLibro(lib);
	while (lib.ISBN <> hastaNum) do
		begin
			agregar(a,lib);
			leerLibro(lib);
		end;
end;



//inciso B

procedure agregarAdelante2 (var LB : listaB ; codigoAutor : integer ; cantLibros : integer);
var
	nue : listaB;
begin
	new(nue);
	nue^.dato.codAutor := codigoAutor;
	nue^.dato.totalLibros := cantLibros;
	nue^.sig := LB;
	LB := nue;
end;


function cantLibros (L : listaLibros) : integer;
var
	contador : integer;
begin
	contador := 0;
	while l <> nil do
		begin
			contador := contador + 1;
			l := l^.sig;
		end;	
	cantLibros := contador;
end;


procedure crearLista (a : arbol ; codigo : integer ; var LB : listaB);
begin
	if a <> nil then
		begin
			crearLista (a^.HI, codigo, LB);
			
			if a^.codAutor > codigo then
				agregarAdelante2 (LB, a^.codAutor, (cantLibros(a^.libros)) );
				
			crearLista (a^.HD, codigo, LB);	
		end;
end;	
	
	
//INCISO C
procedure incisoC (LB : listaB ; var codAutorMax : integer ; var totalLibros : integer);
begin
	if LB <> nil then
		begin
			if LB^.dato.totalLibros > totalLibros then
				begin
					codAutorMax := LB^.dato.codAutor;
					totalLibros := LB^.dato.totalLibros;
				end;
				
			incisoC(LB^.sig , codAutorMax , totalLibros);
		end;
	
end;	
	
var
a : arbol;
LB : listaB;
codigo : integer;

codAutorMax : integer;
totalLibros : integer;
begin
//INCISO A
a := nil;
writeln('--- Carga de libros ---');
crearArbol(a);

//INCISO B
LB := nil;
write('ingrese un codigo: ');
readln(codigo);

crearLista(a, codigo, LB);

//INCISO C
if LB <> nil then
	begin
		codAutorMax := -1;
		totalLibros := -1;
		incisoC (LB,codAutorMax, totalLibros);
		write('el autor con codigo ',codAutorMax,' tiene mas libros (',totalLibros,') ');
	end
	else
		write('ningun escritor superó el codigo ',codigo);
end.
	
	
	
	
	
	
	
	
