# -*- coding: utf-8 -*-

###############################################################################
#    File name: conjuntos_independ.py
#    Author: Alba Minguez
#    Date created: June 2017
#    Python Version: 2.7
#    Sklearn version: scikit-learn 0.18.1
#    
#    Description
#    This script creates the corresponding train and test sets with Set 1 and
#    Set 2 previously created from VOCE database.
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

set_train = 'set1'
set_test = 'set2'

# Matrices nivel 1: tamano ventana pequena
dir_features1_train = glob.glob("recordings/"+ set_train +"/features/matriz1*")
dir_features1_test = glob.glob("recordings/"+ set_test +"/features/matriz1*")

# Matrices nivel 1: tamano ventana grande
dir_features2_train = glob.glob("recordings/"+ set_train +"/features/matriz2*")
dir_features2_test = glob.glob("recordings/"+ set_test +"/features/matriz2*")

# Etiquetas nivel 1 opcion 1 (media+desv)
dir_labels11_train = glob.glob("recordings/"+ set_train +"/labels/L11_*")
dir_labels11_test = glob.glob("recordings/"+ set_test +"/labels/L11_*")

# Etiquetas nivel 1 opcion 2 (percentil)
dir_labels12_train = glob.glob("recordings/"+ set_train +"/labels/L12_*")
dir_labels12_test = glob.glob("recordings/"+ set_test +"/labels/L12_*")

# Etiquetas nivel 2 opcion 1 (media+desv)
dir_labels21_train = glob.glob("recordings/"+ set_train +"/labels/L21_*")
dir_labels21_test = glob.glob("recordings/"+ set_test +"/labels/L21_*")

# Etiquetas nivel 2 opcion 2 (percentil)
dir_labels22_train = glob.glob("recordings/"+ set_train +"/labels/L22_*")
dir_labels22_test = glob.glob("recordings/"+ set_test +"/labels/L22_*")

#############################################################################

# Cargamos datos de edades y genero
edades = pickle.load( open( "recordings/metadata/edades.p", "rb" ) )
generos = pickle.load( open( "recordings/metadata/generos.p", "rb" ) )

#############################################################################

#############################################################################

# Cargamos y juntamos las matrices de caracteristicas 1

matriz1_features_train = [] #Matriz de caracteristicas del set a nivel 1

for index, audio in enumerate(dir_features1_train):
    
    if index==0:
        matriz1_features_train = scipy.io.loadmat(audio)['matriz1_features']    
    else:
        matriz_audio = scipy.io.loadmat(audio)['matriz1_features']
        matriz1_features_train = np.hstack((matriz1_features_train, matriz_audio))

# Trasponemos la matriz para tener ntramas x caracteristicas

matriz1_features_train = matriz1_features_train.T 

matriz1_features_test = [] #Matriz de caracteristicas del set a nivel 1

for index, audio in enumerate(dir_features1_test):
    
    if index==0:
        matriz1_features_test = scipy.io.loadmat(audio)['matriz1_features']    
    else:
        matriz_audio = scipy.io.loadmat(audio)['matriz1_features']
        matriz1_features_test = np.hstack((matriz1_features_test, matriz_audio))

# Trasponemos la matriz para tener ntramas x caracteristicas

matriz1_features_test = matriz1_features_test.T 

#############################################################################

#############################################################################

# Cargamos y juntamos las matrices de caracteristicas 2

matriz2_features_train = [] #Matriz de caracteristicas del set a nivel 2

for index, audio in enumerate(dir_features2_train):
    
    if index==0:
        matriz2_features_train = scipy.io.loadmat(audio)['matriz2_features']    
    else:
        matriz_audio = scipy.io.loadmat(audio)['matriz2_features']
        matriz2_features_train = np.hstack((matriz2_features_train, matriz_audio))

# Trasponemos la matriz para tener ntramas x caracteristicas

matriz2_features_train = matriz2_features_train.T 

matriz2_features_test = [] #Matriz de caracteristicas del set a nivel 2

for index, audio in enumerate(dir_features2_test):
    
    if index==0:
        matriz2_features_test = scipy.io.loadmat(audio)['matriz2_features']    
    else:
        matriz_audio = scipy.io.loadmat(audio)['matriz2_features']
        matriz2_features_test = np.hstack((matriz2_features_test, matriz_audio))

