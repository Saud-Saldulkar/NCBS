function [thres_bar] = threshold_bar(file_name, index_returns, to_plot, is_random, random_x, random_y)

% extract threshold bar by providing a [file_name] and [index_returns]
% extracted from (returns_count.m)
% For plotting use [to_plot] = 1 or [to_plot] = 0 to disable 
% plot [thres_bar] using the bar() function; see below

% ----------------------------------------------------------
% load file
load(file_name);
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
% extract maximum data length and origin co-ordinates
data_length = length(x_pos);

if (is_random == 0)
    origin_x = x_pos(1);
    origin_y = y_pos(1);
end

if (is_random == 1)
    origin_x = random_x;
    origin_y = random_y;
end
% ----------------------------------------------------------

% ----------------------------------------------------------
% extract distance
for i = 1:data_length
    distance(i,1) = pdist2([origin_x, origin_y],[x_pos(i), y_pos(i)], 'euclidean');
end
% ----------------------------------------------------------

% ----------------------------------------------------------
% create threshold bar
for i = 1 : data_length
    
    if (distance(i) >= 2)
        thres_bar(i) = 0;
    else 
        thres_bar(i) = 1;
    end    
end
% ----------------------------------------------------------

% ----------------------------------------------------------
% plot
if (to_plot == 1)
    bar(thres_bar, 'r', 'EdgeColor', 'red'); ylim([0 1]);
    hold on;
    bar(index_returns, 'y', 'EdgeColor', 'yellow');
    whitebg([0,0,1]);
    set(gca, 'ytick', []);
    set(gca, 'xtick', []);
%     bar(a,'FaceColor', [1,0,0], 'EdgeColor', [1,0,0]);

end
% ----------------------------------------------------------

end