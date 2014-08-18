clc;
clear all;
close all;

no_files = 10;

for i = 1:no_files
    
    file_name = get_file_name(i);
    load(file_name);
    
    start_frame = 1;
    end_frame = length(x_pos)/3;
    
    x_pos = x_pos(start_frame:end_frame, 1);
    y_pos = y_pos(start_frame:end_frame, 1);
    
    save(file_name, 'x_pos', 'y_pos');    
end

clearvars;