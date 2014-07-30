% Script to extract and save center coordinates

coordinate_file_name = 'coordinates_random_light.mat';
load(coordinate_file_name);

no_files = 10;

for i = 1:no_files
   coordinates(i,1) = 1; 
end

for i = 1:no_files    
    file_name = get_file_name(i); 
    load(file_name);
   
    coordinates(i,2) = ((max(x_pos) - min(x_pos))/2) + min(x_pos);
    coordinates(i,3) = ((max(y_pos) - min(y_pos))/2) + min(y_pos);        
end

clearvars -except coordinates coordinate_file_name
save(coordinate_file_name, 'coordinates');