function [ID, value_Zecg, time_Zecg, value_Zts, time_Zts] = analisis_xml(nombre, tipo )
% NAME
%   analisis_xml
% SYNOPSIS
%   [ID, value_Zecg, time_Zecg, value_Zts, time_Zts] = analisis_xml(nombre, tipo )

% DESCRIPTION
%   Analiza los ficheros xml de sensors y extrae sus datos en forma de
%   vectores junto con su timestamp relativo.
% INPUTS
%   nombre    (char) nombre de archivo .xml del que queremos extraer los
%              datos
%   tipo      (scalar) tipo de archivo que es el xml, a elegir entre 3
%             opciones: 0 = Prebaseline, 1 = Baseline, 2 = Recording)
% OUTPUTS
%   ID          (scalar) ID al que pertenece el archivo xml
%   value_Zecg  (vector) Valores de Zecg extraidos del fichero xml
%   time_Zecg   (vector) Timestamps para los valores Zecg correspondientes
%   value_Zts   (vector) Valores de Zts extraidos del fichero xml
%   time_Zts    (vector) Timestamps para los valores Zts correspondientes
%
% AUTHOR
%   Alba Minguez, Junio 2017
% SEE ALSO
%   xml2struct.m
%   busca_ID.m

datos = xml2struct(strcat('recordings/',nombre)); %Nombre con /recording incluido

% Comprobamos qué tipo de struct vamos a procesar

switch tipo
    
    % UTC_0 = UTC inicial
    % total = numero de lineas Zecg/Zts que vamos a procesar en el fichero
    
    case 0 % Caso PreBaseline
        
        UTC_0 = str2double(datos.PreBaseline.Attributes.Start);
        total = length(datos.PreBaseline.Description.Key);
        
    case 1 % Caso Baseline
        
        UTC_0 = str2double(datos.Baseline.Attributes.Start);
        total = length(datos.Baseline.Description.Key);
        
        
    case 2 % Caso Recording
        
        UTC_0 = str2double(datos.Recording.Attributes.Start);
        total = length(datos.Recording.Description.Key);
        
        
    otherwise
        sprintf('Error');
        
end % end switch tipo

% Inicializamos variables

cont_Zecg = 1;
cont_Zts = 1;
v_Zecg = double([]);
v_Zts_aux = double([]);


for i=1:total
    
    switch tipo
        
        % name = puede tomar valor 'Zecg' o 'Zts'
        % texto = pareja de datos (valor, UTC)
        
        case 0 % Caso PreBaseline
            
            name = datos.PreBaseline.Description.Key{1,i}.Attributes.Name;
            texto = datos.PreBaseline.Description.Key{1,i}.Text;
            
        case 1 % Caso Baseline
            
            name = datos.Baseline.Description.Key{1,i}.Attributes.Name;
            texto = datos.Baseline.Description.Key{1,i}.Text;
            
        case 2 % Caso Recording
            
            name = datos.Recording.Description.Key{1,i}.Attributes.Name;
            texto = datos.Recording.Description.Key{1,i}.Text;
            
        otherwise
            sprintf('Error');
            
    end % end switch 1
    
    celda = strsplit(texto,', '); %Separamos los datos por la coma
    UTC_f = str2double(celda{1,2}); %UTC final
    UTC_r = UTC_f - UTC_0; %UTC relativo
    
    switch name
        
        case 'Zecg'
            
            Zecg = str2double(celda{1,1});
            
            % Pasamos los signed a unsigned.
            % Unsigned de 0 a 255. Signed de -128 a 127. Ejemplo:
            % -128 seria 127 + 129-(-128*-1) = 128
            % -126 seria 127 + 129-(-126*-1) = 130
            % -120 seria 127 + 129-(-120*-1) = 136
            
            if Zecg < 0
                
                Zecg = 127 + 129 - (Zecg*-1);
                
            end
            
            v_Zecg(cont_Zecg,:) = [Zecg, UTC_r];
            cont_Zecg = cont_Zecg + 1;
            
        case 'Zts'
            
            Zts = str2double(celda{1,1});
            
            v_Zts_aux(cont_Zts,:) = [Zts, UTC_r];
            cont_Zts = cont_Zts + 1;
            
        otherwise
            sprintf('Error');
            
    end %end switch
    
