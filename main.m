%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                   MAIN                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% El objetivo de este proyecto es la extracci�n de caracter�sticas y
% vectores de etiquetas a partir de los archivos de la base de datos VOCE.
% Por una parte, tanto las matrices de caracter�sticas como los vectores de
% etiquetas ser�n calculados a lo que denominaremos 2 niveles de ventana.
%
% El nivel 1 ser� el nivel correspondiente a la ventana menor (aprox 1-2
% segundos), y, el nivel 2 ser� el correspondiente a le ventana mayor (unos
% 10 segundos). Los datos del segundo nivel ser�n extra�dos a partir de los
% datos del nivel 1.
%
% El c�lculo de las matrices de las caracter�sticas se basar� en extraer el
% pitch, mfcc, formantes y energ�a con sus correspondientes estad�sticos
% (media y varianza) para ambos niveles.
%
% Por otra parte, el c�lculo de etiquetas se basar� en los archivos xml de
% la base de datos que contienen los valores de Heart Rate (HR) del usuario
% mientras habla el audio del que extraemos las caracter�sticas. Los
% vectores de etiquetas seran binarios (1=estr�s, 0=no estres). Para
% determinar el 1 o el 0 vamos a establecer dos posibles umbrales de
% decision que denominaremos opcion 1 y opcion 2. La opci�n 1 se basa en un
% umbral1 que se calcula como la suma de la media + desviaci�n tipica de
% todos los valores de HR del archivo "base" correspondiente a cada
% usuario. La opci�n 2 se basa en la medida mediante percentil, es decir, a
% partir de un porcentaje que elijamos, los valores de HR se dividir�n en
% si est�n por encima o por debajo de ese porcentaje, obteniendo as� el 1 o
% el 0.
%
% Cada usuario (ID) tiene 2 audios, el audio de base (habla un texto por
% defecto en el que practicamente no hay estres) y el audio de recording
% (audio de evento p�blico de texto libre). A cada audio le corresponder�n
% 2 matrices de caracter�sticas** (nivel 1 y nivel 2) y 4 vectores de
% etiquetas (nivel 1 opcion 1 (L11), nivel 1 opcion 2 (L12), nivel 2 opcion
% 1 (L21) y nivel 2 opcion 2 (L22)). 
%
% ** En el caso de los audios cuya duraci�n sea mayor de 4 minutos, las
% matrices de caracter�sticas se dividir�n en bloques de audios de 4
% minutos por lo que le corresponder�n m�s de 2 matrices de
% caracter�sticas seg�n el n�mero de bloques en que se divida la se�al.
%


% PASO 0. A�adimos las toolbox y definimos las variables del trabajo

addpath(genpath('toolboxes')) %A�adimos carpetas y subcarpetas
clear all
clc

% Definici�n de variables

fs_audio = 16000; %Frecuencia audio con la que trabajaremos tras el resample
fs_HR = 1; %Tenemos una precisi�n m�xima de 1 valor de HR por segundo

% Ventana 1 (nivel 1):

rate1 = 1/2;

l1 = 2; %tama�o ventana en segundos
inc_l1 = l1*rate1; %incremento ventana en segundos

% Ventana 1 para audio en num de muestras
n1_audio = l1*fs_audio; %tama�o ventana en num muestras
inc_n1_audio = inc_l1*fs_audio; %incremento ventana en num muestras

% Ventana 1 para HR en num de muestras
n1_HR = l1*fs_HR; %tama�o ventana en num muestras
inc_n1_HR = inc_l1*fs_HR; %incremento ventana en num muestras

% Ventana 2 (nivel 2):

rate2 = 1/2;
factor = 5;

l2 = l1*factor; %tama�o ventana en segundos
inc_l2 = l2*rate2; %incremento ventana en segundos

% Ventana 2 para audio en num de muestras
n2_audio = l2*fs_audio; %tama�o ventana en num muestras
inc_n2_audio = inc_l2*fs_audio; %incremento ventana en num muestras

% Ventana 2 para HR en num de muestras
n2_HR = l2*fs_HR; %tama�o ventana en num muestras
inc_n2_HR = inc_l2*fs_HR; %incremento ventana en num muestras


% PASO 1 y 2. Preprocesado del set de audios y etiquetado 1: ventana de primer nivel (peque�a)

    preprocesado_set('set2', fs_audio, n1_HR, inc_n1_HR)

% Nivel 2: ventana de segundo nivel (grande)
    etiquetado2_set( 'set2', n2_HR, inc_n2_HR );

    
% 3. Calcular matrices de caracter�sticas a dos niveles (diferentes tama�os 
% de ventana)

    features_set( 'set2', fs_audio, l1, inc_l1, rate1, l2, inc_l2);

