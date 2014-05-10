function isolate_straight_returns(file_name, upper_threshold, lower_threshold, image_suffix, is_random, random_x, random_y)

% -----------------------------------------------------------------------------------------------------------------------------
load(file_name);
% ----------------------------------------------------------------------------------------------------------------------------- 
clear angle            
clear identity         
clear maj_ax           
clear min_ax           
clear ntargets                
clear startframe       
clear timestamps       
% -----------------------------------------------------------------------------------------------------------------------------
if (is_random == 0)
    origin_x = x_pos(1,1);
    origin_y = y_pos(1,1);
end

if (is_random == 1)
    origin_x = random_x;
    origin_y = random_y;
end
% -----------------------------------------------------------------------------------------------------------------------------

% -----------------------------------------------------------------------------------------------------------------------------
[direction_array] = direction_of_movement(x_pos, y_pos, origin_x, origin_y);

iterator = 1;
for i = 1:length(x_pos)
    if (direction_array(i,1) == 1)
        x(iterator,1) = x_pos(i,1); 
        y(iterator,1) = y_pos(i,1);
        iterator = iterator + 1;
    end
end
clear iterator 
% -----------------------------------------------------------------------------------------------------------------------------

% -----------------------------------------------------------------------------------------------------------------------------
[temp_x, temp_y] = remove_data_outside_threshold(x, y,upper_threshold, lower_threshold, origin_x, origin_y);
clear x
clear y
x = temp_x;
y = temp_y;
clear temp_x
clear temp_y
% -----------------------------------------------------------------------------------------------------------------------------

% -----------------------------------------------------------------------------------------------------------------------------
[temp_x, temp_y] = tracking_between_two_threshold(x, y, upper_threshold, lower_threshold, origin_x, origin_y);
clear x
clear y
x = temp_x;
y = temp_y;
clear temp_x
clear temp_y
% -----------------------------------------------------------------------------------------------------------------------------

% -----------------------------------------------------------------------------------------------------------------------------
[temp_x, temp_y] = remove_periphery(x, y, upper_threshold, lower_threshold, origin_x, origin_y);
clear x
clear y
x = temp_x;
y = temp_y;
clear temp_x
clear temp_y
% -----------------------------------------------------------------------------------------------------------------------------

% -----------------------------------------------------------------------------------------------------------------------------
[bigger_circle_x, bigger_circle_y] = draw_circle(origin_x, origin_y, upper_threshold);
[smaller_circle_x, smaller_circle_y] = draw_circle(origin_x, origin_y, lower_threshold);

plot(bigger_circle_x, bigger_circle_y, 'r');
hold on;
plot(smaller_circle_x, smaller_circle_y, 'r');
hold on;

for (i = 1:length(x))
    h = plot(x(i),y(i), 'k', 'Marker','+'); hold on; 
end
set(gca, 'XTick', [], 'YTick', []);
axis square tight off;
% -----------------------------------------------------------------------------------------------------------------------------

% -----------------------------------------------------------------------------------------------------------------------------
image_name = strcat('experiment', int2str(image_suffix), '.png');
saveas(h, image_name);
% -----------------------------------------------------------------------------------------------------------------------------
clear all;
close all;
% -----------------------------------------------------------------------------------------------------------------------------
end

function [direction_array] = direction_of_movement(my_x, my_y, origin_x, origin_y)

distance(length(my_x),1) = 0;

for i = 1:length(my_x)
    distance(i,1) = pdist2([origin_x, origin_y],[my_x(i), my_y(i)]);
end

for i = 1:length(my_x)
    if (i == 1)
        direction_array(i,1) = 0;
        continue;
    end
    
    pre_i = i - 1;
    
    pre_distance = distance(pre_i,1);
    cur_distance = distance(i,1);
    
    if (pre_distance < cur_distance)
        direction_array(i,1) = 0;
        continue;
    end
    
    if (pre_distance > cur_distance)
        direction_array(i,1) = 1;
        continue;
    end    
end

end

function [x, y] = remove_data_outside_threshold(my_x, my_y,upper_threshold, lower_threshold, origin_x, origin_y)

