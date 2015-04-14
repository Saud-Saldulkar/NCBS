function [x_var, y_var] = extract_unique_pair_values(x, y)
% Function extracts unique X and Y coordinates. The unique values are
% extracted as a pair[X and Y] and not individual[X or Y].
    x_var = [];
    y_var = [];
    
    for i = 1:length(x)
        if (isempty(x_var))
            x_var(1,1) = x(1,1);
            y_var(1,1) = y(1,1);
        end
        
        if (length(x_var) >= 1)
            ind_x = find(x_var == x(i,1));
            ind_y = find(y_var == y(i,1));
            
            intersect_set = intersect(ind_x, ind_y);
            
            if (isempty(intersect_set))
                x_var = vertcat(x_var, x(i,1));
                y_var = vertcat(y_var, y(i,1));
            end
            
            if (intersect_set > 0)
                continue;
            end
        end
    end
end