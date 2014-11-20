function formatRoadstationData( filenames )
% formatRoadstationData formats Landsverk roadstation data.
% 
% ...

    %% Loop through the file(s).
    for i=1:numel(filenames)
        
        %% Replace all NA with NaN.
        str = fileread( filenames{i} );
        str = strrep( str, 'NA', 'NaN' );
        fileID = fopen( filenames{i}, 'w' );
        fwrite( fileID, str );
        fclose( fileID );
        
        %% Open the file.
        fileID = fopen( filenames{i}, 'r' );

        %% Read the file in to cell array.
        dataArray = textscan( fileID ...
            , '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]' ...
            , 'Delimiter', '\t' , 'HeaderLines', 1, 'ReturnOnError', false);
        
        %% Close the file.
        fclose( fileID );
        
        %% Open the file in write-mode.
        fileID = fopen( filenames{i}, 'w' );
        
        %% Replace and read.
        time = dataArray{1};
        f = '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n';
        for j=1:numel(time)
            tline = time{j};
            tline = strrep( tline, '-', ' ' );
            tline = strrep( tline, ':', ' ' );
            fprintf( fileID, f, tline, dataArray{2}{j}, dataArray{3}{j} ...
                   , dataArray{4}{j}, dataArray{5}{j}, dataArray{6}{j} ...
                   , dataArray{7}{j}, dataArray{8}{j}, dataArray{9}{j} ...
                   , dataArray{10}{j}, dataArray{11}{j}, dataArray{12}{j} ...
                   , dataArray{13}{j}, dataArray{14}{j}, dataArray{15}{j} ...
                   , dataArray{16}{j}, dataArray{17}{j}, dataArray{18}{j} ...
                   , dataArray{19}{j}, dataArray{20}{j} );
        end
        
        %% Close the file.
        fclose( fileID );
    end
    
end