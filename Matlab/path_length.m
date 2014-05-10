function track_length = path_length(file_name)
% calculate the total path travelled in euclidean distance by using arc length method. 

load(file_name)

clear angle;
clear identity;
clear maj_ax;
clear min_ax;
clear ntargets;
clear startframe;
clear timestamps;

length_analysis = length(x_pos);

for i = 1:length_analysis
    prev_i = i - 1;
    
    if (i > 1)
        prev_var_x = x_pos(prev_i,1);
        prev_var_y = y_pos(prev_i,1);
    end
    
    if (i == 1)
        prev_var_x = x_pos(i,1);
        prev_var_y = y_pos(i,1);
    end
    
    var_x = x_pos(i,1);
    var_y = y_pos(i,1);
    
    array_path_length(i,1) = pdist2([prev_var_x, prev_var_y],[var_x, var_y],'euclidean');
    
    clear prev_var_x
    clear prev_var_y
    clear var_x
    clear var_y
end

clear i;
clear length_analysis;
clear prev_i;
clear prev_var_x;
clear prev_var_y;
clear var_x;
clear var_y;

format long g
track_length = sum(array_path_length);
format long g
end
