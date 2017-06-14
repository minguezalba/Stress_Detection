function etiquetado2_set( set_name, n2_HR, inc_n2_HR )
% NAME
%   etiquetado2_set
% SYNOPSIS
%   etiquetado2_set( set_name, n2_HR, inc_n2_HR )

% DESCRIPTION
% Toma los vectores de etiquetas a nivel 1 (ventana pequeña) ya existentes
% y crea y guarda nuevos vectores a nivel 2 (ventana grande) a partir de 
% ellos.
%
% INPUTS
%   set_name    set de vectores que va a tomar /set/labels
%
%   n2_HR           tamaño de ventana en numero de muestras para el 
%                   etiquetado a nivel 2
%
%   inc_n2_HR       incremento de ventana en numero de muestras para el 
%                   etiquetado a nivel 2
%
% SEE ALSO:
%   redimensionar.m
%
% AUTHOR
%   Alba Minguez, Junio 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    switch set_name

        case 'set1' % Caso set 1

           dir_labels = 'recordings/set1/labels/';

        case 'set2' % Caso set 1

           dir_labels = 'recordings/set2/labels/';
           
        otherwise
            sprintf('Error');
    end
    
    
    folder_labels = dir([dir_labels, '/*.mat']);
    
    for i=1:length(folder_labels)
        
        name = folder_labels(i).name;
        load(strcat(dir_labels, folder_labels(i).name)); %Cargamos labels1
       
        labels2 = redimensionar( labels1, n2_HR, inc_n2_HR, 'mayoria_bin' );
        labels2 = labels2';
                
        % Guardamos el vector de etiquetas con el nombre original que tenia
        % cambiando correspondientemente el L11 y L12 por L21 y L22.
        
        s1 = 'L21';
        s2 = 'L22';
        name_aux = name(4:end); %nos quedamos con parte del nombre
        
        
        % Labels 21: segundo nivel, método 1 (por media+desv)
        if isempty(strfind(name,'L11'))~=1 %si es distinto de ESTAR vacio
            
            label21_name = strcat(dir_labels, s1, name_aux);
            save(label21_name, 'labels2' );
                 
        % Labels 22: segundo nivel, método 2 (percentil)       
        elseif isempty(strfind(name,'L12'))~=1
            
           label22_name = strcat(dir_labels, s2, name_aux);
           save(label22_name, 'labels2' );
                                 
        end
        
        
    end %para cada archivo de la carpeta labels
    
    
end

