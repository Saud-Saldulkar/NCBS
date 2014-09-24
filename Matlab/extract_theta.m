% Extract THETA(angle data) from the raw data files
clc;
clear all;
close all;

no_files = 10;

for i = 1:no_files
    file_name = strcat('n', int2str(i), '.mat');
    load(file_name);
    
    theta = angle;
    
    for i = 1:length(theta)
        theta(i,1) = (theta(i,1) * 180) / pi;    
        if (sign(theta(i,1)) == -1)
            theta(i,1) = theta(i,1) + 360;
        end
    end   
    save(file_name, 'theta', 'x_pos', 'y_pos');
end

clearvars;
display('Done extracting THETA');