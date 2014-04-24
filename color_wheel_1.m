% -------------------------------------
% Create a master map
% Dependency: color_bank.mat
load ('color_bank_1.mat');
master_map = [];
for i = [18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,24,23,22,21,20,19]
    map = strcat('map',int2str(i));
    master_map = vertcat(master_map, eval(map));
end

% -------------------------------------
% Clear color bank
for i = 1:24
    map = strcat('map',int2str(i));
    clear(map);
end
% -------------------------------------

% -------------------------------------
% Create color index to reference with color map(master map)
counter =  0;
for i = 1:24
   for c = 1:120
       counter = counter + 1;
       color_index(c,i) = counter; 
   end
end
color_index(:,25) = color_index(:,1);
% -------------------------------------

% -------------------------------------
% Draw circle and embed colors
no_circle_segments = 12;
no_of_circles = (0:119)'/119;
theta = pi * (-no_circle_segments : no_circle_segments) / no_circle_segments;

X = no_of_circles * cos(theta);
Y = no_of_circles * sin(theta);

% C = no_of_circles * cos(2 * theta); % reference line

pcolor(X,Y,color_index); colormap(master_map);
axis equal tight;
% -------------------------------------

% -------------------------------------
% Clean up code
for i = 1:24
    map = strcat('map',int2str(i));
    clear(map);
end

clear theta;
clear no_of_circles;
clear no_circle_segments;
clear map;
clear i;
clear counter;
clear c;
clear C;
% -------------------------------------