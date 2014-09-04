% Extract subset data (works only for X_POS and Y_POS)
clc;
clear all;
close all;

no_files = 10;
data_size = 45;  % first (x) secs

for i = 1:no_files
   file_name = strcat('n', int2str(i), '.mat');
   load(file_name);
   
   no_frames = floor(((length(x_pos) / 180) * data_size));
   
   x_pos = x_pos(1:no_frames,1);
   y_pos = y_pos(1:no_frames,1);
   
   save(file_name, 'x_pos', 'y_pos');
end

clearvars;
display('Done extracting subset data');