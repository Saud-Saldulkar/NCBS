function [path_length, time] = extract_pathlength_time(coordinate_file)

% to extract path_length and time until it reaches the arena_radius

% IMPORTANT = FEEDING TIME SHOULD BE REMOVED BEFORE RUNNING THIS FUNCTION.

% files are processed in batch of 10 with file name e.g. n1.mat,n2.mat..so
% on.

% ****************
arena_radius = 100;
% ****************
load(coordinate_file)


    for f = 1:10
        
        prefix = 'n';
        postfix = '.mat';
        file_name = strcat(prefix, int2str(f), postfix);
        load(file_name);     
        
        if (coordinates(f,1) == 0)
            origin_x = x_pos(1,1);
            origin_y = x_pos(1,1);
        end
        
        if (coordinates(f,1) == 1)
            origin_x = coordinates(f,2);
            origin_y = coordinates(f,3);
        end
        
        distance = calculate_distance(origin_x, origin_y, x_pos, y_pos);
        
        for i = 1:length(distance)
            if (distance(i,1) >= arena_radius)
                boundary_frame = i;
            end
        end
        
        buf_var = distance(1:boundary_frame,1);
        
        path_length(f,1) = sum(abs(diff(buf_var)));
        time(f,1) = length(buf_var);
               
        clearvars -except path_length time coordinates arena_radius
    end
    clearvars -except path_length time
end


function [output_distance] = calculate_distance(origin_x, origin_y, data_x, data_y)
    
    length_data = length(data_x);
    output_distance(length_data,1) = 0;
    
    for i = 1:length_data        
        output_distance(i,1) = pdist2([origin_x, origin_y], [data_x(i,1), data_y(i,1)], 'euclidean');        
    end
    
end