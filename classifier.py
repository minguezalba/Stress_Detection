# -*- coding: utf-8 -*-

###############################################################################
#    File name: classifier.py
#    Author: Alba Minguez
#    Date created: June 2017
#    Python Version: 2.7
#    Sklearn version: scikit-learn 0.18.1
#    
#    Description
#    This script loads data previously created with conjuntos_depend.py or 
#    conjuntos_depend.py files in order to do the classification of stress.
#    This classification is done for different classifiers and will be evaluated
#    with precision, recall and f score values.
###############################################################################


#############################################################################
#                               LIBRERIAS                                   #
#############################################################################

import numpy as np
#import matplotlib.pyplot as plt
from sklearn.neural_network import MLPClassifier
from sklearn.svm import SVC

from sklearn.metrics import precision_score
from sklearn.metrics import recall_score
from sklearn.metrics import f1_score


#############################################################################
#                       DEFINICION DE FUNCIONES                             #
#############################################################################

def balancear(X_conjunto, Y_conjunto):

    muestras_0 = sum(Y_conjunto==0) #Muestras totales del conjunto con etiqueta 0
    muestras_1 = sum(Y_conjunto==1) #Muestras totales del conjunto con etiqueta 1
    
    # Creamos una matriz de ceros para las nuevas muestras
    nuevas_X = []
    nuevas_Y = []

    # Numero de muestras que vamos a tener que clonar
    resta = np.absolute(muestras_1-muestras_0)
    
    # Vamos a clonar aleatoriamente las muestras de las que menos haya
    
    if muestras_0 > muestras_1: #Si la clase mayoritaria es 0, trabajamos con el conjunto de etiquetas de la clase 1
    
        corregir_conjunto_X = X_conjunto[Y_conjunto == 1]
        nuevas_Y = np.ones((resta)) # Rellenamos con etiquetas 1
        
    else: #Si la clase mayoritaria es 1, trabajamos con el conjunto de etiquetas de la clase 0
    
        corregir_conjunto_X = X_conjunto[Y_conjunto == 0] 
        nuevas_Y = np.zeros((resta)) # Rellenamos con etiquetas 0
        
    
    for i in range (0,resta):
        
        # Creamos indice aleatorio para coger una muestra de la clase que menos haya
        num = int(np.random.randint(corregir_conjunto_X.shape[0], size=1))
        
        # Cogemos una muestra aleatoria del conjunto minoritario (grupo) para clonarla
        clonar_muestra = corregir_conjunto_X[num, :] #Muestra que queremos clonar        
        
        # Añadimos esa nueva muestra clonada al conjunto
        if i==0:
            nuevas_X = clonar_muestra #La metemos al final del conjunto
        else:
            nuevas_X = np.vstack((nuevas_X, clonar_muestra))
    
    
    X_balanceado = np.vstack((X_conjunto, nuevas_X))
    Y_balanceado = np.append(Y_conjunto, nuevas_Y)
    
    return X_balanceado, Y_balanceado

def normalizar(X_train_balanced, X_test):
    
    mx=np.mean(X_train_balanced, axis=0) #Media conjunto train
    std=np.std(X_train_balanced, axis=0) #Desviacion conjunto train
    
    X_train_nor = X_train_balanced - mx
    X_train_nor = X_train_nor/std
    X_test_nor = X_test - mx
    X_test_nor = X_test_nor/std
    
    return X_train_nor, X_test_nor
    

