function [ clean_data ] = clean_vector( data, umbral )
% NAME
%   clean_vector
% SYNOPSIS
%   [ clean_data ] = clean_vector( data, umbral )

% DESCRIPTION
% El objetivo es "limpiar" los 1's o 0's singulares que aparezcan en medio
% de ráfagas de 1's y 0's continuos.
%
% INPUTS
%   data        vector que queremos corregir
%
%   umbral      numero de muestras que ponemos como condicion para que una 
%               "ráfaga" de 1s o 0s se considere  continua
%
% OUTPUTS:
%
%   clean_data   vector data corregido
%
% AUTHOR
%   Alba Minguez, Junio 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
    startPos = find(diff([data(1)-1, data]));
    lengths = diff([startPos, numel(data)+1]);
    values = data(startPos);

    i=1;

    while(i<=length(values)-1)

        if lengths(i)<umbral %Si la racha actual es menor de 5

            if lengths(i+1)>=umbral || lengths(i+1)>= lengths(i)

                % Cambiamos los valores de la racha actual por el valor
                % contrario

                data(startPos(i):startPos(i+1)-1) = values(i+1);

            else

                if lengths(i+1) < lengths(i) 

                    if  i<length(values)-2 && lengths(i)+lengths(i+2)>=umbral

                        data(startPos(i+1):startPos(i+2)-1) = values(i+2);
                        i = i+1;

                    else

                        data(startPos(i):startPos(i+1)-1) = values(i+1);

                    end

                end
            end

            i = i+1;

        end

        i = i+1;

    end

    % Tratamos la última racha por separado fuera del bucle comparándola con la
    % penúltima racha

    ultima = length(values);

    if lengths(ultima)<umbral

        data(startPos(ultima):end) = values(ultima-1);

    end

    clean_data = data';



end