end % end for

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Una vez extraidos los datos de los ficheros xml, procesamos la
% información para poder utilizarla.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1. Procesado vector v_Zecg

% Tras varias observaciones, asumimos que las muestras del vector Zecg
% aparecen con una frecuencia de 1 por segundo. Por tanto, añadimos el
% vector de timestamps correspondiente

% Ponemos una muestra por segundo

v_Zecg(:,2) = (0:1:size(v_Zecg, 1)-1)';


% 2. Procesado vector v_Zts

if isempty(v_Zts_aux)==0 %Si el archivo contiene valores Zts
    
    % 2.1 Ajuste debido al reloj de 16 bits
    
    % Primero ordenamos los timestamp dentro de un mismo instante de
    % tiempo de menor a mayor (ya que por defecto viene de mayor a menor)
    
    maximo = max(v_Zts_aux(:,2));
    diferencia=0;
    
    
    for n=0:maximo %Comprobamos cada valor de tiempo
        
        % Buscamos cuantos valores de Zts tiene ese valor de tiempo
        num_veces = sum(v_Zts_aux(:,2)==n);
        
        if(num_veces ~=0)
            
            v_posiciones = find(v_Zts_aux(:,2)==n);
            %Nos quedamos con la porcion de la matriz que nos interesa
            array_aux = v_Zts_aux(v_posiciones,:);
            
            % Buscamos si en esa porcion se produce el reinicio de reloj a
            % causa de los 16 bits
            pos_salto = find(array_aux(:,1)>0 & array_aux(:,1)<2000);
            
            if num_veces>1 && isempty(pos_salto)==0
                diferencia = abs(array_aux(1,1)-array_aux(2,1));
            end
            
            
            if num_veces > 1
                
                if isempty(pos_salto)==0 && diferencia > 10000
                    %pos_salto no vacio y diferencia entre n y n-1 grande Hay salto de reloj
                    
                    if pos_salto(1)==1 %desordenado (num pequeño primero)
                        
                        resta = 65536*ones(length(pos_salto),1);
                        array_aux(pos_salto,1) = array_aux(pos_salto,1)+resta;
                        
                        array_aux = sortrows(array_aux);
                        
                        array_aux(pos_salto+1,1) = array_aux(pos_salto+1,1)-resta;
                        
                    end
                    
                    for i=1:num_veces
                        
                        v_Zts_aux(v_posiciones(i)) = array_aux(i);
                        
                    end
                    
                    
                else %no hay salto de reloj
                    
                    array_aux = sortrows(array_aux);
                    
                    for i=1:num_veces
                        
                        v_Zts_aux(v_posiciones(i)) = array_aux(i);
                        
                    end
                    
                end
                
                
            else % solo hay una muestra para ese instante
                
                for i=1:num_veces
                    
                    v_Zts_aux(v_posiciones(i)) = array_aux(i);
                    
                end
                
            end
            
            
            
        end
    end
    
    
    % 2.2 Quitamos los saltos de reloj: vamos a hacer que cada vez que 
    % encuentre un salto, sume multiplos de 65536. 
    
    % Vamos a detectar donde se producen saltos
    
    saltos = zeros(size(v_Zts_aux,1),1);
    
    for j=1:size(v_Zts_aux,1)-1
        
        if v_Zts_aux(j,1)> v_Zts_aux((j+1),1)
            
            saltos(j+1) = 1;
            
        end
        
    end
    
    % Ahora sumamos 65536 cada vez que encontremos un salto
    
    k=0;
    
    for j=1:size(v_Zts_aux,1)
        
        if saltos(j)==1
            
            k = k+1;
            
        end
        
        v_Zts_aux(j) = v_Zts_aux(j) + (k*65536);
        
    end
    
    
    % 2.3 Creamos el vector de timestamps para los valores Zts
    
    ind = 1;
    
    %Descartamos la primera muestra ya que no le podemos restar su anterior
    
    for k=2:size(v_Zts_aux,1) 
        
        v_Zts(ind) = v_Zts_aux(k) - v_Zts_aux(k-1);
        ind = ind+1;
        
    end
    
    v_Zts = v_Zts';
    
    % Juntamos el vector de valores junto con el vector tiempo
    v_Zts = [v_Zts v_Zts_aux(2:size(v_Zts_aux,1),2)];
    
    % 2.4 Hasta ahora tenemos un vector de valores con su valor de tiempo
    % correspondiente. Sin embargo, en este momento podemos encontrar
    % varios valores de Zts para el mismo instante. Vamos a corregir esto.
    
    % v_Zts_medio: procesamos el vector para tener 1 muestra por segundo
    
    % Elegimos una ventana y un desplazamiento y muestreamos el vector de Zts
    % para tener una muestra cada 1 seg. Deberia tener al final mas o menos la
    % misma dimension que v_Zecg
    
    win = 2; % En segundos
    desp = 1; %En segundos
    index = 1; %indice para guardar valores en el nuevo vector
    k=0;
    cont=0;
    total=0;
    j=1;
    
    for i=1:size(v_Zecg,1)-1 %veces que tiene que recorrer el vector entero
        
        % bucle para encontrar donde va a empezar a contar teniendo en cuenta
        % que tiene que coger un rango de 2 segundos [k,k+win)
        
        while v_Zts(j,2)<k && j < size(v_Zts,1)-1
            
            j = j+1;
            
        end
        
        % Ya sabemos a partir de que posicion vamos a analizar el vector
        % de Zts ---> posicion j
        
        % Ahora haremos una media de todos los valores que tengan en su
        % columna 2 los valores de los segundos k y k+desp
        
        while ((v_Zts(j,2)== k) || (v_Zts(j,2) == desp+k)) && j < size(v_Zts,1)-1
            
            cont = cont+1;
            total = total+v_Zts(j,1);
            j = j+1;
            
        end
        
        j=1; % Reiniciamos el indice
        
        if cont~=0
            Zts_medio(index) = total/cont; %Guardamos el valor medio de lo anterior
            index = index+1;
        end
        total = 0;
        cont = 0;
        k = k + 1;
        
        
    end
    
    Zts_medio = Zts_medio';
    Zts_medio(:,2) = (0:1:size(Zts_medio, 1)-1)';
    
    % 2.5 Ponemos Zts a beats per minute (bpm)
    
    % (60*1000)/deltaZts --> bpm
    
    Zts_medio(:,1) = ((60*1000)./Zts_medio(:,1))';
    
else % Si el vector Zts SI esta vacio, lo rellenamos de ceros
    
    Zts_medio(:,1) = zeros(size(v_Zecg,1),1);
    Zts_medio(:,2) = v_Zecg(:,2);
    
end 

% 3. Ajustamos dimensiones de Zts y Zecg si es necesario

if size(Zts_medio,1)<size(v_Zecg,1)
    
    v_Zecg = v_Zecg(1:size(Zts_medio,1),:);
    
elseif size(Zts_medio,1)>size(v_Zecg,1)
    
    Zts_medio = Zts_medio(1:size(v_Zecg,1),:);
    
end

value_Zecg = v_Zecg(:,1);
time_Zecg = v_Zecg(:,2);
value_Zts = Zts_medio(:,1);
time_Zts = Zts_medio(:,2);

% 4. Extraccion del ID

ID = busca_ID(nombre);

end % end funcion

