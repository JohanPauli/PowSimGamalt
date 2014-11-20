function radiation = readRisoeData( filename, timeAxis )
% readRisoeData reads data from a Risø database file.
% 
% [windSpeed, radiation] readRisoeData( filename, timeAxis ) reads weather
% data from filename, and outputs wind speeds and solar radiation in vector
% format. Outputs are fitted onto timeAxes using 'nearest' interpolation.
% 
% Inputs:
% * filename : data file name.
% * timeAxis : Points in time for which measurements are output.
%              This is in the output format of datenum().
% Outputs:
% * windSpeed : vector containing wind speeds (m/s).
% * radiation : vector containing sun radiation intensities (W/m^2).
    
    %% Initialise delimiter and format string.
    % delimiter is tab
    delimiter = ' ';
    % %s are columns included, %*s are columns excluded.
    formatSpec = '%n%n%n%n%n%*n%n%[^\n\r]';
    
    %% Open the text file 'filename' using fopen().
    fileID = fopen( filename, 'r' );
    
    %% Read columns from file using textscan.
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter ...
                        , 'HeaderLines', 3, 'ReturnOnError', false);
    
    %% Close the text file.
    fclose( fileID );
    
    %% Convert data to numbers, assign to variables.
    % (dtstr2dtnummx has 3x perf increase over datenum)
    time = datenum( dataArray{1}, dataArray{2} ...
                  , dataArray{3}, dataArray{4} ...
                  , dataArray{5}, 0 );
    rad = dataArray{6};
    
    %% Remove duplicate entries.
    [time, I, ~] = unique(time);
    rad = rad(I);
    
    %% Set negative values of radiation to 0.
    rad(rad<0) = 0;
    
    %% Interpolate desired time values from known values, output.
    I = ~isnan(rad);
    radiation = interp1(time(I), rad(I), timeAxis,'nearest','extrap');
    
    %% Show a figure comparing measurements to model.
%     figure;
%     plot(time,rad,'b',timeAxis,radiation,'r');
%     title('Radiation measurements vs. model');
%     xlabel(['Measured mean/std: ' ...
%         , num2str(mean(rad)), '/', num2str(std(rad)) ...
%         , '   Model mean/std: ' ...
%         , num2str(mean(radiation)), '/', num2str(std(radiation))]);
%     legend( 'Measured','Model' );
%     datetick('x','mmm dd','keeplimits','keepticks');
%     
%     % This makes zooming/panning still show dates on ticks.
%     % (It doesn't by default, for some reason.)
%     xlim([min(time(1),timeAxis(1)) max(time(end),timeAxis(end))]);
%     set(zoom(gcf),'ActionPostCallback',@(h,e)(cellfun(@(x)feval(x,h,e) ...
%        , {@(h,e) datetick(ax(1),'x','mmm dd','keeplimits') ...
%        ,  @(h,e) datetick(ax(2),'x','mmm dd','keeplimits')})));
%     set(pan(gcf),'ActionPostCallback',@(h,e)(cellfun(@(x)feval(x,h,e) ...
%        , {@(h,e) datetick(ax(1),'x','mmm dd','keeplimits') ...
%        ,  @(h,e) datetick(ax(2),'x','mmm dd','keeplimits')})));
end