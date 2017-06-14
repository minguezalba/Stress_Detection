%% Ejemplos plot Zecg y Zts

%% ID 12782919: Tiene los 3 posibles ficheros

clc
clear all

%     fichero1 = 'ID_12782919_prebaseline_sensors.xml';
%     tipo1 = type_file(fichero1);
% 
%     [~, value_Zecg, time_Zecg, value_Zts, time_Zts] = analisis_xml(fichero1, tipo1);
% 
%     figure
%     subplot(1,3,1);
%     plot(time_Zecg,value_Zecg)
%     ylim([50 110])
%     hold on;
%     plot(time_Zts,value_Zts)
%     ylim([50 110])
%     title('Zecg y Zts Prebaseline')
%     xlabel('Segundos') % x-axis label
%     ylabel('Zecg y Zts values') % y-axis label
%     legend('Zecg','Zts')

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fichero2 = 'ID_12782919_baseline_sensors.xml';
    tipo2 = type_file(fichero2);

    [~, value_Zecg, time_Zecg, value_Zts, time_Zts] = analisis_xml(fichero2, tipo2);

    
    subplot(1,2,1)
    plot(time_Zecg,value_Zecg)
    ylim([50 110])
    hold on;
    plot(time_Zts,value_Zts)
    ylim([50 110])
    title('Zecg y Zts Baseline')
    xlabel('Tiempo (s)') % x-axis label
    ylabel('Valores Zecg y Zts') % y-axis label
    legend('Zecg','Zts')

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fichero3 = 'ID_12782919_sensors.xml';
    tipo3 = type_file(fichero3);

    [~, value_Zecg, time_Zecg, value_Zts, time_Zts] = analisis_xml(fichero3, tipo3);

    
    subplot(1,2,2);
    plot(time_Zecg,value_Zecg)
    ylim([50 110])
    hold on;
    plot(time_Zts,value_Zts)
    ylim([50 110])
    title('Zecg y Zts Recording')
    xlabel('Tiempo (s)') % x-axis label
    ylabel('Valores Zecg y Zts') % y-axis label
    legend('Zecg','Zts')
    
    %% ID 334844205: Prebaseline(Zecg negativos, sin Zts) y Recording(sin Zts)
    
    clc
    clear all

    fichero1 = 'ID_334844205_prebaseline_sensors.xml';
    tipo1 = type_file(fichero1);

    [~, value_Zecg, time_Zecg, value_Zts, time_Zts] = analisis_xml(fichero1, tipo1);

    figure
    subplot(1,2,1);
    plot(time_Zecg,value_Zecg)
    hold on;
    plot(time_Zts,value_Zts)
    title('Zecg y Zts Prebaseline')
    xlabel('Segundos') % x-axis label
    ylabel('Zecg y Zts values') % y-axis label
    legend('Zecg','Zts')

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    fichero3 = 'ID_334844205_sensors.xml';
    tipo3 = type_file(fichero3);

    [~, value_Zecg, time_Zecg, value_Zts, time_Zts] = analisis_xml(fichero3, tipo3);
    
    subplot(1,2,2);
    plot(time_Zecg,value_Zecg)
    hold on;
    plot(time_Zts,value_Zts)
    title('Zecg y Zts Recording')
    xlabel('Segundos') % x-axis label
    ylabel('Zecg y Zts values') % y-axis label
    legend('Zecg','Zts')
    
    %% ID 1397020749: Tiene los 3 posibles ficheros, recording con Zecg<0

    clc
    clear all

    fichero1 = 'ID_1397020749_prebaseline_sensors.xml';
    tipo1 = type_file(fichero1);

    [~, value_Zecg, time_Zecg, value_Zts, time_Zts] = analisis_xml(fichero1, tipo1);

    figure
    subplot(1,3,1);
    plot(time_Zecg,value_Zecg)
    ylim([50 150])
    hold on;
    plot(time_Zts,value_Zts)
    ylim([50 150])
    title('Zecg y Zts Prebaseline')
    xlabel('Segundos') % x-axis label
    ylabel('Zecg y Zts values') % y-axis label
    legend('Zecg','Zts')

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fichero2 = 'ID_1397020749_baseline_sensors.xml';
    tipo2 = type_file(fichero2);

    [~, value_Zecg, time_Zecg, value_Zts, time_Zts] = analisis_xml(fichero2, tipo2);

    
    subplot(1,3,2)
    plot(time_Zecg,value_Zecg)
    ylim([50 150])
    hold on;
    plot(time_Zts,value_Zts)
    ylim([50 150])
    title('Zecg y Zts Baseline')
    xlabel('Segundos') % x-axis label
    ylabel('Zecg y Zts values') % y-axis label
    legend('Zecg','Zts')

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fichero3 = 'ID_1397020749_sensors.xml';
    tipo3 = type_file(fichero3);

    [~, value_Zecg, time_Zecg, value_Zts, time_Zts] = analisis_xml(fichero3, tipo3);

    
    subplot(1,3,3);
    plot(time_Zecg,value_Zecg)
    ylim([50 150])
    hold on;
    plot(time_Zts,value_Zts)
    ylim([50 150])
    title('Zecg y Zts Recording')
    xlabel('Segundos') % x-axis label
    ylabel('Zecg y Zts values') % y-axis label
    legend('Zecg','Zts')
    