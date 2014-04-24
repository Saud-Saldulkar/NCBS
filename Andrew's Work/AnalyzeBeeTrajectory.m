function [result] = AnalyzeBeeTrajectory(datafilename, fmffilename, target, radius, random_walk, do_plot, debug)

    % Default values
    if (nargin < 7)
        random_walk = 0;
    end
    if (nargin < 6)
        do_plot = 0;
    end
    if (nargin < 5)
        debug = 0;
    end
   
    % Declare global variables
    global intersection_length between_intersection_length;
    global max_distance;
    global walkX walkY distance_traveled
    global valid_intersection_occurred;
    global bee_on_target start_frame;
	
    % Set initial values of global variables
    intersection_length = 0;
    between_intersection_length = 0;
    max_distance = -inf;
    valid_intersection_occurred = 0;
    distance_traveled = 0;
    bee_on_target = 0;
    start_frame = -1;
    walkX = [];
    walkY = [];
    walkX_curvature = [];
    walkY_curvature = [];
    interval = 100;
    
	% Create empty struct to start
	result = struct;	
	
	% Frame for each intersection
    result.intersection_frames = [];
    % Duration for each intersection
	result.duration_intersection_frames = [];
	
	% Between intersection data (frames, euclidean distance, distance, area)
    result.between_intersection_frames = [];
    result.between_intersection_edistance = [];
    result.between_intersection_distance = [];
    result.between_intersection_area = [];
    
    % Variables measured every interval
    result.speed = [];
    result.turning = [];
    result.curvature = [];
    result.interval_frames = [];
    result.valid = 0;
    result.type = 'undefined';
 
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
    
    % If the target is not defined, we use the bee head as the target
    if (isempty(target))
        target = GetBeeHead(data.x_pos(1), data.y_pos(1), data.angle(1), data.maj_ax(1), data.min_ax(1), 0);
        target
    end
    
    % Get the points for the circle around the target
    increment = 0.01;
    circle_points = zeros(length(0:increment:2*pi), 2);
    angle = 0;
    for j=1:length(0:increment:2*pi)
        circle(j, 1) = radius*sin(angle) + target(1);
        circle(j, 2) = radius*cos(angle) + target(2);
        angle = angle + increment;
    end     
    
	% Now we have verified that the files are properly analyzed and have the correct number of frames.  Now we can
	% step through each frame
    for f=f_start:f_end
         
        % Only if the user requests plotting
        if (do_plot)
        
            % Get the data for this frame 
            frame = fmf_read_frame(fp, h, w, frame_size, data_format); 

            % Plot the frame
            PlotFrame(f,frame, do_plot);

            % Plot the target circle
            PlotTarget(target, circle, do_plot);
        
        end
        
        % Plot the bee
        %PlotEllipse(data.x_pos(f),data.y_pos(f),data.angle(f),data.maj_ax(f),data.min_ax(f));
        head = GetBeeHead(data.x_pos(f), data.y_pos(f), data.angle(f), data.maj_ax(f), data.min_ax(f), do_plot);
        
        % If the bee starts on the target, we wait until she leaves and
        % mark that as a valid start frame.  If the bee does not start on
        % the target, we count every event to the end
        
        % Record the walking path of the bee
        walkX(end+1) = data.x_pos(f);
        walkY(end+1) = data.y_pos(f);
        walkX_curvature(end+1) = data.x_pos(f);
        walkY_curvature(end+1) = data.y_pos(f);        
                
        % Calculate the max Euclidean distance
        CalculateEuclideanDistance(target); 
        
        % Calculate the distance traveled
        CalculateDistanceTraveled();
        
        % Calculate the start frame
        CheckBeeOnTarget(2*radius, f);
        
        % Measure the interval variables
        if (mod(f, interval) == 0)
                % Calculate the curvature of the path
                %[curve, turn_preference] = CalculateCurvature(walkX_curvature, walkY_curvature);
                curve = 1;
                turn_preference = 1;
                result.interval_frames(end+1) = f;
                result.curvature(end+1) = curve;
                result.turning(end+1) = turn_preference; 
                result.speed(end+1) = distance_traveled / interval;  
                walkX_curvature = [];
                walkY_curvature = [];
        end
        
        % Now check for intersection 
        if(IsIntersection(target, head, radius, debug))
                        
            % Record the between intersection length and reset it
            if (IsValidPath(2*radius))
                
                % Record the number of frames elapsed during the path
                result.between_intersection_frames(end+1) = between_intersection_length;
                result.intersection_frames(end+1) = f;
                                                
                % Estimate the area covered using convex hull
                result.between_intersection_area(end+1) = CalculateArea(do_plot);
                
                % Save the euclidean distance
                result.between_intersection_edistance(end+1) = max_distance;
                
                % Save the walking distance
                result.between_intersection_distance(end+1) = distance_traveled;
                            
                % Plot the path
                PlotPath(do_plot);
                PlotEuclideanDistance(do_plot);
                
                % Report path stats
                if debug
                    fprintf('FRAME: %d Between Intersection length: %d Distance: %.3f Speed: %.3f EDistance: %.3f Curvature: %.3f Area: %.3f\n', ...
                        result.intersection_frames(end), ...
                        result.between_intersection_frames(end), result.between_intersection_distance(end), ...
                        1, 1, 1, 1);
                        %result.speed(end), result.between_intersection_edistance(end), ...
                        % result.curvature(end), result.between_intersection_area(end));
                end
                               
                % Pause for a second
                valid_intersection_occurred = 1;
                
                if (do_plot)
                    pause(0.1);
                end;
            end
            
            % Clear the walking path
            between_intersection_length = 0;
            distance_traveled = 0;
            max_distance = -inf;
            walkX = [];
            walkY = [];            
            
        else
            
            % Record the intersection length and reset it
            if (IsValidIntersection())
                valid_intersection_occurred = 0;
                result.duration_intersection_frames(end+1) = intersection_length;
                if debug
                    fprintf('Intersection length: %d\n', intersection_length);
                end
            end
            intersection_length=0;
            between_intersection_length = between_intersection_length + 1;
            
            if (do_plot)
                % Plot the path
                PlotPath(do_plot);
            end
        end     
        
        % Allow drawing to complete
        if (do_plot)
            pause(1e-3);
            hold off
        end
    end
    
    % At the very end, we check to see if the bee terminated on the intersection
    if (IsValidIntersection())
        fprintf('Bee terminated on intersection\n');
        valid_intersection_occurred = 0;
        result.duration_intersection_frames(end+1) = intersection_length;
        if debug
            fprintf('Intersection length: %d\n', intersection_length);
        end
    end 


     
    % Close the file and add the valid field
    fclose(fp);    
    result.start = f_start;
    
    % If this is a random walk, we do not care whether or not the bee starts
    % on the target or not
    if (random_walk == 1) && (bee_on_target == 0)
        fprintf('Random walk, so ignoring start of bee\n');
        result.valid = 1;
        result.type = 'randomwalk_off';
    elseif (random_walk == 1) && (bee_on_target == 1)
        fprintf('Random walk, so ignoring start of bee\n');
        result.valid = 1;
        result.type = 'randomwalk_on';        
    % If the bee did not start on the target, erase the first
    % between_intersection_time point
    elseif (random_walk == 0) && (bee_on_target == 0)
        fprintf('Bee started off target');
        result.valid = 1;   
        result.type = 'treatment_off';
    % If the bee started on the target, erase the first intersection_frames
    elseif (random_walk == 0) && (bee_on_target == 1)
        fprintf('Bee started on target\n');
        result.valid = 1;  
        result.type = 'treatment_on';
    end

  
