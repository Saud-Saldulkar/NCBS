function [output] = circling_score(file_no, coordinate_file)
    file_name = strcat('n', int2str(file_no), '.mat');
    load(file_name);
    load(coordinate_file);
    
    if (coordinates(file_no,1) == 1)
        origin.x = coordinates(file_no,2);
        origin.y = coordinates(file_no,3);
    end
    
    if (coordinates(file_no,1) == 0)
        origin.x = x_pos(1,1);
        origin.y = y_pos(1,1);
    end
    
    for i = 1:length(x_pos)
        if (i == 1)
           continue 
        end
        
        direction_of_motion(i,1) = calculate_angle(origin, x_pos, y_pos, i);
    end
    
    direction_of_motion = post_processing(origin, x_pos, y_pos, direction_of_motion);
       
    for i = 1:length(theta)
        output(i,1) = theta(i,1) - direction_of_motion(i,1);
    end
    
    output = abs(output);
end

function [output] = calculate_angle(origin, x_pos, y_pos, iterator)
    p1.x = x_pos((iterator - 1),1);   % Previous point (x, subscript -1)
    p1.y = y_pos((iterator - 1),1);   

    p2.x = origin.x;   % Origin point
    p2.y = origin.y;

    p3.x = x_pos(iterator,1);  % Current point (x)
    p3.y = y_pos(iterator,1);

    p12 = sqrt((p1.x - p2.x).^2 + (p1.y - p2.y).^2);
    p13 = sqrt((p1.x - p3.x).^2 + (p1.y - p3.y).^2);
    p23 = sqrt((p2.x - p3.x).^2 + (p2.y - p3.y).^2);

    output = acosd((p12.^2 + p13.^2 - p23.^2) / (2 * p12 * p13)); % Angle in degrees (for radians use [acos])
end

function [output] = determine_quadrant(origin, x_pos, y_pos, iterator)
    i = iterator;
    output = 0;
    if ((x_pos(i,1) > origin.x) && (y_pos(i,1) > origin.y))
        output = 1;
        return;
    end

    if ((x_pos(i,1) > origin.x) && (y_pos(i,1) < origin.y))
        output = 2;
        return;        
    end

    if ((x_pos(i,1) < origin.x) && (y_pos(i,1) < origin.y))
        output = 3;
        return;        
    end

    if ((x_pos(i,1) < origin.x) && (y_pos(i,1) > origin.y))
        output = 4;
        return;        
    end
end

function [output] = determine_if_candidate_for_CCW(y_pos, iterator, quadrant)   
    output = 0;
    
    if (iterator == 1)
        return;
    end
    
    y = y_pos(iterator, 1);
    prev_y = y_pos((iterator - 1),1);
     
    if (quadrant == 1)
        if (y >= prev_y)
            output = 1;
        end        
    end

    if (quadrant == 2)
        if (y >= prev_y)
            output = 1;
        end
    end

    if (quadrant == 3)
        if (y <= prev_y)
            output = 1;
        end
    end

    if (quadrant == 4)
        if (y <= prev_y)
            output = 1;
        end
    end
end
    
function [output] = post_processing(origin, x_pos, y_pos, direction_of_motion)
    for i = 1:length(direction_of_motion)
        quadrant = determine_quadrant(origin, x_pos, y_pos, i);
        if_CCW = determine_if_candidate_for_CCW(y_pos, i, quadrant);
        
        if (if_CCW == 1)
            direction_of_motion(i,1) = 360 - direction_of_motion(i,1);
        end
    end
    output = direction_of_motion;
end