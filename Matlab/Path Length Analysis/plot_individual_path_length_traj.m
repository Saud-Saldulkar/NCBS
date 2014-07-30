function plot_individual_path_length_traj(coordinate_file, file_no)
% plot individual trajectories for path length data under two concentric
% circles of radius 2 and 100

    load(coordinate_file);

    prefix = 'n';
    postfix = '.mat';
    file_name = strcat(prefix, int2str(file_no), postfix);

    load(file_name);

    if (coordinates(file_no, 1) == 1)
        origin_x = coordinates(file_no, 2);
        origin_y = coordinates(file_no, 3);
    end

    if (coordinates(file_no, 1) == 0)
       origin_x = x_pos(1,1);
       origin_y = y_pos(1,1);   
    end

    radius = 100;
    [result_x, result_y] = draw_circle(origin_x, origin_y, radius);
    plot(result_x, result_y, 'r'); hold on;


    radius = 2;
    [result_x, result_y] = draw_circle(origin_x, origin_y, radius);
    plot(result_x, result_y, 'r'); hold on;

    plot(x_pos, y_pos);

    axis square off;

end