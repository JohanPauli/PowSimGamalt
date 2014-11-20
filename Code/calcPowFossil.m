function Pow = calcPowFossil( ~, ~, timeAxis, ~, powReq, ~ )
% calcPowFossil calculates fossil fuel power production.
% 
% This just assigns the positive portion of powReq to
% FossilSites.stats.pow.
    
    %% Do it.
    Pow.Total = zeros(numel(timeAxis),1);
    Pow.Total(powReq>=0) = powReq(powReq>=0);
    Pow.TotalOP = zeros(numel(timeAxis),1);
end