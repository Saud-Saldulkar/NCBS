% Remove feeding data
% dependencies: feed_time_datapoints.m

% ------------------------------------
clc;
clear all;
close all;
% ------------------------------------
% array of feed times 
feed_time = [3];
% ------------------------------------
filename = 'n';
fileextension = '.mat';
total_no_of_files = 1;
% ------------------------------------

for i = 1:total_no_of_files
    
    file  = strcat(filename,int2str(i),fileextension);
    load(file);

    % clean variables from loaded file
    %------------------------------------------------
    clear angle;
    clear identity;
    clear maj_ax;
    clear min_ax;
    clear ntargets;
    clear startframe;
    %------------------------------------------------
    
    max_length = length(x_pos);
    
    del_datapoints = feed_time_datapoints(max_length, feed_time(i));
    
    x_pos(1:del_datapoints) = [];
    y_pos(1:del_datapoints) = [];
    
    save(file,'x_pos','y_pos');

end



