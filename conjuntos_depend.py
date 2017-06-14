# -*- coding: utf-8 -*-

###############################################################################
#    File name: conjuntos_depend.py
#    Author: Alba Minguez
#    Date created: June 2017
#    Python Version: 2.7
#    Sklearn version: scikit-learn 0.18.1
#    
#    Description
#    This script creates the corresponding train and test sets for one selected
#    set, dividing data in 80% train and 20% test
###############################################################################

#############################################################################
#                               LIBRERIAS                                   #
#############################################################################

import numpy as np
import scipy.io
import glob
import pickle

#############################################################################
#                               FUNCIONES                                   #
#############################################################################

def get_edad_genero(namefile, edades, genero):
    
    partes = namefile.split("_") #Dividimos el nombre del archivo
    
    #El nombre del archivo siempre será ...matriz1_ID_XXXXXX o L22_ID_XXXXX
    #Por tanto el numero de ID siempre estará en partes[2]
    ID = partes[2]
    
    edad = edades.get(ID, default=0)
    gen = genero.get(ID, default=0)
    
    return edad, gen
    
    
def get_ID(namefile):
    
    partes = namefile.split("_") #Dividimos el nombre del archivo
    
    #El nombre del archivo siempre será ...matriz1_ID_XXXXXX o L22_ID_XXXXX
    #Por tanto el numero de ID siempre estará en partes[2]
    ID = partes[2]
    
    return ID

# Definimos los directorios para cada conjunto

set_name = 'set3'

# Matrices nivel 1: tamano ventana pequena
dir_features1 = glob.glob("recordings/"+ set_name +"/features/matriz1*")

# Matrices nivel 1: tamano ventana grande
dir_features2 = glob.glob("recordings/"+ set_name +"/features/matriz2*")

# Etiquetas nivel 1 opcion 1 (media+desv)
dir_labels11 = glob.glob("recordings/"+ set_name +"/labels/L11_*")

# Etiquetas nivel 1 opcion 2 (percentil)
dir_labels12 = glob.glob("recordings/"+ set_name +"/labels/L12_*")

# Etiquetas nivel 2 opcion 1 (media+desv)
dir_labels21 = glob.glob("recordings/"+ set_name +"/labels/L21_*")

# Etiquetas nivel 2 opcion 2 (percentil)
dir_labels22 = glob.glob("recordings/"+ set_name +"/labels/L22_*")

#############################################################################

# Cargamos datos de edades y genero
edades = pickle.load( open( "recordings/metadata/edades.p", "rb" ) )
generos = pickle.load( open( "recordings/metadata/generos.p", "rb" ) )

#############################################################################

# OJO! PODEMOS JUNTAR LAS MATRICES UNA DETRAS DE LA OTRA Y HACER LO MISMO CON 
# LAS ETIQUETAS PORQUE LOS FICHEROS DE LAS CARPETAS SE LEEN ALFABETICAMENTE Y
# EL ORDEN DE LAS MATRICES CORRESPONDE CON LAS ETIQUETAS

#############################################################################

# Cargamos y juntamos las matrices de caracteristicas 1

matriz1_features = [] #Matriz de caracteristicas del set a nivel 1

for index, audio in enumerate(dir_features1):
    
    if index==0:
        matriz1_features = scipy.io.loadmat(audio)['matriz1_features']    
    else:
        matriz_audio = scipy.io.loadmat(audio)['matriz1_features']
        matriz1_features = np.hstack((matriz1_features, matriz_audio))

# Trasponemos la matriz para tener ntramas x caracteristicas

matriz1_features = matriz1_features.T 

#############################################################################

# Cargamos y juntamos las matrices de caracteristicas 2

matriz2_features = [] #Matriz de caracteristicas del set a nivel 1

for index, audio in enumerate(dir_features2):
    
    if index==0:
        matriz2_features = scipy.io.loadmat(audio)['matriz2_features']    
    else:
        matriz_audio = scipy.io.loadmat(audio)['matriz2_features']
        matriz2_features = np.hstack((matriz2_features, matriz_audio))

# Trasponemos la matriz para tener ntramas x caracteristicas

matriz2_features = matriz2_features.T 
       
#############################################################################

# Cargamos y juntamos los vectores de etiquetas nivel 1 opcion 1

etiquetas11 = [] 
ID_1 = [] #vector de IDs nivel 1. Contiene el ID correspondiente a cada trama
# del nivel 1. Coincide tanto para las etiquetas 11, 12 y matriz1_features

for index, audio in enumerate(dir_labels11):
    
    if index==0:
        etiquetas11 = scipy.io.loadmat(audio)['labels1'] 
        ID = get_ID(audio)
        replica_ID = np.repeat(ID, etiquetas11.shape[1])
        ID_1 = replica_ID
              
    else:
        vector_etiquetas = scipy.io.loadmat(audio)['labels1']
        vector_etiquetas = vector_etiquetas.T
        etiquetas11 = np.append(etiquetas11, vector_etiquetas)
                
        ID = get_ID(audio)
        replica_ID = np.repeat(ID, vector_etiquetas.shape[0])
        ID_1 = np.append(ID_1, replica_ID)


    
#############################################################################

# Cargamos y juntamos los vectores de etiquetas nivel 1 opcion 2

etiquetas12 = []

for index, audio in enumerate(dir_labels12):
    
    if index==0:
        etiquetas12 = scipy.io.loadmat(audio)['labels1']    
    else:
        vector_etiquetas = scipy.io.loadmat(audio)['labels1']
        vector_etiquetas = vector_etiquetas.T
        etiquetas12 = np.append(etiquetas12, vector_etiquetas)

