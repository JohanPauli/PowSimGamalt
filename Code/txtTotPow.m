function txtTotPow( Pow )
% txtTotPow shows a total production statistics.
% 
% txtTotPow( Pow ) prints text showing the total energy production for each
% type of energy contained in Pow.
% 
% Input:
% * Pow: a struct containing fields for each type of power.

    %% Calculate and print.
    f = fieldnames( Pow );
    fprintf( '\n%21s: %6.1f GWh' ...
           , 'Total production', sum(Pow.Total) / 1000 );
    for i=2:numel(f)
        fprintf( '\n%21s: %6.1f GWh' ...
               , ['Total ',f{i},' energy'] ...
               , sum(Pow.(f{i}).Total) / 1000 );
    end
    fprintf( '\n' );
end