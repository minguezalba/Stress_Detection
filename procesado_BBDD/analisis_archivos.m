% El objetivo de este script es crear una tabla que contiene, para cada ID,
% qué archivos existen y cuáles no de entre los 6 posibles (3 de audio .wav 
% y 3 de sensors .xml para prebaseline, baseline y recording). Además,
% también sacamos la duración de los archivos de audio.

% 1. Definimos el vector de identificadores ID

ID = [12782919; 49425811; 62963719; 92305089; 105804962; 192369217;
      286484722; 304102792; 334342001; 334844205; 348334269; 354408438;
      513604950; 548414142; 550155379; 638882617; 652033332;
      724250529; 852630991; 902398068; 928432217; 935941053; 1015666824;
      1062237033; 1113564542; 1143102813; 1395228143; 1397020749;
      1411484167; 1420900415; 1458206716; 1499703648; 1507583907;
      1610132012; 1626125349; 1650434878; 1686645257; 1739028311; 
      1756953694; 1777108864; 1777769661; 1884865801; 2054751935;
      2071492831; 2084620463];
       
num_ID = length(ID);

% 2. Buscamos qué archivos tiene cada ID (1 = Lo tiene, 0 = No lo tiene) y,
%    si lo tienen, su duración 

% 2.1 Archivos de audio .wav 

    folder_wav = dir(['recordings/', '/*.wav']);
    
    ID_id_wav = zeros(num_ID, 1);
    dur_ID_id_wav = zeros(num_ID, 1); %Duración en minutos
    ID_id_baseline_wav = zeros(num_ID, 1);
    dur_ID_id_baseline_wav = zeros(num_ID, 1);%Duración en minutos
    ID_id_prebaseline_wav = zeros(num_ID, 1);
    dur_ID_id_prebaseline_wav = zeros(num_ID, 1);%Duración en minutos
        
    for i=1:length(folder_wav)
    
        for j=1:num_ID
            
            s1 = 'ID_';
            s2 = int2str(ID(j));
            s3 = '.wav';
            s4 = '_baseline.wav';
            s5 = '_prebaseline.wav';
            
            wav1 = strcat(s1,s2,s3);
            wav2 = strcat(s1,s2,s4);
            wav3 = strcat(s1,s2,s5);
            
            if strcmp(folder_wav(i).name, wav1) == 1
                ID_id_wav(j) = 1;
                [sig, fs] = audioread(strcat('recordings/',wav1));
                dur_ID_id_wav(j) = (length(sig)/fs)/60;
                
            end
            
            if strcmp(folder_wav(i).name, wav2) == 1
                ID_id_baseline_wav(j) = 1;
                [sig, fs] = audioread(strcat('recordings/',wav2));
                dur_ID_id_baseline_wav(j) = (length(sig)/fs)/60;
            end
            
            if strcmp(folder_wav(i).name, wav3) == 1
                ID_id_prebaseline_wav(j) = 1;
                [sig, fs] = audioread(strcat('recordings/',wav3));
                dur_ID_id_prebaseline_wav(j) = (length(sig)/fs)/60;
            end
            
        end
    end
    
% 2.2 Archivos de datos .xml

    folder_xml = dir(['recordings/', '/*.xml']);
    
    ID_id_sensors_xml = zeros(num_ID, 1);
    ID_id_baseline_sensors_xml = zeros(num_ID, 1);
    ID_id_prebaseline_sensors_xml = zeros(num_ID, 1);
        
    for x=1:length(folder_xml)
    
        for y=1:num_ID
            
            s1 = 'ID_';
            s2 = int2str(ID(y));
            s3 = '_sensors.xml';
            s4 = '_baseline_sensors.xml';
            s5 = '_prebaseline_sensors.xml';
            
            xml1 = strcat(s1,s2,s3);
            xml2 = strcat(s1,s2,s4);
            xml3 = strcat(s1,s2,s5);
            
            if strcmp(folder_xml(x).name, xml1) == 1
                ID_id_sensors_xml(y) = 1;
            end
            
            if strcmp(folder_xml(x).name, xml2) == 1
                ID_id_baseline_sensors_xml(y) = 1;
            end
            
            if strcmp(folder_xml(x).name, xml3) == 1
                ID_id_prebaseline_sensors_xml(y) = 1;
            end
            
        end
    end
    
% Creamos tabla con los datos

%load('data.mat')

 T = table(ID, ID_id_wav, dur_ID_id_wav, ID_id_baseline_wav,  ...
     dur_ID_id_baseline_wav, ID_id_prebaseline_wav, dur_ID_id_prebaseline_wav, ...
     ID_id_sensors_xml, ID_id_baseline_sensors_xml, ID_id_prebaseline_sensors_xml );
 
% Exportamos la tabla a excel

    excel_file = 'data.xlsx';
    writetable(T,excel_file);
  

















