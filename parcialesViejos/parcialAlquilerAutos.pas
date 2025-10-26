{

Una empresa de alquiler de autos desea procesar la información de sus alquileres.
a) Implementar un módulo que lea información de los alquileres y retorne un vector que agrupe los alquileres de
acuerdo a la cantidad de días de alquiler. Para cada cantidad de días, los alquileres deben almacenarse en un
árbol binario de búsqueda ordenado por número de chasis del auto.
De cada alquiler se lee: dni del cliente, número de chasis y cantidad de días (de 1 a 7). La lectura finaliza con el
número de chasis 0.
b) Implementar un módulo que reciba la estructura generada en a) y un dni D. Este módulo debe retornar la
cantidad de alquileres realizados por el dni D.
c) Implementar un módulo que reciba la estructura generada en a), un día D y dos números de chasis N1 y N2.
Este módulo debe retornar la cantidad de alquileres realizados en el día D, para los chasis entre N1 y N2 (ambos
incluidos).
NOTA: Implementar el programa principal, que invoque a los incisos a, b y c. En caso de ser necesario, puede utilizar los
módulos que se encuentran a continuación.

}


program parcialAlquilerAutos;

const
	hastaNum = 0;
	diaMin = 1;
	diaMax = 7;
	
type
	rangoDias = diaMin..diaMax;
	alquiler = record
		dniCliente : integer;
		numChasis : integer;
		cantDias : rangoDias;
	end;
	
	arbol = ^nodoArbol;
	
	nodoArbol = record
		dato : alquiler;
		HI : arbol;
		HD : arbol;
	end;
	
	vArboles = array [rangoDias ] of arbol;
	
	
	
procedure leerAlquiler (var alq : alquiler);
begin
	write('ingrese dni del cliente: ');readln(alq.dniCliente);
	write('ingrese numero de chasis: ');readln(alq.numChasis);
	write('ingrese cantidad de dias(del 1 al 7): ');readln(alq.cantDias);
end;	


procedure agregar (var a : arbol ; alq : alquiler);
begin
	if a = nil then
		begin
			new(a);
			a^.dato := alq;
			a^.HI := nil;
			a^.HD := nil;
		end
	else
		if alq.numChasis < a^.dato.numChasis then
			agregar(a^.HI, alq)
		else
			agregar(a^.HD, alq);
end;

	
procedure inicializarVector (var v : vArboles);
var
	i : rangoDias;
begin
	for i := diaMin to diaMax do
		v[ i ] := nil;
end;
	
procedure cargarVector (var v : vArboles);
var
	alq : alquiler;
begin
	inicializarVector(v);
	leerAlquiler(alq);
	while (alq.numChasis <> hastaNum) do
		begin
			agregar(v[ alq.cantDias ], alq);
			leerAlquiler(alq);
		end;
end;
	
	
	
function recorrerArbol1 (a : arbol ; dni : integer) : integer;
begin
	if a = nil then
		recorrerArbol1 := 0
	else
		if a^.dato.dniCliente = dni then
			recorrerArbol1 := recorrerArbol1(a^.HI, dni) + recorrerArbol1(a^.HD, dni) + 1
		else
			recorrerArbol1 := recorrerArbol1(a^.HI, dni) + recorrerArbol1(a^.HD, dni);
end;
	
	
function incisoB (v : vArboles; dni : integer) : integer;
var
	conteoTotal : integer;
	i : rangoDias;
begin
	conteoTotal := 0;
	for i := diaMin to diaMax do 
		begin
			if v[ i ] <> nil then
				conteoTotal :=conteoTotal + recorrerArbol1(v[ i ], dni)
		end;
		
	incisoB := conteoTotal	;
end;
	
	
	
	
function recorrerArbolDia (a : arbol; n1,n2 : integer) : integer;
begin
	if a = nil then
		recorrerArbolDia := 0
	else
		if  (a^.dato.numChasis < n1)  then
			recorrerArbolDia := recorrerArbolDia(a^.HD, n1,n2)
		else
			if  (a^.dato.numChasis  > n2)  then
				recorrerArbolDia := recorrerArbolDia(a^.HI, n1,n2)
			else
				begin
					recorrerArbolDia := recorrerArbolDia(a^.HI, n1, n2) + recorrerArbolDia(a^.HD, n1, n2) + 1;
				end;
end;
	
	
	
function incisoC (v : vArboles ; dia,n1,n2 : integer) : integer;
begin
	incisoC := recorrerArbolDia(v[ dia ],n1,n2);
end;


	
	
	
var
v : vArboles;
dia,dni,n1,n2 : integer;
aux : integer;
begin
//inciso A
cargarVector(v);

//inciso B
write('ingrese dni: ');
readln(dni);
writeln('el dni ',dni,' hizo ',incisoB(v,dni),' alquileres');

//inciso C
write('ingrese dia: ');
readln(dia);

write('ingrese N1: ');readln(n1);
write('ingrese N2: ');readln(n2);

if n1 > n2 then
	begin
		aux := n2;
		n2 := n1;
		n1 := aux;
	end;

writeln('el dia ',dia,' se hicieron ',incisoC(v,dia,n1,n2),' alquileres de autos con chasis entre ',n1,' y ',n2);


end.
	
	
	
	