def cargar_datos(setname, prueba):
    
    # Cargamos los ficheros de datos para el conjunto correspondiente
    
    X_train1_unbalanced = np.load('recordings/'+ setname + prueba + 'X_train1.npy')
    X_test1 = np.load('recordings/'+ setname + prueba + 'X_test1.npy')
    
    X_train2_unbalanced = np.load('recordings/'+ setname + prueba + 'X_train2.npy')
    X_test2 = np.load('recordings/'+ setname + prueba + 'X_test2.npy')
    
    Y_train11_unbalanced = np.load('recordings/'+ setname + prueba + 'Y_train11.npy')
    Y_test11 = np.load('recordings/'+ setname + prueba + 'Y_test11.npy')
    
    Y_train12_unbalanced = np.load('recordings/'+ setname + prueba + 'Y_train12.npy')
    Y_test12 = np.load('recordings/'+ setname + prueba + 'Y_test12.npy')
    
    Y_train21_unbalanced = np.load('recordings/'+ setname + prueba + 'Y_train21.npy')
    Y_test21 = np.load('recordings/'+ setname + prueba + 'Y_test21.npy')
    
    Y_train22_unbalanced = np.load('recordings/'+ setname + prueba + 'Y_train22.npy')
    Y_test22 = np.load('recordings/'+ setname + prueba + 'Y_test22.npy')
    
    ID_train1 = np.load('recordings/'+ setname + prueba + 'ID_train1.npy')
    ID_test1 = np.load('recordings/'+ setname + prueba + 'ID_test1.npy')
    
    ID_train2 = np.load('recordings/'+ setname + prueba + 'ID_train2.npy')
    ID_test2 = np.load('recordings/'+ setname + prueba + 'ID_test2.npy')
    
    
    #############################################################################
    
    # Balanceamos los conjuntos de train para que tengan el mismo numero de 
    # ceros que de unos
    
    # Nivel ventana pequena, opcion 1 (media+desv)
    
    X_train11_balanced, Y_train11 = balancear(X_train1_unbalanced, Y_train11_unbalanced)
    
   
    # Nivel ventana pequena, opcion 2 (percentil)
    
    X_train12_balanced, Y_train12 = balancear(X_train1_unbalanced, Y_train12_unbalanced)
    
    
    # Nivel ventana grande, opcion 1 (media+desv)
    
    X_train21_balanced, Y_train21 = balancear(X_train2_unbalanced, Y_train21_unbalanced)
 
    
    # Nivel ventana grande, opcion 2 (percentil)
    
    X_train22_balanced, Y_train22 = balancear(X_train2_unbalanced, Y_train22_unbalanced)
   
    
    ##############################################################################
    
    # Normalizamos los conjuntos de X_train y X_test
    
    # Creamos un test para cada combinacion porque segun si es la opcion 1 o la 2, 
    # el numero de 0s o de 1s que tiene el train al equilibrar es distinto
    
    X_train11, X_test11 = normalizar(X_train11_balanced, X_test1)
    
    X_train12, X_test12 = normalizar(X_train12_balanced, X_test1)
    
    X_train21, X_test21 = normalizar(X_train21_balanced, X_test2)
    
    X_train22, X_test22 = normalizar(X_train22_balanced, X_test2)
    
    return (X_train11, X_test11,X_train12, X_test12,
            X_train21, X_test21,X_train22, X_test22,
            Y_train11, Y_test11,Y_train12, Y_test12,
            Y_train21, Y_test21,Y_train22, Y_test22,
            ID_train1, ID_test1, ID_train2, ID_test2)
    
def curva_PR(Y_test, Y_test_estimated): 

    P_logistic = precision_score(Y_test,Y_test_estimated)
    R_logistic = recall_score(Y_test,Y_test_estimated)
    F1_logistic = f1_score(Y_test,Y_test_estimated)

    return P_logistic, R_logistic, F1_logistic #, AUC
    
def clasificacion_MLP(X_train11, X_test11,X_train12, X_test12,
                      X_train21, X_test21,X_train22, X_test22,
                      Y_train11, Y_test11,Y_train12, Y_test12,
                      Y_train21, Y_test21,Y_train22, Y_test22):
    
   
    model_MLP_11 = MLPClassifier()
    model_MLP_11.fit(X_train11, Y_train11) #entrenamos el modelo
    Y_MLP11 = model_MLP_11.predict(X_test11)
    P_MLP11, R_MLP11, F_MLP11 = curva_PR(Y_test11, Y_MLP11)
    
    model_MLP_12 = MLPClassifier()
    model_MLP_12.fit(X_train12, Y_train12) #entrenamos el modelo
    Y_MLP12 = model_MLP_12.predict(X_test12)
    P_MLP12, R_MLP12, F_MLP12 = curva_PR(Y_test12, Y_MLP12) 
   
    model_MLP_21 = MLPClassifier()
    model_MLP_21.fit(X_train21, Y_train21) #entrenamos el modelo
    Y_MLP21 = model_MLP_21.predict(X_test21)
    P_MLP21, R_MLP21, F_MLP21 = curva_PR(Y_test21, Y_MLP21) 
    
    model_MLP_22 = MLPClassifier()
    model_MLP_22.fit(X_train22, Y_train22) #entrenamos el modelo
    Y_MLP22 = model_MLP_22.predict(X_test22)
    P_MLP22, R_MLP22, F_MLP22 = curva_PR(Y_test22, Y_MLP22) 

    
    return (P_MLP11, R_MLP11, F_MLP11, 
            P_MLP12, R_MLP12, F_MLP12,
            P_MLP21, R_MLP21, F_MLP21,
            P_MLP22, R_MLP22, F_MLP22)
    
    
