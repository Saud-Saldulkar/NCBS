function [output] = plot_degree_vs_time(file_name, bin_size1, bin_size2)

% Angle data extracted required with [theta] variable
%
% usage example:
% --------------------------------------------------------------------
% file_name = 'n5.mat';
% bin_size1 = 8;
% bin_size2 = 25;
% [output] = plot_degree_vs_time(file_name, bin_size1, bin_size2);

% [output] = mean | STD DEV | STD ERROR
% --------------------------------------------------------------------

    load(file_name);
    
    theta1 = convert_rad_degrees(theta);
    
    theta2 = abs(theta1);
    
    theta3 = convert_negative_angles(theta2);
    
    theta4 = relative_turning(theta3, bin_size1);

    theta5 = extract_mean(theta4, bin_size2);

    theta6 = extract_std_error(theta5, bin_size2);    
    
    output = theta6;
end

function [output] = convert_rad_degrees(input)
    for i = 1:length(input)
        output(i,1) = (input(i,1) * 180) / pi;
    end
end

function [output] = relative_turning(theta, bin_size1)
   iterator = 1;
    for i = 1:bin_size1:length(theta)
        
        start_frame = i;
        end_frame = i + (bin_size1 - 1);
        
        if (end_frame > length(theta))
            return;
        end
        
        data_block = theta(start_frame:end_frame, 1);
        block_max = max(data_block);
        block_min = min(data_block);
        
        block = block_max - block_min;
        
        output(iterator, 1) = block;
        iterator = iterator + 1;
    end 
end

function [output] = extract_mean(theta, bin_size2)
    iterator = 1;
    for i = 1:bin_size2:length(theta)
        
        start_frame = i;
        end_frame = i + (bin_size2 - 1);
        
        if (end_frame > length(theta))
            return;
        end
        
        data_block = theta(start_frame:end_frame, 1);
        
        block_mean = mean(data_block);
        block_std_dev = std(data_block);
        
        output(iterator, 1) = block_mean;
        output(iterator, 2) = block_std_dev;
        iterator = iterator + 1;
    end
end

function [output] = extract_std_error(theta, bin_size2)
   for i = 1:length(theta(:,1))
       theta(i,3) = (theta(i,2)/ sqrt(bin_size2));
   end
   output = theta;
end

function [output] = convert_negative_angles(theta)    
    
    for i = 1:length(theta)
        if (sign(theta(i,1)) == -1)
            theta(i,1) = theta(i,1) + 360;
        end
    end
    
    output = theta;
end