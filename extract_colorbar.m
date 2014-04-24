function [color_bar, length_color_bar] = extract_colorbar(file_name, color_bank_no, to_plot, is_random, random_x, random_y)

% ----------------------------------------------------------
% To plot/extract the colorbar[color_bar] and [length_color_bar] from a given file[file_name] with
% a reference color bank[color_bank_no].
% Externally can be plotted as **image(1:length_color_bar); colormap(color_bar)** 
% For plotting use [to_plot] = 1 or [to_plot] = 0 to disable
% is_random = 1 for random experiments else value is 0
% for random experiments provide values of origin else assign as 0
% ----------------------------------------------------------

% ----------------------------------------------------------
% Load file and the appropriate colorbank
load(file_name);

if (color_bank_no == 1)
    load('color_bank_1.mat');
end

if (color_bank_no == 2)
    load('color_bank_2.mat');
end

if (color_bank_no == 3)
    load('color_bank_3.mat');
end
    
% ----------------------------------------------------------

% ----------------------------------------------------------
% clean up code
clear angle;
clear identity;
clear maj_ax;
clear min_ax;
clear ntargets;
clear startframe;
clear timestamps;
% ----------------------------------------------------------

% ----------------------------------------------------------
% extract maximum data length and the centroid
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
color_bar(data_length,3) = 0;

no_of_blocks = 24;
max_distance = 225;
% ----------------------------------------------------------

% ----------------------------------------------------------
% extract distance
for i = 1:data_length
    distance(i,1) = pdist2([origin_x, origin_y],[x_pos(i), y_pos(i)], 'euclidean');
end
% ----------------------------------------------------------

% ----------------------------------------------------------
for i = 1 : data_length
    % Allocate data points based on:
    % quadrant->angle->angle_range->distance->distance_range
    
    % quadrant 01
    if  (x_pos(i) >= origin_x && y_pos(i) >= origin_y)
        
        angle = calculate_angle([origin_x,origin_y], [x_pos(i), y_pos(i)], 1);
        angle_range = find_range(90, 6, angle);
        distance_range = find_range(max_distance, no_of_blocks, distance(i));
        
        map_range = [24,23,22,21,20,19];
        map = 'map';
        map_no = map_range(angle_range);
        map_index_no = distance_range;
        % map1(2,1:3)
        combine = strcat(map,int2str(map_no),'(',int2str(map_index_no), ',', int2str(1), ':', int2str(3), ')');
        
        color_bar(i,1:3) = eval(combine);       
        
        clear angle;
        clear angle_range;
        clear distance_range;
        clear map_range;
        clear map;
        clear map_no;
        clear map_index_no;
        clear combine;
        
        continue;
    end
    
    % quadrant 02
    if (x_pos(i) >= origin_x && y_pos(i) <= origin_y)
        angle = calculate_angle([origin_x,origin_y], [x_pos(i), y_pos(i)], 2);
        angle_range = find_range(90, 6, angle);
        
        distance_range = find_range(max_distance, no_of_blocks, distance(i));
        
        map_range = [1,2,3,4,5,6];
        map = 'map';
        map_no = map_range(angle_range);
        map_index_no = distance_range;
        combine = strcat(map,int2str(map_no),'(',int2str(map_index_no), ',', int2str(1), ':', int2str(3), ')');
        color_bar(i,1:3) = eval(combine);      
        
        clear angle;
        clear angle_range;
        clear distance_range;
        clear map_range;
        clear map;
        clear map_no;
        clear map_index_no;
        clear combine;
        
        continue;
    end
    
    % quadrant 03
    if (x_pos(i) <= origin_x && y_pos(i) <= origin_y)
        angle = calculate_angle([origin_x,origin_y], [x_pos(i), y_pos(i)], 3);
        angle_range = find_range(90, 6, angle);
        
        distance_range = find_range(max_distance, no_of_blocks, distance(i));
        
        map_range = [12,11,10,9,8,7];
        map = 'map';
        map_no = map_range(angle_range);
        map_index_no = distance_range;
        combine = strcat(map,int2str(map_no),'(',int2str(map_index_no), ',', int2str(1), ':', int2str(3), ')');
        color_bar(i,1:3) = eval(combine);     
        
        clear angle;
        clear angle_range;
        clear distance_range;
        clear map_range;
        clear map;
        clear map_no;
        clear map_index_no;
        clear combine;
        
        continue;
    end
    
    % quadrant 04
    if (x_pos(i) <= origin_x && y_pos(i) >= origin_y)
        angle = calculate_angle([origin_x,origin_y], [x_pos(i), y_pos(i)], 4);
        angle_range = find_range(90, 6, angle);
        
        distance_range = find_range(max_distance, no_of_blocks, distance(i));
        
        map_range = [13,14,15,16,17,18];
        map = 'map';
        map_no = map_range(angle_range);
        map_index_no = distance_range;
        combine = strcat(map,int2str(map_no),'(',int2str(map_index_no), ',', int2str(1), ':', int2str(3), ')');
        color_bar(i,1:3) = eval(combine);      
        
        clear angle;
        clear angle_range;
        clear distance_range;
        clear map_range;
        clear map;
        clear map_no;
        clear map_index_no;
        clear combine;
        
        continue;
    end
end

length_color_bar = data_length;

% plot
if (to_plot == 1)
    h = image(1:data_length); colormap(color_bar);
    set(gcf, 'Position', [1,1,1000,50]);
end
end
% ----------------------------------------------------------
 