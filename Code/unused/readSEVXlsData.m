function powReq = readSEVData( filename, timeAxis )
% readSEVData reads SEV production data.
% 
% powReq = readSEVData( filename, timeAxis ) reads production data from
% a file (filename), and outputs production data (powReq).
% Outputs only as many values as there are elements in the time axis
% (timeAxis), where missing data is interpolated using 'linear', and if
% the read data exceeds the number of elements in the time axis, they are
% averaged accordingly.
% 
% Inputs:
% * filename : data file name.
% * timeAxis : Points in time for which measurements are output.
%              This is in the output format of datenum().
% Outputs:
% * powReq: vector of grid power requirements in the form of SEV production
%           data, one point for each in timeAxis.

    %% Open the file.
    fileID = fopen( filename, 'r' );
    
    %% Read the file in to cell array.
    dataArray = textscan( fileID, '%n%n%n%n%n%n%[^\n\r]', 'Delimiter', ' ' ...
                        , 'HeaderLines', 1, 'ReturnOnError', false);
    
	%% Close the file.
    fclose( fileID );
    
    %% Convert contents of dataArray to numbers.
    time = datenum( dataArray{3}, dataArray{2}, dataArray{1} ...
                  , dataArray{4}, dataArray{5}, 0 );
    pows = dataArray{6};
    
    %% Interpolate or average time values onto timeAxis.
    if time(2) - time(1) < timeAxis(2) - timeAxis(1)
        k = round( (timeAxis(2) - timeAxis(1)) / (time(2) - time(1)) );
        avgTimes = knnsearch( time, timeAxis, 'K', int32(k) );
        avgPows = zeros(numel(timeAxis),int32(k));
        for i=1:k
            avgPows(:,i) = pows(avgTimes(:,i));
        end
        powReq = mean( avgPows, 2 ) * (timeAxis(2) - timeAxis(1)) * 24;
    else
        powReq = interp1( time, pows, timeAxis, 'linear' );
    end
end