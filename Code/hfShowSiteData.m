function hfShowSiteData( Sites, name )
% hfShowSiteData is a help function to show data from a *Sites object.
% 
% hfShowSiteData( Sites ) presents the site data and units installed at
% each site in a readable format.
% 
% Input:
% * Sites: the *Sites object for which information is to be shown.
% * name: the * in *Sites (can't be inferred from var name).

    %% Just a simple loop.
    fprintf( '%s sites:\n', name );
    f = fieldnames( Sites );
    for i=3:numel(f) % first field is statistics.
        fprintf( '\tAt %s\n', Sites.(f{i}).name );
        if isempty( Sites.(f{i}).units )
            fprintf( '\t\tNothing.\n' );
        else
            for j=1:numel(Sites.(f{i}).units)
                fprintf( '\t%4g x %-s\n' ...
                , Sites.(f{i}).unitCount(j), Sites.(f{i}).units(j).name );
            end
        end
    end
end