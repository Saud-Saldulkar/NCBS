function feed_time_datapoints = feed_time_datapoints(total_datapoints, feed_time_sec) 
   % dependency file for [remove_feed_data.m]

   datapoints_per_sec = total_datapoints/180;
   feed_time_datapoints = round(feed_time_sec * datapoints_per_sec);  
end