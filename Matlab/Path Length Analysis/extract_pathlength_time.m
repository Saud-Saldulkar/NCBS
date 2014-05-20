function [pathlength, time] = extract_pathlength_time(coordinate_file)
% to extract [pathlength] and [time] variables from the data after using
% [extract_pathlength_data.m]

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
        
        for i = 1:length(x_pos)
            distance(i,1) = calculate_distance(origin_x, origin_y, x_pos(i,1), y_pos(i,1));
        end
        
        pathlength(f,1) = sum(abs(diff(distance)));
        time(f,1) = length(distance);
        
        clearvars -except coordinates no_files f pathlength time
    end
    
    clearvars -except pathlength time
end

function [output_distance] = calculate_distance(origin_x, origin_y, data_x, data_y)
    
    length_data = length(data_x);
    output_distance(length_data,1) = 0;
    
    for i = 1:length_data        
        output_distance(i,1) = pdist2([origin_x, origin_y], [data_x(i,1), data_y(i,1)], 'euclidean');        
    end
    
end