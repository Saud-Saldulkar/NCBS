function [total_count, time_index, intersect_x, intersect_y] = extract_circular_movements(file_no, bin_size1, bin_size2)

    file_name = strcat('n', int2str(file_no), '.mat');
    load(file_name);
    
    intersect_x = [];
    intersect_y = [];
    
    iterator = 1;
    
    for i = 1:bin_size1:length(x_pos)
        start_frame = i;
        end_frame = (start_frame + bin_size1);
        
        if (end_frame > length(x_pos))
           break; 
        end
        
        x1 = x_pos(start_frame:end_frame);
        y1 = y_pos(start_frame:end_frame);
        
        start_frame = end_frame + 1;
        end_frame = start_frame + bin_size2;
        
        if (end_frame > length(x_pos))
            break; 
        end
        
        x2 = x_pos(start_frame:end_frame, 1);
        y2 = y_pos(start_frame:end_frame, 1);
        
        [count, xo, yo] = extract_data(x1, y1, x2, y2);
        
        intersect_x = vertcat(intersect_x, xo);
        intersect_y = vertcat(intersect_y, yo);
        
        time_index(iterator,1) = count;
        iterator = iterator + 1;
        
    end
    
    total_count = sum(time_index);
end

function [count, xo, yo] = extract_data(x1, y1, x2, y2)
    [xo, yo] = polyxpoly(x1, y1, x2, y2);
    [xo, yo] = extract_unique_values(xo, yo);
    
    count = length(xo);
end

function [x_var, y_var] = extract_unique_values(x, y)       
    x_var = [];
    y_var = [];
    
    for i = 1:length(x)
        if (isempty(x_var))
            x_var(1,1) = x(1,1);
            y_var(1,1) = y(1,1);
        end
        
        if (length(x_var) >= 1)
            ind_x = find(x_var == x(i,1));
            ind_y = find(y_var == y(i,1));
            
            intersect_set = intersect(ind_x, ind_y);
            
            if (isempty(intersect_set))
                x_var = vertcat(x_var, x(i,1));
                y_var = vertcat(y_var, y(i,1));
            end
            
            if (intersect_set > 0)
                continue;
            end
        end
    end
end

