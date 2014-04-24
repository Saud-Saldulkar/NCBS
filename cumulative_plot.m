% Script to plot the cumulative trajectory data

clear all;
clc;
close all;

for c = 1:3
    
    filename = 't';
    fileextension = '.mat';
    total_no_of_files = 10;

    if c == 1
        path_prefix = 'experimental_data/figure 2/data1/';
    end
    
    if c == 2
        path_prefix = 'experimental_data/figure 2/data2/';
    end
    
    if c == 3
        path_prefix = 'experimental_data/figure 2/data3/';
    end
      
    for i = 1:total_no_of_files    
        file  = strcat(path_prefix, filename,int2str(i),fileextension);
        load(file);
        
        subplot(1,3,c); plot(data_x, data_y); xlim([100 350]); ylim([0 250]);
        hold on
    end

end