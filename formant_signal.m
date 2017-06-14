function matriz_formantes = formant_signal( signal, win, inc, fs_audio)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NAME
%   formant_signal - Calcula matriz de los 3 primeros formantes de un audio
%                   para una ventana dada
%
% SYNOPSIS
%   matriz_formantes = formant_signal( signal, win, inc, fs_audio)
%
% DESCRIPTION
% Esta funcion extrae la matriz de los 3 primeros formantes de un audio
% para una ventana dada
%
% INPUTS
%   
%   signal    	Audio o porción de audio del que queremos extraer los
%               formantes
%
%   win         Tamaño de ventana en segundos
%
%   inc         Incremento de ventana en segundos
%
%   fs_audio    Frecuencia de muestreo del audio
%
%   OUTPUTS:
%
%   matriz_formantes     matriz de formantes del audio
%
% SEE ALSO:
%   formant_trama.m
%
% AUTHOR
%   Alba Minguez, Junio 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    win_n = win*fs_audio;
    inc_n = inc*fs_audio;

    matriz_formantes = []; %matriz que contiene 3 formantes (filas) x N tramas (columnas)
    cont_trama = 1; %contadores para ir rellenando las columnas

    nVeces = floor(size(signal,1)/inc_n) - 1; %numero de tramas enteras
    i_final = floor(size(signal,1)/inc_n) * inc_n;

    cont_vez = 1; %contador para el numero de veces que se mueve la trama
    i_signal = 1; %contador para mover el indice por el vector

    while (cont_vez <= nVeces )

        porcion_signal= signal(i_signal:(i_signal+win_n-1),1);

        v_formantes = formant_trama( porcion_signal, fs_audio );

        % v_formantes es un vector de 3 formantes (filas) x 1 trama
        % (columna)

        matriz_formantes = horzcat(matriz_formantes, v_formantes);

        cont_trama = cont_trama + 1;

        i_signal = i_signal + inc_n;

        cont_vez = cont_vez+1;

    end %end while(cont_vez <= nVeces )

    % Calculamos la etiqueta para lo que sobra al final del vector

    if i_final <= size(signal,1)-1

        porcion_signal= signal(i_signal:(size(signal,1)-1),1);

        v_formantes = formant_trama( porcion_signal, fs_audio );

        % v_formantes es un vector de 3 formantes (filas) x 1 trama
        % (columna)

        matriz_formantes = horzcat(matriz_formantes, v_formantes);

        % matriz_formantes es una matriz de 3 x n_tramas

    end % enf if i_final <= size(signal,1)-1

end