function CheckBeeOnTarget(radius, f)
% Check to see if the bee is on the target
    global max_distance bee_on_target start_frame
    
    % If the bee starts on the target
    if (max_distance < radius) && (f==1)
       bee_on_target = 1; 
       fprintf('Bee started on target\n');
    end
    
    if (max_distance > radius) && (start_frame==-1) && (bee_on_target)
        start_frame = f;
        fprintf('Bee started on target and left at frame %d\n', start_frame);
    end

    
function valid = IsValidPath(radius)
% Check to see if the path is valid
    global walkX walkY between_intersection_length max_distance
    valid = 1;
    
    % Check to make sure the between intersection length is significant
    if (between_intersection_length<1)
        valid = 0;
    end
    
    % Make sure we have enough points for a convex hull calculation
    if (length(unique(walkX))<3) || (length(unique(walkY))<3)
        valid = 0;
    end
    
    % Make sure we have traveled some distance away from the spot
    if (max_distance < radius)
        valid = 0;
    end    
    
function valid = IsValidIntersection()
% Check to see if a valid intersection occurred
    global intersection_length valid_intersection_occurred
    valid = 1;
    if (intersection_length<1)
        valid = 0;
    end
    if (valid_intersection_occurred==0)
        valid = 0;
    end
    
function CalculateDistanceTraveled()
% Calculate the distance traveled
    global walkX walkY distance_traveled
    if (length(walkX)>1)
        distance_traveled = distance_traveled + sqrt((walkX(end)-walkX(end-1))*(walkX(end)-walkX(end-1)) + ...
                                                    (walkY(end)-walkY(end-1))*(walkY(end)-walkY(end-1)));
    end           
                                                
function CalculateEuclideanDistance(target)
% Calculate the maximum distance traveled from the target
    global walkX walkY maxX maxY max_distance
    distance_to_target = sqrt((walkX(end)-target(1))*(walkX(end)-target(1)) + ...
                              (walkY(end)-target(2))*(walkY(end)-target(2)));
    if (distance_to_target > max_distance)
        max_distance = distance_to_target; 
        maxX = walkX(end);
        maxY = walkY(end);
    end
      
