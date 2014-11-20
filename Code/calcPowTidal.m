function Pow = calcPowTidal( Sites, Weather, timeAxis, SEV, powReq, ~ )
% calcPowTidal calculates tidal power production and overproduction.
% 
% Pow = calcPowTidal( Sites, Weather, timeAxis, SEV, powReq ) calculates
% tidal power production and overproduction from data about weather
% (Weather), points-in-time (timeAxis), power production (SEV), and power
% requirements (powReq).
% 
% Inputs:
% * Sites: a struct array containing tidal site unit data.
% * Weather: a struct array containing weather for all known sites.
% * timeAxis : vector of the points-in-time for which calculations
%              are done. This is in the output format of datenum().
% * SEV: struct containing SEV data for the period (or extrapolated data).
% * powReq: vector of power requirements at each point in timeAxis.
% 
% Outputs:
% * Pow: a struct containing tidal power production data.

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
        tSpeed = Weather.(f{i}).tidalSpeed;
        u = Sites.(f{i}).units;
        uc = Sites.(f{i}).unitCount;
        
        % Raw power for the site.
        rawPow = zeros(numel(timeAxis),1);
        
        % Loop through the units, calculating production for each type.
        for j = 1:numel(u)
            % Extract efficiency, area, min & rated speeds.
            eff = u(j).eff;
            area = u(j).area;
            minSpeed = u(j).minSpeed;
            ratedSpeed = u(j).ratedSpeed;
            
            % For each point of tidalSpeed, calculate corresponding
            % production capacity.
            mask = tSpeed >= minSpeed & tSpeed < ratedSpeed;
            rawPow(mask) = rawPow(mask) + 1/2 * 1023 * area * eff ...
                * tSpeed(mask).^3 * uc(j);
            mask = tSpeed >= ratedSpeed;
            rawPow(mask) = rawPow(mask) + 1/2 * 1023 * area * eff ...
                * ratedSpeed^3 * uc(j);
        end
        
        % Convert rawPow from W to MW.
        rawPow = rawPow / 1e6;
        
        % Convert from MW to MWh per time axis interval.
        rawPow = rawPow * (timeAxis(2) - timeAxis(1)) * 24;
        
        % Calculate overproduction.
        Pow.(f{i}).powOP = zeros(numel(timeAxis),1);
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