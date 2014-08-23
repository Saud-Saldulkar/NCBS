% --------------------------------------------------
clc;
clear all;
close all;
% --------------------------------------------------

% --------------------------------------------------
no_files = 10;
% --------------------------------------------------

% --------------------------------------------------
% extract and save theta variable
for i = 1:10   
   file_name = strcat('n', int2str(i), '.mat');
   load(file_name);
   
   theta = angle;
   clear angle;
   
   save(file_name, 'theta');
end
% --------------------------------------------------

% --------------------------------------------------
% convert radian values to degrees
for i = 1:no_files
    file_name = strcat('n', int2str(i), '.mat'); 
    load(file_name);
    
    for x = 1:length(theta)
        theta(x,1) = theta(x,1) * 180 / pi;

        if (sign(theta(x,1)) == -1)
            theta(x,1) = theta(x,1) + 360;
        end       
    end   
    save(file_name, 'theta');
end
% --------------------------------------------------

clearvars
display('Done Extracting angles');