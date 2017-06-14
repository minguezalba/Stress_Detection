function etiquetado1_id(identificador, dir_originals, dir_labels, vad_rec, vad_base, porcentaje, n1_HR, inc_n1_HR)
% NAME
%   etiquetado1_id
% SYNOPSIS
%   etiquetado1_id(identificador, dir_originals, dir_labels, vad_rec, vad_base, porcentaje, n1_HR, inc_n1_HR)

% DESCRIPTION
% Crea y guarda en archivos .mat las etiquetas correspondientes a un ID
% concreto. Estas etiquetas son calculadas basandonos en 2 umbrales
% diferentes para distinguir el estres/no estres. 
% Opcion 1: nos basamos en la el valor de media+desv del vector Zecg del 
% archivo base. 
% Opcion 2: nos basamos en percentiles a partir de un valor de porcentaje
% que elegimos a mano. 
%
% INPUTS
%   identificador   ID del usuario del que queremos extraer las etiquetas
%
%   dir_originals   carpeta desde donde tomamos los archivos Zecg que
%                   contienen los valores de HR
%
%   dir_labels      carpeta donde guardamos los vectores de etiquetas
%
%   vad_rec         vector de 1's y 0's para eliminar silencios del vector
%                   de etiquetas del archivo recording
%
%   vad_base        vector de 1's y 0's para eliminar silencios del vector
%                   de etiquetas del archivo base
%
%   porcentaje      valor de 0-100 para determinar los percentiles en la
%                   opcion 2 del etiquetado
%
%   n1_HR           tamaño de ventana en numero de muestras para el 
%                   etiquetado a nivel 1
%
%   inc_n1_HR       incremento de ventana en numero de muestras para el 
%                   etiquetado a nivel 1
%
% Variables:
%
%   umbral 1   umbral para decidir estres/no estres para la opcion 1
%              (basado en media+desv del archivo base)
%   umbral 2   umbral para decidir estres/no estres para la opcion 2
%              (basado percentil del archivo base)
%
% AUTHOR
%   Alba Minguez, Junio 2017
%
% SEE ALSO
%   crear_labels.m
%   clean_vector.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 1. Buscamos en la carpeta /originals/ los archivos tanto de recording 
% como base que contienen los vectores de HR
    
    s1 = 'ID_';
    s3 = '_sensors.mat';
    s4 = '_baseline_sensors.mat';
    s5 = '_prebaseline_sensors.mat';
    s6 = '_base.mat';
    s7 = '_rec.mat';

    Zecg_rec_name = strcat(dir_originals,s1,identificador,s3);
    Zecg_base1_name = strcat(dir_originals,s1,identificador,s4);
    Zecg_base2_name = strcat(dir_originals,s1,identificador,s5);
    
    % Comprobamos si existen los archivos y cargamos los datos
    
    % Archivo con datos Zecg Recording
    if exist(Zecg_rec_name)~=0
        load(Zecg_rec_name)
        Zecg_rec = v_Zecg;           
    end

    % Archivo con datos Zecg Base (Baseline/Prebaseline)
    if exist(Zecg_base1_name)~=0 || exist(Zecg_base2_name)~=0

        if exist(Zecg_base1_name)~=0
            load(Zecg_base1_name) %devuelve v_Zecg
            Zecg_base = v_Zecg;          
        end

        if exist(Zecg_base2_name)~=0
            load(Zecg_base2_name) %devuelve v_Zecg
            Zecg_base = v_Zecg;          
        end

    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2. Definimos umbrales de decisión a partir de los archivos base

    % OPCIÓN 1: MEDIA + DESV

        media = mean(Zecg_base(:,1));
        desv = std(Zecg_base(:,1));
        umbral1 = media + desv;
    
    
    % OPCIÓN 2: PERCENTIL

        umbral2 = prctile(Zecg_base(:,1), porcentaje);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 3. Creamos las etiquetas para ambos archivos utilizando ambas opciones

    [ labels1_base, labels2_base ] = crear_labels(Zecg_base, umbral1, umbral2, n1_HR, inc_n1_HR);
    [ labels1_rec, labels2_rec ] = crear_labels(Zecg_rec, umbral1, umbral2, n1_HR, inc_n1_HR);
    
    % labels1_base son las etiquetas para el archivo base obtenidas
    % mediante la opción 1
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% OJO!! En este momento deben coincidir las dimensiones de labels1_base con
% las dimensiones de vad_base
    
% A veces da el vector de vad más grande (ultima trama), así que lo 
% recortamos para ajustarse a las dimensiones de labels

vad_base = vad_base(1:length(labels1_base)-1);
vad_rec = vad_rec(1:length(labels1_rec)-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 4. Recortamos las zonas de silencio de los vectores de etiquetas

    labels1_base = labels1_base(vad_base == 1);
    labels2_base = labels2_base(vad_base == 1);
    
    labels1_rec = labels1_rec(vad_rec == 1);
    labels2_rec = labels2_rec(vad_rec == 1);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 5. Limpiamos los vectores de etiquetas

    % 'condicion': Numero de muestras que debe haber seguidas para que se 
    % considere silencio o sonido
    
    condicion = 2; % En este caso el nº muestras coincide con nº segundos
    
    labels1_base_clean = clean_vector( labels1_base, condicion ); 
    labels2_base_clean = clean_vector( labels2_base, condicion ); 
    
    labels1_rec_clean = clean_vector( labels1_rec, condicion ); 
    labels2_rec_clean = clean_vector( labels2_rec, condicion );
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 6. Guardamos los vectores de etiquetas en el directorio /labels/
    
    % Recordamos s1 = ID_
    %            s6 = '_base.mat';
    %            s7 = '_rec.mat';

    s8 = 'L11_'; % Etiquetas nivel 1 opcion 1 "L11_ID_XXXXXXXX_base.mat"
    s9 = 'L12_'; % Etiquetas nivel 1 opcion 2 "L12_ID_XXXXXXXX_rec.mat"

    path_labels1_base = strcat(dir_labels, s8, s1, identificador, s6);
    path_labels2_base = strcat(dir_labels, s9, s1, identificador, s6);
    
    path_labels1_rec = strcat(dir_labels, s8, s1, identificador, s7);
    path_labels2_rec = strcat(dir_labels, s9, s1, identificador, s7);
    
    % Utilizamos la variable auxiliar "labels1" para luego utilizar este
    % nombre de variable en la funcino etiquetado2()
    
    labels1 = labels1_base_clean';
    save(path_labels1_base, 'labels1' );
    
    labels1 = labels2_base_clean';
    save(path_labels2_base, 'labels1' );
    
    labels1 = labels1_rec_clean';
    save(path_labels1_rec, 'labels1' );

    labels1 = labels2_rec_clean';
    save(path_labels2_rec, 'labels1' );


end

