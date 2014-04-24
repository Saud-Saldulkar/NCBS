function PlotBeeTrajectory(datafilename, fmffilename)

    if (nargin < 3)
        debug = 0;
    end

    walkX = [];
    walkY = [];

    % Get fileparts for both filenames
    [pathstr1, name1, ext1] = fileparts(datafilename);
    [pathstr2, name2, ext2] = fileparts(fmffilename);    
    result.simulation = name1;
    result.datapath = datafilename;
    result.fmfpath = fmffilename;
    
	% Load the MAT file containing the data for this bee 
	eval(['data = load(''' datafilename ''');']);	
    fprintf('Loaded file "%s"\n', [name1 ext1]);
    	
	% Get the number of frames analyzed in the struct
	ctrax_numDataFrames = length(data.x_pos);
	ctrax_startDataFrame = data.startframe;
    result.total_frames = ctrax_numDataFrames;
			
    % Set the start and end frames
    f_start = 1;
    %f_end = 1000;
    f_end = ctrax_numDataFrames;
           
	% Get the information about the movie FMF file
	[header_size, version, h, w, frame_size, numFMFFrames, data_format] = fmf_read_header(fmffilename);
    fp = fopen(fmffilename, 'r');
    fseek(fp, header_size, 'bof');
    fseek(fp, frame_size*(f_start-1), 'cof' );
    
	if (debug)
		fprintf('Data stats: [num_data_frames: %d start_data_frame: %d num_fmf_frames: %d]\n', ...
				ctrax_numDataFrames, ctrax_startDataFrame, numFMFFrames);
	end
	if (abs(numFMFFrames - ctrax_numDataFrames) > 10)

		fprintf('WARNING: File "%s" has %d frames and file "%s" has %d frames.  Please reanalyze.  Skipping ...\n', ...
				[name1 ext1], ctrax_numDataFrames, [name2 ext2], numFMFFrames);
        return
    end
        
    frame = fmf_read_frame(fp, h, w, frame_size, data_format); 
    PlotFrame(2, frame, 1);
    plot(data.x_pos, data.y_pos, 'b:', 'LineWidth', 0.1);

   
function PlotTarget(target_position, circle_points, do_plot)
    %plot(target_position(1),target_position(2),'g*');
    if (do_plot)
        plot(circle_points(:,1), circle_points(:,2), 'g');
    end
    
function PlotPath(do_plot)      
    global walkX walkY;
    if (do_plot)
        plot(walkX, walkY, 'b:', 'LineWidth', 0.1);
    end
    
function PlotFrame(f, frame, do_plot)
    if (do_plot)
        % Plot the frame
        if (f==1)
            imshow(frame);
        else
            imshow(frame);
            image(frame)  
            hold on;
        end   
    end
