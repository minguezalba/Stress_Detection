# -*- coding: utf-8 -*-

###############################################################################
#    File name: graficas.py
#    Author: Alba Minguez
#    Date created: June 2017
#    Python Version: 2.7
#    Sklearn version: scikit-learn 0.18.1
#    
#    Description
#    This file includes the necessary code to plot values of F score and HR mean
#    for base and recording time for each ID individually. You can choose easily
#    the set, classifier, level and threshold to analyse it.
###############################################################################

###############################################################################
#                               CONFIGURACIÓN                                 #
###############################################################################

import numpy as np
import matplotlib.pyplot as plt
import scipy.io
from sklearn.neural_network import MLPClassifier
from sklearn.svm import SVC
from sklearn.metrics import f1_score
import matplotlib.patches as mpatches
import pickle


###############################################################################
#                                  FUNCIONES                                  #
###############################################################################
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
    
def cargar_datos(setname, prueba, opcion):
    
    if setname=='set1' and prueba=='D':
        
        path = 'recordings/set1/prueba_depend/'
        path_Zecg = 'recordings/set1/'
        
    elif setname=='set2' and prueba=='D':
        
        path = 'recordings/set2/prueba_depend/'
        path_Zecg = 'recordings/set2/'
        
    elif setname=='set3' and prueba=='D':
        
        path = 'recordings/set3/prueba_depend/'
        path_Zecg = 'recordings/set3/'
        
    elif setname=='set3' and prueba=='I':
        
        path = 'recordings/prueba_independ/'
        path_Zecg = 'recordings/set3/'
        
    else: 
        print 'Error'
        
        
    if opcion=='11':
        
        set_train = 'X_train1.npy'
        set_test = 'X_test1.npy'
        
        eti_train = 'Y_train11.npy'
        eti_test = 'Y_test11.npy'
        
        train_ID = 'ID_train1.npy'
        test_ID = 'ID_test1.npy'
        
    elif opcion=='12':
        
        set_train = 'X_train1.npy'
        set_test = 'X_test1.npy'
        
        eti_train = 'Y_train12.npy'
        eti_test = 'Y_test12.npy'
        
        train_ID = 'ID_train1.npy'
        test_ID = 'ID_test1.npy'
        
    elif opcion=='21':
        
        set_train = 'X_train2.npy'
        set_test = 'X_test2.npy'
        
        eti_train = 'Y_train21.npy'
        eti_test = 'Y_test21.npy'
        
        train_ID = 'ID_train2.npy'
        test_ID = 'ID_test2.npy'
        
    elif opcion=='22':
        
        set_train = 'X_train2.npy'
        set_test = 'X_test2.npy'
        
        eti_train = 'Y_train22.npy'
        eti_test = 'Y_test22.npy'
        
        train_ID = 'ID_train2.npy'
        test_ID = 'ID_test2.npy'
        
    
    
    # Cargamos los ficheros de datos para el conjunto correspondiente
    
    X_train_unbalanced = np.load(path + set_train)
    X_test = np.load(path + set_test)
    
    Y_train_unbalanced = np.load(path + eti_train)
    Y_test = np.load(path + eti_test)
           
    ID_train = np.load(path + train_ID)
    ID_test = np.load(path + test_ID)
    
    datos_Zecg = scipy.io.loadmat(path_Zecg + 'tabla_Zecg.mat')['tabla']

         
    #############################################################################
    
    # Balanceamos los conjuntos de train para que tengan el mismo numero de 
    # ceros que de unos
    
    # Nivel ventana pequena, opcion 1 (media+desv)
    
    X_train_balanced, Y_train = balancear(X_train_unbalanced, Y_train_unbalanced)
           
    
    X_train, X_test = normalizar(X_train_balanced, X_test)
   
    
    return (X_train, X_test, Y_train, Y_test, ID_train, ID_test, datos_Zecg)
    
  
def entrenamiento(clasificador, X_train, Y_train):
    
    if clasificador=='MLP':
        
        clf = MLPClassifier()                   
        
    elif clasificador=='SVM':  
    
        clf = SVC()
    
    clf_entrenado = clf.fit(X_train, Y_train)
    
    return clf_entrenado
    

