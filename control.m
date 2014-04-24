% control to check if the matlab data output from CTRAX is reliable

% clean up code 
close all;
clc; 
clear all;

% declare input
filename = 't';
fileextension = '.mat';
total_no_of_files = 10;
threshold  = 1775;
n = 1;

% loop over all files to do check
for i = 1:total_no_of_files
    file  = strcat(filename,int2str(i),fileextension);

    load(file);
    
    length_x = length(data_x);
    length_y = length(data_y);
    
    if (length_x < threshold) | (length_y < threshold)
        logbook(n,1) = i;
        n = n + 1;
    end    
    
end

