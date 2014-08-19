function [output] = plot_degree_vs_time(file_no, bin_size1, bin_size2, to_plot, to_lim, x_lim, y_lim)

% Angle data extracted required with [theta] variable
%
% usage example:
% --------------------------------------------------------------------
% file_no = 5;
% bin_size1 = 8;
% bin_size2 = 25;
% to_plot = 1;
% to_lim = 1;
% x_lim = [0 25];
% y_lim = [0 180];
% [output] = plot_degree_vs_time(file_name, bin_size1, bin_size2);

% [output] = mean | STD DEV | STD ERROR
% --------------------------------------------------------------------
    file_name = get_file_name(file_no);
    
    load(file_name);
    
    if (length(theta) < (bin_size1 * bin_size2))
        output = [];
        return;
    end
    
    theta1 = convert_rad_degrees(theta);
       
    theta2 = convert_negative_angles(theta1);
    
    theta3 = relative_turning(theta2, bin_size1);

    theta4 = extract_mean(theta3, bin_size2);

    theta5 = extract_std_error(theta4, bin_size2);    
    
    output = theta5;
    
    if (to_plot == 1)
        plot_print_data(file_no, output, to_lim, x_lim, y_lim);
    end
end

function [output] = convert_rad_degrees(input)
    for i = 1:length(input)
        output(i,1) = (input(i,1) * 180) / pi;
    end
end

function [output] = convert_negative_angles(theta)    
    for i = 1:length(theta)
        if (sign(theta(i,1)) == -1)
            theta(i,1) = theta(i,1) + 360;
        end
    end   
    output = theta;
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

function [output] = get_file_name(file_no)
    prefix = 'n';
    postfix = '.mat';
    output = strcat(prefix, int2str(file_no), postfix);
end

function plot_print_data(file_no, output, to_lim, x_lim, y_lim)
    errorbar(output(:,1),output(:,3), ':sk', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
    
    fig_title = strcat('Turning Analysis -',' Experiment No:', int2str(file_no));
    title(fig_title);
    xlabel('time');
    ylabel('angle (degrees)');
    
    if (to_lim == 1)
        xlim(x_lim);
        ylim(y_lim);
    end
    
    file_name = strcat('Experiment No', int2str(file_no), '.png');
    
    set(gcf,'PaperPosition',[0,0,15,13]);
    print(gcf,'-r0','-dpng',file_name);
end
