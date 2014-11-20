function formatSEVData( dir, theYear )
% formatSEVData formats SEV data to the working format.
% 
% SEV = formatSEVData( prefixes ) formats SEV data and stuff


    %% Remove 23 the first characters from each file (so they can be read).
    theDay = 1;
    while 1
        disp(theDay)
        % Read the lines.
        fileID = fopen( [dir, '/AktivEffektH', theYear ...
                     , 'R1D', num2str(theDay), '.txt'], 'r' );
        if fileID == -1
            break;
        end
        
        % Establish the number of header lines.
        % The headers describe equipment, so they change as new equipment is
        % added or removed.
        h = 0;
        while 1
            tline = fgetl( fileID );
            if strcmp(tline(2:5),theYear)
                break;
            else
                h = h + 1;
            end
        end
        fclose( fileID );
        
        % Skip the lines until the header.
        fileID = fopen( [dir, '/AktivEffektH', theYear ...
                     , 'R1D', num2str(theDay), '.txt'], 'r' );
        for i=1:h
            fgetl( fileID );
        end
        
        % Change the rest of the lines.
        tline = cell(1440,1);
        for i=1:1440
            tline{i} = fgetl( fileID );
            tline{i} = tline{i}(24:end);
        end
        fclose( fileID );
        
        % Replace (assumed) blackouts with 0 productions.
        tline = strrep( tline, '*****', '00.00' );
        
        % Write the lines.
        fileID = fopen( [dir, '/AktivEffektH', theYear ...
                     , 'R1D', num2str(theDay), '.txt'], 'w' );
        fprintf( fileID, '%s\n', tline{:} );
        fclose(fileID);
        
        theDay = theDay + 1;
    end
    
    %% The lines to read.
    % Hydro                 Wind            Diesel
    % 4 : Fossaverkið       39 : Røkt       19+20 : Strendur
    % 7 : Mýruverkið        40 : Neshagi    31 : Sundsverkið
    % 8 : Heygaverkið
    % 11+12 : Eiði
    % 18 : Strendur
    f = [ '%n%*s%*s%n%*s%*s%n%n%*s%*s' ...
        , '%n%n%*s%*s%*s%*s%*s%n%n%n' ...
        , '%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s' ...
        , '%n%*s%*s%*s%*s%*s%*s%*s%n%n%[^\r\n]' ];
    
    %% The dates considered.
    dates = datenum(str2double(theYear),1,1,0,0,0) ...
          : 1/24/60 ...
          : datenum(str2double(theYear),1,1,23,59,0);
    
    %% Loop through the files (days).
    theDay = 1;
    while 1
        disp(datestr( dates(1:2), 'yyyy-mm-dd HH:MM:SS' ));
        
        %% Open the file
        fileID ...
            = fopen( [dir, '/AktivEffektH', theYear ...
                     , 'R1D', num2str(theDay), '.txt'], 'r' );
        if fileID == -1
            break;
        end
        
        %% Read the wanted columns:
        dataArray = textscan( fileID, f, 1440, 'ReturnOnError', false );
        
        %% Close file.
        fclose( fileID );
        
        %% Make Vectors to contain the data
        total = dataArray{1};
        hFossa = dataArray{2};
        hMyru = dataArray{3};
        hHeyga = dataArray{4};
        hEidi = dataArray{5} + dataArray{6};
        hStrendur = dataArray{7};
        dStrendur = dataArray{8} + dataArray{9};
        dSund = dataArray{10};
        wRokt = dataArray{11};
        wNeshagi = dataArray{12};
        
        %% Open file to write to.
        fileID = fopen( [dir, '/SEV', theYear, '.txt'], 'a+' );
        %% Write the data to the file.
        for i=1:numel(total)
            fprintf( fileID, [ '%0.10f %0.2f %0.2f %0.2f %0.2f ' ...
                             , '%0.2f %0.2f %0.2f %0.2f %0.2f %0.2f\n' ] ...
                   , dates(i) , total(i), hFossa(i), hMyru(i), hHeyga(i) ...
                   , hEidi(i), hStrendur(i), dStrendur(i), dSund(i) ...
                   , wRokt(i), wNeshagi(i) );
        end
       
       %% Close the file
       fclose( fileID );
       
       %% Increment the day for the next file.
       theDay = theDay + 1;
       dates = dates + 1;
    end
end