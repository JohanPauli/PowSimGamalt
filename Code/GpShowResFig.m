 
    
    
    % Show rainfall and hydropower production.
    figure
    ax(1) = subplot(2,1,1);
    title( 'Hydropower production' )
    plot( timeAxis, [Sites.Hydro.stats.pow, hTot], '--' )
    datetick( 'x', 'mmm dd', 'keeplimits', 'keepticks' )
    ax(2) = subplot(2,1,2);
    plot( timeAxis ...
        , smooth(Weather.Fossa.rainInt + Weather.Eidi.rainInt...
                ,1000,'moving') / 2 );
    title( 'Rainfall' )
    datetick( 'x', 'mmm dd', 'keeplimits', 'keepticks' )
    linkaxes( ax, 'x' );
    
    % Monthly sum of rainfall.
    figure
    sumRain = zeros( 12,1 );
    for i=1:12
        sumRain(i) = (sum(Weather.Fossa.rainInt(MM==i))/6 ...
                   + sum(Weather.Eidi.rainInt(MM==i))/6) / 2;
    end
    bar( datenum(str2double(theYear),1:12,1)' ...
        , sumRain );
    title( 'Monthly rainfall' )
    datetick( 'x', 'mmm', 'keeplimits' );
    clear meanRain;
    
    toc
    clear f i s MM meanPows ax j ;
end