# Trasponemos la matriz para tener ntramas x caracteristicas

matriz2_features_test = matriz2_features_test.T 

#############################################################################

# Cargamos y juntamos los vectores de etiquetas nivel 1 opcion 1

etiquetas11_train = [] 
ID_1_train = [] #vector de IDs nivel 1. Contiene el ID correspondiente a cada trama
# del nivel 1. Coincide tanto para las etiquetas 11, 12 y matriz1_features

for index, audio in enumerate(dir_labels11_train):
    
    if index==0:
        etiquetas11_train = scipy.io.loadmat(audio)['labels1'] 
        ID = get_ID(audio)
        replica_ID = np.repeat(ID, etiquetas11_train.shape[1])
        ID_1_train = replica_ID
              
    else:
        vector_etiquetas = scipy.io.loadmat(audio)['labels1']
        vector_etiquetas = vector_etiquetas.T
        etiquetas11_train = np.append(etiquetas11_train, vector_etiquetas)
                
        ID = get_ID(audio)
        replica_ID = np.repeat(ID, vector_etiquetas.shape[0])
        ID_1_train = np.append(ID_1_train, replica_ID)

etiquetas11_test = [] 
ID_1_test = [] #vector de IDs nivel 1. Contiene el ID correspondiente a cada trama
# del nivel 1. Coincide tanto para las etiquetas 11, 12 y matriz1_features

for index, audio in enumerate(dir_labels11_test):
    
    if index==0:
        etiquetas11_test = scipy.io.loadmat(audio)['labels1'] 
        ID = get_ID(audio)
        replica_ID = np.repeat(ID, etiquetas11_test.shape[1])
        ID_1_test = replica_ID
              
    else:
        vector_etiquetas = scipy.io.loadmat(audio)['labels1']
        vector_etiquetas = vector_etiquetas.T
        etiquetas11_test = np.append(etiquetas11_test, vector_etiquetas)
                
        ID = get_ID(audio)
        replica_ID = np.repeat(ID, vector_etiquetas.shape[0])
        ID_1_test = np.append(ID_1_test, replica_ID)
    
#############################################################################

# Cargamos y juntamos los vectores de etiquetas nivel 1 opcion 2

etiquetas12_train = []

for index, audio in enumerate(dir_labels12_train):
    
    if index==0:
        etiquetas12_train = scipy.io.loadmat(audio)['labels1']    
    else:
        vector_etiquetas = scipy.io.loadmat(audio)['labels1']
        vector_etiquetas = vector_etiquetas.T
        etiquetas12_train = np.append(etiquetas12_train, vector_etiquetas)
        
        
etiquetas12_test = []

for index, audio in enumerate(dir_labels12_test):
    
    if index==0:
        etiquetas12_test = scipy.io.loadmat(audio)['labels1']    
    else:
        vector_etiquetas = scipy.io.loadmat(audio)['labels1']
        vector_etiquetas = vector_etiquetas.T
        etiquetas12_test = np.append(etiquetas12_test, vector_etiquetas)

#############################################################################

# Cargamos y juntamos los vectores de etiquetas nivel 1 opcion 2

ID_2_train = [] #vector de IDs nivel 2. Contiene el ID correspondiente a cada trama
# del nivel 1. Coincide tanto para las etiquetas 21, 22 y matriz2_features

etiquetas21_train = []

for index, audio in enumerate(dir_labels21_train):
    
    if index==0:
        etiquetas21_train = scipy.io.loadmat(audio)['labels2']   
        ID = get_ID(audio)
        replica_ID = np.repeat(ID, etiquetas21_train.shape[1])
        ID_2_train = replica_ID 
    else:
        vector_etiquetas = scipy.io.loadmat(audio)['labels2']
        vector_etiquetas = vector_etiquetas.T
        etiquetas21_train = np.append(etiquetas21_train, vector_etiquetas)
        
        ID = get_ID(audio)
        replica_ID = np.repeat(ID, vector_etiquetas.shape[0])
        ID_2_train = np.append(ID_2_train, replica_ID)
        
# Cargamos y juntamos los vectores de etiquetas nivel 1 opcion 2

ID_2_test = [] #vector de IDs nivel 2. Contiene el ID correspondiente a cada trama
# del nivel 1. Coincide tanto para las etiquetas 21, 22 y matriz2_features

