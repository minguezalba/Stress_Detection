function features_set( set_name, fs_audio, l1, inc_l1, rate1, l2, inc_l2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NAME
%   features_set - Extrae las características de un set de audios
%
% SYNOPSIS
%   features_set( set_name, fs_audio, l1, inc_l1, rate1, l2, inc_l2)
%
% DESCRIPTION
% Esta funcion extrae las caracteristicas de todos los audios de un set
% determinado. Trata de forma distinta a los audios con duracion mayor de 4
% minutos, partiendolo en bloques, y a los audios con duracion menor.
% Guarda las matrices de caracteristicas a los 2 niveles en el directorio
% /set/features. Cada audio tendrá minimo (si su duracion es menor de 4
% minutos) dos archivos .mat con las matrices a nivel 1 y nivel 2.
%
% INPUTS
%   
%   set_name    Set de audios del que queremos extraer las caracteristicas
%
%   fs_audio    Frecuencia de muestreo del audio
%   l1          Tamaño de ventana en segundos del nivel 1 (pequeña)
%   inc_l1      Incremento de ventana en segundos del nivel 1
%   rate1       Rate entre l1 e inc_l1
%   l2          Tamaño de ventana en segundos del nivel 2 (grande)
%   inc_l2      Incremento de ventana en segundos del nivel 2
%
%   Variables:
%   matriz1_features: matriz de caracteristicas del audio a nivel 1
%   matriz2_features: matriz de caracteristicas del audio a nivel 2
%
% SEE ALSO:
%   features1_signal.m
%   features2_signal.m
%
% AUTHOR
%   Alba Minguez, Junio 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    switch set_name

        case 'set1' % Caso set 1

           dir_signals = 'recordings/set1/signals/';
           dir_features = 'recordings/set1/features/';
           dir_labels = 'recordings/set1/labels/';

       case 'set2' % Caso set 1

           dir_signals = 'recordings/set2/signals/';
           dir_features = 'recordings/set2/features/';
           dir_labels = 'recordings/set2/labels/';
           
        otherwise
            sprintf('Error');
    end
    
    folder_signals = dir([dir_signals, '/*.mat']);
    
    % Vamos a trabajar de forma distinta con las señales que ocupen mas
    % de 4 minutos, para evitar problemas computacionales

    minutos = 4;
    tam_bloque = minutos * 60 * fs_audio; % num de muestras por bloque

    for i=1:length(folder_signals)
        
        [~,name_sin,ext] = fileparts(folder_signals(i).name);

        name = strcat(name_sin,ext);

        dim1_features = 0;
        dim2_features = 0;
        
        % Cargamos la señal como 'signal'
        load(strcat(dir_signals, name));
        
        if length(signal) > tam_bloque
            
            num_bloques = ceil(length(signal)/tam_bloque);
            
            for j=1:num_bloques
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % MATRIZ 1: NIVEL VENTANA 1 %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                if j~=num_bloques % si NO estamos en el ultimo bloque
                    
                   % Cogemos el bloque de señal que corresponda
                   porcion_signal = signal(tam_bloque*(j-1)+1:(tam_bloque*j));
                   
                   % Calculamos su matriz de caracteristicas
                   matriz1_features = features1_signal( porcion_signal, fs_audio, l1, inc_l1 , rate1);
                   
                   % Vamos sumando las dimensiones para ver cuánto tendria
                   % que dar la matriz total y compararlo con el vector de
                   % etiquetas
                   dim1_features = dim1_features + size(matriz1_features, 2);
                   
                
                else % si SI estamos en el ultimo bloque
                    
                   porcion_signal = signal(tam_bloque*(j-1)+1:length(signal));
                   
                   % Calculamos su matriz de caracteristicas
                   matriz1_features = features1_signal( porcion_signal, fs_audio, l1, inc_l1 , rate1);
                   
                   % Vamos sumando las dimensiones para ver cuánto tendria
                   % que dar la matriz total y compararlo con el vector de
                   % etiquetas
                   dim1_features = dim1_features + size(matriz1_features, 2);
                   
                   % Cargamos labels1

                    load(strcat(dir_labels, 'L11_', name));

                    dim_labels1 = length(labels1);

                    if dim_labels1 > dim1_features

                        labels1 = labels1(1:dim1_features);
                        save(strcat(dir_labels, 'L11_', name), 'labels1');

                        load(strcat(dir_labels, 'L12_', name));

                        labels1 = labels1(1:dim1_features);
                        save(strcat(dir_labels, 'L12_', name), 'labels1');            


                    elseif dim_labels1 < dim1_features

                        resta = dim1_features - dim_labels1;
                        matriz1_features = matriz1_features(:, 1:size(matriz1_features, 2)-resta);            

                    end

                    
                end
                
                
                % Guardar matriz con nombre XXXXXXX_numIteracion.mat
              
                nombre_matriz1 = strcat('matriz1_', name_sin, '_', int2str(j)); 
                path_matriz1 = strcat(dir_features, nombre_matriz1 );
                save(path_matriz1, 'matriz1_features' );
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % MATRIZ 2: NIVEL VENTANA 2 %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                matriz2_features = features2_signal( matriz1_features,  l2, inc_l2 );
                
                dim2_features = dim2_features + size(matriz2_features, 2);
                
                if j==num_bloques % si NO estamos en el ultimo bloque
                    
                    % Cargamos labels2

                    load(strcat(dir_labels, 'L21_' ,folder_signals(i).name));

                    dim_labels2 = length(labels2);

                    if dim_labels2 > dim2_features

                        labels2 = labels2(1:dim2_features);
                        save(strcat(dir_labels, 'L21_' ,folder_signals(i).name), 'labels2');

                        load(strcat(dir_labels, 'L22_' ,folder_signals(i).name));

                        labels2 = labels2(1:dim2_features);
                        save(strcat(dir_labels, 'L22_' ,folder_signals(i).name), 'labels2');            


                    elseif dim_labels2 < dim2_features
                        resta2 = dim2_features - dim_labels2;
                        matriz2_features = matriz2_features(:, 1:size(matriz2_features, 2)-resta2);            
                                    

                    end
                 
                end
                
                % Guardar matrices en /features/

                nombre_matriz2 = strcat('matriz2_', name_sin, '_', int2str(j)); 
                path_matriz2 = strcat(dir_features, nombre_matriz2 );
                save(path_matriz2, 'matriz2_features' );
                                   
            end
            
        else %if lenght(signal) <= tam_bloque
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % MATRIZ 1: NIVEL VENTANA 1 %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
            
            % Calculamos su matriz de caracteristicas
            matriz1_features = features1_signal( signal, fs_audio, l1, inc_l1 , rate1);

            dim1_features = size(matriz1_features, 2);
            
            % Cargamos labels1

            load(strcat(dir_labels, 'L11_', name));

            dim_labels1 = length(labels1);

            if dim_labels1 > dim1_features

                labels1 = labels1(1:dim1_features);
                save(strcat(dir_labels, 'L11_', name), 'labels1');

                load(strcat(dir_labels, 'L12_', name));

                labels1 = labels1(1:dim1_features);
                save(strcat(dir_labels, 'L12_', name), 'labels1');            


            elseif dim_labels1 < dim1_features

                matriz1_features = matriz1_features(:, 1:dim_labels1);            

            end
            
            % Guardar matriz en /features/

            nombre_matriz1 = strcat('matriz1_', folder_signals(i).name); 
            path_matriz1 = strcat(dir_features, nombre_matriz1 );
            save(path_matriz1, 'matriz1_features' );
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % MATRIZ 2: NIVEL VENTANA 2 %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            matriz2_features = features2_signal( matriz1_features,  l2, inc_l2 );

            dim2_features = size(matriz2_features, 2);
            
            % Cargamos labels2

            load(strcat(dir_labels, 'L21_' ,folder_signals(i).name));

            dim_labels2 = length(labels2);

            if dim_labels2 > dim2_features

                labels2 = labels2(1:dim2_features);
                save(strcat(dir_labels, 'L21_' ,folder_signals(i).name), 'labels2');

                load(strcat(dir_labels, 'L22_' ,folder_signals(i).name));

                labels2 = labels2(1:dim2_features);
                save(strcat(dir_labels, 'L22_' ,folder_signals(i).name), 'labels2');            


            elseif dim_labels2 < dim2_features

                matriz2_features = matriz2_features(:, 1:dim_labels2);            

            end
            
            % Guardar matrices en /features/

            nombre_matriz2 = strcat('matriz2_', folder_signals(i).name); 
            path_matriz2 = strcat(dir_features, nombre_matriz2 );
            save(path_matriz2, 'matriz2_features' );
            
            
        end % end if tamaño señal > o < que 4 min
        
    end % end for para cada señal
       
end %end funcion

