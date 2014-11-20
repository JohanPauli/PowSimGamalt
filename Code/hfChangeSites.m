function Sites = hfChangeSites( Sites )
% Help function to change the sites of a type of production.
% 
% ...

    %% Decide whether a preset or a change is to be used.
    fprintf( '1. From file...\n' );
    fprintf( '2. Custom settings...\n' );
    fprintf( '3. No changes\n' );
    in = floor(str2double(input( 'Change which site? [num]: ', 's' )));
    while isempty(in) || isnan(in) ...
            || (in < 1 && in > 3)
        fprintf( 'Invalid input, try again.\n' );
        in = floor(str2double(input( 'Change which site? [num]: ', 's' )));
    end
    
    %% Show the choice/quit.
    if strcmp(in,'1')
        in = input( 'File name?', 's' );
        fileID = fopen( in );
        while fileID = -1
            fprintf( 'Invalid file, try again.\n' );
            in = input( 'File name?', 's' );
            fileID = fopen( in );
        end
        Sites = hfReadFileSites( Sites, fileID );
    elseif strcmp(in,'2')
        return;
    end
    
    %% If custom is chosen, customise.
    while 1
        %% Print out the sites for the production.
        f = fieldnames(Sites);
        for i=3:numel(f)
            fprintf( [num2str(i-2),'. ',Sites.(f{i}).name,'\n'] );
        end
        fprintf( [num2str(i-2)+1,'. Back.\n'] );
        in = floor(str2double(input( 'Change which site? [num]: ', 's' )));
        while isempty(in) || isnan(in) ...
                || (in < 1 && in > numel(f)-2)
            fprintf( 'Invalid input, try again.\n' );
            in = floor(str2double(input( 'Change which site? [num]: ', 's' )));
        end
        if 
        
        while 1
            %% Print the site out that is going to be changed.
            
        end
    end
end