etiquetas21_test = []

for index, audio in enumerate(dir_labels21_test):
    
    if index==0:
        etiquetas21_test = scipy.io.loadmat(audio)['labels2']   
        ID = get_ID(audio)
        replica_ID = np.repeat(ID, etiquetas21_test.shape[1])
        ID_2_test = replica_ID 
    else:
        vector_etiquetas = scipy.io.loadmat(audio)['labels2']
        vector_etiquetas = vector_etiquetas.T
        etiquetas21_test = np.append(etiquetas21_test, vector_etiquetas)
        
        ID = get_ID(audio)
        replica_ID = np.repeat(ID, vector_etiquetas.shape[0])
        ID_2_test = np.append(ID_2_test, replica_ID)

#############################################################################

# Cargamos y juntamos los vectores de etiquetas nivel 1 opcion 2

etiquetas22_train = []

for index, audio in enumerate(dir_labels22_train):
    
    if index==0:
        etiquetas22_train = scipy.io.loadmat(audio)['labels2']    
    else:
        vector_etiquetas = scipy.io.loadmat(audio)['labels2']
        vector_etiquetas = vector_etiquetas.T
        etiquetas22_train = np.append(etiquetas22_train, vector_etiquetas)
        
# Cargamos y juntamos los vectores de etiquetas nivel 1 opcion 2

etiquetas22_test = []

for index, audio in enumerate(dir_labels22_test):
    
    if index==0:
        etiquetas22_test = scipy.io.loadmat(audio)['labels2']    
    else:
        vector_etiquetas = scipy.io.loadmat(audio)['labels2']
        vector_etiquetas = vector_etiquetas.T
        etiquetas22_test = np.append(etiquetas22_test, vector_etiquetas)


##############################################################################

# Conjuntos train y test para el nivel 1 (ventana pequena)
X_train1 = matriz1_features_train
X_test1 = matriz1_features_test

# Conjuntos train y test para el nivel 2 (ventana grande)
X_train2 = matriz2_features_train
X_test2 = matriz2_features_test

#############################################################################

# Creamos los correspondientes de Ytest e Ytrain con los mismos indices

# Etiquetas para el nivel 1 (ventana pequena)
# Opcion 1: media+desv
Y_train11 = etiquetas11_train
Y_test11 = etiquetas11_test

# Opcion 2: percentil
Y_train12 = etiquetas12_train
Y_test12 = etiquetas12_test

# Etiquetas para el nivel 2 (ventana grande)
# Opcion 1: media+desv
Y_train21 = etiquetas21_train
Y_test21 = etiquetas21_test

# Opcion 2: percentil
Y_train22 = etiquetas22_train
Y_test22 = etiquetas22_test

ID_train1 = ID_1_train
ID_test1 = ID_1_test

ID_train2 = ID_2_train
ID_test2 = ID_2_test

#############################################################################

# Guardamos estos conjuntos en /features/set1/prueba..

carpeta_prueba = 'prueba_independ/'

np.save('recordings/' + carpeta_prueba + 'X_train1', X_train1)
np.save('recordings/' + carpeta_prueba + 'X_test1', X_test1)

np.save('recordings/' + carpeta_prueba + 'X_train2', X_train2)
np.save('recordings/' + carpeta_prueba + 'X_test2', X_test2)

np.save('recordings/' + carpeta_prueba + 'ID_train1', ID_train1)
np.save('recordings/' + carpeta_prueba + 'ID_test1', ID_test1)

np.save('recordings/' + carpeta_prueba + 'ID_train2', ID_train2)
np.save('recordings/' + carpeta_prueba + 'ID_test2', ID_test2)

np.save('recordings/' + carpeta_prueba + 'Y_train11', Y_train11)
np.save('recordings/' + carpeta_prueba + 'Y_test11', Y_test11)

np.save('recordings/' + carpeta_prueba + 'Y_train12', Y_train12)
np.save('recordings/' + carpeta_prueba + 'Y_test12', Y_test12)

np.save('recordings/' + carpeta_prueba + 'Y_train21', Y_train21)
np.save('recordings/' + carpeta_prueba + 'Y_test21', Y_test21)

np.save('recordings/' + carpeta_prueba + 'Y_train22', Y_train22)
np.save('recordings/' + carpeta_prueba + 'Y_test22', Y_test22)