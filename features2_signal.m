function [ matriz2_features ] = features2_signal( matriz1_features,  l2, inc_l2 )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NAME
%   features2_signal - Extrae las características de un audio a nivel 2
%
% SYNOPSIS
%   [ matriz2_features ] = features2_signal( matriz1_features,  l2, inc_l2 )
%
% DESCRIPTION
% Esta funcion redimensiona la matriz de caracteristicas de nivel 1 al
% nivel 2 de ventana.
%
% INPUTS
%   
%   matriz1_features    Matriz de caracterisitcas a nivel 1 que queremos
%                       redimensionar
%
%   l2                  Tamaño de ventana en segundos del nivel 2 (grande)
%   inc_l2              Incremento de ventana en segundos del nivel 2
%
%   OUTPUTS:
%
%   matriz2_features    matriz de caracteristicas con dimension 33xN_tramas
%                       donde:
%                       fila 1      vector medias pitch
%                       fila 2      vector varianzas pitch
%                       fila 3-14   matriz medias mfcc
%                       fila 15-26  matriz varianzas mfcc
%                       fila 27-29  matriz medias formantes
%                       fila 30-32  matriz varianza formantes
%                       fila 33     vector energía
%
% SEE ALSO:
%   redimensionar.m
%
% AUTHOR
%   Alba Minguez, Junio 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    matriz2_features = [];
     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % MATRIZ 2: NIVEL VENTANA 2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 1. PITCH

    pitch2_media = redimensionar(matriz1_features(1,:), l2, inc_l2, 'media')';
    pitch2_var = redimensionar(matriz1_features(2,:), l2, inc_l2, 'media')';
    matriz2_features = vertcat(matriz2_features, pitch2_media);
    matriz2_features = vertcat(matriz2_features, pitch2_var);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 2. MFCC

    mfcc2_media = [];
    mfcc2_var = [];

    for j=1:12
         mfcc2_media(j,:) = redimensionar(matriz1_features(j+2,:), l2, inc_l2, 'media')';
         mfcc2_var(j,:) = redimensionar(matriz1_features(j+12+2,:), l2, inc_l2, 'media')';
    end

    matriz2_features = vertcat(matriz2_features, mfcc2_media);
    matriz2_features = vertcat(matriz2_features, mfcc2_var);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 3. FORMANTES

    formantes2_media = [];
    formantes2_var= [];

    for j=1:3
        formantes2_media(j,:) = redimensionar(matriz1_features(j+26,:), l2, inc_l2, 'media')';
        formantes2_var(j,:) = redimensionar(matriz1_features(j+3+26,:), l2, inc_l2, 'media')';
    end

    matriz2_features = vertcat(matriz2_features, formantes2_media);
    matriz2_features = vertcat(matriz2_features, formantes2_var);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 4. ENERGIA

    energia2 = redimensionar(matriz1_features(33,:), l2, inc_l2, 'media')';
    matriz2_features = vertcat(matriz2_features, energia2);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



end

