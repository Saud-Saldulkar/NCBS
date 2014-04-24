function [results, max_frames, bad_datasets] = AnalyzeBeeDataset(datapath, debug, use_target, do_plot, random_walk)
%[results, max_frames, bad_datasets] = AnalyzeBeeDataset('C:\Users\Mr S\Desktop\process')

    if (nargin < 5)
        random_walk = 0;
    end;
    if (nargin < 4)
        do_plot = 0;
    end
    if (nargin < 3)
        use_target = 1;
    end

    % Get the filenames
    mat_files = dir([datapath '/*.mat']);
    fmf_files = dir([datapath '/*.fmf']);
    
    mat_files
    fmf_files
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
       
   
    matfiles
    
    % Process the trajectories
    results = struct([]);
    bad_datasets = struct([]);
    for j=1:length(matfiles)
    %for j=1:1   
    %for j=length(matfiles)-2
        
        % Get the target for this movie
        if (use_target)
            [target_position, radius, arena] = GetTarget(fmffiles{j});        
        else
            target_position = [];
            radius = 3;
            arena = [];
        end
        
		% Analyze this trajectory and return the results in a struct
		result = AnalyzeBeeTrajectory(matfiles{j}, fmffiles{j}, target_position, radius, debug, do_plot, random_walk);
        
        % Only add to results if it is valid data
        if (result.valid)
            %clusters = FindClusters(result.intersection_frames);
            %result.clusters = clusters;
            results = [results result];
        else
            bad_datasets = [bad_datasets result];
            fprintf('Invalid dataset for some reason, omitting\n');
        end
    end
    
    % Find the range of data for each simulation
    max_frames = inf;
    for j=1:length(results)
        num_frames = (results(j).total_frames - results(j).start) + 1;
        if (num_frames < max_frames)
            max_frames = num_frames;
            %fprintf('Simulation %s [%f frames]\n', results(j).simulation, max_frames);
        end
    end
    
function clusters = FindClusters(data)

    if (length(data)==1)
        clusters = ones(size(data));
        return
    end

    X = [data; data]';
    Y = pdist(X,'euclidean');
    Z = linkage(Y,'average');
    %clusters = cluster(Z, 'maxclust', 2);
    clusters = cluster(Z, 'cutoff', 1000, 'criterion', 'distance');

    %figure 
    %subplot(2, 1, 1);
    %plot(X);
    %title('Bee trajectory (interesection frames)');
    %xlabel('intersections');
    %ylabel('frames');
    %subplot(2, 1, 2);
    %[H,T] = dendrogram(Z,'colorthreshold','default');
    %title('Bee dendrogram (intersection clusters)');
    %clusters = cluster(Z, 'maxclust', 2);


    