% Funcion para devolver el tipo de archivo que es el xml segun su
% estructura. Puede haber 3 tipos: prebaseline, baseline y recording

function [ tipo ] = type_file( name_file )

    tipo = -1;

    estructura = xml2struct(strcat('recordings/',name_file));
    
    if isfield(estructura, 'PreBaseline')
        tipo = 0;

    end
    
    if isfield(estructura, 'Baseline')
        tipo = 1;

    end
    
    if isfield(estructura, 'Recording')
        tipo = 2;

    end
    
end

