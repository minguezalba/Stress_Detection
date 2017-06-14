function datos_Zecg( set_name )

     switch set_name

        case 'set1' % Caso set 1

            set = [62963719; 652033332; 935941053; 1015666824;
            1395228143; 1397020749; 1420900415; 1739028311; 
            1777769661; 2054751935];

            dir_originals = 'recordings/set1/originals/';
  
    
        case 'set2' % Caso set 2

            set = [12782919; 49425811; 92305089; 304102792;
            334844205; 513604950; 852630991; 902398068;
            1143102813; 1458206716; 1626125349; 1686645257;
            1756953694; 1777108864];

            dir_originals = 'recordings/set2/originals/';
            
         case 'set3' % Caso set 3 = set 1 + set 2

            set = [62963719; 652033332; 935941053; 1015666824;
            1395228143; 1397020749; 1420900415; 1739028311; 
            1777769661; 2054751935; 12782919; 49425811; 92305089; 
            304102792; 334844205; 513604950; 852630991; 902398068;
            1143102813; 1458206716; 1626125349; 1686645257;
            1756953694; 1777108864];

            dir_originals = 'recordings/set3/originals/';
         

        
        otherwise
            sprintf('Error');

    end % end switch nombre_set
   
   tabla = [set zeros(size(set)) zeros(size(set))];
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Creamos tabla de datos sobre Zecg para las pruebas. El formato es:
%
%     ID    |      Media Zecg Base     |     Media Zecg Recording
%           |                          |
%           |                          |
%           |                          |
%           |                          |
%           |                          |
%           |                          |


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   for i=1:length(set)
       
        s1 = 'ID_';
        s2 = int2str(set(i));
        s3 = '_prebaseline';
        s4 = '_baseline';
        s5 = '_sensors.mat';

        % Caso prebaseline
        if exist(strcat(dir_originals,s1,s2,s3,s5))~=0

            load(strcat(dir_originals,s1,s2,s3,s5));

            tabla(i,2) = mean(v_Zecg(:,1));

        end

        % Caso baseline
        if exist(strcat(dir_originals,s1,s2,s4,s5))~=0

            load(strcat(dir_originals,s1,s2,s4,s5));
            tabla(i,2) = mean(v_Zecg(:,1));

        end

        % Caso recording
        if exist(strcat(dir_originals,s1,s2,s5))~=0

            load(strcat(dir_originals,s1,s2,s5));
            tabla(i,3) = mean(v_Zecg(:,1));

        end
       
   end
   
  
   T_name = strcat('recordings/', set_name, '/tabla_Zecg');
   save(T_name, 'tabla' );
   

end

