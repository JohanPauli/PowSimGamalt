function Weather = loadWeatherData( timeAxis )
% loadWeatherData loads the weather data for the sim.
% 
% Weather = loadWeatherData( timeAxis ) loads the weather data for
% each power production site, based on a time axis, into the Weather
% struct.
% 
% Input:
% * timeAxis: vector of points-in-time to load data for.
%             In the format output by datenum().
% 
% Output:
% * Weather: a struct containing a field for each site at which weather
%            data is present.

    %% Announce this is happening.
    fprintf( 'Loading weather data...\n' );
    
    %% The year is...
    [theYear, ~, ~, ~, ~, ~] = datevec( timeAxis(1) );
    theYear = num2str( theYear );
    
    %% Wind data.
    % R�kt wind data.
    tic
    fPath = ['data/Hogareyn',theYear,'.txt'];
    fprintf( '\tR�kt wind data from %s...', fPath  );
    [Weather.Rokt.windSpeed, ~] = readWindData( fPath, timeAxis );
    Weather.Rokt.windSpeed = Weather.Rokt.windSpeed * 0.765;
    fprintf( '\n\t' );toc
    
    % Neshagi wind data.
    tic
    fPath = ['data/Hogareyn',theYear,'.txt'];
    fprintf( '\tNeshagi wind data from %s...', fPath  );
    [Weather.Neshagi.windSpeed, ~] = readWindData( fPath, timeAxis );
    Weather.Neshagi.windSpeed = Weather.Neshagi.windSpeed * 0.76;
    fprintf( '\n\t' );toc
    
    % H�sahagi wind data.
    tic
    fPath = ['data/Hogareyn',theYear,'.txt'];
    fprintf( '\tH�sahagi wind data from %s...', fPath  );
    [Weather.Husahagi.windSpeed, ~] = readWindData( fPath, timeAxis );
    Weather.Husahagi.windSpeed = Weather.Husahagi.windSpeed * 0.8;
    fprintf( '\n\t' );toc
    
    %% Rain data.
    % Rain data is the same everywhere.
    tic
    fprintf( '\tFoss�verki� data from mean...'  );
    Weather.Fossa.rainInt = readRainData( timeAxis );
    fprintf( '\n\tM�ruverki� data from mean...'  );
    Weather.Myru.rainInt = Weather.Fossa.rainInt;
    fprintf( '\n\tHeygaverki� data from mean...'  );
    Weather.Heyga.rainInt = Weather.Fossa.rainInt;
    fprintf( '\n\tEi�isverki� data from mean...'  );
    Weather.Eidi.rainInt = Weather.Fossa.rainInt;
    fprintf( '\n\tStrond data from mean...'  );
    Weather.Strond.rainInt = Weather.Fossa.rainInt;
    fprintf( '\n\t' );toc
    
    %% Solar data.
    % Koltur data.
    tic
    fPath = ['data/Koltur',theYear,'.txt'];
    fprintf( '\tfrom %s...', fPath );
    Weather.Koltur.sunRad = readSolarData( fPath, timeAxis );
    fprintf( '\n\t' );toc
    
    %% Wave data.
    % Eystanfyri data.
    tic
    fPath = ['data/Eystanfyri',theYear,'.txt'];
    fprintf( '\tfrom %s...', fPath );
    [Weather.Eystanfyri.waveH, Weather.Eystanfyri.waveT] ...
        = readWaveData( fPath, timeAxis );
    fprintf( '\n\t' );toc
    
    %% Tidal data.
    % Vest (Vestmannasund) data.
    tic
    fprintf( '\tfrom ''Vest'' (Vestmannasund)...' );
    Weather.Vest.tidalSpeed = readTidalData( 'Vest', timeAxis );
    fprintf( '\n\t' );toc
    
    % Leir (Leirv�ksfj�r�ur) data.
    tic
    fprintf( '\tfrom ''Leir'' (Leirv�ksfj�r�ur)...' );
    Weather.Leir.tidalSpeed = readTidalData( 'Leir', timeAxis );
    fprintf( '\n\t' );toc
    
    % Hest (Hestfj�r�ur) data.
    tic
    fprintf( '\tfrom ''Hest'' (Hestfj�r�ur)...' );
    Weather.Hest.tidalSpeed = readTidalData( 'Hest', timeAxis );
    fprintf( '\n\t' );toc
    fprintf( '\n' );
end