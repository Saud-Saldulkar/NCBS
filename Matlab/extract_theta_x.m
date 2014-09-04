% Extract subset data in (x)seconds (ONLY WORKS FOR THETA DATA)

clc;
clear all;
close all;

no_files = 10;
extract_time = 5;  % sec

for i = 1:no_files
   file_name = strcat('n', int2str(i), '.mat');
   load(file_name);
   
   data_length = length(theta);
   no_frames = (data_length / 180) * extract_time;
   
   buf_var = theta(1:no_frames,1);
   theta = [];
   theta = buf_var;
   
   save(file_name, 'theta');
end

clc;
clear all;
display('Done Extracting data');