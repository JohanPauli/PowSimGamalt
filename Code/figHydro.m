function figHydro( Pow, timeAxis )
% figHydro shows hydropower production figures.
% 
% figHydro( Pow, timeAxis ) shows hydropower production statistics for the
% given power struct (Pow), ordered over a time axis.

    %% Make a figure.
    figure;
    
    %% Show a subplot of hydropower production.
    ax(1) = subplot( 3, 1, 1 );
    area( timeAxis, [Pow.Hydro.Total,Pow.Hydro.TotalOP] ...
        , 'LineStyle', 'none' );
    datetick( 'x' );
    
    %% Show a subplot of dam volume progression.
    ax(2) = subplot( 3, 1, 2 );
    plot( timeAxis, Pow.Hydro.TotalDP );
    datetick( 'x' );
    
    %% Show a subplot of dam overflow.
    ax(3) = subplot( 3, 1, 3 );
    plot( timeAxis, Pow.Hydro.TotalOF );
    datetick( 'x' );
    
    %% Link the x-axes.
    linkaxes( ax, 'x' );
end