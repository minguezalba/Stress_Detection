# -*- coding: utf-8 -*-

###############################################################################
#    File name: diccionarios.py
#    Author: Alba Minguez
#    Date created: June 2017
#    Python Version: 2.7
#    Sklearn version: scikit-learn 0.18.1
#    
#    Description
#    This script creates the corresponding dictionaries for VOCE database
###############################################################################

import numpy as np
import pickle

# DICCIONARIO DE EDADES
edades = {'2071492831': 22,
          '2054751935': 21,
          '1884865801': 20,
          '1777108864': 26,
          '1756953694': 19,
          '1739028311': 22,
          '1626125349': 23,
          '1610132012': 22,
          '1499703648': 0,
          '1458206716': 23,
          '1420900415': 25,
          '1411484167': 20,
          '1395228143': 21,
          '1113564542': 49,
          '1062237033': 22,
          '1015666824': 22,
          '935941053': 24,
          '852630991': 24,
          '724250529': 19,
          '638882617': 20,
          '550155379': 20,
          '548414142': 19,
          '348334269': 24,
          '334844205': 27,
          '334342001': 19,
          '192369217': 19,
          '105804962': 28,
          '62963719': 23,
          '92305089': 48,
          '286484722': 34,
          '304102792': 22,
          '513604950': 21,
          '652033332': 22,
          '902398068': 11,
          '1143102813': 22,
          '1397020749': 24,
          '1650434878': 19,
          '1686645257': 0,}
              

# DICCIONARIO DE GENEROS
generos = {'2071492831': 'M',
          '2054751935': 'F',
          '1884865801': 'F',
          '1777108864': 'M',
          '1756953694': 'M',
          '1739028311': 'M',
          '1626125349': 'M',
          '1610132012': 'M',
          '1499703648': 'M',
          '1458206716': 'M',
          '1420900415': 'M',
          '1411484167': 'F',
          '1395228143': 'F',
          '1113564542': 'F',
          '1062237033': 'F',
          '1015666824': 'M',
          '935941053': 'F',
          '852630991': 'M',
          '724250529': 'F',
          '638882617': 'F',
          '550155379': 'F',
          '548414142': 'F',
          '348334269': 'M',
          '334844205': 'F',
          '334342001': 'M',
          '192369217': 'M',
          '105804962': 'M',
          '62963719': 'F',
          '92305089': 'F',
          '286484722': 'F',
          '304102792': 'F',
          '513604950': 'M',
          '652033332': 'M',
          '902398068': 'M',
          '1143102813': 'M',
          '1397020749': 'M',
          '1650434878': 'F',
          '1686645257': 'M',}

# DICCIONARIO DE CARACTERÍSTICAS
#features = {1: 'Media pitch',
#           2: 'Varianza pitch',
#           3: 'Media MFCC 1',
#           4: 'Media MFCC 2',
#           5: 'Media MFCC 3',
#           6: 'Media MFCC 4',
#           7: 'Media MFCC 5',
#           8: 'Media MFCC 6',
#           9: 'Media MFCC 7',
#           10: 'Media MFCC 8',
#           11: 'Media MFCC 9',
#           12: 'Media MFCC 10',
#           13: 'Media MFCC 11',
#           14: 'Media MFCC 12',
#           15: 'Varianza MFCC 1',
#           16: 'Varianza MFCC 2',
#           17: 'Varianza MFCC 3',
#           18: 'Varianza MFCC 4',
#           19: 'Varianza MFCC 5',
#           20: 'Varianza MFCC 6',
#           21: 'Varianza MFCC 7',
#           22: 'Varianza MFCC 8',
#           23: 'Varianza MFCC 9',
#           24: 'Varianza MFCC 10',
#           25: 'Varianza MFCC 11',
#           26: 'Varianza MFCC 12',
#           27: 'Media Formante 1',
#           28: 'Media Formante 2',
#           29: 'Media Formante 3',
#           30: 'Varianza Formante 1',
#           31: 'Varianza Formante 2',
#           32: 'Varianza Formante 3',
#           33: 'Energia'}

features = ['Media pitch', 'Varianza pitch', 'Media MFCC 1', 'Media MFCC 2',
           'Media MFCC 3', 'Media MFCC 4', 'Media MFCC 5', 'Media MFCC 6',
           'Media MFCC 7', 'Media MFCC 8', 'Media MFCC 9', 'Media MFCC 10',
           'Media MFCC 11', 'Media MFCC 12', 'Varianza MFCC 1', 'Varianza MFCC 2',
           'Varianza MFCC 3', 'Varianza MFCC 4', 'Varianza MFCC 5', 'Varianza MFCC 6',
           'Varianza MFCC 7', 'Varianza MFCC 8', 'Varianza MFCC 9', 'Varianza MFCC 10',
           'Varianza MFCC 11', 'Varianza MFCC 12', 'Media Formante 1', 'Media Formante 2',
           'Media Formante 3', 'Varianza Formante 1', 'Varianza Formante 2', 'Varianza Formante 3', 
           'Energia']

#%%  Save
pickle.dump( edades, open( "recordings/metadata/edades.p", "wb" ) )
pickle.dump( generos, open( "recordings/metadata/generos.p", "wb" ) )
pickle.dump( features, open( "recordings/metadata/features.p", "wb" ) )

np.save('recordings/metadata/edades', edades)
np.save('recordings/metadata/generos', generos)
np.save('recordings/metadata/features', features)

#%% Load

edades = pickle.load( open( "recordings/metadata/edades.p", "rb" ) )
generos = pickle.load( open( "recordings/metadata/generos.p", "rb" ) )
features = pickle.load( open( "recordings/metadata/features.p", "rb" ) )



