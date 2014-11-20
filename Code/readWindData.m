function [windSpeed, rainInt] = readRoadstationData( filename, timeAxis )
% readRoadstation reads weatherstation data.
% 
% [windSpeed, rainInt] = readRoadstationData( filename, timeAxis ) reads 
% weather data from filename, and outputs wind speeds and rain intensities
% in vector format.
% Outputs only as many values as there are elements in timeAxis, where
% missing data is interpolated using 'nearest'.
%
% Inputs:
% * filename : data file name.
% * timeAxis : Points in time for which measurements are output.
%              This is in the output format of datenum().
% Outputs:
% * windSpeed : vector containing wind speeds (m/s).
% * rainInt : vector containing rain intensities (mm/h).
    
    %% Initialise delimiter and format string.
    % delimiter is tab
    delimiter = ' ';
    % %s are columns included, %*s are columns excluded.
    formatSpec = '%n%n%n%n%n%n%n%*s%*s%*s%*s%*s%*s%*s%*s%*s%n%[^\n\r]';
    
    %% Open the text file 'filename' using fopen().
    fileID = fopen( filename, 'r' );
    
    %% Read columns from file using textscan.
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter ...
                        , 'HeaderLines', 0, 'ReturnOnError', false);
    
    %% Close the text file.
    fclose( fileID );
    
    %% Convert data from strings to numbers.
    % (dtstr2dtnummx has 3x perf increase over datenum)
    time = datenum( dataArray{1}, dataArray{2}, dataArray{3} ...
                  , dataArray{4}, dataArray{5}, dataArray{6} );
    wind = dataArray{7};
    rain = dataArray{8};
    
    %% Remove duplicate entries.
    [time, I, ~] = unique(time);
    wind = wind(I);
    rain = rain(I);
    
    %% Interpolate desired time values from known (non NaN) values, output.
    I = ~isnan(wind);
    windSpeed = interp1(time(I), wind(I), timeAxis,'nearest','extrap');
    
    I = ~isnan(rain);
    rainInt = interp1(time(I), rain(I), timeAxis,'nearest','extrap');
    
    %% Remove NaN from wind/rain.
    mask = ~isnan(wind);
    windTime = time(mask);
    wind = wind(mask);
    mask = ~isnan(rain);
    rainTime = time(mask);
    rain = rain(mask);
    
    %% Show a figure comparing measurements to model.
%     figure;
%     ax(1) = subplot(2,1,1);
%     plot(windTime,wind,'b',timeAxis,windSpeed,'r');
%     title('Wind speed measurements vs. model');
%     xlabel(['Measured mean/std: ' ...
%         , num2str(mean(wind)), '/', num2str(std(wind)) ...
%         , '    Model mean/std: ' ...
%         , num2str(mean(windSpeed)), '/', num2str(std(windSpeed))]);
%     legend( 'Measured', 'Model' );
%     datetick('x','mmm dd','keeplimits','keepticks');
%     
%     ax(2) = subplot(2,1,2);
%     plot(rainTime,rain,'b',timeAxis,rainInt,'r');
%     title('Rain measurements vs. model');
%     xlabel(['Measured mean/std: ' ...
%         , num2str(mean(rain)), '/', num2str(std(rain)) ...
%         , '    Model mean/std: ' ...
%         , num2str(mean(rainInt)), '/', num2str(std(rainInt))]);
%     legend( 'Measured','Model' );
%     datetick('x','mmm dd','keeplimits','keepticks');
%     
%     % This makes zooming/panning still show dates on ticks.
%     % (It doesn't by default, for some reason.)
%     linkaxes(ax,'x');
%     xlim([min(time(1),timeAxis(1)) max(time(end),timeAxis(end))]);
%     set(zoom(gcf),'ActionPostCallback',@(h,e)(cellfun(@(x)feval(x,h,e) ...
%        , {@(h,e) datetick(ax(1),'x','mmm dd','keeplimits') ...
%        ,  @(h,e) datetick(ax(2),'x','mmm dd','keeplimits')})));
%     set(pan(gcf),'ActionPostCallback',@(h,e)(cellfun(@(x)feval(x,h,e) ...
%        , {@(h,e) datetick(ax(1),'x','mmm dd','keeplimits') ...
%        ,  @(h,e) datetick(ax(2),'x','mmm dd','keeplimits')})));
end