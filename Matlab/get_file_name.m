function [output] = get_file_name(file_no)
% Generate file names for the search experiments(NCBS-Bangalore)
    prefix = 'n';
    postfix = '.mat';
    output = strcat(prefix, int2str(file_no), postfix);
end