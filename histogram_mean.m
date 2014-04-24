% mean of 3 histograms
% dependency: random_generator.m

% ----------------------------------------------------------
clc;
clear all;
close all;
% ----------------------------------------------------------

% ----------------------------------------------------------
load('one.mat');

bin_values(125,1) = 0;

data_length = length(one);

for i = 1:125
    max_range = i * 2;
    min_range = max_range - 2;
    
    for c = 1:data_length
        if one(c,1) >= min_range && one(c,1) <= max_range                   
            bin_values(i,1) = bin_values(i,1) + 1; 
        end    
    end
end
% ----------------------------------------------------------

% ----------------------------------------------------------
clear one;
clear min_range;
clear max_range;
clear i;
clear c;
clear data_length;
% ----------------------------------------------------------

% ----------------------------------------------------------
load('two.mat');

bin_values(125,2) = 0;

data_length = length(two);

for i = 1:125
    max_range = i * 2;
    min_range = max_range - 2;
    
    for c = 1:data_length
        if two(c,1) >= min_range && two(c,1) <= max_range                   
            bin_values(i,2) = bin_values(i,2) + 1; 
        end    
    end
end
% ----------------------------------------------------------

% ----------------------------------------------------------
clear two;
clear min_range;
clear max_range;
clear i;
clear c;
clear data_length;
% ----------------------------------------------------------

% ----------------------------------------------------------
load('three.mat');

bin_values(125,3) = 0;

data_length = length(three);

for i = 1:125
    max_range = i * 2;
    min_range = max_range - 2;
    
    for c = 1:data_length
        if three(c,1) >= min_range && three(c,1) <= max_range                   
            bin_values(i,3) = bin_values(i,3) + 1; 
        end    
    end
end
% ----------------------------------------------------------

% ----------------------------------------------------------
clear three;
clear min_range;
clear max_range;
clear i;
clear c;
clear data_length;
% ----------------------------------------------------------

% ----------------------------------------------------------
for i = 1:length(bin_values)
    bin_values(i,4) = round((bin_values(i,1) + bin_values(i,2) + bin_values(i,3))/3);
end
% ----------------------------------------------------------

% ----------------------------------------------------------
clear i;
% ----------------------------------------------------------

% ----------------------------------------------------------
data = 0;
for z = 1:125
      
    max_range = z * 2;
    min_range = max_range - 2;
    
    temp = random_generator(min_range, max_range, bin_values(z,4));   
    data = vertcat(data,temp);
    clear temp;
end    
% ----------------------------------------------------------



