% use same data from 2nd stage. [output] = theta conversion
no_files = 10;

for i = 1:no_files
   
    prefix = 'n';
    postfix = '.mat';
    file_name = strcat(prefix, int2str(i), postfix);
    load(file_name);
    
    theta = angle;
    clearvars -except theta file_name

    save(file_name, 'theta');
   
end

clearvars