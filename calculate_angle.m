function [result] = calculate_angle(origin_vector, data_vector, quadrant)
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
result = (abs(angle1 - angle2) * 180 / pi);
% ----------------------------------------------------------
end