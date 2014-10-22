function [count, x_i, y_i] = extract_intersections(file_no, bin_size)

    file_name = strcat('n', int2str(file_no), '.mat');
    load(file_name);

    x_i = [];
    y_i = [];
    iterator = 1;

    for i = 1:bin_size:length(x_pos)
        start_frame = i;
        end_frame = (start_frame + bin_size) - 1;

        if (end_frame > length(x_pos))
            break;
        end

        x = x_pos(start_frame:end_frame, 1);
        y = y_pos(start_frame:end_frame, 1);   

        buf_count = 0;
        for iter = 1:bin_size:length(x_pos)
            if (iter == i)
                continue
            end

            s_frame = iter;
            e_frame = (s_frame + bin_size) - 1;

            if (e_frame > length(x_pos))
                break
            end

            temp_x = x_pos(s_frame:e_frame, 1);
            temp_y = y_pos(s_frame:e_frame, 1);

            [x_buf, y_buf] = polyxpoly(x, y, temp_x, temp_y);
            buf_count = buf_count + length(x_buf);

            if (not(isempty(x_buf)))
                x_i = vertcat(x_i, x_buf);
                y_i = vertcat(y_i, y_buf);       
            end
        end
        
        count(iterator, 1) = buf_count;
        iterator = iterator + 1;
    end
end