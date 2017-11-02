# Stress Detection in Voice Signals

This project consists on detecting stress in voice signals based on heart rate values. 
The project is divided in three main different parts: data processing, feature extraction and classification. 
We are going to use VOCE database so the code will be focused on its structure. However, individual functions can be used separately.
We strongly recommend to read the paper about this project before trying to run it.

## Getting Started

You will need some requisites to run this project.

### Prerequisites

* Download database VOCE from its [own webpage](http://cloud.futurecities.up.pt/~voce/metadata/)
* [MATLAB](https://es.mathworks.com/products/matlab.html) 2016
* [MIRtoolbox](http://mirtoolbox.sourceforge.net/)
* [VOICEBOX: Speech Processing Toolbox for MATLAB](http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html)
* Python 2.7 at least
* Spyder IDE from [Anaconda Python](https://www.continuum.io/downloads)
* Sklearn version: scikit-learn 0.18.1


## Code Structure and Usage

### 1. Data Processing

From raw files in VOCE database you will need to follow some steps in order to have usefull data. You will find the scripts in "Procesado BBDD" folder.
* Use script_rename.bat file to rename negative IDs so all of them are positive numbers
* Use analisis_archivos.m to analysis how much data is available (wav files, sensor files...) for each ID
* Extract Heart Rate values from sensors xml files with analisis.xml function. Check both Zts and Zecg values are similar with ejemplos_Zecg_Zts.m script.
* Select the files you will use based on mean and standar deviation from ejemplos_pre_baseline.m script.
* Extract the heart rate values you will use to generate labels with crear_Zecg.m script.

### 2. Feature Extraction with MATLAB
In this stage we will need Heart Rate values from sensors files and their corresponding speech wav files. 
We will extract some basic features and their statistics with some tools like MIRtoolbox and VOICEBOX for MATLAB. 
We will also create the corresponding labels (1 = stress, 0 = no stress) for each segment from the audio file based on the Heart Rate values.

* You just need to run main.m script in Matlab and you will get feature matrix and labels for each ID.


### 3. Classification with Python 

When we already have feature matrix and labels for each file, we well go on with the classification stage.

* First of all, we well create train and test sets with conjuntos_depend.py or conjuntos_independ.py depending on the kind of test we want to do. We can try speaker dependent or speaker independent test.
* Once you have X_train, X_test, Y_train and Y_test sets, you will be able to run the classification with classifier.py script. You can try different classifiers with different parameters.
* Classifiers are evaluated with precision, recall and f scores.
* You can get some comparative graphics about F score and Heart Rate values for each ID with graficas.py script.

## Author

Alba Minguez Sanchez, June 2017


