function [ labels1, labels2 ] = crear_labels(Zecg, umbral1, umbral2, n1_HR, inc_n1_HR  )
% NAME
%   crear_labels
% SYNOPSIS
%   [ labels1, labels2 ] = crear_labels(Zecg, umbral1, umbral2, n1_HR, inc_n1_HR  )

% DESCRIPTION
% A partir de un archivo con valores Zecg (heart rate) extraemos un vector
% de caracteristicas basandonos en 2 umbrales dados y aplicando una ventana
% determinada
%
% INPUTS
%   Zecg   vector con valores de heart rate que vamos a analizar
%
%   umbral1   umbral 1 en el que nos vamos a basar (opcion media+desv)
%
%   umbral2   umbral 2 en el que nos vamos a basar (opcion percentil)
%
%   n1_HR           tamaño de ventana en numero de muestras para el 
%                   etiquetado a nivel 1
%
%   inc_n1_HR       incremento de ventana en numero de muestras para el 
%                   etiquetado a nivel 1
%
% OUTPUTS:
%
%   labels1   vector de etiquetas extraidas a partir del umbral1
%
%   labels2   vector de etiquetas extraidas a partir del umbral2
%
% AUTHOR
%   Alba Minguez, Junio 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Esta función recorre un vector Zecg de HR dado y va pasando una ventana y
% comparando con los umbrales introducidos

    % Creamos vectores labels vacios

    labels1 = []; %Etiquetas base opcion 1 (media+desv)
    labels2 = []; %Etiquetas base opcion 2 (percentil)
    cont1 = 1; %contadores para ir rellenando el vector de etiquetas
    cont2 = 1;
    
    nVeces = floor(size(Zecg,1)/inc_n1_HR) - 1;
    i_final = floor(size(Zecg,1)/inc_n1_HR) * inc_n1_HR;
    
    cont_vez = 1; %contador para el numero de veces que se mueve la trama
    i_label = 1; %contador para mover el indice por el vector
    
    while (cont_vez <= nVeces )
        
        porcion_trama = Zecg(i_label:(i_label+n1_HR-1),1);
        
        media_trama = mean(porcion_trama);
                
        % Opcion 1:
        
        if media_trama > umbral1
            
            labels1(cont1) = 1;
            
        else
            
            labels1(cont1) = 0;
            
        end       
        
        cont1 = cont1 + 1;
        
        % Opcion 2:

        if media_trama > umbral2
            
            labels2(cont2) = 1;
            
        else
            
            labels2(cont2) = 0;
            
        end  
        
        cont2 = cont2 + 1;
        
        i_label = i_label + inc_n1_HR;
        
        cont_vez = cont_vez+1;
        
    end %end while
        
    % Calculamos la etiqueta para lo que sobra al final del vector   
    
    if i_final <= size(Zecg,1)-1
               
        porcion_trama = Zecg(i_label:(size(Zecg,1)-1),1);
        
        media_trama = mean(porcion_trama);

           % Opcion 1:

            if media_trama > umbral1

                labels1(cont1) = 1;

            else

                labels1(cont1) = 0;

            end       


            % Opcion 2:

            if media_trama > umbral2

                labels2(cont2) = 1;

            else

                labels2(cont2) = 0;

            end  
            
    end %end if i_final <= size(Zecg,1)-1   



end

