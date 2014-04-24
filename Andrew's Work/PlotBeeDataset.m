function [results, max_frames, bad_datasets] = PlotBeeDataset(datapath)

    % Get the filenames
    mat_files = dir([datapath '/*.mat']);
    fmf_files = dir([datapath '/*.fmf']);
    
    if (length(mat_files) ~= length(fmf_files))
        error('Number of mat files ~= number of fmf files in this directory!');
    end
    matfiles = cell(length(mat_files), 1);
    fmffiles = cell(length(fmf_files), 1);
    for j=1:length(mat_files)
        matfiles{j} = [datapath '/' mat_files(j).name];
        fmffiles{j} = [datapath '/' fmf_files(j).name];
    end
    
    % Default inputs
    if (nargin < 3), doPlot = 0; end
    if (nargin < 2), debug=0; end
        
    random_walk = 0;
    do_plot = 0;
    debug = 0;
       
    figure
    for j=1:length(matfiles)
              
        subplot(5, 5, j);
        [target_position, radius] = GetTarget(fmffiles{j}, 0);

        %PlotBeeTrajectory(mat_file, fmf_file);
        result = AnalyzeBeeTrajectory(matfiles{j}, fmffiles{j}, target_position, radius, random_walk, do_plot, debug); 
        plot(result.intersection_frames, '*');
        [pathstr1, name1, ext1] = fileparts(matfiles{j});
        title(name1);
        
    end
   

    