function [count, x_i, y_i] = extract_intersections(file_no, bin_size)

    file_name = strcat('n', int2str(file_no), '.mat');
    load(file_name);

    x_i = [];
    y_i = [];
    iterator = 1;

    for i = 1:bin_size:length(x_pos)
        start_frame = i;
        end_frame = (start_frame + bin_size) - 1;

        if (end_frame > length(x_pos))
            break;
        end

        x = x_pos(start_frame:end_frame, 1);
        y = y_pos(start_frame:end_frame, 1);   

        buf_count = 0;
        x_i_temp = [];
        y_i_temp = [];
        for iter = 1:bin_size:length(x_pos)
            if (iter == i)
                continue
            end

            s_frame = iter;
            e_frame = (s_frame + bin_size) - 1;

            if (e_frame > length(x_pos))
                break
            end

            temp_x = x_pos(s_frame:e_frame, 1);
            temp_y = y_pos(s_frame:e_frame, 1);

            [x_buf, y_buf] = polyxpoly(x, y, temp_x, temp_y);

            if (not(isempty(x_buf)))
                x_i_temp = vertcat(x_i_temp, x_buf);
                y_i_temp = vertcat(y_i_temp, y_buf);       
            end
        end
        
        [x_i_temp, y_i_temp] = extract_unique_values(x_i_temp, y_i_temp);
        buf_count = length(x_i_temp);
        
        x_i = vertcat(x_i, x_i_temp);
        y_i = vertcat(y_i, y_i_temp);
        
        count(iterator, 1) = buf_count;
        iterator = iterator + 1;
    end
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