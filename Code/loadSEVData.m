function SEV = loadSEVData( timeAxis )
% loadSEVData loads SEV data for a period.
% 
% SEV = loadSEVData( timeAxis ) reads SEV data, made to fit to each point
% of timeAxis. If the timeAxis is after the period 2009-2012, the data will
% be extrapolated in a chosen manner, and only the total will be included.
% 
% Input:
% * timeAxis: vector of points-in-time to load data for.
%             In the format output by datenum().
% Output:
% * SEV: a struct containing power demand for the timeAxis period.

    %% Extract the year from timeAxis.
    [theYear, ~, ~, ~, ~, ~] = datevec(timeAxis(1));
    
    %% Read or extrapolate SEV data from timeAxis.
    if theYear <= 2012
        %% If the timeAxis is in [2009..2012], just load.
        fprintf( 'Loading power requirements for time axis...\n' );
        SEV = readSEVData( ['data/SEV',num2str(theYear),'.txt'] ...
                         , timeAxis );
        toc,fprintf( '\n' );
    else
        %% Otherwise, extrapolate.
        error( 'years after 2012 aren''t implemented' );
        % TODO: Do stuff.
    end
end