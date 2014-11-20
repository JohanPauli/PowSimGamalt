function [waveH, waveT] = readWaveData( filename, timeAxis )
% readRoadstation reads wave measurement data.
%
% [waveH, waveT] = readWaveData( filename ) reads wave data
% from filename, and outputs wave height and period in vector format.
% The data is interpolated onto timeAxis using 'nearest'.
% Wave height and period are output.
% 
% Inputs:
% * filename : data file name.
% * timeAxis : Points in time for which measurements are output.
%              This is in the output format of datenum().
% Outputs:
% * waveH : vector containing wave heights. (m).
% * waveT : vector containing wave periods. (s).
    
    %% Initialise delimiter and format string.
    % delimiter is tab
    delimiter = ' ';
    % %s are columns included, %*s are columns excluded.
    formatSpec = '%n%n%n%n%n%n%n%[^\n\r]';
    
    %% Open the text file 'filename' using fopen().
    fileID = fopen( filename, 'r' );
    
    %% Read columns from file using textscan.
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter ...
                        , 'HeaderLines', 0, 'ReturnOnError', false);
    
    %% Close the text file.
    fclose( fileID );
    
    %% Convert data to numbers, assign to variables.
    % (dtstr2dtnummx has 3x perf increase over datenum)
    time = datenum( dataArray{1}, dataArray{2}, dataArray{3} ...
                  , dataArray{4}, dataArray{5}, 0 );
    height = dataArray{6};
    period = dataArray{7};
    
    %% Remove duplicate entries.
    [time I ~] = unique(time);
    height = height(I);
    period = period(I);
    
    %% Convert period from Tz to Te.
    B = ( period / 0.751 ).^4;
    A = ( height / 2 ).^2 .* B;
    m0 = 1/4 * A ./ B;
    mNeg1 = 1/4 * A .* B.^(-0.75) * 0.90640;
    period = mNeg1 ./ m0;
    
    %% Interpolate desired time values from known (non NaN) values, output.
    mask = ~isnan(height);
    waveH = interp1(time(mask), height(mask), timeAxis,'nearest','extrap');
    
    mask = ~isnan(period);
    waveT = interp1(time(mask), period(mask), timeAxis,'nearest','extrap');
    
    %% Show a figure comparing measurements to model.
%     figure;
%     ax(1) = subplot(2,1,1);
%     plot(time,height,'b',timeAxis,waveH,'r');
%     title('Wave height measurements vs. model');
%     xlabel(['Measured mean/std: ' ...
%         , num2str(mean(height)), '/', num2str(std(height)) ...
%         , 'Model mean/std: ' ...
%         , num2str(mean(waveH)), '/', num2str(std(waveH))]);
%     legend( 'Measured', 'Model' );
%     datetick('x','mmm dd');
%     
%     ax(2) = subplot(2,1,2);
%     plot(time,period,'b',timeAxis,waveT,'r');
%     title('Wave period measurements vs. model');
%     xlabel(['Measured mean/std: ' ...
%         , num2str(mean(period)), '/', num2str(std(period)) ...
%         , 'Model mean/std: ' ...
%         , num2str(mean(waveT)), '/', num2str(std(waveT))]);
%     legend( 'Measured','Model' );
%     datetick('x','mmm dd');
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