to_use = 1;

% x = ((max(x_pos) - min(x_pos))/2) + min(x_pos);
% y = ((max(y_pos) - min(y_pos))/2) + min(y_pos);

% x = 384.586;
% y = 205.902;

[color_bar, length_color_bar] = extract_colorbar('n1.mat',2, 1, to_use, x, y);

% [a, b] = returns_count('n1.mat', to_use, x, y);

% [thres_bar] = threshold_bar('n1.mat', b, 1, to_use, x, y);
% plot(thres_bar); ylim([0 1]);
% set(gca, 'xtick', [], 'ytick', []);