function area = CalculateArea(do_plot)     
% Estimate the area covered by the bee 
    global walkX walkY;
    vi = convhull(walkX,walkY);
    area = polyarea(walkX(vi),walkY(vi));    
    if (do_plot)
        plot(walkX(vi),walkY(vi),'r-', 'LineWidth', 2);       
    end
    
function [curve, turn_preference] = CalculateCurvature(walkX_curvature, walkY_curvature)
% Calculate the average curvature of the path taken by the bee
    %global walkX walkY;
    
    kappa = curvature(walkX_curvature', walkY_curvature', 'polynom', 10);
    curve = mean(abs(kappa));
    turn_preference = sum(kappa);
    
function [does_intersect] = IsIntersection(origin, position, epsilon, debug)

    global intersection_length;
    if (nargin<4)
        debug=0;
    end

    % Get distance between origin and frame
    radius = sqrt((origin(2)-position(2))*(origin(2)-position(2)) + (origin(1)-position(1))*(origin(1)-position(1)));
    does_intersect = 0;
    if (radius < epsilon)
        does_intersect = 1;
        intersection_length = intersection_length+1;
    end
    if (does_intersect && debug)
        %fprintf('Intersection [%.3f %.3f]\n', position(1), position(2));
    end
   
function PlotTarget(target_position, circle_points, do_plot)
    %plot(target_position(1),target_position(2),'g*');
    if (do_plot)
        plot(circle_points(:,1), circle_points(:,2), 'g');
    end
    
function PlotEllipse(x_pos, y_pos, angle, maj_ax, min_ax, do_plot)
    if (do_plot)
        drawfly_ellipse(x_pos,y_pos, angle, maj_ax, min_ax);       
    end
    
function PlotEuclideanDistance(do_plot)
    global maxX maxY
    if(do_plot)
        plot(maxX, maxY, 'b*');    
    end
    
function [head_position] = GetBeeHead(x, y, theta, maj, min, do_plot)

    % Adjust the major axis, otherwise it is in front of the bee's head
    %maj = maj-0.25;
    
    % isosceles triangle not yet rotated or centered
    pts = [-maj*2,-min*2
           -maj*2,min*2
           maj*2,0];

    % rotate
    costheta = cos(theta);
    sintheta = sin(theta);
    R = [costheta,sintheta;-sintheta,costheta];
    pts = pts*R;

    % translate
    pts(:,1) = pts(:,1) + x;
    pts(:,2) = pts(:,2) + y;
    head_position = [pts(3,1); pts(3,2)];    
    
    % plot a triangle on the bee's body (off)
    %  if (doPlot)
    %      patch(pts([1:3,1],1),pts([1:3,1],2),'b');
    %  end
    if (do_plot)
        plot(head_position(1), head_position(2), 'r.');
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
            image(frame)  
            hold on;
        end   
    end
%       
% function [curv, r, a, b] = GetCurvature(x, y)
%     
%      mx = mean(x); my = mean(y);
%      X = x - mx; Y = y - my; % Get differences from means
%      dx2 = mean(X.^2); dy2 = mean(Y.^2); % Get variances
%      t = [X,Y]\(X.^2-dx2+Y.^2-dy2)/2; % Solve least mean squares problem
%      a0 = t(1); b0 = t(2); % t is the 2 x 1 solution array [a0;b0]
%      r = sqrt(dx2+dy2+a0^2+b0^2); % Calculate the radius
%      a = a0 + mx; b = b0 + my; % Locate the circle's center
%      curv = 1/r; % Get the curvature
% 
% 	
% 	
% 	
% 
% 	function [is_curve] = IsCurve(cutoff)
% 
%     % Get global curvature points
%     global curvatureX curvatureY on_curve
%     is_curve = 0;
%     
%     if (length(curvatureX)<20)
%         return;
%     end
%     
%     % Calculate the curvature of this set of points
%     kappa = curvature(curvatureX', curvatureY', 'polynom', 6);
%     
%     % Convert the kappa to binary
%     kappaB = (abs(kappa)>cutoff);
%     
%     kappa
%     
%     % Find the continuous regions of curvature
%     runs = contiguous(kappaB,1);
%     if (isempty(runs))
%         return;
%     end
%     
%     indices = cell2mat(runs(2));
%     found_curve = 0;
%     % Plot these indices
%     
%     if (size(indices,1)<2)
%         return;
%     end
%     
%     for j=1:size(indices,1)
%               
%         fprintf('Found curve from [%d to %d]\n', indices(j,1),indices(j,2));
%         plot(curvatureX(indices(j,1):indices(j,2)), curvatureY(indices(j,1):indices(j,2)), 'r');
%         pause(1);
%         found_curve = 1;
%            
%     end   
% 
%     %Erase these points
%     if (found_curve)
%         max_index = max(indices(:));
%         curvatureX(1:max_index) = [];
%         curvatureY(1:max_index) = [];
%     end
% 	
