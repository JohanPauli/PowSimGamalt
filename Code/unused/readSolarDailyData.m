function insolation = readSolarData( filename, timeAxis )
% readSolarData reads insolation data from a file.
% 
% readSolarData( filename, timeAxis ) reads ...
% 
% Inputs:
% * filename: the file to be read (string).
% * timeAxis: the points-in-time to be sampled.
    
    % Set up file format.
    delimiter = ',';
    formatSpec = '%n%n%n%n%[^\n\r]';
    
    %% Open the file
    fileID = fopen( filename, 'r' );
    
    %% Read the file into cell array.
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter ...
                        , 'HeaderLines', 1, 'ReturnOnError', false);
    
    %% Close the file.
    fclose( fileID );
    
    %% Convert data to numbers, assign to variables.
    time = datenum( dataArray{3}, dataArray{1}, dataArray{2} );
    inso = dataArray{4};
    
    %% Remove duplicates.
    [time, I, ~] = unique( time );
    inso = inso(I);
    
    %% Interpolate the data onto timeAxis.
    insolation = interp1( time, inso, timeAxis, 'linear', 'extrap' );
end