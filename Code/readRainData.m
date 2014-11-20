function rainInt = readRainFromMean( timeAxis )
% generateRain generates 10-minute rain intensity data.
% 
% rainInt = generateRain( timeAxis ) generates rain intensities based on a
% time axis (timeAxis) and mean monthly rain data from 1961-1990. The rain
% data is stored in a vector (rainInt).

    %% The rain data.
    rainSum = [286, 225, 274, 177, 170, 117, 123, 168, 266, 316, 306, 283];
    rainDays = [19, 16, 18, 14, 13, 10, 11, 13, 18, 19, 19, 19 ];
    
    %% Make a month vector from timeAxis.
    [~, MM, DD, ~, ~, ~] = datevec(timeAxis);
    [yr, ~, ~, ~, ~, ~] = datevec(timeAxis(1));
    
    %% Initialise rainInt.
    rainInt = zeros(numel(timeAxis),1);
    
    %% Seed the rng, for some variation.
    rng( 'shuffle' );
    
    %% Distribute the rain within each month.
    for i=1:12
        % The sum of rain to distribute to each day.
        rSum = rainSum(i) / rainDays(i) / 24;
        
        % The days where the rain occurs.
        rDays = randperm( eomday(yr,i), rainDays(i) );
        
        % For each day of rain, distribute rain evenly.
        for j=1:numel(rDays)
            rainInt(MM==i & DD==rDays(j)) ...
                = rainInt(MM==i & DD==rDays(j)) + rSum;
        end
    end
end