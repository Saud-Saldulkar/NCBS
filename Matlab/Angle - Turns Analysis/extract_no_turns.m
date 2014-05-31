function [no_turns] = extract_no_turns(file_name)
% calculate number of turns based on the [upper_threshold] and
% [lower_threshold](radians) using the [angles] variable provided by CTRAX

    load(file_name);

    counter = 0;
    flag = 0;
    
%   -------------------
    upper_threshold = 3;
    lower_threshold = -3;
%   -------------------

    for i = 1:length(theta)

        if (theta(i,1) > upper_threshold && flag == 0)
           flag = 1;
           start_threshold = 1;
        end

        if (theta(i,1) < -lower_threshold && flag == 0)
            flag = 1;
            start_threshold = 0;
        end

        if (flag == 1 && start_threshold == 1 && theta(i,1) < -lower_threshold)
            counter = counter + 1;
            flag = 0;
            start_threshold = nan;
        end

        if (flag == 1 && start_threshold == 0 && theta(i,1) > upper_threshold)
            counter = counter + 1;
            flag = 0;
            start_threshold = nan;
        end
        
    end    
    no_turns = counter;   
end

