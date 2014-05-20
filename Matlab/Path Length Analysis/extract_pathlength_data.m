function extract_pathlength_data(coordinate_file)
% to isolate/extract data from the first returns count(return to center of arena)
% in the data untill it reaches the arena boundary[arena_radius]

    load(coordinate_file);
    arena_radius = 100;
    no_files = length(coordinates);
    
    for f = 1:no_files
        
        prefix = 'n';
        postfix = '.mat';
        file_name = strcat(prefix, int2str(f), postfix);
        load(file_name)
                
        if (coordinates(f,1) == 0)
           origin_x = x_pos(1,1);
           origin_y = y_pos(1,1);
        end
        
        if (coordinates(f,1) == 1)
            origin_x = coordinates(f,2);
            origin_y = coordinates(f,3);
        end
        
        distance = calculate_distance(origin_x, origin_y, x_pos, y_pos);
 
        [start_frame, end_frame] = extract_range(distance, arena_radius);
        
        x_pos = x_pos(start_frame:end_frame);
        y_pos = y_pos(start_frame:end_frame);
                
        save(file_name, 'x_pos', 'y_pos');
        clearvars -except coordinates arena_radius
    end
 
end

function [output_distance] = calculate_distance(origin_x, origin_y, data_x, data_y)
    
    length_data = length(data_x);
    output_distance(length_data,1) = 0;
    
    for i = 1:length_data        
        output_distance(i,1) = pdist2([origin_x, origin_y], [data_x(i,1), data_y(i,1)], 'euclidean');        
    end
    
end

function [start_frame, end_frame] = extract_range(distance, arena_radius)
    
    data_length = length(distance);
    
    for i = 1:data_length
        if (distance(i,1) < 1.5)
            start_frame = i;
            break;
        end
    end
    
    for i = start_frame:data_length
        if (distance(i,1) >= arena_radius)
            end_frame = i;
            break;
        end 
    end
    
end

