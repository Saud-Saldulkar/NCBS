% Algorithm to extract the first 45 seconds data

% Clean up code ------------------------------
clc;
clear all;
close all;
% ---------------------------------------------

% Declare variables
% ---------------------------------------------
filename = 'n';
fileextension = '.mat';
total_no_of_files = 10;
% ---------------------------------------------

% Loop over all files
% ---------------------------------------------
for i = 1:total_no_of_files
    file  = strcat(filename,int2str(i),fileextension);
    load(file);

    % clean variables from loaded file
    % ---------------------------------------------
    clear angle;
    clear identity;
    clear maj_ax;
    clear min_ax;
    clear ntargets;
    clear startframe;
    % ---------------------------------------------
    
    % Extract data length and check if both x_pos and y_pos are equal 
    % ---------------------------------------------
    data_length_x = length(x_pos);
    data_length_y = length(y_pos);
    
    if (data_length_x ~= data_length_y)
        disp(strcat('Error: X and Y datapoints are not of the same length for file n',int2str(i)));        
    end
    % ---------------------------------------------
    
    % Extract the data for first 45 seconds
    % ---------------------------------------------
    for c = 1:data_length_x
        data_x = (x_pos(1:1775));
        data_y = (y_pos(1:1775));  
    end
    % ---------------------------------------------
    
    % Save the data
    % ---------------------------------------------
    file_name = strcat('t',int2str(i),fileextension);
    save(file_name, 'data_x', 'data_y');
    % ---------------------------------------------
    
end