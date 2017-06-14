function  [vad_audio, vad_HR] = vad( signal_16000, fs16000, mode, threshold)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NAME
%   vad - Detecta zonas de silencio en una señal de audio basado en un
%   umbral determinado.
%
% SYNOPSIS
%   [vad_audio, vad_HR] = vad( signal_16000, fs16000, mode, threshold)
%
% INPUTS
%   signal_16000: Señal de la que queremos detectar la actividad
%   fs16000: Frecuencia de muestreo de la señal
%   mode: modo detección (1 o 0) 
%   threshold: Umbral de detección de sonido/silencio
%
% OUTPUTS
%   vad_audio: Señal recortada
%   vad_HR: 
%
% SEE ALSO:
%   vadsohn.m (Voicebox)
%   procesar_vad.m
%
% AUTHOR
%   Alba Minguez, Junio 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 1. Detectamos las zonas de silencio

%   Definimos los valores para la función de la Voicebox. Dejamos los
%   valores por defecto excepto para el umbral de decisión

    qq.of=2;        % overlap factor = (fft length)/(frame increment)
    qq.pr=threshold;% Speech probability threshold
    qq.ts=0.1;      % mean talkspurt length (100 ms)
    qq.tn=0.05;     % mean silence length (50 ms)
    qq.ti=10e-3;    % desired output frame increment (10 ms)
    qq.tj=10e-3;    % internal frame increment (10 ms)
    qq.ri=0;        % round ni to the nearest power of 2
    qq.ta=0.396;    % Time const for smoothing SNR estimate = -tinc/log(0.98) from [2]
    qq.gx=1000;     % maximum posterior SNR = 30dB
    qq.gz=1e-4;     % minimum posterior SNR = -40dB
    qq.xn=0;        % minimum prior SNR = -Inf dB
    qq.ne=0;        % noise estimation: 0=min statistics, 1=MMSE [0]

%   Obtenemos vector de detección donde 1=sonido y 0=silencio

    [vad_prob16000, ~] = vadsohn(signal_16000,fs16000, mode, qq); 
    
    % vad_prob16000 tiene menor dimensión que signal_16000 porque el algoritmo
    % descarta la última trama si no tiene las muestras justas.

    % Vamos a procesar el vector de probabilidad de vad a 16000Hz para
    % poder eliminar las zonas de silencio posteriormente del vector de
    % audio y el de HR (etiquetas)
    
    % Para ello, vamos a forzar a que en bloques de 1 seg (precision minima que
    % tenemos para el HR) el audio (todas las muestras contenidas en ese segundo)
    % será sonido o silencio. De esta manera no perdemos la sincronización
    
    [vad_audio, vad_HR] = procesar_vad(vad_prob16000, fs16000);
    


    
    

end

