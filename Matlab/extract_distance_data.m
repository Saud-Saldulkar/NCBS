function [distance] = extract_distance_data(origin_x, origin_y, data_x, data_y)
% calculate distance from an origin/centroid
distance = pdist2([origin_x, origin_y], [data_x, data_y], 'euclidean');
end