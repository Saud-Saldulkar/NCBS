% Algorith to extract First, Second and Third sixty second data
clc;
clear all;
close all;

sixty_1_x = [];
sixty_1_y = [];

sixty_2_x = [];
sixty_2_y = [];

sixty_3_x = [];
sixty_3_y = [];


filename = 'n';
filenumber = 1;
fileextension = '.mat';

status  = 1;

while status == 1
    file = strcat(filename, int2str(filenumber), fileextension);

    load(file);
    disp(file);
    disp('file loaded');

    blockx = floor(length(x_pos)/3);
    blocky = floor(length(y_pos)/3);
    disp('blocks calculated');

    sixty_1_x = vertcat(sixty_1_x, x_pos(1:blockx));
    sixty_1_y = vertcat(sixty_1_y, y_pos(1:blocky));
    disp('block 1 acquired');

    sixty_2_x = vertcat(sixty_2_x, x_pos((blockx + 1):(blockx * 2)));
    sixty_2_y = vertcat(sixty_2_y, y_pos((blocky + 1):(blocky * 2)));
    disp('block 2 acquired');

    sixty_3_x = vertcat(sixty_3_x, x_pos(((blockx * 2) + 1): (blockx * 3)));
    sixty_3_y = vertcat(sixty_3_y, y_pos(((blocky * 2) + 1): (blocky * 3)));
    disp('block 3 acquired');

    save('sixty_1_x.mat','sixty_1_x');
    save('sixty_1_y.mat','sixty_1_y');
    disp('data1 saved');

    save('sixty_2_x.mat','sixty_2_x');
    save('sixty_2_y.mat','sixty_2_y');
    disp('data2 saved');

    save('sixty_3_x.mat','sixty_3_x');
    save('sixty_3_y.mat','sixty_3_y');
    disp('data3 saved');

    if filenumber == 10
        status = 0
        disp('loop halted');
    end

    filenumber = filenumber + 1;
    disp('file number changed');

end
disp('loop end');
%--------------------------------------------------------------------------
clear all;
load('sixty_1_x.mat');
load('sixty_1_y.mat');

load('sixty_2_x.mat');
load('sixty_2_y.mat');

load('sixty_3_x.mat');
load('sixty_3_y.mat');