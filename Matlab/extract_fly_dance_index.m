function [output] = extract_fly_dance_index(file_no, coordinate_file_name)
%   Extract Fly Dance Index for each data point
    
    bin_duration = 10;  % sec
    
    file_name = strcat('n', int2str(file_no), '.mat');
    load(file_name);
    load(coordinate_file_name);
    
    no_frames = floor((length(x_pos)/180) * bin_duration);
    no_datapoints = floor(length(x_pos)/ no_frames);
    
    start_frame = 1;
       
    for iter = 1:no_datapoints
        
        end_frame = iter * no_frames;
      
        data.x = x_pos(start_frame:end_frame, 1);
        data.y = y_pos(start_frame:end_frame, 1);
        
        total_distance = calculate_total_distance(data.x, data.y);

        direct_distance = calculate_direct_distance(file_no, coordinates, x_pos, y_pos, data);
      
        vectorial_angle = calculate_angle(data);

        fly_dance_index(iter,1) = total_distance / (direct_distance * vectorial_angle);
        
        start_frame = end_frame + 1;
   
    end
    
    output = fly_dance_index;
end

function [output] = calculate_total_distance(x_pos, y_pos)

for i = 1:length(x_pos)
    if (i == (length(x_pos)))
        break;
    end

    p1.x = x_pos(i,1);
    p1.y = y_pos(i,1);

    p2.x = x_pos((i+1),1);
    p2.y = y_pos((i+1),1);

    distance(i,1) = sqrt((p1.x - p2.x).^2 + (p1.y - p2.y).^2);    
end
output  = sum(distance);
end

function [output] = calculate_direct_distance(file_no, coordinates, x_pos, y_pos, data)

   if (coordinates(file_no, 1) == 1)
       origin.x = coordinates(file_no, 2);
       origin.y = coordinates(file_no, 3);
   end
   
   if (coordinates(file_no, 1) == 0)
        origin.x = ((max(x_pos) - min(x_pos)) / 2) + min(x_pos);
        origin.y = ((max(y_pos) - min(y_pos)) / 2) + min(y_pos);
   end
   
   for i = 1:length(data.x)
        distance(i,1) = sqrt((origin.x - data.x(i,1)).^2 + (origin.y - data.y(i,1)).^2);
   end
   
   distance = nanmean(distance);
   output = abs(distance);

end

function [output] = calculate_angle(data)
    for i = 1:length(data.x)
        if (i == 1)
           continue; 
        end
        
        if (i == length(data.x))
            break;
        end
        
        p2.x = data.x((i - 1), 1);
        p2.y = data.y((i - 1), 1);
        p1.x = data.x(i,1);
        p1.y = data.y(i,1);
        p3.x = data.x((i+1), 1);
        p3.y = data.y((i+1), 1);

        p12 = sqrt((p1.x - p2.x).^2 + (p1.y - p2.y).^2);
        p13 = sqrt((p1.x - p3.x).^2 + (p1.y - p3.y).^2);
        p23 = sqrt((p2.x - p3.x).^2 + (p2.y - p3.y).^2);

        angle_data(i,1) = acosd((p12.^2 + p13.^2 - p23.^2) / (2 * p12 * p13));
    end
    output = nanmean(angle_data);
end