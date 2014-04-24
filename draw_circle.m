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
%---------------------------------------