function plot_pathlength_traj(coordinate_file)
% function to plot trajectory data extracted from
% [extract_pathlength_data.m] or from manually extracted or isolated
% pathlength data

% data is processed in batch; output is stores as individual *.png files
% requires [coordinate_file] which has data about the origin/center coordinates of the
% arena


    load(coordinate_file);
    no_files = length(coordinates);

    for f = 1:no_files
       
        prefix = 'n';
        postfix = '.mat';
        file_name = strcat(prefix, int2str(f), postfix);
        load(file_name);
        
        if (coordinates(f,1) == 0)
            origin_x = x_pos(1,1);
            origin_y = y_pos(1,1);
        end
        
        if (coordinates(f,1) == 1)
            origin_x = coordinates(f,2);
            origin_y = coordinates(f,3);
        end

        radius = 2;
        [inner_circle_x, inner_circle_y] = draw_circle(origin_x, origin_y, radius);
        radius = 100;
        [outer_circle_x, outer_circle_y] = draw_circle(origin_x, origin_y, radius);
        
        h = plot(outer_circle_x, outer_circle_y, 'r'); hold on
        h = plot(inner_circle_x, inner_circle_y, 'r'); hold on
        h = plot(x_pos, y_pos);
        axis square off;
        set(gca, 'XTickLabel', [], 'YTickLabel', []);
        
        file_name = strcat(prefix, int2str(f), '.png');
        saveas(h, file_name);
        close all;
    end
end


function [result_x, result_y] = draw_circle(origin_x, origin_y, radius)

theta = 0:pi/1000:2*pi;

result_x = radius * cos(theta) + origin_x;
result_y = radius * sin(theta) + origin_y;
end