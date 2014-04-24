% Calculate (euclidean)distance data for each data point with reference to
% the centroid of the arena

%  plot distance map 
% ------------------------------------------------------------
clc;
clear all;
close all;
% ------------------------------------------------------------

% ------------------------------------------------------------
filename = 'n';
fileextension = '.mat';
total_no_of_files = 10;
% ------------------------------------------------------------

% ------------------------------------------------------------
for c = 1:total_no_of_files
    
    file  = strcat(filename,int2str(c),fileextension);
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
    
    for i = 1:length(x_pos)
        distance(i,1) = pdist2([x_pos(1), y_pos(1)],[x_pos(i), y_pos(i)], 'euclidean');    
    end

    subplot(5,2,c), plot(distance, 'r'); xlim([0 6500]); ylim([2 250]);
    % ------------------------------------------------------------
%     clear all;

end
