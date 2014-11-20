function Sites = changeSitesSettings( Sites )
% getSiteChanges

    %% Show the default.
    % Print initial status:
    fprintf( 'Default values are:\n' );
    f = fieldnames( Sites );
    for i=1:numel(f)
        hfShowSiteData( Sites.(f{i}), f{i} );
    end
    fprintf( '\n' );

    %% Change parameters if requested.
    if hfGetChoice( 'Change simulation parameters?' )
        Sites = changeSitesFile( Sites );
        fprintf( 'New values are:\n' );
        f = fieldnames( Sites );
        for i=1:numel(f)
            hfShowSiteData( Sites.(f{i}), f{i} );
        end
        fprintf( '\n' );
        % Change sites?
%         f = fieldnames( Sites );
%         for i=1:numel(f)
%             if hfGetChoice( ['Change ',f{i},' sites?'] )
%                 Sites.(f{i}) = hfChangeSites( Sites.(f{i}) );
%             end
%         end
    end
end