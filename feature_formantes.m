function [ formantes_media, formantes_var ] = feature_formantes( signal, fs_audio, l1, rate1 )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NAME
%   feature_formantes - Calcula matriz de medias y varianzas de los
%   formantes
%
% SYNOPSIS
%   [ formantes_media, formantes_var ] = feature_formantes( signal, fs_audio, l1, rate1 )
%
% DESCRIPTION
% Esta funcion extrae la matriz de los 3 primeros formantes de un audio con 
% una ventana % relativamente pequeña (20 ms) y posteriormente redimensiona 
% ese vector con la ventana de nivel 1 calculando la media y la varianza de 
% la ventana
%
% INPUTS
%   
%   signal    	Audio o porción de audio del que queremos extraer los
%               formantes
%
%   fs_audio    Frecuencia de muestreo del audio
%
%   l1          Tamaño de ventana en segundos del nivel 1 (pequeña)
%
%   rate1       Rate entre l1 e inc_l1
%
%   OUTPUTS:
%
%   formantes_media     matriz de medias de formantes del audio
%
%   formantes_var       matriz de varianzas de formantes del audio
%
% SEE ALSO:
%   formant_signal.m
%   redimensionar.m  
%
% AUTHOR
%   Alba Minguez, Junio 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    win = 0.02; %en segundos [20 ms]
    r = 0.5;
    inc = win*r; %en segundos [10 ms]

    matriz_formantes = formant_signal( signal, win, inc, fs_audio);

    %Numero de muestras en 0.01 seg (sera el incremento para redim)
    win_red = l1/inc;
    inc_red = win_red*rate1;
    formantes_media = [];
    formantes_var = [];

    for j=1:size(matriz_formantes,1)

        formantes_media(j,:) = redimensionar(matriz_formantes(j,:), win_red, inc_red, 'media')';
        formantes_var(j,:) = redimensionar(matriz_formantes(j,:), win_red, inc_red, 'varianza')';

    end

end

