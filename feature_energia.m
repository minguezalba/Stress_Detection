function [ vector_energia ] = feature_energia( signal, fs_audio, l1, inc_l1 )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NAME
%   feature_energia - Calcula vector de energias de un audio por tramas
%
% SYNOPSIS
%   [ vector_energia ] = feature_energia( signal, fs_audio, l1, inc_l1 )
%
% DESCRIPTION
% Esta funcion extrae el vector de energia de un audio para la ventana de
% nivel 1 dada.
%
% INPUTS
%   
%   signal    	Audio o porción de audio del que queremos extraer el
%               vector de energia
%
%   fs_audio    Frecuencia de muestreo del audio
%
%   l1          Tamaño de ventana en segundos del nivel 1 (pequeña)
%
%   inc1        Incremento de ventana en segundos del nivel 1 (pequeña)
%
%   OUTPUTS:
%
%   vector_energia     vector de energias del audio
%
% AUTHOR
%   Alba Minguez, Junio 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    win = l1; %en segundos [2 ms]
    inc = inc_l1; %en segundos [1 ms]

    win_n = win*fs_audio;
    inc_n = inc*fs_audio;

    vector_energia = []; %matriz que contiene 3 formantes (filas) x N tramas (columnas)
    cont_trama = 1; %contadores para ir rellenando el vector energia

    nVeces = floor(size(signal,1)/inc_n) - 1;
    i_final = floor(size(signal,1)/inc_n) * inc_n;

    cont_vez = 1; %contador para el numero de veces que se mueve la trama
    i_signal = 1; %contador para mover el indice por el vector señal

    while (cont_vez <= nVeces )

        porcion_signal= signal(i_signal:(i_signal+win_n-1),1);

        energia = sum(porcion_signal.^2);

        vector_energia(cont_trama) = energia;

        cont_trama = cont_trama + 1;

        i_signal = i_signal + inc_n;

        cont_vez = cont_vez+1;

    end %end while(cont_vez <= nVeces )

    % Calculamos la etiqueta para lo que sobra al final del vector   

    if i_final <= size(signal,1)-1

        porcion_signal= signal(i_signal:(size(signal,1)-1),1);

        energia = sum(porcion_signal.^2);

        vector_energia(cont_trama) = energia;

        %es un vector fila de 1 x n_tramas

    end % enf if i_final <= size(signal,1)-1  

end

