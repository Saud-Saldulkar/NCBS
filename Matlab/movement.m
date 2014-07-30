function [towards, away, data_considered] = movement(file_name, is_random, random_x, random_y)

% ----------------------------------------------------------
load(file_name);
% ----------------------------------------------------------

% ----------------------------------------------------------
% clean up code
clear file_name;
clear angle;
clear identity;
clear maj_ax;
clear min_ax;
clear ntargets;
clear startframe;
clear timestamps;
% ----------------------------------------------------------

% ----------------------------------------------------------
% extract length of the data
data_length = length(x_pos);
% ----------------------------------------------------------

% ----------------------------------------------------------
% origin coordinates for sugar elicited experiments
if (is_random == 0)
    origin_x = x_pos(1);
    origin_y = y_pos(1);
end

% origin coordinates for sugar elicited experiments
if (is_random == 1)
    origin_x = random_x;
    origin_y = random_y;
end
% ----------------------------------------------------------

% ----------------------------------------------------------
% preallocate and declare variables
distance(data_length,1) = 0;
circle_segment(data_length,1) = 0;
mvmnt(data_length,1) = 0;
% ----------------------------------------------------------

% ----------------------------------------------------------
% extract distance
for i = 1:data_length
    distance(i,1) = pdist2([origin_x, origin_y],[x_pos(i), y_pos(i)], 'euclidean');
end
% ----------------------------------------------------------


% ----------------------------------------------------------
% tag circle segment number
for i = 1 : data_length   
    % quadrant 01
    if  (x_pos(i) >= origin_x && y_pos(i) >= origin_y)
        
        angle = calculate_angle([origin_x,origin_y], [x_pos(i), y_pos(i)], 1);
        angle_range = find_range(90, 6, angle); 
        map_range = [24,23,22,21,20,19];
        circle_segment(i,1) = map_range(angle_range);
        
        clear angle;
        clear angle_range;
        clear map_range;
        clear map_no;       
        continue;
    end
    
    % quadrant 02
    if (x_pos(i) >= origin_x && y_pos(i) <= origin_y)
        
        angle = calculate_angle([origin_x,origin_y], [x_pos(i), y_pos(i)], 1);
        angle_range = find_range(90, 6, angle); 
        map_range = [1,2,3,4,5,6];
        circle_segment(i,1) = map_range(angle_range);
        
        clear angle;
        clear angle_range;
        clear map_range;
        clear map_no;
        continue;
    end
    
    % quadrant 03
    if (x_pos(i) <= origin_x && y_pos(i) <= origin_y)
        
        angle = calculate_angle([origin_x,origin_y], [x_pos(i), y_pos(i)], 1);
        angle_range = find_range(90, 6, angle); 
        map_range = [12,11,10,9,8,7];
        circle_segment(i,1) = map_range(angle_range);
        
        clear angle;
        clear angle_range;
        clear map_range;
        clear map_no;
        continue;
    end
    
    % quadrant 04
    if (x_pos(i) <= origin_x && y_pos(i) >= origin_y)
         
        angle = calculate_angle([origin_x,origin_y], [x_pos(i), y_pos(i)], 1);
        angle_range = find_range(90, 6, angle); 
        map_range = [13,14,15,16,17,18];
        circle_segment(i,1) = map_range(angle_range);
        
        clear angle;
        clear angle_range;
        clear map_range;
        clear map_no;
        continue;
    end
end
clear i;
clear is_random;
% ----------------------------------------------------------

% tag for TOWARDS and AWAY movements
% ----------------------------------------------------------
for i = 1:data_length
    if (i == 1)
        mvmnt(i,1) = 0;
        continue;
    end
    pre_i = i - 1;
    
    pre_distance = distance(pre_i,1);
    cur_distance = distance(i,1);
    
    if (pre_distance < cur_distance)
        mvmnt(i,1) = 0;
        continue;
    end
    if (pre_distance > cur_distance)
        mvmnt(i,1) = 1;
        continue;
    end  
end

clear i;
clear pre_i;
clear cur_distance;
clear pre_distance;
% ----------------------------------------------------------


% ----------------------------------------------------------
% extract block (data under a single circle segment)
straight_lines = 0;
towards = 0;
away = 0;
block_n = 0;

for i = 1:data_length  
    
    if (i == (block_n + 1))
        
        start_block = circle_segment(i,1);
        block_i = i;
        iterator = i;
        bool = true;
        
        while bool == true 
            
            % to stop iterator overflow
            if (iterator == data_length)
                break;
            end
            
            iterator = iterator + 1;

            if (circle_segment(iterator,1) == start_block)
                continue;   
            end
            
            if (circle_segment(iterator,1) ~= start_block)
                block_n = iterator - 1;
                bool = false;
            end
            
        end
        
    [output1, output2, output3] = analyze_block(x_pos, y_pos, block_i, block_n, mvmnt);    
    towards = towards + output1;
    away = away + output2;
    straight_lines = straight_lines + output3;
    
    end
end  
data_considered = (straight_lines / data_length) * 100;
towards = (towards / data_length) * 100;
away = (away / data_length) * 100;
end
% ----------------------------------------------------------

% ----------------------------------------------------------
function [towards, away, no_straightline_frames] = analyze_block(x_pos, y_pos, block_i, block_n, mvmnt)
    towards = 0;
    away = 0;
    
    c = 1;
    block_x = [];
    block_y = [];
    
    for i = block_i:block_n
        block_x(c,1) = x_pos(i);
        block_y(c,1) = y_pos(i);
        c = c + 1;
    end
    
    % x threshold
    block_x_max = max(block_x);
    block_x_min = min(block_x);
    
    distance_x = block_x_max - block_x_min;   
    
    % y threshold
    block_y_max = max(block_y);
    block_y_min = min(block_y);
    
    distance_y = block_y_max - block_y_min;
   
    distance = sqrt((distance_x)^2 + (distance_y)^2);
    
    if (distance >= 28.125)
        no_straightline_frames = distance;
        
        for i = block_i:block_n
            
            mvmnt_i = mvmnt(i,1);

            if (mvmnt_i == 1)
                towards = towards + 1;
            end

            if (mvmnt_i == 0)
                away = away + 1;
            end
            
        end
    else
        no_straightline_frames = 0;
    end
end
% ----------------------------------------------------------