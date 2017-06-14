function preprocesado_set(set_name, fs_audio, n1_HR, inc_n1_HR)
% NAME
%   preprocesado_set
% SYNOPSIS
%   preprocesado_set(set_name, fs_audio, n1_HR, inc_n1_HR)

% DESCRIPTION
% Para un set de audios .wav concreto, hace el preprocesado del audio y su
% correspondiente etiquetado a nivel 1 (ventana pequeña)
%
% INPUTS
%   set_name   nombre del set de audios que queremos procesar
%
%   fs_audio   frecuencia a la que queremos hacer el downsampling en el
%              preprocesado del audio
%
%   n1_HR      nivel 1 de ventana (pequeña) en numero de muestras para el
%              etiquetado
%
%   inc_n1_HR  incremento de ventana nivel 1 en numero de muestras
%
% Variables:
%
%   porcentaje   valor de 0-100 para la funcion percentil del etiquetado
%                basado en la opcion 2
%   vad_rec      vector de 0s y 1's para quitar silencios del archivo de
%                recording en el etiquetado nivel 1
%   vad_base     vector de 0s y 1's para quitar silencios del archivo de
%                base en el etiquetado nivel 1
%
% AUTHOR
%   Alba Minguez, Junio 2017
%
% SEE ALSO
%   preprocesado_id.m
%   etiquetado1_id.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 1. Seleccionamos el set de IDs

	% Posibles sets:
    %
    %   - set1: Contiene 10 muestras completas (audio event, audio baseline o
    %   prebaseline para normalizar y sensores de ambos) escuchadas
    %   manualmente. Son los que tienen mejor calidad.
    %
    %   - set2: Contiene 14 muestras completas (audio event, audio baseline o
    %   prebaseline para normalizar y sensores de ambos) escuchadas
    %   manualmente. Tienen peor calidad que el set1.

     switch set_name

        case 'set1' % Caso set 1

            set = [62963719; 652033332; 935941053; 1015666824;
            1395228143; 1397020749; 1420900415; 1739028311; 
            1777769661; 2054751935];

            dir_originals = 'recordings/set1/originals/';
            dir_signals = 'recordings/set1/signals/';
            dir_labels = 'recordings/set1/labels/';            
    
        case 'set2' % Caso set 2

            set = [12782919; 49425811; 92305089; 304102792;
            334844205; 513604950; 852630991; 902398068;
            1143102813; 1458206716; 1626125349; 1686645257;
            1756953694; 1777108864];

            dir_originals = 'recordings/set2/originals/';
            dir_signals = 'recordings/set2/signals/';
            dir_labels = 'recordings/set2/labels/';            

        
        otherwise
            sprintf('Error');

    end % end switch nombre_set

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Para cada ID:

    for i=1:length(set)
        
        id = int2str(set(i));
        
        [vad_rec, vad_base] = preprocesado_id(id, dir_originals, dir_signals, fs_audio);
        
        porcentaje = 75; % Dato para opcion 2: percentil
        
        etiquetado1_id(id, dir_originals, dir_labels, vad_rec, vad_base, porcentaje, n1_HR, inc_n1_HR);
        

    end %for i=1:length(set)
    
end

