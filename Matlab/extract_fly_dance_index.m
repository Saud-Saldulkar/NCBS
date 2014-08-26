function [output] = extract_fly_dance_index(file_no, coordinate_file_name)
    file_name = strcat('n', int2str(file_no), '.mat');
    load(file_name);
    load(coordinate_file_name);
    
    total_distance = calculate_total_distance(x_pos, y_pos);
    
    for i = 1:length(x_pos)
        if (i == 1)
            continue;
        end
        
        if (i == length(x_pos))
           break; 
        end
        
        data.x = x_pos(i,1);
        data.y = y_pos(i,1);   
        direct_distance = calculate_direct_distance(file_no, coordinates, x_pos, y_pos, data);
        
        p2.x = x_pos((i - 1), 1);
        p2.y = y_pos((i - 1), 1);
        p1.x = x_pos(i,1);
        p1.y = y_pos(i,1);
        p3.x = x_pos((i+1), 1);
        p3.y = y_pos((i+1), 1);
        vectorial_angle = calculate_angle(p2, p1, p3);
        
        fly_dance_index(i,1) = total_distance / (direct_distance * vectorial_angle);
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
   
   distance = sqrt((origin.x - data.x).^2 + (origin.y - data.y).^2);   
   output = abs(distance);

end

function [output] = calculate_angle(p2, p1, p3)
    p12 = sqrt((p1.x - p2.x).^2 + (p1.y - p2.y).^2);
    p13 = sqrt((p1.x - p3.x).^2 + (p1.y - p3.y).^2);
    p23 = sqrt((p2.x - p3.x).^2 + (p2.y - p3.y).^2);

    output = acosd((p12.^2 + p13.^2 - p23.^2) / (2 * p12 * p13));
end