function txtCapFac( Sites, Pow, timeAxis )
% txtCapFac shows capacity factors.
% 
% txtTotPow( Pow ) prints text showing the capacity factor for each
% type of renewable energy contained in Pow.
% 
% Input:
% * Sites: a struct containing power unit data for each type of power.
% * Pow: a struct containing fields for each type of power.
% * timeAxis: a vector of the points-in-time for which power is produced.
%             This is in the format output by datenum().

    %% Capacity factors.
    fprintf( '\n' );
    f = fieldnames( Sites );
    for i=1:numel(f)-1
        fprintf( '\n%21s: %6.1f%%' ...
               , ['Capacity factor ',f{i}] ...
               , hfGetCapFactor( Sites.(f{i}) ...
                               , sum(Pow.(f{i}).Total) / 1000 ...
                               , timeAxis ) );
    end
    fprintf( '\n' );
end