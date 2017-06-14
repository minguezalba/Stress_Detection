function formantes = formant_trama( porcion_signal, fs_audio )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NAME
%   formant_trama - Calcula los 3 primeros formantes de una trama de audio
%
% SYNOPSIS
%   formantes = formant_trama( porcion_signal, fs_audio )
%
% DESCRIPTION
% Esta funcion extrae los 3 primeros formantes de una trama de audio
% mediante el calculo de las raices
%
% INPUTS
%   
%   porcion_signal      Trama de audio del que queremos extraer los
%                       formantes
%
%   fs_audio    Frecuencia de muestreo del audio
%
%   OUTPUTS:
%
%   formantes     vector con los 3 primeros formantes de la trama de audio
%
% SEE ALSO:
%   http://www.phon.ucl.ac.uk/courses/spsci/matlab/lect10.html
%
% AUTHOR
%   Alba Minguez, Junio 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1. Plot waveform

%     t=(0:length(porcion_signal)-1)/fs_audio;% times of sampling instants
%     subplot(2,1,1);
%     plot(t,porcion_signal);
%     legend('Waveform');
%     xlabel('Time (s)');
%     ylabel('Amplitude');
%     

% 2. Get Linear prediction filter

    ncoeff=2+fs_audio/1000;% rule of thumb for formant estimation
    a=lpc(porcion_signal,ncoeff);
    
% 3. Plot frequency response

%     [h,f]=freqz(1,a,512,fs_audio);
%     subplot(2,1,2);
%     plot(f,20*log10(abs(h)+eps));
%     legend('LP Filter');
%     xlabel('Frequency (Hz)');
%     ylabel('Gain (dB)');

% 4. Find frequencies by root-solving
    r=roots(a);                  % find roots of polynomial a
    r=r(imag(r)>0.01);           % only look for roots >0Hz up to fs/2
    ffreq=sort(atan2(imag(r),real(r))*fs_audio/(2*pi)); % convert to Hz and sort

% 5. Print all the formants

%     for i=1:length(ffreq)
%         fprintf('Formant %d Frequency %.1f\n',i,ffreq(i));
%     end

% 6. Tomamos solo los 3 primeros formantes que son los que contienen mas
% informacion

    formantes = ffreq(1:3);
    
end

