function  matriz1_features = features1_signal( signal, fs_audio, l1, inc_l1 , rate1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NAME
%   features1_signal - Extrae las características de un audio a nivel 1
%
% SYNOPSIS
%   matriz1_features = features1_signal( signal, fs_audio, l1, inc_l1 , rate1)
%
% DESCRIPTION
% Esta funcion extrae las caracteristicas de un audio o porción de audio a
% nivel 1 con los parametros correspondientes. Para la mayoría de
% características, extraemos los valores para ventanas pequeñas de unos 20
% ms y posteriormente, extraemos vectores de medias y de varianzas con la
% ventana a nivel 1 correspondiente
%
% INPUTS
%   
%   signal    	Audio o porción de audio del que queremos extraer las 
%               caracteristicas
%
%   fs_audio    Frecuencia de muestreo del audio
%   l1          Tamaño de ventana en segundos del nivel 1 (pequeña)
%   inc_l1      Incremento de ventana en segundos del nivel 1
%   rate1       Rate entre l1 e inc_l1
%
%   OUTPUTS:
%
%   matriz1_features    matriz de caracteristicas con dimension 33xN_tramas
%                       donde:
%                       fila 1      vector medias pitch
%                       fila 2      vector varianzas pitch
%                       fila 3-14   matriz medias mfcc
%                       fila 15-26  matriz varianzas mfcc
%                       fila 27-29  matriz medias formantes
%                       fila 30-32  matriz varianza formantes
%                       fila 33     vector energía
%
% SEE ALSO:
%   feature_pitch.m
%   feature_mfcc.m
%   feature_formantes.m
%   feature_energia.m
%   
%
% AUTHOR
%   Alba Minguez, Junio 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    matriz1_features = [];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % MATRIZ 1: NIVEL VENTANA 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 1. PITCH

    [ pitch1_media, pitch1_var ] = feature_pitch( signal, fs_audio, l1, rate1 );
    
    %Hay un problema de dimension para el audio prebaseline 334844205.
    %Hay que añadir un 0 para que cuadren las dimensiones que
    %posteriormente se elimina solo al ajustar dimensiones con las
    %etiquetas.
%     pitch1_media = horzcat(pitch1_media, 0);
%     pitch1_var = horzcat(pitch1_var, 0);
    
    matriz1_features = vertcat(matriz1_features, pitch1_media);
    matriz1_features = vertcat(matriz1_features, pitch1_var);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 2. MFCC

    [ mfcc1_media, mfcc1_var ] = feature_mfcc( signal, fs_audio, l1, rate1 ); %debe ser una matriz de 12xn_tramas
    matriz1_features = vertcat(matriz1_features, mfcc1_media);
    matriz1_features = vertcat(matriz1_features, mfcc1_var);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 3. FORMANTES 

    [ formantes1_media, formantes1_var ] = feature_formantes( signal, fs_audio, l1, rate1 );
    matriz1_features = vertcat(matriz1_features, formantes1_media);
    matriz1_features = vertcat(matriz1_features, formantes1_var);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 4. ENERGIA 

    energia1 = feature_energia( signal, fs_audio, l1, inc_l1 );
    matriz1_features = vertcat(matriz1_features, energia1);



end

