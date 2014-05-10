function output = random_generator(min_range,max_range,n_outputs)
% min_range = 0;
% max_range = 2;
% n_outputs = 100;
output = (max_range-min_range).*rand(n_outputs,1) + min_range;
end