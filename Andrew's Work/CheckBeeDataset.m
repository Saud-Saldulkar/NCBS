function [results, max_frames, bad_datasets] = CheckBeeDataset(datapath)

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
               
    for j=1:length(matfiles)
           
        CheckTrack(matfiles{j}, fmffiles{j});
        
        %[target_position, radius] = GetTarget(fmffiles{j}, 0);

        %PlotBeeTrajectory(mat_file, fmf_file);
        %result = AnalyzeBeeTrajectory(matfiles{j}, fmffiles{j}, target_position, radius, random_walk, do_plot, debug); 
        
    end
   

function result = CheckTrack(datafilename, fmffilename)

        % Get fileparts for both filenames
    [pathstr1, name1, ext1] = fileparts(datafilename);
    [pathstr2, name2, ext2] = fileparts(fmffilename);    
    
	% Load the MAT file containing the data for this bee 
	eval(['data = load(''' datafilename ''');']);	
    	
	% Get the number of frames analyzed in the struct
	ctrax_numDataFrames = length(data.x_pos);
	ctrax_startDataFrame = data.startframe;
    result.total_frames = ctrax_numDataFrames;
          
	% Get the information about the movie FMF file
    [header_size, version, h, w, frame_size, numFMFFrames, data_format] = fmf_read_header(fmffilename);
    fprintf('%s\t%d\t%d\n', [name2 ext2], numFMFFrames, ctrax_numDataFrames);
    
