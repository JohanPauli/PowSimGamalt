function Sites = hfReadFileSites( Sites, fileID )
% hfReadFileSites is a help function to read site config files.
% 
% ...

    %% Load unit types.
    f = fieldnames( Sites );
    for i=1:numel(f)
        eval( [f,'Units = load',f,'Units()'] );
    end
    
    
    %% Site type, then object data.
    while ~feol(fileID)
        % Get the site type.
        s = fgetl( fileID );
        
        % Clear the unit and unit count fields of site type.
        Sites.(s).units = [];
        Sites.(s).unitCount = [];
        
        % Add unit types and counts.
        us = fgetl( fileID );
        while strcmp(us,'')
            strsplit( us, ' ' );
            Sites.(s).unitCount = [Sites.(s).unitCount, str2double(us{1})];
            Sites.(s).units = [Sites.(s).units, eval([s,'Units.',us{2}])];
        end
end