function [output] = calculate_relative_turning(file_no, bin_size)
    file_name = strcat('n',int2str(file_no), '.mat');    
    load(file_name);
    
    no_frames = floor((length(theta)/180) * bin_size);
    no_datapoints = floor(length(theta)/ no_frames);
    
    start_frame = 1;
    
    for i = 1:no_datapoints
        end_frame = i * no_frames;
        
        data.theta = theta(start_frame:end_frame, 1);
        
        output(i,1) = relative_turning(data);
        
        start_frame = end_frame + 1;
    end
end

function [output] = relative_turning(data)
    data.max = max(data.theta);
    data.min = min(data.theta);    
    output = data.max - data.min;
end