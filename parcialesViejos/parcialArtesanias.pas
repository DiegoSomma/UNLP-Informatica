program parcialArtesanias;

const
	rangoCodMin = 1;
	rangoCodMax = 8;
	hastaNum = 0;
	
type
	rangoCodigos = rangoCodMin..rangoCodMax;
	
	artesania = record
		numIdentificacion : integer;
		dniArtesano : integer;
		codMaterialBase : integer;
	end;
	
	
	arbol = ^nodoArbol;
	
	nodoArbol = record
		dni : integer;
		cantArtesania : integer;
		HI : arbol;
		HD : arbol;
	end;
	
	rVector = record
		codMaterial : integer;
		cantArtesaniaCod : integer;
	end;
	
	vector = array [rangoCodigos] of rVector;
	vectorNombres = array [rangoCodigos] of string;

procedure inicializarVector (var v : vector);
var
	i : rangoCodigos;
begin
	for i := rangoCodMin to rangoCodMax do
		begin
			v[ i ].codMaterial := i;
			v[ i ].cantArtesaniaCod := 0;
		end;
end;



procedure leerArtesania (var art : artesania);
begin
	art.dniArtesano := random(10000);
	if (art.dniArtesano <> hastaNum) then
		begin
			art.numIdentificacion  := random(100) + 2000;
			art.codMaterialBase := random (8) + 1 ;
		end;
end;

procedure cargarArbol (var a : arbol ; art : artesania);
begin
	if (a = nil) then
		begin
			new(a);
			a^.dni := art.dniArtesano;
			a^.cantArtesania := 1;
			a^.HI := nil;
			a^.HD := nil;
		end
	else
		if a^.dni = art.dniArtesano then
			a^.cantArtesania := a^.cantArtesania + 1
		else
			if art.dniArtesano < a^.dni then cargarArbol(a^.HI, art)
			else
				cargarArbol(a^.HD, art);
end;



procedure crearEstructuras (var a : arbol ; var v : vector);
var
	art : artesania;
begin
	inicializarVector(v);
	leerArtesania(art);
	while (art.dniArtesano <> hastaNum) do
		begin
			cargarArbol(a, art);
			
			v[ art.codMaterialBase ].cantArtesaniaCod := v[ art.codMaterialBase ].cantArtesaniaCod + 1;
							
			leerArtesania(art);
		end;
end;


function incisoA (a : arbol ; dni : integer) : integer;
begin
	if a = nil then
		incisoA := 0
	else
		if a^.dni < dni then
			incisoA := 1 + incisoA(a^.HI, dni) + incisoA(a^.HD, dni)
		else
			incisoA := incisoA(a^.HI, dni);
end;



procedure ordenarVectorSeleccion(var v: vector; dimlog: integer);
var
  i, j, pos: integer;
  item: rVector;
begin
  for i := 1 to dimlog - 1 do
  begin
    pos := i;
    for j := i + 1 to dimlog do
      if (v[j].cantArtesaniaCod < v[pos].cantArtesaniaCod) then
        pos := j;

    item := v[pos];
    v[pos] := v[i];
    v[i] := item;
  end;
end;
	

procedure incisoB (var v : vector ; var nombreMax : string ; vN : vectorNombres ; var encontro : boolean );
var
	max : integer;
	i : integer;
begin
	ordenarVectorSeleccion(v, rangoCodMax);
	encontro := False;
	{
	en el caso q se ordene de mayor a menor
	if v[ 1 ].cantArtesaniaCod  = 0 then
		encontro := False;
	else
		begin
		nombreMax := vN[ v[ 1 ].codMaterial];
		encontro := True;
		end;
	}	
		
	{
	//en el caso q se ordene de menor a mayor
	max := 0;
	for i := 1 to 8 do
		begin
			if v[ i ].cantArtesaniaCod > max then
				begin
					max :=  v[ i ].cantArtesaniaCod;
					nombreMax := vN[ v[ i ].codMaterial];
					encontro := True;
				end;
		end;
	}
end;


procedure cargarVectorNombres (var vN : vectorNombres);
begin
	vN[ 1 ] := 'madera';
	vN[ 2 ] := 'yeso';
	vN[ 3 ] := 'ceramica';
	vN[ 4 ] := 'vidrio';
	vN[ 5 ] := 'acero';
	vN[ 6 ] := 'porcelana';
	vN[ 7 ] := 'lana';
	vN[ 8 ] := 'carton';
end;


var
a : arbol;
v : vector;
vN : vectorNombres;
dni : integer;
nombre : string;
encontro : boolean;
begin
	randomize;
	a := nil;
	cargarVectorNombres(vN);
	crearEstructuras(a, v);
	
	
	write('ingrese numero de dni: ');readln(dni);
	write('hubieron ',incisoA(a, dni),' artesanos con dni menor a ',dni); 
	
	incisoB(v, nombre, vN, encontro);
	if encontro then
		write('nombre del material con mayor artesanias: ',nombre)
	else
		write('no se encontró nombre maximo');
end.
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
