function c = hfGetChoice( msg )
% hfGetChoice is a help function for y/n choices.
% 
% Input:
% * msg: a message to be shown.
%        Ex.: 'Would you like to repeat the simulation?'.
% 
% Output:
% * c: a true if the choice was 'y', false otherwise.

    c = input( [msg, ' [y/n]: '], 's' );
    while isempty(c) || (~strcmp(c,'y') && ~strcmp(c,'n'))
        fprintf( 'Invalid input, try again.\n' );
        c = input( [msg, ' [y/n]: '], 's' );
    end
    if strcmp(c,'y')
        c = true;
    else
        c = false;
    end
end