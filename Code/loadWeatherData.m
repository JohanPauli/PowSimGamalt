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
    % Røkt wind data.
    tic
    fPath = ['data/Hogareyn',theYear,'.txt'];
    fprintf( '\tRøkt wind data from %s...', fPath  );
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
    
    % Húsahagi wind data.
    tic
    fPath = ['data/Hogareyn',theYear,'.txt'];
    fprintf( '\tHúsahagi wind data from %s...', fPath  );
    [Weather.Husahagi.windSpeed, ~] = readWindData( fPath, timeAxis );
    Weather.Husahagi.windSpeed = Weather.Husahagi.windSpeed * 0.8;
    fprintf( '\n\t' );toc
    
    %% Rain data.
    % Rain data is the same everywhere.
    tic
    fprintf( '\tFossáverkið data from mean...'  );
    Weather.Fossa.rainInt = readRainData( timeAxis );
    fprintf( '\n\tMýruverkið data from mean...'  );
    Weather.Myru.rainInt = Weather.Fossa.rainInt;
    fprintf( '\n\tHeygaverkið data from mean...'  );
    Weather.Heyga.rainInt = Weather.Fossa.rainInt;
    fprintf( '\n\tEiðisverkið data from mean...'  );
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
    
    % Leir (Leirvíksfjørður) data.
    tic
    fprintf( '\tfrom ''Leir'' (Leirvíksfjørður)...' );
    Weather.Leir.tidalSpeed = readTidalData( 'Leir', timeAxis );
    fprintf( '\n\t' );toc
    
    % Hest (Hestfjørður) data.
    tic
    fprintf( '\tfrom ''Hest'' (Hestfjørður)...' );
    Weather.Hest.tidalSpeed = readTidalData( 'Hest', timeAxis );
    fprintf( '\n\t' );toc
    fprintf( '\n' );
end