function figPowDistMonthly( Pow, timeAxis )
% figPowDistMonthly shows monthly power distribution.
% 
% figPowDistMonthly( Pow, timeAxis ) shows a figure cotaining a stacked bar
% graph of monthly power distribution based on power statistics (Pow) and
% a time axis (timeAxis).
% 
% Inputs:
% * Pow: a struct containing power data.
% * timeAxis: vector with points-in-time at which simulation is done.
%             This is in the format output by datenum().

    %% Show the figure.
    figure;
    [~,MM,~,~,~,~] = datevec( timeAxis );
    f = fieldnames( Pow );
    meanPows = zeros( 12,numel(f)-1 );
    for i=1:12
        for j=2:numel(f)
            meanPows(i,j) = mean(Pow.(f{j}).Total(MM==i));
        end
    end
    [theYear, ~, ~, ~, ~, ~] = datevec(timeAxis(1));
    theYear = num2str( theYear );
    bar( datenum(str2double(theYear),1:12,1)' ...
        , meanPows ...
        , 'stacked' );
    title( 'Monthly production distribution' );
    datetick( 'x', 'mmm', 'keeplimits' );
    legend( f );
end