function acceleration = extract_acceleration(file_name, start_f, end_f, step_size)
% usage example:     
% file_name = 'n1.mat';
% start_f = 1;              // start frame number
% end_f = 2400;             // end frame number
% step_size = 20;           // if  chosen 20, acceleration is per 1 sec (for 40 fps data)

    load(file_name);

    iterator = 1;
    for i = start_f:step_size:end_f
        start_frame = i;
        end_frame = (i + step_size) - 1;

        x = x_pos(start_frame:end_frame, 1);
        y = y_pos(start_frame:end_frame, 1);

        for j = 1:length(x)
            if (j == 1)
                continue
            end

            x_pre = x((j - 1), 1);
            y_pre = y((j - 1), 1);

            x_curr = x(j);
            y_curr = y(j);

            i_distance(j,1) = sqrt((x_pre - x_curr).^2 + (y_pre - y_curr).^2);
        end

        distance(iterator,1) = sum(i_distance);
        iterator = iterator + 1;
    end

    iterator = 1;
    for i = 1:2:length(distance)
        acceleration(iterator, 1) = abs(distance(i,1) - distance((i + 1),1));
        iterator = iterator + 1;
    end
end
