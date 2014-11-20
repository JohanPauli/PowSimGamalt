function sunRad = readHavstovaData( filename, timeAxis )
% readHavstovaData reads solar irradiation data from Havstovan.
% 
% ...

    %% Open the files
    fileID = fopen( filename );
    
    %% Read the data.
    dataArray = textscan( fileID, '%n%n%[^\r\n]', 'HeaderLines', 3 ...
        , 'ReturnOnError', false );
    
    %% Close the file.
    fclose( fileID );
    
    %% Convert data into meaningful formats.
    time = datenum(2003,1,1) + dataArray{1};
    rad = dataArray{2} / 4.566 / 0.43;
    
    %% Interpolate rad onto timeAxis.
    sunRad = interp1( time, rad, timeAxis, 'nearest', 'extrap' );
end