def clasificacion_SVM(X_train11, X_test11,X_train12, X_test12,
                      X_train21, X_test21,X_train22, X_test22,
                      Y_train11, Y_test11,Y_train12, Y_test12,
                      Y_train21, Y_test21,Y_train22, Y_test22):  
    
    # La funcion kernel puede ser: ‘linear’, ‘poly’, ‘rbf’, ‘sigmoid' 
    func_kernel = 'sigmoid'
    
    print 'Clasificador SVM tipo ' + func_kernel
    
    model_SVM_11 = SVC(kernel=func_kernel)
    model_SVM_11.fit(X_train11, Y_train11) #entrenamos el modelo
    Y_SVM11 = model_SVM_11.predict(X_test11)
    P_SVM11, R_SVM11, F_SVM11 = curva_PR(Y_test11, Y_SVM11) 

    model_SVM_12 = SVC(kernel=func_kernel)
    model_SVM_12.fit(X_train12, Y_train12) #entrenamos el modelo
    Y_SVM12 = model_SVM_12.predict(X_test12)
    P_SVM12, R_SVM12, F_SVM12 = curva_PR(Y_test12, Y_SVM12) 

    model_SVM_21 = SVC(kernel=func_kernel)
    model_SVM_21.fit(X_train21, Y_train21) #entrenamos el modelo
    Y_SVM21 = model_SVM_21.predict(X_test21)
    P_SVM21, R_SVM21, F_SVM21 = curva_PR(Y_test21, Y_SVM21) 

    model_SVM_22 = SVC(kernel=func_kernel)
    model_SVM_22.fit(X_train22, Y_train22) #entrenamos el modelo
    Y_SVM22 = model_SVM_22.predict(X_test22)
    P_SVM22, R_SVM22, F_SVM22 = curva_PR(Y_test22, Y_SVM22) 

    
    return (P_SVM11, R_SVM11, F_SVM11,  
            P_SVM12, R_SVM12, F_SVM12, 
            P_SVM21, R_SVM21, F_SVM21, 
            P_SVM22, R_SVM22, F_SVM22)
    

#############################################################################
#                                 FUNCIÓN MAIN                              #
#############################################################################

N_veces = 5

# Inicializamos variables
P_MLP11 = np.zeros(N_veces)
R_MLP11 = np.zeros(N_veces)
F_MLP11 = np.zeros(N_veces)
Y_MLP11 = np.zeros(N_veces) 

P_MLP12 = np.zeros(N_veces)
R_MLP12 = np.zeros(N_veces)
F_MLP12 = np.zeros(N_veces)
Y_MLP12 = np.zeros(N_veces)

P_MLP21 = np.zeros(N_veces)
R_MLP21 = np.zeros(N_veces)
F_MLP21 = np.zeros(N_veces)
Y_MLP21 = np.zeros(N_veces)

P_MLP22 = np.zeros(N_veces)
R_MLP22 = np.zeros(N_veces)
F_MLP22 = np.zeros(N_veces)
Y_MLP22 = np.zeros(N_veces)
         
P_SVM11 = np.zeros(N_veces)
R_SVM11 = np.zeros(N_veces)
F_SVM11 = np.zeros(N_veces)
Y_SVM11 = np.zeros(N_veces)
 
P_SVM12 = np.zeros(N_veces) 
R_SVM12 = np.zeros(N_veces)
F_SVM12 = np.zeros(N_veces)
Y_SVM12 = np.zeros(N_veces) 
 
P_SVM21 = np.zeros(N_veces)
R_SVM21 = np.zeros(N_veces)
F_SVM21 = np.zeros(N_veces) 
Y_SVM21 = np.zeros(N_veces)
 
P_SVM22 = np.zeros(N_veces)
R_SVM22 = np.zeros(N_veces)
F_SVM22 = np.zeros(N_veces)
Y_SVM22 = np.zeros(N_veces)

#%%##############################################################################

modo = '0'

# Cargamos los datos del set correspondiente

#opciones 'setname': 'set1/', 'set2/', 'set3/' o ' '  para prueba=='prueba_independ/'
setname = ''
#opciones 'prueba': 'prueba_independ/' o 'prueba_depend/'
prueba = 'prueba_independ/'

(X_train11, X_test11,X_train12, X_test12,
X_train21, X_test21,X_train22, X_test22,
Y_train11, Y_test11,Y_train12, Y_test12,
Y_train21, Y_test21,Y_train22, Y_test22,
ID_train1, ID_test1, ID_train2, ID_test2)= cargar_datos(setname, prueba)

