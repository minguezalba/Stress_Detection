function [ output ] = redimensionar( input, win, inc, modo )
% NAME
%   redimensionar
% SYNOPSIS
%   [ output ] = redimensionar( input, win, inc, modo )

% DESCRIPTION
% El objetivo redimensionar un vector existente y convertirlo en otro con
% la dimension resultante de aplicar una ventana e incremento determinado.
%
% INPUTS
%   input   vector input
%
%   win     tamaño de ventana en numero de muestras que queremos aplicar
%
%   inc     incremento de ventana en numero de muestras que queremos aplicar
%
%   modo    podemos hacer 3 acciones con la porcion de trama que cabe en
%           cada ventana:
%           'mayoria_bin': Sirve para los vectores binarios. Pone en el
%           nuevo vector un 1 o un 0 según de lo que haya mayoria dandole
%           prioridad al 1
%           'media': Pone en el nuevo vector la media de los valores que
%           entran en la ventana
%           'varianza': Pone en el nuevo vector la varianza de los valores que
%           entran en la ventana
           
% OUTPUTS:
%
%   output   vector redimensionado
%
% AUTHOR
%   Alba Minguez, Junio 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    output = [];
    cont_vector = 1; %contador para ir rellenando el vector output

    % Vamos a recorrer el vector con el tamaño de ventana "win" con
    % desplazamiento "inc"

    nVeces = floor(length(input)/inc) - 1;
    i_final = floor(length(input)/inc) * inc;

    cont_vez = 1; %contador para el numero de veces que se mueve la trama
    i_vector = 1; %contador para mover el indice por el vector

    while (cont_vez <= nVeces )

        porcion_trama = input(i_vector:(i_vector+win-1));

        switch modo

           case 'mayoria_bin' % Caso decidir por mayoria de 1s o 0s

                num_1 = numel(find(porcion_trama==1)); %cantidad de 1's que aparecen en la porcion de la trama
                num_0 = numel(find(porcion_trama==0)); %cantidad de 0's que aparecen en la porcion de la trama


                if num_1 >= num_0 %si hay mas 1s que 0s (damos prioridad al 1)

                    output(cont_vector) = 1;

                else %si hay mas 0s que 1s

                    output(cont_vector) = 0;

                end       


           case 'media' % Caso rellenar con la media

               media = mean(porcion_trama);

               output(cont_vector) = media;
               
            case 'varianza' % Caso rellenar con la varianza

            varianza = var(porcion_trama);

            output(cont_vector) = varianza;

            otherwise
                sprintf('Error');
        end


        cont_vector = cont_vector + 1;

        i_vector = i_vector + inc;

        cont_vez = cont_vez+1;

    end %end while


    % Calculamos la etiqueta para lo que sobra al final del vector   

    if i_final <= length(input)-1

        porcion_trama = input(i_vector:length(input)-1);

        switch modo

           case 'mayoria_bin' % Caso decidir por mayoria de 1s o 0s

                num_1 = numel(find(porcion_trama==1)); %cantidad de 1's que aparecen en la porcion de la trama
                num_0 = numel(find(porcion_trama==0)); %cantidad de 0's que aparecen en la porcion de la trama


                if num_1 >= num_0 %si hay mas 1s que 0s

                    output(cont_vector) = 1;

                else %si hay mas 0s que 1s

                    output(cont_vector) = 0;

                end       


           case 'media' % Caso rellenar con la media (diezmado)

               media = mean(porcion_trama);

               output(cont_vector) = media;
               
            case 'varianza' % Caso rellenar con la varianza

            varianza = var(porcion_trama);

            output(cont_vector) = varianza;
            
            otherwise
                sprintf('Error');
        end

    end %end if i_final <= length(input)-1


    output = output';





end

