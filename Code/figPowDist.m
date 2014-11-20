function figPowDist( Pow, timeAxis )
% figPowDist makes a power distribution plot.
% 
% figPowDist( Pow ) makes an area plot of each type of production held in
% the production info struct (Pow).
% 
% Input:
% * Pow: a struct containing power production data.
% * timeAxis: vector of points-in-time for which the sim does calculations.
%             This is in the format output by datenum().

    %% Make a figure with the structs info.
    figure
    f = fieldnames( Pow );
    s = zeros( numel(timeAxis), numel(f)-1 );
    for i=2:numel(f)
        s(:,i-1) = Pow.(f{i}).Total;
    end
    area( timeAxis, s, 'LineStyle', 'none' );
    title( 'Production distribution' );
    legend( f{2:end} );
    datetick( 'x', 'mmm dd', 'keeplimits', 'keepticks' );
    xlim( [timeAxis(1),timeAxis(end)] );
end