function [vad_HR_rec, vad_HR_base] = preprocesado_id(identificador, dir_originals, dir_signals, fs_audio)
% NAME
%   preprocesado_id
% SYNOPSIS
% [vad_HR_rec, vad_HR_base] = preprocesado_id(identificador, dir_originals, dir_signals, fs_audio)
%
% DESCRIPTION
% Para un ID, preprocesa (stereo a mono, downsampling, normaliza, aplica 
% voice activity detector, elimina los silencioos) sus archivos de audio 
% recording y base y los guarda en archivos .mat en /recordings/set/signals
% Además, también crea los vectores de 1's (sonido) y 0's (silencio)
% para recortar los vectores de etiquetas correspondientes
%
% INPUTS
%   identificador   ID del que vamos a procesar los audios
%
%   fs_audio        frecuencia a la que queremos hacer el downsampling en el
%                   preprocesado del audio
%
%   dir_originals   carpeta desde la que vamos a extraer los audios
%
%   dir_signals     carpeta en la que queremos guardar las señales
%                   procesadas
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
% SEE ALSO
%   audioread.m (MATLAB)
%   resample.m (MATLAB)
%   vad.m
%   miraudio.m (MIR Toolbox)
%   vadsohn.m (Voicebox)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1. Encontramos para un id concreto sus señales recording y base
% correspondiente en la carpeta dir_originals que han sido elegidas
% previamente a mano

    s1 = 'ID_';
    s3 = '.wav';
    s4 = '_baseline.wav';
    s5 = '_prebaseline.wav';
    
    wav1 = strcat(s1,identificador,s3); % nombre audio recording
    wav2 = strcat(s1,identificador,s4); % nombre audio baseline
    wav3 = strcat(s1,identificador,s5); % nombre audio prebaseline
    
    folder_set = dir([dir_originals, '/*.wav']);
    
    for j = 1:length(folder_set) % Buscamos entre todos los archivos de la carpeta

        filename = folder_set(j).name;
        file_path = strcat(dir_originals,filename);

        %Si el fichero j contiene en su nombre el identificador i

        if isempty(strfind(filename,identificador))==0

            %Si encontramos el archivo de recording
            if strcmp(filename, wav1) == 1

                [signal_rec, fs_recording] = audioread(file_path);

            end

            %Si encontramos el archivo de baseline o prebaseline
            if strcmp(filename, wav2) == 1 || strcmp(filename, wav3) == 1

                [signal_base, fs_base] = audioread(file_path);

            end

        end 

    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2. Pasamos las señales de stereo a mono


    if (size(signal_rec,2)==2)
        signal_rec = (signal_rec(:,1)+signal_rec(:,2))/2;
    end

    if (size(signal_base,2)==2)
        signal_base = (signal_base(:,1)+signal_base(:,2))/2;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 3. Downsampling de 44100 Hz a fs_audio

    signal_rec = resample(signal_rec,fs_audio,fs_recording);

    signal_base = resample(signal_base,fs_audio,fs_base);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 4. Normalizamos las señales para que su rango sea de [-1,1]

%     figure(1); miraudio(signal_rec)
%     title('Señal mono a 16000 Hz');

    signal_rec = (signal_rec-mean(signal_rec));
    signal_rec = signal_rec / max(abs(signal_rec));
    
%     figure(2); miraudio(signal_rec)
%     title('Señal normalizada');
   
    signal_base = signal_base-mean(signal_base); 
    signal_base = signal_base/ max(abs(signal_base));
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 5. Aplicamos VAD (Voice Activity Detector)

    mode = 'a'; % Output activity decision
    threshold = 0.99; %Umbral para detectar silencios

    [vad_audio_rec, vad_HR_rec] = vad( signal_rec, fs_audio, mode, threshold);
    [vad_audio_base, vad_HR_base] = vad( signal_base, fs_audio, mode, threshold);

    signal_rec_cut = signal_rec(vad_audio_rec==1);
    signal_base_cut = signal_base(vad_audio_base==1);
    
%     figure(3); miraudio(signal_rec_cut)
%     title('Señal recortada');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 6. Guardamos las señales recortadas en la carpeta /signals/

    s6 = '_rec';
    s7 = '_base';

    wav_rec = strcat(s1,identificador,s6);
    wav_base = strcat(s1,identificador,s7);

    path_rec_file = strcat(dir_signals,wav_rec);
    path_base_file = strcat( dir_signals ,wav_base);

    signal = signal_rec_cut;
    save(path_rec_file, 'signal' );
    signal = signal_base_cut;
    save(path_base_file, 'signal' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

