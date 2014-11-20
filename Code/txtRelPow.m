function txtRelPow( Pow )
% txtTotPow shows a relative production statistics.
% 
% txtTotPow( Pow ) prints text showing the energy production for each
% type of energy contained in Pow, relative to total production.
% 
% Input:
% * Pow: a struct containing fields for each type of power.

    %% Calculate and show
    f = fieldnames( Pow );
    totalPow = sum(Pow.Total) / 1000;
    for i=2:numel(f)
        fprintf( '\n%21s: %6.1f%%' ...
               , ['Percent ',f{i},' energy'] ...
               , sum(Pow.(f{i}).Total) / 1000 / totalPow * 100 );
    end
    fprintf( '\n' );
end