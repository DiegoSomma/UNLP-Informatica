program parcialEntregas;

const
	hastaNum = 0;

type
	compra = record
		codComida : integer;
		codCliente : integer;
		categoria : string;
		categoriaNumero : integer;
	end;
	
	rArbol = record
		codComida : integer;
		cantEntregas :integer;
	end;
	
	arbol = ^nodoArbol;
	nodoArbol = record
		dato : rArbol;
		hi : arbol;
		hd : arbol;
	end;
	
	rVector = record
		codigo : integer;
		categoria : string;
		cantEntregas : integer;
	end;
	
	vector = array [1..5] of rVector;	
	
	

procedure leerCompra (var c : compra);
var
	v : array[1.. 5] of string = ('full', 'super', 'media', 'normal', 'basica');
begin
	c.codCliente := random(200);
	if c.codCliente <> hastaNum then
		begin
			c.categoriaNumero := random(5) + 1;
			c.categoria := v[c . categoriaNumero];
			c.codComida := random(200) + 1000;
		end;
end;
	

procedure agregar (var a : arbol ; c : compra);
begin
	if a = nil then
		begin
			new(a);
			a^.dato.codComida := c.codComida;
			a^.dato.cantEntregas := 1;
			a^.hi := nil;
			a^.hd := nil;
		end
	else
		if a^.dato.codComida = c.codComida then
			a^.dato.cantEntregas := a^.dato.cantEntregas + 1
		else
			if a^.dato.codComida > c.codComida then
				agregar(a^.HI, c)
			else
				agregar(a^.HD, c);
end;	


	
procedure inicializarVector(var v : vector);
var
	i : integer;
	v2 : array[1.. 5] of string = ('full', 'super', 'media', 'normal', 'basica');
begin
	for i := 1 to 5 do
		begin
			v[ i ].categoria := v2[ i ];
			v[ i ].cantEntregas := 0;
			v[ i ].codigo := i
		end;
end;
	
	
procedure cargarEstructuras (var a : arbol ; var v : vector);
var
	c : compra;
begin
	inicializarVector(v);
	leerCompra(c);
	while c.codCliente <> hastaNum do
		begin
			agregar(a, c);
			v[ c.categoriaNumero ].cantEntregas :=  v[ c.categoriaNumero ].cantEntregas + 1;
			leerCompra(c);
		end;
			
end;
	
	
function incisoB (a : arbol ; codigoComida : integer) : integer;
begin
	if a = nil then
		incisoB := 0
	else
		if a^.dato.codComida = codigoComida then
			incisoB := a^.dato.cantEntregas
		else
			if  a^.dato.codComida > codigoComida then
				incisoB := incisoB(a^.HI,codigoComida)
			else
				incisoB := incisoB(a^.HD,codigoComida)
end;	
	
	
procedure seleccion (var v : vector; dimlog : integer);
var
	i, j, pos :integer;
	item : rVector;
begin
	for i := 1 to dimlog - 1 do 
		begin
			pos := i;
			for j := i + 1 to dimlog do
				if v[ j ].cantEntregas < v[ pos ].cantEntregas then
					pos := j;
					
			item := v[ pos ];
			v[ pos ] := v[ i ];
			v[ i ] := item;
		end;
end;



	
procedure incisoC (var v : vector; 	var cat_max : string);
var
	i : integer;
	diml : integer;
	max : integer;
begin
	diml := 5;
	seleccion(v,diml); // lo ordeno de menor a mayor por cant Entregas
	max := -1;
	for i := 1 to 5 do
		begin
				if v[ i ].cantEntregas > max then
					begin
						max := v[ i ].cantEntregas;
						cat_max := v[ i ].categoria;
					end;
		end;
	
end;
	
	
	
	
var
	a : arbol;
	v : vector;
	
	codigo : integer;
	categoriaMax : string;
begin
	a := nil;
	//inciso A
	cargarEstructuras(a, v);
	
	// inciso B
	write('ingrse codigo: ');readln(codigo);
	write('cantidad de entregas con el codigo de comida ingresado: ',incisoB(a,codigo));
	
	//inciso C
	categoriaMax := ' ';
	incisoC(v, categoriaMax);
	if categoriaMax <> ' ' then
		write('categoria con mas entregas: ',categoriaMax)
	else
		write('vector vacio');
	
	
end.
	
		
		
