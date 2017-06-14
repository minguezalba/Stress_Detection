%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                   MAIN                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% El objetivo de este proyecto es la extracción de características y
% vectores de etiquetas a partir de los archivos de la base de datos VOCE.
% Por una parte, tanto las matrices de características como los vectores de
% etiquetas serán calculados a lo que denominaremos 2 niveles de ventana.
%
% El nivel 1 será el nivel correspondiente a la ventana menor (aprox 1-2
% segundos), y, el nivel 2 será el correspondiente a le ventana mayor (unos
% 10 segundos). Los datos del segundo nivel serán extraídos a partir de los
% datos del nivel 1.
%
% El cálculo de las matrices de las características se basará en extraer el
% pitch, mfcc, formantes y energía con sus correspondientes estadísticos
% (media y varianza) para ambos niveles.
%
% Por otra parte, el cálculo de etiquetas se basará en los archivos xml de
% la base de datos que contienen los valores de Heart Rate (HR) del usuario
% mientras habla el audio del que extraemos las características. Los
% vectores de etiquetas seran binarios (1=estrés, 0=no estres). Para
% determinar el 1 o el 0 vamos a establecer dos posibles umbrales de
% decision que denominaremos opcion 1 y opcion 2. La opción 1 se basa en un
% umbral1 que se calcula como la suma de la media + desviación tipica de
% todos los valores de HR del archivo "base" correspondiente a cada
% usuario. La opción 2 se basa en la medida mediante percentil, es decir, a
% partir de un porcentaje que elijamos, los valores de HR se dividirán en
% si están por encima o por debajo de ese porcentaje, obteniendo así el 1 o
% el 0.
%
% Cada usuario (ID) tiene 2 audios, el audio de base (habla un texto por
% defecto en el que practicamente no hay estres) y el audio de recording
% (audio de evento público de texto libre). A cada audio le corresponderán
% 2 matrices de características** (nivel 1 y nivel 2) y 4 vectores de
% etiquetas (nivel 1 opcion 1 (L11), nivel 1 opcion 2 (L12), nivel 2 opcion
% 1 (L21) y nivel 2 opcion 2 (L22)). 
%
% ** En el caso de los audios cuya duración sea mayor de 4 minutos, las
% matrices de características se dividirán en bloques de audios de 4
% minutos por lo que le corresponderán más de 2 matrices de
% características según el número de bloques en que se divida la señal.
%


% PASO 0. Añadimos las toolbox y definimos las variables del trabajo

addpath(genpath('toolboxes')) %Añadimos carpetas y subcarpetas
clear all
clc

% Definición de variables

fs_audio = 16000; %Frecuencia audio con la que trabajaremos tras el resample
fs_HR = 1; %Tenemos una precisión máxima de 1 valor de HR por segundo

% Ventana 1 (nivel 1):

rate1 = 1/2;

l1 = 2; %tamaño ventana en segundos
inc_l1 = l1*rate1; %incremento ventana en segundos

% Ventana 1 para audio en num de muestras
n1_audio = l1*fs_audio; %tamaño ventana en num muestras
inc_n1_audio = inc_l1*fs_audio; %incremento ventana en num muestras

% Ventana 1 para HR en num de muestras
n1_HR = l1*fs_HR; %tamaño ventana en num muestras
inc_n1_HR = inc_l1*fs_HR; %incremento ventana en num muestras

% Ventana 2 (nivel 2):

rate2 = 1/2;
factor = 5;

l2 = l1*factor; %tamaño ventana en segundos
inc_l2 = l2*rate2; %incremento ventana en segundos

% Ventana 2 para audio en num de muestras
n2_audio = l2*fs_audio; %tamaño ventana en num muestras
inc_n2_audio = inc_l2*fs_audio; %incremento ventana en num muestras

% Ventana 2 para HR en num de muestras
n2_HR = l2*fs_HR; %tamaño ventana en num muestras
inc_n2_HR = inc_l2*fs_HR; %incremento ventana en num muestras


% PASO 1 y 2. Preprocesado del set de audios y etiquetado 1: ventana de primer nivel (pequeña)

    preprocesado_set('set2', fs_audio, n1_HR, inc_n1_HR)

% Nivel 2: ventana de segundo nivel (grande)
    etiquetado2_set( 'set2', n2_HR, inc_n2_HR );

    
% 3. Calcular matrices de características a dos niveles (diferentes tamaños 
% de ventana)

    features_set( 'set2', fs_audio, l1, inc_l1, rate1, l2, inc_l2);

