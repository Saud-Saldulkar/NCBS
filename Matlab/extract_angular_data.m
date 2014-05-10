function [angular_data] = extract_angular_data(file_name, is_random, random_x, random_y)

load(file_name);

clear angle            
clear identity         
clear maj_ax           
clear min_ax           
clear ntargets                
clear startframe       
clear timestamps       

if (is_random == 0)
    origin_x = x_pos(1,1);
    origin_y = y_pos(1,1);
end

if (is_random == 1)
    origin_x = random_x;
    origin_y = random_y;
end

for i = 1:length(x_pos)
    data_x = x_pos(i,1);
    data_y = y_pos(i,1);
    quadrant(i,1) = calculate_quadrant(origin_x, origin_y, data_x, data_y);
end

for i = 1:length(x_pos)
    
    origin_vector(1) = origin_x;
    origin_vector(2) = origin_y;
    
    data_vector(1) = x_pos(i,1);
    data_vector(2) = y_pos(i,1);
    
    angular_data(i,1) = calculate_angle(origin_vector, data_vector, quadrant(i,1));
end

end

function [quadrant] = calculate_quadrant(origin_x, origin_y, data_x, data_y)

% quadrant 01
if  (data_x >= origin_x && data_y >= origin_y)
    quadrant = 1;
end

% quadrant 02
if (data_x >= origin_x && data_y <= origin_y)
    quadrant = 2;
end

% quadrant 03
if (data_x <= origin_x && data_y <= origin_y)
    quadrant = 3;
end

% quadrant 04
if (data_x <= origin_x && data_y >= origin_y)
    quadrant = 4;
end

end

function [angle] = calculate_angle(origin_vector, data_vector, quadrant)
% ----------------------------------------------------------
origin_x = origin_vector(1);
origin_y = origin_vector(2);

data_x = data_vector(1);
data_y = data_vector(2);
% ----------------------------------------------------------

% ----------------------------------------------------------
if (quadrant == 1 || quadrant == 2)
    ref_x = origin_x + 100;
    ref_y = origin_y;
end

if (quadrant == 3 || quadrant == 4)
    ref_x = origin_x - 100;
    ref_y = origin_y;
end
% ----------------------------------------------------------

% ----------------------------------------------------------
line_y = abs(origin_y - ref_y);
line_x = abs(origin_x - ref_x);

angle1 = atan2(line_y,line_x);
% ----------------------------------------------------------

% ----------------------------------------------------------
clear line_y;
clear line_x;
% ----------------------------------------------------------

% ----------------------------------------------------------
line_y = abs(origin_y - data_y);
line_x = abs(origin_x - data_x);

angle2 = atan2(line_y,line_x);
% ----------------------------------------------------------

% ----------------------------------------------------------
ref_angle = (abs(angle1 - angle2) * 180 / pi);
% ----------------------------------------------------------

if (quadrant == 1)
    angle = ref_angle;
end

if (quadrant == 2)
    angle = 270 + (90 - ref_angle);
end

if (quadrant == 3)
    angle = 180 + ref_angle;
end

if (quadrant == 4)
    angle = 90 + (90 - ref_angle);
end

end