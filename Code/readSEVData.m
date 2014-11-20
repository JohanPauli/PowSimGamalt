function SEV = readSEVData( filename, timeAxis )
% readSEVData reads SEV data.
% 
% SEV = readSEVData( filename, timeAxis ) reads a file (filename)
% containing SEV production data, and outputs an object holding each type
% and production and its location. The output is ordered such that it fits
% a given time axis (timeAxis).
% 
% Inputs:
% * filename : data file name.
% * timeAxis : Points in time for which measurements are output.
%              This is in the output format of datenum().
% 
% Output:
% SEV: an object containing production data for each SEV production site.

    %% Open the file
    fileID = fopen( filename );
    
    %% Read the file contents.
    dataArray = textscan( fileID, '%n%n%n%n%n%n%n%n%n%n%n%[^\r\n]' ...
                        , 'Delimiter', ' ', 'ReturnOnError', false );
    
    %% Close the file.
    fclose( fileID );
    
    %% Get the data into containers.
    time = dataArray{1};
    total = dataArray{2};
    hFossa = dataArray{3};
    hMyru = dataArray{4};
    hHeyga = dataArray{5};
    hEidi = dataArray{6};
    hStrond = dataArray{7};
    dStrond = dataArray{8};
    dSund = dataArray{9};
    wRokt = dataArray{10};
    wNeshagi = dataArray{11};
    
    %% Replace negative values (uses power) with 0.
    total(total<0) = 0;
    hFossa(hFossa<0) = 0;
    hMyru(hMyru<0) = 0;
    hHeyga(hHeyga<0) = 0;
    hEidi(hEidi<0) = 0;
    hStrond(hStrond<0) = 0;
    dStrond(dStrond<0) = 0;
    dSund(dSund<0) = 0;
    wRokt(wRokt<0) = 0;
    wNeshagi(wNeshagi<0) = 0;
    
    %% Interpolate or average time values onto timeAxis.
    if time(2) - time(1) < timeAxis(2) - timeAxis(1)
        k = round( (timeAxis(2) - timeAxis(1)) / (time(2) - time(1)) );
        method = @(x) interp1( time, smooth(x,k,'moving') ...
            , timeAxis, 'linear', 'extrap' ) ...
            * (timeAxis(2) - timeAxis(1)) * 24;
    else
        method = @(x) interp1( time, x, timeAxis, 'linear', 'extrap' ) ...
            * (timeAxis(2) - timeAxis(1)) * 24;
    end
    
    %% Apply method to data to get useful data.
    SEV.Total = method( total );
    SEV.Wind.Rokt = method( wRokt );
    SEV.Wind.Neshagi = method( wNeshagi );
    SEV.Wind.Total = SEV.Wind.Rokt + SEV.Wind.Neshagi;
    SEV.Hydro.Fossa = method( hFossa );
    SEV.Hydro.Myru = method( hMyru );
    SEV.Hydro.Heyga = method( hHeyga );
    SEV.Hydro.Eidi = method( hEidi );
    SEV.Hydro.Strond = method( hStrond );
    SEV.Hydro.Total = SEV.Hydro.Fossa + SEV.Hydro.Myru ...
                    + SEV.Hydro.Heyga + SEV.Hydro.Eidi + SEV.Hydro.Strond;
    SEV.Fossil.Strond = method( dStrond );
    SEV.Fossil.Sund = method( dSund );
    SEV.Fossil.Total = SEV.Fossil.Strond + SEV.Fossil.Sund;
end