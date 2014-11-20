% GreenPower is a script for simulating the production in a power grid.
% 
% The actions performed by the script are:
% 1. Load weather data and default production site parameters.
% 2. Get input for changes to production site parameters.
% 3. Calculate production from given parameters.
% 4. Show text and plots of the calculation outputs.
% 5. Repeat from step 2. or exit.


%% Load data into workspace.
fprintf( '\n**************************************************\n' );
fprintf( '    DATA LOADING\n\n' );

% Check if data already is loaded.
% If it is, and user doesn't want a reload, skip loading.
c = true;
if exist( 'Weather', 'var' )
    c = hfGetChoice( 'Data seems to be loaded already, reload?' );
end
if c
    % Clear everything loaded here to reset structs.
    clear timeAxis SEV Sites Weather Pow;

    % Create time axis.
    timeAxis = loadTimeAxis();

    % Read weather data into weather sites.
    Weather = loadWeatherData( timeAxis );

    % Load power requirements.
    tic
    SEV = loadSEVData( timeAxis );

    % Load the production unit data.
    % Units are distributed into sites.
    tic
    fprintf( 'Loading default site data...\n' );
    Sites = makeDefaultSites();
    toc,fprintf( '\n' );
end
clear c;

%% PROGRAM LOOP.
while 1
    %% Get user input for simulation.
    fprintf( '\n**************************************************\n' );
    fprintf( '    SIMULATION SETTINGS\n\n' );
    Sites = changeSitesSettings( Sites );

    %% Run simulation functions (order: wind > tidal > ... > fossil).
    fprintf( '\n**************************************************\n' );
    fprintf( '    PRODUCTION CALCULATION\n\n' );
    Pow = calcPow( Sites, Weather, SEV, timeAxis );

    %% Show simulation results
    fprintf( '\n**************************************************\n' );
    fprintf( '    SHOWING SIMULATION RESULTS\n' );
    % Text of total production.
    txtTotPow( Pow );

    % Text of relative (%) production.
    txtRelPow( Pow );

    % Text showing capacity factors.
    txtCapFac( Sites, Pow, timeAxis );
    fprintf( '\n' );

    % In graph form if requested.
    if hfGetChoice( 'Show figures for simulation?' );
        tic, fprintf( 'Showing figures...\n' );
        figPowDist( SEV, timeAxis );
        figPowDist( Pow, timeAxis );
        figPowDistMonthly( SEV, timeAxis );
        figPowDistMonthly( Pow, timeAxis );
        figHydro( Pow, timeAxis );
        toc;
    end

    fprintf( '\n' );

    %% Start again/stop simulating.
    fprintf( '\n**************************************************\n\n' );
    if ~hfGetChoice( 'Repeat simulation?' )
        break;
    end
end
fprintf( '\n' );
clear c;