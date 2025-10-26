{

Una clinica necesita un sistema para el procesamiento de las atenciones realizadas a los pacientes.
a) Implementar un módulo que lea información de las atenciones. De cada atención se lee: DNI del paciente,
número de mes, y código de diagnóstico (1 a 15). La lectura finaliza con el mes 0. Se sugiere utilizar el módulo
leerAtencion (). El módulo debe retornar dos estructuras de datos:
i. Una estructura de datos eficiente para la búsqueda por DNI del paciente. Para cada DNI debe almacenarse la
cantidad total de atenciones recibidas.
li. Otra estructura de datos con la cantidad de atenciones realizadas para cada diagnóstico.
b) Implementar un módulo que reciba la estructura generada en a) i., dos números de DNI y un valor entero x. Este
módulo debe retornar la cantidad de pacientes con más de x atenciones cuyos DNI están entre los 2 números de
DNI recibidos.
c) Implementar un módulo recursivo que reciba la estructura generada en a) il, y retorne la cantidad de
diagnósticos para los cuales la cantidad de atenciones fue cero.

NOTA: Implementar el programa principal, que invoque a los incisos a, b y c. En caso de ser necesario, puede utilizar los
módulos que se encuentran a continuación.

}


program parcialClinica; 

const
	hastaNum = 0;
	codMin = 1;
	codMax = 15;
	mesMin = 1;
	mesMax = 12;
	
type
	rangoMeses = mesMin..mesMax;
	rangoDiagnosticos = codMin..codMax;

	atencion = record
		dniPaciente : integer;
		numMes : rangoMeses;
		codigoDiagnostico : rangoDiagnosticos;
	end;

	rArbol = record
		dni : integer;
		cantAtenciones : integer;
	end;
	
	arbol = ^nodoArbol;
	nodoArbol = record
		dato : rArbol;
		hi : arbol;
		hd : arbol;
	end;
	
	vector = array [ rangoDiagnosticos ] of integer;


procedure leerAtencion (var ate : atencion);
begin
	write('ingrese dni del paciente: ');readln(ate.dniPaciente);
	if ate.dniPaciente <> hastaNum then
		begin
			write('ingrese mes(del 1 al 12): ');readln(ate.numMes);
			write('ingrese codigo del diagnostico: ');readln(ate.codigoDiagnostico);
		end;
end;



procedure agregar (var a : arbol ; ate : atencion);
begin
	if a = nil then
		begin
			new(a);
			a^.dato.dni := ate.dniPaciente;
			a^.dato.cantAtenciones := 1;
			a^.hi := nil;
			a^.hd := nil;
		end
	else
		if a^.dato.dni = ate.dniPaciente then
			a^.dato.cantAtenciones := a^.dato.cantAtenciones + 1
		else
			if a^.dato.dni > ate.dniPaciente then
				agregar(a^.hi, ate)
			else
				agregar(a^.hd, ate);
end;

procedure inicializarVector(var v: vector);
var
  i: rangoDiagnosticos;
begin
  for i := codMin to codMax do
    v[i] := 0;
end;

procedure cargarEstructuras (var a : arbol ; var  v : vector);
var
	ate : atencion;
begin
	inicializarVector(v);
	leerAtencion (ate);
	while ate.dniPaciente <> hastaNum do
		begin
			agregar(a, ate);
			v[ ate.codigoDiagnostico ] := v[ ate.codigoDiagnostico ] + 1;
			leerAtencion (ate);
		end;
end;



function incisoB(a: arbol; dniMin, dniMax, x: integer): integer;
begin
	if a = nil then
		incisoB := 0
	else 
			if a^.dato.dni <= dniMin then
				// Solo puede haber candidatos en subárbol derecho
				incisoB := incisoB(a^.hd, dniMin, dniMax, x)
			else	
				if a^.dato.dni >= dniMax then
				// Solo puede haber candidatos en subárbol izquierdo
				incisoB := incisoB(a^.hi, dniMin, dniMax, x)
				else
					begin
					// Está dentro del rango
						if a^.dato.cantAtenciones > x then
							incisoB := 1 + incisoB(a^.hi, dniMin, dniMax, x) + incisoB(a^.hd, dniMin, dniMax, x)
						else
							incisoB := incisoB(a^.hi, dniMin, dniMax, x) + incisoB(a^.hd, dniMin, dniMax, x);
	end;
end;

function incisoC (v : vector ; diml : integer) : integer;
begin
	if diml = 0 then
		incisoC := 0
	else
		if v[ diml ] = 0 then 
			incisoC := 1 + incisoC(v,diml - 1)
		else
			incisoC := incisoC(v,diml - 1);
end;






var
	a : arbol;
	v : vector;
	
	aux, dniMin, dniMax, x : integer;
	diml : integer;
begin
	a := nil;
	//inciso A 
	cargarEstructuras(a,v);
	
	//inciso B
	write('ingrese dni min: ');readln(dniMin);
	write('ingrese dni max: ');readln(dniMax);
	write('ingrese valor x: ');readln(x);
	if dniMin > dniMax then
		begin
			aux := dniMax;
			dniMax := dniMin;
			dniMin := aux;
		end;
		
	writeln('cantidad del inciso B: ',incisoB(a, dniMin, dniMax,x));	
	
	diml := codMax;
	writeln('cantidad de diagnostico con 0 pacientes: ',incisoC(v, diml));
end.














	














