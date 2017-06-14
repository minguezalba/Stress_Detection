
% Ejemplos para ver como de diferentes son prebaseline y baseline y sus
% medias y varianzas

clear all
clc

%Probaremos para un subconjunto al azar de IDs

% Total IDs:
v_ID = [12782919; 49425811; 62963719; 92305089; 105804962; 192369217;
      286484722; 304102792; 334342001; 334844205; 348334269; 354408438;
      513604950; 548414142; 550155379; 638882617; 652033332;
      724250529; 852630991; 902398068; 928432217; 935941053; 1015666824;
      1062237033; 1113564542; 1143102813; 1395228143; 1397020749;
      1411484167; 1420900415; 1458206716; 1499703648; 1507583907;
      1610132012; 1626125349; 1650434878; 1686645257; 1739028311; 
      1756953694; 1777108864; 1777769661; 1884865801; 2054751935;
      2071492831; 2084620463];

% Subconjunto:

%v_ID = [12782919; 49425811; 62963719; 92305089; 105804962; 192369217];
  

num_ID = size(v_ID, 1);

% Vectores para almacenar .mat
prebaseline = double([]);
baseline = double([]);
recording = double([]);

% Variables para almacenar media y desv del .mat
media_pre=0;
media_base=0;
media_rec=0;

desv_pre=0;
desv_base=0;
desv_rec=0;

% Vectores para el archivo excel
pre_medias = double([]);
pre_desv = double([]);

base_medias = double([]);
base_desv = double([]);

rec_medias = double([]);
rec_desv = double([]);


folder_mat =  dir(['recordings/', '/*.mat']);

for i=1:num_ID
    
    media_pre=0;
    media_base=0;
    desv_pre=0;
    desv_base=0;
    
    for k=1:length(folder_mat) %Buscar en toda la carpeta
    
        s1 = 'ID_';
        s2 = int2str(v_ID(i));
        s3 = '_baseline_sensors.mat';
        s4 = '_prebaseline_sensors.mat';
        s5 = '_sensors.mat';

        mat_pre = strcat(s1,s2,s4);
        mat_base = strcat(s1,s2,s3);
        mat_rec = strcat(s1,s2,s5);

        %Si encuentra el archivo .mat prebaseline
        if strcmp(folder_mat(k).name, mat_pre) == 1
            
           file = folder_mat(k).name;
           cargar = strcat('recordings/',file);
           load (cargar);
           prebaseline = v_Zecg;
           
           media_pre = mean(prebaseline(:,1));
           desv_pre= std(prebaseline(:,1));
           
                      
        end
        
        %Si encuentra el archivo .mat baseline
        if strcmp(folder_mat(k).name, mat_base) == 1
            
           file = folder_mat(k).name;
           cargar = strcat('recordings/',file);
           load (cargar);
           baseline = v_Zecg;
           
           media_base = mean(baseline(:,1));
           desv_base= std(baseline(:,1));
            
        end 
        
        
        %Si encuentra el archivo .mat recording
        if strcmp(folder_mat(k).name, mat_rec) == 1
            
           file = folder_mat(k).name;
           cargar = strcat('recordings/',file);
           load (cargar);
           recording = v_Zecg;
           
           media_rec = mean(recording(:,1));
           desv_rec= std(recording(:,1));
            
        end 
        
    end   %end folder_mat
    
   
   pre_medias(i) = media_pre;
   pre_desv(i) = desv_pre;
   
   base_medias(i) = media_base;
   base_desv(i) = desv_base;
   
   rec_medias(i) = media_rec;
   rec_desv(i) = desv_rec;

   
    % Cuando ya tengo los vectores prebaseline y baseline de un ID
    
    if isempty(prebaseline)==0 || isempty(baseline)==0 || isempty(recording)==0 %Si alguno de los tres NO esta vacio
       
        figure()
        fprintf('........................................................\n');
        fprintf('ID %s: \n',s2)
        
        if isempty(prebaseline)==0
            
            plot(prebaseline(:,2), prebaseline(:,1),'r')
            fprintf('Media Prebaseline: %.2f \n',media_pre)
            fprintf('Desv Prebaseline: %.2f \n',desv_pre)
            
                        
        end
        
        if isempty(baseline)==0
            
            hold on
            plot(baseline(:,2), baseline(:,1),'g')
            fprintf('Media Baseline: %.2f \n',media_base)
            fprintf('Desv Baseline: %.2f \n',desv_base)
                        
        end
        
        if isempty(recording)==0
            
            hold on
            plot(recording(:,2), recording(:,1),'c')
            fprintf('Media Recording: %.2f \n',media_rec)
            fprintf('Desv Recording: %.2f \n',desv_rec)
                        
        end
        
            title(['Comparativa ID: ' s2])
            ylabel('bpm') % y-axis label
            legend('Prebaseline','Baseline','Recording')
        
        
    end
    
    
%Reiniciamos variables
    
% Vectores para almacenar .mat
prebaseline = double([]);
baseline = double([]);
recording = double([]);

% Variables para almacenar media y desv del .mat
media_pre=0;
media_base=0;
media_rec=0;

desv_pre=0;
desv_base=0;
desv_rec=0;

    
end %end v_ID


%% Crear archivo excel con medias y varianzas 

close all

%%
 T = table(v_ID, pre_medias', pre_desv', base_medias', base_desv', rec_medias', rec_desv' );
 T.Properties.VariableNames = {'ID' 'Media_Prebaseline' 'Desv_Prebaseline' 'Media_Baseline' 'Desv_Baseline' 'Media_Recording' 'Desv_Recording'};
 
% Exportamos la tabla a excel

    excel_file = 'medias y desv.xlsx';
    writetable(T,excel_file);
