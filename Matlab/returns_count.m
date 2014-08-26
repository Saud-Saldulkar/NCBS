function [no_returns, index_returns] = returns_count(file_name, is_random, random_x, random_y)
% function to count the number of returns[no_returns] and location or index
% of the return event[index returns]
% parameters to modify: euclidean radius, centroid position(default/manual) 


    euclidean_radius = 2;
    load(file_name);
    
    % clean variables from loaded file
    %------------------------------------------------
    clear angle;
    clear identity;
    clear maj_ax;
    clear min_ax;
    clear ntargets;
    clear startframe;
    %------------------------------------------------

    %------------------------------------------------
    % extract CENTROID(x and y) 
    centroid = struct('x',[],'y',[]);
    
    if (is_random == 0)
        centroid.x = x_pos(1);
        centroid.y = y_pos(1);
    end
    
    if (is_random == 1)
        centroid.x = random_x;
        centroid.y = random_y;
    end
    %------------------------------------------------
    
    data_length = struct('x',[],'y',[]);
    data_length.x = length(x_pos);
    data_length.y = length(y_pos);
    index_returns(data_length.x) = 0;
    
    % check if data length of X and Y are equal; if not then display error message
    if (data_length.x ~= data_length.y)
        disp(strcat('Error: X and Y datapoints are not of the same length for file n',int2str(i)));        
    end

    for n = 1:data_length.x    
        distance(n,1) = pdist2([centroid.x,centroid.y],[x_pos(n), y_pos(n)], 'euclidean');
    end

    % annotate dataset for inside the circle [0] or outside the circle [1]
    for n = 1:length(distance)
        if distance(n,1) <= euclidean_radius
            dataset_pattern(n,1) = 0;
        else
            dataset_pattern(n,1) = 1;            
        end    
    end
    
    % check for [10..] pattern i.e from outside to inside transition
    counter  = 0;
    for n = 1:length(dataset_pattern)
        if dataset_pattern(n,1) == 0
        continue;
        end;

        if dataset_pattern(n,1) == 1
            prev = n - 1;
            if prev ~= 0
                if (dataset_pattern(prev,1) == 0) 
                    counter  = counter + 1;
                    index_returns(n) = 1; 
                end
            end
        end
    end    
    no_returns = counter;    
end



