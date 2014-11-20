function formatSEVXlsData( filenames )
% formatSEVData formats SEV data.
% 
% ...

    %% Loop through the file(s).
    for i=1:numel(filenames)
        %% Open the file.
        fileID = fopen( filenames{i}, 'r' );

        %% Read the file in to cell array.
        dataArray = textscan( fileID, '%s%s%[^\n\r]', 'Delimiter', '\t' ...
                            , 'HeaderLines', 0, 'ReturnOnError', false);
        
        %% Close the file.
        fclose( fileID );
        
        %% Open the file in write-mode.
        fileID = fopen( filenames{i}, 'w' );
        
        %% Replace and read.
        time = dataArray{1};
        data = dataArray{2};
        fprintf( fileID, '%s %s\n', time{1}, data{1} );
        for j=2:numel(time)
            tline = time{j};
            dline = data{j};
            tline = strrep( tline, '-', ' ' );
            tline = strrep( tline, ':', ' ' );
            if ~strcmp( tline, 'Tiden' )
                fprintf( fileID, '%s %s\n', tline, dline );
            end
        end
        
        %% Close the file.
        fclose( fileID );
    end
end