distance(length(my_x),1) = 0;

for i = 1:length(my_x)
    distance(i,1) = pdist2([origin_x, origin_y],[my_x(i), my_y(i)]);
end

iterator = 1;
for i = 1:length(my_x)
    if (distance(i,1) < (upper_threshold + 1) && distance(i,1) >= lower_threshold)
        x(iterator,1) = my_x(i,1);
        y(iterator,1) = my_y(i,1);
        iterator = iterator + 1;
    end
end

end

function [x, y] = tracking_between_two_threshold(my_x, my_y, upper_threshold, lower_threshold, origin_x, origin_y)

start_index = 0;
stop_index = 0;
iterator = 1;
tracking = false;

for i = 1:length(my_x)
    distance(i,1) = pdist2([origin_x, origin_y],[my_x(i,1), my_y(i,1)]);
end

for i = 1:length(my_x)
    if (tracking == false && distance(i,1) >= upper_threshold && distance(i,1) < (upper_threshold + 1))
        start_index(iterator,1) = i;
        tracking = true;
    end
   
    if (tracking == true && distance(i,1) >= lower_threshold && distance(i,1) < (lower_threshold + 1))       
            stop_index(iterator, 1) = i;
            iterator = iterator + 1;
            tracking = false;
    end
    
end

length_start_index = length(start_index);
length_stop_index = length(stop_index);

if (length_start_index ~= length_stop_index)
   temp_var = start_index;
   clear start_index;
   start_index = temp_var(1:length_stop_index,1);
end

x = [];
y = [];
for i = 1:length_stop_index
    start = start_index(i,1);
    stop = stop_index(i,1);
    
    temp_x = my_x((start:stop),1);
    temp_y = my_y((start:stop),1);

    x = vertcat(x, temp_x);
    y = vertcat(y, temp_y);
end  
  
end

function [x, y] = remove_periphery(my_x, my_y, upper_threshold, lower_threshold, origin_x, origin_y)

    for i = 1:length(my_x)
        distance(i,1) = pdist2([origin_x, origin_y],[my_x(i,1), my_y(i,1)]);
    end

    tracking = false;
    start_index = 0;
    stop_index = 0;
    iterator = 1;
    eof = false;

    for i = 1:length(my_x)

        if (tracking == false && distance(i,1) >= upper_threshold && distance(i,1) < (upper_threshold + 1))
            tracking = true;
            start_index(iterator, 1) = i;
        end


        next_i = i + 1;

        if (next_i > length(my_x))
            eof = true;
        end

        if (eof == false)
            diff_distance = pdist2([my_x(i,1), my_y(i,1)],[my_x(next_i,1), my_y(next_i,1)]);

            if (tracking == true && diff_distance > 2)
                tracking = false;
            end
        end

        if (tracking == true && distance(i,1) >= lower_threshold && distance(i,1) < (lower_threshold + 1))
            tracking = false;
            stop_index(iterator, 1) = i;
            iterator = iterator + 1; 
        end
    end

    if (length(start_index) ~= length(stop_index))
        temp_index = start_index;
        clear start_index
        start_index = temp_index(1:length(stop_index),1);
    end

    x = 0;
    y = 0;
    for i = 1:length(stop_index)
        start = start_index(i,1);
        stop = stop_index(i,1);

        temp_x = my_x(start:stop, 1);
        temp_y = my_y(start:stop, 1);

        x = vertcat(x, temp_x);
        y = vertcat(y, temp_y);
    end

    var_x = x;
    var_y = y;

    clear x
    clear y

    req_length = length(var_x);

    x = var_x(2:req_length, 1);
    y = var_y(2:req_length, 1);

    
end

function [result_x, result_y] = draw_circle(origin_x, origin_y, radius)
%---------------------------------------
% Draw a circle

% r = desired radius
% x = x coordinates of the centroid
% y = y coordinates of the centroid
% plot [result_x,result_y]
% **adjust theta to increase the number of datapoints**
%---------------------------------------
theta = 0:pi/1000:2*pi;

result_x = radius * cos(theta) + origin_x;
result_y = radius * sin(theta) + origin_y;
end