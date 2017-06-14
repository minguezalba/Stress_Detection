# -*- coding: utf-8 -*-
"""
Created on Fri May 26 10:13:48 2017

@author: Alba
"""

#############################################################################
#                               LIBRERIAS                                   #
#############################################################################

import numpy as np
#import matplotlib.pyplot as plt
from sklearn.neural_network import MLPClassifier
from sklearn.svm import SVC
from sklearn.feature_selection import RFE
import pickle

# Librerías Curvas Precision-Recall 
#from sklearn.metrics import precision_recall_curve
#from sklearn.metrics import average_precision_score
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
    
    #print '.........................................................'
    #print 'Train 11 No Equilibrado'
    #print 'Muestras clase 1 :', sum(Y_train11_unbalanced==1)
    #print 'Muestras clase 0:', sum(Y_train11_unbalanced==0)
    #print 'Muestras totales train:', sum(Y_train11_unbalanced==1)+sum(Y_train11_unbalanced==0)
    #print 'Train 11 Equilibrado'
    #print 'Muestras clase 1 :', sum(Y_train11==1)
    #print 'Muestras clase 0:', sum(Y_train11==0)
    #print 'Muestras totales train:', sum(Y_train11==1)+sum(Y_train11==0)
    
    
    # Nivel ventana pequena, opcion 2 (percentil)
    
    X_train12_balanced, Y_train12 = balancear(X_train1_unbalanced, Y_train12_unbalanced)
    
    #print '.........................................................'
    #print 'Train 12 No Equilibrado'
    #print 'Muestras clase 1 :', sum(Y_train12_unbalanced==1)
    #print 'Muestras clase 0:', sum(Y_train12_unbalanced==0)
    #print 'Muestras totales train:', sum(Y_train12_unbalanced==1)+sum(Y_train12_unbalanced==0)
    #print 'Train 12 Equilibrado'
    #print 'Muestras clase 1 :', sum(Y_train12==1)
    #print 'Muestras clase 0:', sum(Y_train12==0)
    #print 'Muestras totales train:', sum(Y_train12==1)+sum(Y_train12==0)
    
    
    # Nivel ventana grande, opcion 1 (media+desv)
    
    X_train21_balanced, Y_train21 = balancear(X_train2_unbalanced, Y_train21_unbalanced)
    
    #print '.........................................................'
    #print 'Train 21 No Equilibrado'
    #print 'Muestras clase 1 :', sum(Y_train21_unbalanced==1)
    #print 'Muestras clase 0:', sum(Y_train21_unbalanced==0)
    #print 'Muestras totales train:', sum(Y_train21_unbalanced==1)+sum(Y_train21_unbalanced==0)
    #print 'Train 21 Equilibrado'
    #print 'Muestras clase 1 :', sum(Y_train21==1)
    #print 'Muestras clase 0:', sum(Y_train21==0)
    #print 'Muestras totales train:', sum(Y_train21==1)+sum(Y_train21==0)
    
    
    # Nivel ventana grande, opcion 2 (percentil)
    
    X_train22_balanced, Y_train22 = balancear(X_train2_unbalanced, Y_train22_unbalanced)
    
    #print '.........................................................'
    #print 'Train 22 No Equilibrado'
    #print 'Muestras clase 1 :', sum(Y_train22_unbalanced==1)
    #print 'Muestras clase 0:', sum(Y_train22_unbalanced==0)
    #print 'Muestras totales train:', sum(Y_train22_unbalanced==1)+sum(Y_train22_unbalanced==0)
    #print 'Train 22 Equilibrado'
    #print 'Muestras clase 1 :', sum(Y_train22==1)
    #print 'Muestras clase 0:', sum(Y_train22==0)
    #print 'Muestras totales train:', sum(Y_train22==1)+sum(Y_train22==0)
    
    
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

#    # Compute Precision-Recall and plot curve
#    precision = dict()
#    recall = dict()
#    AUC = dict()
#
#    precision, recall, _ = precision_recall_curve(Y_test,Y_test_estimated)
#    AUC = average_precision_score(Y_test, Y_test_estimated)

    P_logistic = precision_score(Y_test,Y_test_estimated)
    R_logistic = recall_score(Y_test,Y_test_estimated)
    F1_logistic = f1_score(Y_test,Y_test_estimated)

    # Print values
    
#    print 'Precision:' , P_logistic
#    print 'Recall: ', R_logistic
#    print 'F1: ', F1_logistic
#    print 'AUC:', AUC
    

#    #Plot Precision-Recall curve
#    plt.figure()
#    plt.plot(recall, precision, color='navy',label='Precision-Recall curve')
#    plt.xlabel('Recall')
#    plt.ylabel('Precision')
#    plt.ylim([0.0, 1.05])
#    plt.xlim([0.0, 1.0])
#    plt.title('Precision-Recall example: AUC={0:0.2f}'.format(AUC))
#    plt.legend(loc="lower left")
#    plt.show()

    return P_logistic, R_logistic, F1_logistic #, AUC
    
# Matriz características: n_tramas x 33 características:
#columna 1      vector medias pitch
#columna 2      vector varianzas pitch
#columna 3-14   matriz medias mfcc
#columna 15-26  matriz varianzas mfcc
#columna 27-29  matriz medias formantes
#columna 30-32  matriz varianza formantes
#columna 33     vector energía    
    


def clasificacion_SVM(X_train11, X_test11, Y_train11, Y_test11, features):
    
    # con kernel='rbf' sale mejor resultado
    model_SVM_11 = SVC(kernel="linear")

    N_features = 1
    selector11 = RFE(model_SVM_11, N_features, step=1)
    selector11 = selector11.fit(X_train11, Y_train11)
    rank = selector11.ranking_
      
    model_SVM_11.fit(X_train11, Y_train11) #entrenamos el modelo
    Y_SVM11 = model_SVM_11.predict(X_test11)
    P_SVM11, R_SVM11, F_SVM11 = curva_PR(Y_test11, Y_SVM11) 

    
       
    return (P_SVM11, R_SVM11, F_SVM11)
    
    
    
    
###############################################################################

# Cargamos los datos del set correspondiente
features = pickle.load( open( "recordings/metadata/features.p", "rb" ) )
setname = 'set1/'
prueba = 'prueba2/'

(X_train11, X_test11,X_train12, X_test12,
X_train21, X_test21,X_train22, X_test22,
Y_train11, Y_test11,Y_train12, Y_test12,
Y_train21, Y_test21,Y_train22, Y_test22,
ID_train1, ID_test1, ID_train2, ID_test2)= cargar_datos(setname, prueba)  

  
(P_MLP11, R_MLP11, F_MLP11) = clasificacion_SVM(X_train11, X_test11, Y_train11, Y_test11, features)


print '...........................................'
print 'Modelo SVM nivel 1 opcion 1'
print 'Precision:' , P_MLP11
print 'Recall: ', R_MLP11
print 'F1: ', F_MLP11
    
print 'Las',  N_features , 'características con más peso son:'
    for i in range (0, rank.shape[0]):
        
        if rank[i]==1:
            print features[i]    
