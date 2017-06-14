% Script para crear los archivos Zecg correspondientes a cada fichero xml
% una vez ya hemos decidido que la comparaci�n con Zts es correcta.

% El nombre del fichero que contiene los valores Zecg ser� el mismo que el 
% del fichero xml pero con la extensi�n .mat

clc
clear all

folder_xml = dir(['recordings/', '/*.xml']);

for i=1:length(folder_xml)
    
    nombre = folder_xml(i).name;
    tipo = type_file(nombre);
    
    [~, value_Zecg, time_Zecg, ~, ~] = analisis_xml(nombre, tipo);
    
    nombre_con_extension = strcat('recordings/',nombre);
    
    [path,name,extension] = fileparts(nombre_con_extension);
    
    nombre_sin_extension = strcat('recordings/',name);

    v_Zecg = [value_Zecg time_Zecg];

    save(nombre_sin_extension, 'v_Zecg' );
        
end

