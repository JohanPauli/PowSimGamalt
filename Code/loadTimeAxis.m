function timeAxis = loadTimeAxis()
% loadTimeAxis loads the time axis to use for the sim.
% 
% timeAxis = loadTimeAxis() prompts for the years to be simulated by the
% program, and makes a time axis based on it.
% 
% Output:
% * timeAxis: a vector containing points-in-time to be simulated.
%             This is in the format output by datenum().

    %% Prompt for the years to load.
    msg = 'Which year should be simulated? [yyyy]: ';
    in = floor( str2double( input( msg, 's' ) ) );
    while isnan(in)
        fprintf( 'Invalid input, try again.\n' );
        in = floor( str2double( input( msg, 's' ) ) );
    end
    
    %% Make a time axis.
    timeAxis = ( datenum( in, 1, 1 ) ...
               : 1/24/6 ...
               : datenum( in + 1, 1, 1 ) )';
	timeAxis = timeAxis(1:end-1);
    
    fprintf( 'done\n\n' );
end