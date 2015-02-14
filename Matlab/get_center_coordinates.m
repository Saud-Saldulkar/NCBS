function [center_x, center_y, return_count] = get_center_coordinates(file_name, spatial_threshold, returns_count_threshold, manual_count)
    load(file_name);
    
    origin_x = x_pos(1,1);
    origin_y = y_pos(1,1);
    
    for i = 1:length(x_pos)
        distance_ed(i,1) = sqrt((x_pos(i,1) - origin_x).^2 + (y_pos(i,1) - origin_y).^2);
    end
    
    iterator = 1;
    for i = 1:length(distance_ed)
        if (distance_ed(i,1) <= spatial_threshold)
           x(iterator,1) = x_pos(i,1);
           y(iterator,1) = y_pos(i,1);
           iterator = iterator + 1;
        end
    end
    
    for i = 1:length(x)
        is_random = 1;
        random_x = x(i,1);
        random_y = y(i,1);
       [no_returns(i,1), index_returns] = returns_count(file_name, is_random, random_x, random_y);       
    end
    
    iterator = 1;
    for i = 1:length(x)
       if (no_returns(i,1) == manual_count)
           exact_x(iterator,1) = x(i,1);
           exact_y(iterator,1) = y(i,1);           
           iterator = iterator + 1;
       end
    end
    
   clear distance_ed
    
    if (exist('exact_x', 'var') == 1)
        disp('Exact match found');

        for i = 1:length(exact_x)
            distance_ed(i,1) = sqrt((exact_x(i,1) - origin_x).^2 + (exact_y(i,1) - origin_y).^2);        
        end

        min_index = find(distance_ed == min(distance_ed));

        center_x = exact_x(min_index,1);
        center_y = exact_y(min_index,1);

        is_random = 1;
        random_x = center_x;
        random_y = center_y;
        [return_count, index_returns] = returns_count(file_name, is_random, random_x, random_y);
    end
    
    if (exist('exact_x','var') == 0)
       disp('Exact match not found');
       disp('Searching for a close match based on RETURNS COUNT THRESHOLD....');
       
       upper_range = manual_count + returns_count_threshold;
       lower_range = manual_count - returns_count_threshold;
       
       iterator = 1;
       for i = 1:length(x)
           if (no_returns(i,1) <= upper_range && no_returns(i,1) >= lower_range)
                close_x(iterator,1) = x(i,1);
                close_y(iterator,1) = y(i,1);
                iterator = iterator + 1;
           end
       end
       
       clear distance_ed
       
       if (exist('close_x','var') == 1)
            disp('Close match found');

            for i = 1:length(close_x)
                distance_ed(i,1) = sqrt((close_x(i,1) - origin_x).^2 + (close_y(i,1) - origin_y).^2);        
            end

            min_index = find(distance_ed == min(distance_ed));

            center_x = close_x(min_index,1);
            center_y = close_y(min_index,1);
            
            is_random = 1;
            random_x = center_x;
            random_y = center_y;
            [return_count, index_returns] = returns_count(file_name, is_random, random_x, random_y);
       end

       if (exist('close_x','var') == 0)
            disp('Close match not found');
            center_x = 0;
            center_y = 0;
            return_count = 0;
       end
    end 
end