#############################################################################

# Cargamos y juntamos los vectores de etiquetas nivel 1 opcion 2

ID_2 = [] #vector de IDs nivel 2. Contiene el ID correspondiente a cada trama
# del nivel 1. Coincide tanto para las etiquetas 21, 22 y matriz2_features

etiquetas21 = []

for index, audio in enumerate(dir_labels21):
    
    if index==0:
        etiquetas21 = scipy.io.loadmat(audio)['labels2']   
        ID = get_ID(audio)
        replica_ID = np.repeat(ID, etiquetas21.shape[1])
        ID_2 = replica_ID 
    else:
        vector_etiquetas = scipy.io.loadmat(audio)['labels2']
        vector_etiquetas = vector_etiquetas.T
        etiquetas21 = np.append(etiquetas21, vector_etiquetas)
        
        ID = get_ID(audio)
        replica_ID = np.repeat(ID, vector_etiquetas.shape[0])
        ID_2 = np.append(ID_2, replica_ID)

#############################################################################

# Cargamos y juntamos los vectores de etiquetas nivel 1 opcion 2

etiquetas22 = []

for index, audio in enumerate(dir_labels22):
    
    if index==0:
        etiquetas22 = scipy.io.loadmat(audio)['labels2']    
    else:
        vector_etiquetas = scipy.io.loadmat(audio)['labels2']
        vector_etiquetas = vector_etiquetas.T
        etiquetas22 = np.append(etiquetas22, vector_etiquetas)


##############################################################################
# Creamos los conjuntos de Xtest y Xtrain de forma aleatoria (80%-20%)

N1 = matriz1_features.shape[0] #Muestras totales matriz1_features
N2 = matriz2_features.shape[0] #Muestras totales matriz1_features

np.random.seed() #Iniciamos la semilla para las funciones que hagan cosas aleatorias
perm1=np.random.permutation(N1) #Vector con valores entre 0 y N-1 desordenados
perm2=np.random.permutation(N2) #Vector con valores entre 0 y N-1 desordenados

num1_train=int(np.round((0.8*N1),0)) # 80% conjunto train
num1_test=int(N1-num1_train) # 20% conjunto test

num2_train=int(np.round((0.8*N2),0)) # 80% conjunto train
num2_test=int(N2-num2_train) # 20% conjunto test

# Conjuntos train y test para el nivel 1 (ventana pequena)
X_train1 = matriz1_features[perm1[num1_test:N1]] 
X_test1 = matriz1_features[perm1[0:num1_test]] 

# Conjuntos train y test para el nivel 2 (ventana grande)
X_train2 = matriz2_features[perm2[num2_test:N2]] 
X_test2 = matriz2_features[perm2[0:num2_test]]

#############################################################################

# Creamos los correspondientes de Ytest e Ytrain con los mismos indices

# Etiquetas para el nivel 1 (ventana pequena)
# Opcion 1: media+desv
Y_train11 = etiquetas11[perm1[num1_test:N1]]
Y_test11 = etiquetas11[perm1[0:num1_test]] 

# Opcion 2: percentil
Y_train12 = etiquetas12[perm1[num1_test:N1]]
Y_test12 = etiquetas12[perm1[0:num1_test]] 

# Etiquetas para el nivel 2 (ventana grande)
# Opcion 1: media+desv
Y_train21 = etiquetas21[perm2[num2_test:N2]]
Y_test21 = etiquetas21[perm2[0:num2_test]] 

# Opcion 2: percentil
Y_train22 = etiquetas22[perm2[num2_test:N2]]
Y_test22 = etiquetas22[perm2[0:num2_test]] 

ID_train1 = ID_1[perm1[num1_test:N1]]
ID_test1 = ID_1[perm1[0:num1_test]]

ID_train2 = ID_2[perm2[num2_test:N2]]
ID_test2 = ID_2[perm2[0:num2_test]]

#############################################################################

# Guardamos estos conjuntos en /features/set1/prueba..

carpeta_set = 'set3/'
carpeta_prueba = 'prueba_depend/'

np.save('recordings/' + carpeta_set + carpeta_prueba + 'X_train1', X_train1)
np.save('recordings/' + carpeta_set + carpeta_prueba + 'X_test1', X_test1)

np.save('recordings/' + carpeta_set + carpeta_prueba + 'X_train2', X_train2)
np.save('recordings/' + carpeta_set + carpeta_prueba + 'X_test2', X_test2)

np.save('recordings/' + carpeta_set + carpeta_prueba + 'ID_train1', ID_train1)
np.save('recordings/' + carpeta_set + carpeta_prueba + 'ID_test1', ID_test1)

np.save('recordings/' + carpeta_set + carpeta_prueba + 'ID_train2', ID_train2)
np.save('recordings/' + carpeta_set + carpeta_prueba + 'ID_test2', ID_test2)

np.save('recordings/' + carpeta_set + carpeta_prueba + 'Y_train11', Y_train11)
np.save('recordings/' + carpeta_set + carpeta_prueba + 'Y_test11', Y_test11)

np.save('recordings/' + carpeta_set + carpeta_prueba + 'Y_train12', Y_train12)
np.save('recordings/' + carpeta_set + carpeta_prueba + 'Y_test12', Y_test12)

np.save('recordings/' + carpeta_set + carpeta_prueba + 'Y_train21', Y_train21)
np.save('recordings/' + carpeta_set + carpeta_prueba + 'Y_test21', Y_test21)

np.save('recordings/' + carpeta_set + carpeta_prueba + 'Y_train22', Y_train22)
np.save('recordings/' + carpeta_set + carpeta_prueba + 'Y_test22', Y_test22)