def clasificacion_por_ID(setname, clf_entrenado, datos_Zecg, X_test, Y_test, ID_test):
    
    v_ID = np.zeros((datos_Zecg.shape[0],1))
    Zecg_base = np.zeros((datos_Zecg.shape[0],1))
    Zecg_rec = np.zeros((datos_Zecg.shape[0],1))
    v_Fscore = np.zeros((datos_Zecg.shape[0],1))
    
    
    
    for i in range (0, datos_Zecg.shape[0]):
        
        ID = str(int(datos_Zecg[i,0]))

        X_test_ID = X_test[ID_test==ID]
        Y_test_ID = Y_test[ID_test==ID]

        Y_estimadas_ID = clf_entrenado.predict(X_test_ID)
    
        Fscore_ID = f1_score(Y_test_ID,Y_estimadas_ID)
        
        v_Fscore[i] = Fscore_ID
        v_ID[i] = int(datos_Zecg[i,0])
        Zecg_base[i] = datos_Zecg[i,1]
        Zecg_rec[i] = datos_Zecg[i,2]    
    
    return (v_ID, Zecg_base, Zecg_rec, v_Fscore)
    
###############################################################################
#                                  MAIN                                       #
###############################################################################

# Cargamos datos de edades y genero
edades = pickle.load( open( "recordings/metadata/edades.p", "rb" ) )
generos = pickle.load( open( "recordings/metadata/generos.p", "rb" ) )


#opciones: 'set1', 'set2', 'set3'
setname = 'set2'

# opciones: MLP o SVM
clasificador = 'MLP'

#opciones: 'M': masculino, 'F': femenino, 'N': ambos
genero = 'N'

#opciones: 'D': speaker-dependent, 'I':  speaker-independent (solo para set3)
prueba = 'D'

#opciones: '11', '12', '21', '22'
opcion = '21'
    
(X_train, X_test, Y_train, 
 Y_test, ID_train, ID_test, datos_Zecg) = cargar_datos(setname, prueba, opcion)

clf_entrenado = entrenamiento(clasificador, X_train, Y_train)

(v_ID, Zecg_base, 
 Zecg_rec, v_Fscore) = clasificacion_por_ID(setname, clf_entrenado, datos_Zecg, X_test, Y_test, ID_test)

# Si queremos resultados solo para genero M o F:
 
if genero!='N':
    
    v_ID_M = np.zeros(v_ID.shape)
    v_ID_F = np.zeros(v_ID.shape)


    for i in range (0, v_ID.shape[0]):
        
        identificador = str(int(v_ID[i,0]))
                
        if generos.get(identificador, 'N') =='M':
            
            v_ID_M[i] = v_ID[i]  
              
            
        elif generos.get(identificador, 'N') =='F':
    
            v_ID_F[i] = v_ID[i]  
    

if genero=='M':
    
    Zecg_base = Zecg_base[v_ID == v_ID_M]
    Zecg_rec = Zecg_rec[v_ID == v_ID_M]
    v_Fscore = v_Fscore[v_ID == v_ID_M]
    v_ID_M = v_ID_M[v_ID_M != 0]
    v_ID = v_ID_M

    
elif genero=='F':
    
    Zecg_base = Zecg_base[v_ID == v_ID_F]
    Zecg_rec = Zecg_rec[v_ID == v_ID_F]
    v_Fscore = v_Fscore[v_ID == v_ID_F]
    v_ID_F = v_ID_F[v_ID_F != 0]
    v_ID = v_ID_F
    

x = np.arange(1,v_ID.shape[0]+1, 1)

#fig, ax1 = plt.subplots()
#
#ax1.plot(x, Zecg_base, '--bo', x, Zecg_rec, '--go')
#ax1.set_xlabel('ID')
#ax1.set_ylabel('HR (bpm)')
#
#
#ax2 = ax1.twinx()
#ax2.plot(x, v_Fscore, '--ro')
#ax2.set_ylabel('F Score')
#
#
#red_patch = mpatches.Patch(color='red', label='F Score')
#blue_patch = mpatches.Patch(color='blue', label='Media HR Base')
#green_patch = mpatches.Patch(color='green', label='Media HR Recording')
#
#plt.legend(handles=[red_patch, blue_patch, green_patch], loc=2)
#fig.tight_layout()
#plt.xticks(x)
##plt.title(setname + ' ' + clasificador + ' ' + opcion + ' ' + genero)
#plt.show()


fig2, ax3 = plt.subplots()

ax3.plot(x, Zecg_rec-Zecg_base, '--bo')
ax3.set_xlabel('ID')
ax3.set_ylabel('Diferencia HR (bpm)')

ax4 = ax3.twinx()
ax4.plot(x, v_Fscore, '--ro')
ax4.set_ylabel('F score')

red_patch = mpatches.Patch(color='red', label='F Score')
blue_patch = mpatches.Patch(color='blue', label='Diferencia HR')

plt.legend(handles=[red_patch, blue_patch], loc=4)
plt.tight_layout()
plt.xticks(x)
plt.title(setname + ' ' + clasificador + ' ' + opcion + ' ' + genero)
plt.show()

print 'Lista número gráfica ---> ID'

for i in range (1, v_ID.shape[0]+1):
    
    print  i ,'--> ID:', int(v_ID[i-1])

