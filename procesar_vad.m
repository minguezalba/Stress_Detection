function [vad_audio, vad_HR] = procesar_vad(vad_16000Hz, fs_audio)
% NAME
%   procesar_vad
% SYNOPSIS
% [vad_audio, vad_HR] = procesar_vad(vad_16000Hz, fs_audio)
%
% DESCRIPTION
% La función procesa el vector de voice activity extraido con anterioridad
% por la funcion vadsohn.m (Voicebox). Este proceso consiste en conseguir 
% que nuestor vector de VAD tenga una precision de 1 seg para poder
% eliminar de forma sincronizada las zonas de silencios tanto de los audios
% como de los vectores de etiquetas. 
%
% INPUTS
%   vad_16000Hz   vector de probabilidad de actividad de voz salido de la
%                 funcion vadshon.m (Voicebox)
%
%   fs_audio      frecuencia a la que esta el vector vad_16000Hz
%
% Variables:
%
%   vad_audio: Vector de 1s y 0s para el archivo de audio
%
%       1 SEG            1 SEG            1 SEG           1 SEG
% |----------------|----------------|----------------|----------------|
% |1111111111111111|0000000000000000|0000000000000000|1111111111111111
%
%
%   vad_HR: Vector de 1s y 0s para el archivo de etiquetas
%
%       1 SEG            1 SEG            1 SEG           1 SEG
% |----------------|----------------|----------------|----------------|
% |-------1--------|-------0--------|--------0-------|--------1-------|
%
%
% AUTHOR
%   Alba Minguez, Junio 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    vad_audio = [];
    vad_HR = [];
    
    % Ventana de 2 seg y desplazamiento de 1 para obtener 1 muestra/s
    win = 2*fs_audio;
    inc = win*0.5;

    % Vamos a recorrer el vector con el tamaño de ventana "win" con
    % desplazamiento "inc"

    nVeces = floor(length(vad_16000Hz)/inc) - 1;
    i_final = floor(length(vad_16000Hz)/inc) * inc;
    cont_vector = 1; %contador para ir rellenando el array
    cont_vez = 1; %contador para el numero de veces que se mueve la trama
    i_vector = 1; %contador para mover el indice por el vector

    while (cont_vez <= nVeces )

        porcion_trama = vad_16000Hz(i_vector:(i_vector+win-1));

        media = mean(porcion_trama);
        
        % Decidimos que la porcion_trama sera "sonido" si supera el 0.5 de
        % probabilidad del VAD. En el caso del vector de HR, será solo una
        % muestra la que será sonido o silencio.
        
        if media >= 0.5
            
            vad_HR(cont_vector) = 1;
            vad_audio(i_vector:(i_vector+win-1)) = 1;
            
        else % En el caso contrario, la porcion_trama será "silencio"
            
            vad_HR(cont_vector) = 0;
            vad_audio(i_vector:(i_vector+win-1)) = 0;

        end

        cont_vector = cont_vector + 1;
        i_vector = i_vector + inc;
        cont_vez = cont_vez+1;

    end %end while


    % Calculamos la etiqueta para lo que sobra al final que no entra en el
    % tamaño de la ventana.

    if i_final <= length(vad_16000Hz)-1

        porcion_trama = vad_16000Hz(i_vector:length(vad_16000Hz)-1);

        media = mean(porcion_trama);

        if media >= 0.5
            
            vad_HR(cont_vector) = 1;
            vad_audio(i_vector:length(vad_16000Hz)-1) = 1;
            
        else
            
            vad_HR(cont_vector) = 0;
            vad_audio(i_vector:length(vad_16000Hz)-1) = 0;

        end

    end %end if i_final <= length(input)-1

end

