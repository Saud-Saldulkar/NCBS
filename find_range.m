function [result] = find_range(total_distance, no_of_blocks, distance)

% Find the range in which a particular value[distance] lies given a total
% value[total_distance] and number of ranges available[no_of_blocks]

% ----------------------------------------------------------
total_distance  = ceil(total_distance);
block_length = total_distance/no_of_blocks;
% ----------------------------------------------------------

% ----------------------------------------------------------
table(1,1) = 0; 
table(1,2) = block_length;

for i = 2:no_of_blocks
    table(i,1) = table((i - 1),2);
    table(i,2) = table(i,1) + block_length;
end

for i = 1:no_of_blocks
    min = table(i,1);
    max = table(i,2);
    
    if (distance >= min && distance <=max)
        result = i;
        break;
    end    
end    
% ----------------------------------------------------------
end
