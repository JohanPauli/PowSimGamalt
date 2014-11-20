function Pow = calcPowWind( Sites, Weather, timeAxis, SEV, powReq, ~ )
% calcPowWind calculates wind power production and overproduction.
% 
% Pow = calcPowWind( Sites, Weather, timeAxis, SEV, powReq ) calculates
% wind power production and overproduction from data about weather
% (Weather), points-in-time (timeAxis), power production (SEV), and power
% requirements (powReq).
% 
% Inputs:
% * Sites: a struct array containing wind site unit data.
% * Weather: a struct array containing weather for all known sites.
% * timeAxis : vector of the points-in-time for which calculations
%              are done. This is in the output format of datenum().
% * SEV: struct containing SEV data for the period (or extrapolated data).
% * powReq: vector of power requirements at each point in timeAxis.
% 
% Outputs:
% * Pow: a struct containing wind power production data.

    %% Initialise totals.
    Pow.Total = zeros(numel(timeAxis),1);
    Pow.TotalOP = zeros(numel(timeAxis),1);
    
    %% Set the power requirements.
    % Power requirements are either power requirements after whatever comes
    % before this, or the ceiling set on this kind of production.
    powReq = min( powReq, SEV.Total * Sites.maxProd );
    
    %% Calculate production.
    % Loop through the sites.
    f = fieldnames(Sites);
    for i = 3:numel(f)
        % Don't do anything if no units installed.
        if isempty(Sites.(f{i}).units)
            continue;
        end
        
        % Relevant site data aliases (references, since not changed).
        windSpeed = Weather.(f{i}).windSpeed;
        units = Sites.(f{i}).units;
        unitCount = Sites.(f{i}).unitCount;
        
        % Transform wind speed from 10m to 25m.
        windSpeed = windSpeed * 1.25;
        
        % Raw power for the site.
        rawPow = zeros(numel(windSpeed),1);
        
        % Loop through the units, calculating production for each type.
        for j = 1:numel(units)
            % Extract power curve for type (n x 2 matrix, with (wind,pow)).
            pc = units(j).powerCurve;
            
            % For each point of windSpeed, interpolate production level
            % in power curve.
            mask = windSpeed < pc(end,1) & windSpeed > pc(1,1);
            rawPow(mask) = rawPow(mask) ...
                + unitCount(j) * interp1( pc(:,1), pc(:,2) ...
                , windSpeed(mask), 'linear' );
        end
        
        % Convert rawPow from kW to MW.
        rawPow = rawPow / 1000;
        
        % Convert from MW to MWh per time axis interval.
        rawPow = rawPow * (timeAxis(2) - timeAxis(1)) * 24;
        
        % Calculate overproduction.
        Pow.(f{i}).powOP = zeros(numel(windSpeed),1);
        mask = rawPow > powReq;
        Pow.(f{i}).powOP(mask) = rawPow(mask) - powReq(mask);
        
        % Calculate production.
        Pow.(f{i}).pow = rawPow - Pow.(f{i}).powOP;
        
        % Update power requirements.
        powReq = powReq - Pow.(f{i}).pow;
        
        % Update total.
        Pow.Total = Pow.Total + Pow.(f{i}).pow;
        Pow.TotalOP = Pow.Total + Pow.(f{i}).powOP;
    end
end