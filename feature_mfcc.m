function [ mfcc_media, mfcc_var ] = feature_mfcc( signal, fs_audio, l1, rate1 )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NAME
%   feature_mfcc - Calcula matriz de medias y varianzas de los mfcc
%
% SYNOPSIS
%   [ mfcc_media, mfcc_var ] = feature_mfcc( signal, fs_audio, l1, rate1 )
%
% DESCRIPTION
% Esta funcion extrae la matriz de mfcc de un audio con una ventana
% relativamente pequeña (20 ms) y posteriormente redimensiona ese vector
% con la ventana de nivel 1 calculando la media y la varianza de la ventana
%
% INPUTS
%   
%   signal    	Audio o porción de audio del que queremos extraer los mfcc
%
%   fs_audio    Frecuencia de muestreo del audio
%
%   l1          Tamaño de ventana en segundos del nivel 1 (pequeña)
%
%   rate1       Rate entre l1 e inc_l1
%
%   OUTPUTS:
%
%   mfcc_media     matriz de medias de mfcc del audio
%
%   mfcc_var       matriz de varianzas de mfcc del audio
%
% SEE ALSO:
%   melcepst.m (Voicebox)
%   redimensionar.m  
%
% AUTHOR
%   Alba Minguez, Junio 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Fijamos los valores que queremos para calcular los MFCC

    winlen = 0.02; %longitud ventana en segundos
    txinc = winlen-winlen*rate1; %solapamiento en segundos
    n = winlen*fs_audio; % longitud ventana en muestras
    inc = txinc * fs_audio ; % solapamiento en muestras
    w   = 'M'; % 'M' Hamming window in time domain (default)
               % '0' include 0'th order cepstral coefficient
               % 'E' include log energy

    % Valores por defecto de la función melcepts
	nc  = 12; %number of cepstral coefficients excluding 0'th coefficient
    p   = floor(3*log(fs_audio)); %number of filters in filterbank 
    fl  = 0; %low end of the lowest filter as a fraction of fs 
    fh  = 0.5; %high end of highest filter as a fraction of fs 
    
    
    [mfcc,~] = melcepst(signal,fs_audio,w,nc,p,n,inc,fl,fh);
    
    mfcc = mfcc';
    
    win_red = l1/txinc;
    inc_red = win_red*rate1;
    mfcc_media = [];
    mfcc_var = [];
    
    % Redimensionamos cada vector de mfcc a la ventana de nivel 1
    for j=1:size(mfcc,1)
        
        mfcc_media(j,:) = redimensionar(mfcc(j,:), win_red, inc_red, 'media')';
        mfcc_var(j,:) = redimensionar(mfcc(j,:), win_red, inc_red, 'varianza')';

    end

end

