function [ pitch_media, pitch_var ] = feature_pitch( signal, fs_audio, l1, rate1 )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NAME
%   feature_pitch - Calcula vector de medias y varianzas del pitch
%
% SYNOPSIS
%   [ pitch_media, pitch_var ] = feature_pitch( signal, fs_audio, l1, rate1 )
%
% DESCRIPTION
% Esta funcion extrae el vector de pitch de un audio con una ventana
% relativamente pequeña (20 ms) y posteriormente redimensiona ese vector
% con la ventana de nivel 1 calculando la media y la varianza de la ventana
%
% INPUTS
%   
%   signal    	Audio o porción de audio del que queremos extraer el pitch
%
%   fs_audio    Frecuencia de muestreo del audio
%
%   l1          Tamaño de ventana en segundos del nivel 1 (pequeña)
%
%   rate1       Rate entre l1 e inc_l1
%
%   OUTPUTS:
%
%   pitch_media     vector de medias de pitch del audio
%
%   pitch_var       vector de varianzas de pitch del audio
%
% SEE ALSO:
%   fxpefac.m (Voicebox)
%   redimensionar.m  
%
% AUTHOR
%   Alba Minguez, Junio 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 1. Utilizamos la función de la Voicebox con los valores por defecto:
        
    %mode = 'g'; %plot graph showing waveform and pitch

    inc_default = 0.01;
    [fx_default,~,pv_default,~] = fxpefac(signal,fs_audio,inc_default);%,mode);
    
    % fx_default: vector de pitch en Hz
    % pv_default: vector de probabilidad de que la trama sea sordo/sonora
    
    %Numero de muestras en 0.01 seg (sera el incremento para redimensionar)
    win = l1/inc_default;
    % Incremento de ventana
    inc = win*rate1;
    
    % Redimensionamos los vectores a la ventana de nivel 1
    fx_media = redimensionar(fx_default, win, inc, 'media');
    fx_var = redimensionar(fx_default, win, inc, 'varianza');
    pv_media = redimensionar(pv_default, win, inc, 'media');
    
    pitch_media = fx_media';
    pitch_var = fx_var';
    
    % Ponemos a cero las tramas cuya probabilidad de ser sonora es menor de
    % 0.5
    pitch_media(pv_media < 0.5) = 0; % en herzios
    pitch_var(pv_media < 0.5) = 0; % en herzios
    
    % esto devuelve un vector de 1 x n_tramas


end

