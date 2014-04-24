function [t, r, arena] = GetTarget(filename, do_plot)
% Gets the coordinates and radius of the target

    % Default values
    if (nargin < 2)
        do_plot = 0;
    end
    
    nframes = inf;
    f_start = 1;
    incr = 100;
    
    % Get information about FMF file, including header size and h/w
    [header_size, version, h, w, frame_size, max_n_frames, data_format] = fmf_read_header(filename);
    if(nframes ~= inf && nframes + f_start - 1 > max_n_frames ),
        nframes = max_n_frames - f_start + 1;
        warning( 'fmf_short', sprintf( 'not enough frames in file -- returning %d frames', nframes ) );
    elseif nframes == inf,
        nframes = max_n_frames - f_start + 1;
    end
    
    % Create array to save the data
    data = uint8(zeros(h, w));

    % Create the figure
    if (do_plot)
        figure(20); clf
        pause(1e-3)
    end
    
    % Open the file and seek past the header
    fp = fopen( filename, 'r' );
    fseek( fp, header_size, 'bof' );
    
    % Skip through FMF file in increments
    for f=1:nframes/incr,

        % Get the correct frame from the data file 
        data(:,:,f) = fmf_read_frame(fp, h, w, frame_size, data_format); 

        % Seek forward in the frame file
        fseek(fp, frame_size*(incr), 'cof');
        
    end
    
    % Close the file
    fclose(fp);
    
    % Get the max intensity for each pixel across all frames  The
    % (hopefully moving) bee is removed
    flat_data = max(data, [], 3);
    
    % Plot the result
    if (do_plot)
        imshow(flat_data);
        image(flat_data)
        hold on 
    end
    
    % Offset these slightly by -10 so we don't get confused by the dot
    xcoords = FindXArena(flat_data, floor(h/2)-10, do_plot);
    ycoords = FindYArena(flat_data, floor(mean(xcoords))-10, do_plot);    
    
    % Now find the target
    shorten = floor((ycoords(2)-ycoords(1)) / 4);
    truncate_data = flat_data(ycoords(1)+shorten:ycoords(2)-shorten,xcoords(1)+shorten:xcoords(2)-shorten);
    
    % First find the absolute darkest spot on here.  This should be 
    % the center of the target
    [v,index] = min(truncate_data(:));
    [yindex, xindex] = ind2sub(size(truncate_data), index);
    t = [xindex+xcoords(1)+shorten+1, yindex+ycoords(1)+shorten-2];

    % Plot the resulting dots 
    if (do_plot)
        plot(t(1), t(2),'go');
    end
    
    % Set the output variables
    r = 3.0;
    arena = [xcoords ycoords];
    
function [ycoords] = FindYArena(data, xcoord, do_plot)

    % Get xboundaries
    ycoords = GetBoundaries(data(:, xcoord));
    if (do_plot)
        plot([xcoord, xcoord], ycoords, 'r*');  
    end
       
function [xcoords] = FindXArena(data, ycoord, do_plot)

    % Get xboundaries
    xcoords = GetBoundaries(data(ycoord, :)); 
    if (do_plot)
        plot(xcoords, [ycoord, ycoord], 'r*');  
    end
    
function [boundaries] = GetBoundaries(line)       

    % Go through this line and find the longest
    % continuous white space.  
    % Cluster the values into two groups, black and white
    [IDX, C] = kmeans(double(line'),4, 'emptyaction', 'singleton');
    
    % Set the cutoff by averaging the centers of the clusters
    cutoff = mean([max(C),min(C)]);

    indices = double(line > cutoff);
    %[line indices]

    longest_white = -inf;
    start_white = -inf;
    current_white = 0;
    start_coord = -inf;
    for j=1:length(indices)
        
        % If this is white
        if (indices(j) == 1)
            if (current_white == 0)
               start_white = j;
            end
            current_white = current_white + 1;
        else
            if (current_white > longest_white)
                longest_white = current_white;
                start_coord = start_white;
            end
            current_white = 0;
        end
    end    
    
    longest_white = -inf;
    start_white = -inf;
    current_white = 0;
    end_coord = inf;
    for j=length(indices):-1:1
        
        % If this is white
        if (indices(j) == 1)
            if (current_white == 0)
               start_white = j;
            end
            current_white = current_white + 1;
        else
            if (current_white > longest_white)
                longest_white = current_white;
                end_coord = start_white;
            end
            current_white = 0;
        end
    end        
    boundaries = [start_coord end_coord];
    
