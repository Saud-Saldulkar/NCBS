function extract_angle_data_from_pathlength_data(no_files, stage_no)
% extract angle data from the path length data through 4 stages
% note: 3rd stage in a seperate script
    if (stage_no == 1)
        stage1(no_files)
    end
    
    if(stage_no == 2)
        stage2();
    end
    
    if (stage_no == 4)
        stage4();
    end
    
end

function stage1(no_files)
% use path length data. [output] = [start_value]|[end_value]|[length]
    for f = 1:no_files
        
        file_name = filename(f); 
        load(file_name);
        
        data_length = length(x_pos);        
        data_bank1(f,1) = x_pos(1,1);
        data_bank1(f,2) = x_pos(data_length,1);
        data_bank1(f,3) = data_length;        
    end
    save('data_bank1.mat','data_bank1');
end

function stage2()
% use raw data. [output] = [start_frame]|[end_frame]
   load('data_bank1.mat');
   no_files = length(data_bank1);
   
   for i = 1:no_files
        file_name = filename(i);
        load(file_name);
        
        
        [start_frame,y] = find(x_pos == data_bank1(i,1));
        data_length = data_bank1(i,3);
        data_length = data_length - 1;
        end_frame = start_frame + data_length;
        
        if (x_pos(end_frame,1) ~= data_bank1(i,2))
            disp('Error in end value for');
            i
        end
        
        data_bank2(i,1) = start_frame;
        data_bank2(i,2) = end_frame;
   end
   save('data_bank2.mat', 'data_bank2');
end

function stage4()
% use same data from stage 3. [output] = required angle data
    load('data_bank2.mat');
    no_files = length(data_bank2);
    
    for f = 1:no_files
        file_name = filename(f);
        load(file_name);
        
        start_frame = data_bank2(f,1);
        end_frame = data_bank2(f,2);
        theta = theta(start_frame:end_frame, 1);
        save(file_name, 'theta');
    end
end

function [file_name] = filename(file_no)
    prefix = 'n';
    postfix = '.mat';
    file_name = strcat(prefix, int2str(file_no), postfix);
end