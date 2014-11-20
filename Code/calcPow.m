function Pow = calcPow( Sites, Weather, SEV, timeAxis )
% calcPow calculates power production.
% 
% Pow = calcPow( Sites, Weather, SEV, timeAxis ) calculates the power
% production (Pow) for the time axis period (timeAxis), depending on which
% sites are available (Sites), what the weather is (Weather), and what the
% production demand is (SEV).

    %% The first field of Pow is the total production.
    Pow.Total = zeros(numel(timeAxis),1);
    
    %% Calculate production and power requirements.
    f = fieldnames( Sites );
    
    % The first field must use SEV data for powReq.
    tic
    fprintf( ['Calculating production for ', f{1}, '...\n'] );
    powReq = SEV.Total;
    powOP = 0;
    Pow.(f{1}) = Sites.(f{1}).prodFunc( Sites.(f{1}), Weather ...
                                      , timeAxis, SEV, powReq, powOP );
    % Add to total.
    Pow.Total = Pow.Total + Pow.(f{1}).Total;
    toc,fprintf( '\n' );
    
    % The rest depend on the previous.
    for i=2:numel(f)
       tic
       powReq = powReq - Pow.(f{i-1}).Total;
       powOP = powOP + Pow.(f{i-1}).TotalOP;
       fprintf( ['Calculating production for ', f{i}, '...\n'] );
       Pow.(f{i}) = Sites.(f{i}).prodFunc( Sites.(f{i}), Weather ...
                                         , timeAxis, SEV, powReq, powOP );
       % Add to total.
       Pow.Total = Pow.Total + Pow.(f{i}).Total;
       toc,fprintf( '\n' );
    end
end