#%%##############################################################################
# Si queremos hacer la clasificacion para un ID concreto:
    
# modo == '0' : hacemos la clasificación para todos los IDS, el set completo
# modo != '0' : hacemos la clasificación para un ID concreto, caso==ID    

# Si queremos generar un ID aleatorio:
    
# Ejemplo prueba para ver para un ID concreto cómo de bien se ha estimado

#IDS_disponibles1 = np.unique(ID_test1)
#identificador1 = np.random.choice(IDS_disponibles1,1)
#print 'Clasificación a nivel 1 para el ID:', identificador1
#
## Por defecto, modo == '0'
#modo = identificador1

###############################################################################

if modo != '0':
    
    print '...........................................'
    print 'Clasificación concreta para el ID:', modo                       
    Y_test11 = Y_test11[ID_test1==modo]
    X_test11 = X_test11[ID_test1==modo,:]
    Y_test12 = Y_test12[ID_test1==modo]
    X_test12 = X_test12[ID_test1==modo,:]

    Y_test21 = Y_test21[ID_test2==modo]
    X_test21 = X_test21[ID_test2==modo,:]
    Y_test22 = Y_test22[ID_test2==modo]  
    X_test22 = X_test22[ID_test2==modo,:]     


#%%##############################################################################
for i in range (0, N_veces):
    
    (P_MLP11[i], R_MLP11[i], F_MLP11[i], 
    P_MLP12[i], R_MLP12[i], F_MLP12[i], 
    P_MLP21[i], R_MLP21[i], F_MLP21[i], 
    P_MLP22[i], R_MLP22[i], F_MLP22[i]) = clasificacion_MLP(X_train11, X_test11,X_train12, X_test12,
                                                            X_train21, X_test21,X_train22, X_test22,
                                                            Y_train11, Y_test11,Y_train12, Y_test12,
                                                            Y_train21, Y_test21,Y_train22, Y_test22)
    
    
print '...........................................'
print 'Modelo MLP nivel 1 opcion 1'
print 'Precision:' , np.mean(P_MLP11)
print 'Recall: ', np.mean(R_MLP11)
print 'F1: ', np.mean(F_MLP11)


print '...........................................'
print 'Modelo MLP nivel 1 opcion 2'
print 'Precision:' , np.mean(P_MLP12)
print 'Recall: ', np.mean(R_MLP12)
print 'F1: ', np.mean(F_MLP12)

print '...........................................'
print 'Modelo MLP nivel 2 opcion 1'
print 'Precision:' , np.mean(P_MLP21)
print 'Recall: ', np.mean(R_MLP21)
print 'F1: ', np.mean(F_MLP21)

print '...........................................'
print 'Modelo MLP nivel 2 opcion 2'
print 'Precision:' , np.mean(P_MLP22)
print 'Recall: ', np.mean(R_MLP22)
print 'F1: ', np.mean(F_MLP22)
 
    
#%%##############################################################################
for i in range (0, N_veces):
    (P_SVM11[i], R_SVM11[i], F_SVM11[i],
    P_SVM12[i], R_SVM12[i], F_SVM12[i], 
    P_SVM21[i], R_SVM21[i], F_SVM21[i], 
    P_SVM22[i], R_SVM22[i], F_SVM22[i]) = clasificacion_SVM(X_train11, X_test11,X_train12, X_test12,
                                                            X_train21, X_test21,X_train22, X_test22,
                                                            Y_train11, Y_test11,Y_train12, Y_test12,
                                                            Y_train21, Y_test21,Y_train22, Y_test22)

    

print '...........................................'
print 'Modelo SVM nivel 1 opcion 1'
print 'Precision:' , np.mean(P_SVM11)
print 'Recall: ', np.mean(R_SVM11)
print 'F1: ', np.mean(F_SVM11)

print '...........................................'
print 'Modelo SVM nivel 1 opcion 2'
print 'Precision:' , np.mean(P_SVM12)
print 'Recall: ', np.mean(R_SVM12)
print 'F1: ', np.mean(F_SVM12)

print '...........................................'
print 'Modelo SVM nivel 2 opcion 1'
print 'Precision:' , np.mean(P_SVM21)
print 'Recall: ', np.mean(R_SVM21)
print 'F1: ', np.mean(F_SVM21)

print '...........................................'
print 'Modelo SVM nivel 2 opcion 2'
print 'Precision:' , np.mean(P_SVM22)
print 'Recall: ', np.mean(R_SVM22)
print 'F1: ', np.mean(F_SVM22)