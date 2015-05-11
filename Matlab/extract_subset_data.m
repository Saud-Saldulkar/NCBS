% Extract subset data (works only for X_POS and Y_POS)
clc;
clear all;
close all;

try
    % -----------------------------------
    no_files = 10;
    start_frame = 3000;
    end_frame = 4000;
    % -----------------------------------

    for i = 1:no_files
       file_name = strcat('n', int2str(i), '.mat');
       load(file_name);

       x_pos = x_pos(start_frame:end_frame,1);
       y_pos = y_pos(start_frame:end_frame,1);

       save(file_name, 'x_pos', 'y_pos');
    end

    clearvars;
    display('Done extracting subset data');
    
catch err
   display('Error'); 
end