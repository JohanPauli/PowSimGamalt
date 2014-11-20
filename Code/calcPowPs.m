function Pow = calcPowPs( Sites, Weather, timeAxis, SEV, powReq, powOP )
% calcPowPs calculates pumped-storage power production and storage.
% 
% Pow = calcPowPs( Sites, Weather, timeAxis, SEV, powReq ) calculates
% pumped-storage power production and storage from data about weather
% (Weather), points-in-time (timeAxis), power production (SEV), and power
% requirements (powReq).
% 
% Inputs:
% * Sites: a struct array containing pumped-storage site unit data.
% * Weather: a struct array containing weather for all known sites.
% * timeAxis : vector of the points-in-time for which calculations
%              are done. This is in the output format of datenum().
% * SEV: struct containing SEV data for the period (or extrapolated data).
% * powReq: vector of power requirements at each point in timeAxis.
% 
% Outputs:
% * Pow: a struct containing pumped-storage power production data.

    %% Initialise totals.
    Pow.Total = zeros(numel(timeAxis),1);
    Pow.TotalOP = zeros(numel(timeAxis),1);
    Pow.TotalPS = zeros(numel(timeAxis),1);
    Pow.TotalDP = zeros(numel(timeAxis),1);
    Pow.TotalOF = zeros(numel(timeAxis),1);
    
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
        
        % Rain intensity, converted from mm/h to m per timeaxis interval.
        rainInt = Weather.(f{i}).rainInt;
        rainInt = rainInt * 1e-3 * (timeAxis(2) - timeAxis(1)) * 24;
        rain = rainInt * Sites.(f{i}).area;
        
        % Units and unit count.
        u = Sites.(f{i}).units;
        uc = Sites.(f{i}).unitCount;
        % Gather units, sum production, average efficiency.
        rPow = 0;
        pPow = 0;
        rFlx = 0;
        pFlx = 0;
        for j=1:numel(u)
            rPow = rPow + uc(j) * u(j).rPow;
            pPow = pPow + uc(j) * u(j).pPow;
            rFlx = rFlx + uc(j) * u(j).rFlx;
            pFlx = pFlx + uc(j) * u(j).pFlx;
        end
        eff = 0;
        pEff = 0;
        for j=1:numel(u)
            eff = eff + u(j).eff * uc(j) * u(j).rPow / rPow;
            pEff = pEff + u(j).pEff * uc(j) * u(j).pPow / pPow;
        end
        
        % Store and transform rated power/flux from SI to MWh/timeaxis.
        rPow = rPow * (timeAxis(2) - timeAxis(1)) * 24;
        pPow = pPow * (timeAxis(2) - timeAxis(1)) * 24;
        rFlx = rFlx * 3600 * (timeAxis(2) - timeAxis(1))* 24;
        pFlx = pFlx * 3600 * (timeAxis(2) - timeAxis(1))* 24;
        volPerPow = rFlx / rPow;
        pVolPerPow = pFlx / pPow;
        
        % Dam variables
        h = Sites.(f{i}).head;
        dCap = Sites.(f{i}).dCap;
        
        % Dam status vectors.
        dOflow = zeros(numel(timeAxis),1);
        dProg = zeros(numel(timeAxis)+1,1);
        % Start value for the dam.
        dProg(1) = Sites.(f{i}).dCap;
        
        % Loop through rain data, calculating volume change.
        for j=1:numel(dProg)-1
            % Water over limit => production & overproduction.
            if powOP(j) > 0
                % Not enough pump capacity => pump at capacity.
                if powReq(j) > pPow
                    dProg(j+1) = dProg(j) + rain(j) + pFlx;
                % Enough pump capacity => pump requirements.
                else % powReq(j) <= pPow
                    dProg(j+1) = dProg(j) + rain(j) ...
                        + powReq(j) * pVolPerPow;
                end
            end
            if powReq(j) > 0
                if dProg(j) >= dCap * 0.95
                    dProg(j+1) = dProg(j) - rFlx ...
                               + rain(j);
                % Water under limit => produce a fraction of powReq.
                else % dProg(j) < dCap * 0.95
                    dProg(j+1) = dProg(j) + rain(j) ...
                               - powReq(j) * volPerPow ...
                               * (exp((dProg(j)-3)/dCap*10)/22500) ...
                               * 0.3;
                end
            end
            
            % Dam volume is over capacity => overflow.
            if dProg(j+1) > dCap
                dOflow(j) = dOflow(j) ...
                    + dProg(j+1) - dCap;
                    dProg(j+1) = dCap;
            end
        end
        
        % The first element of dProg is just initial water level.
        dProg = dProg(2:end);
            
        % Production.
        Pow.(f{i}).pow = zeros(numel(timeAxis),1);
        mask = powReq >= 0 & dProg < dCap * 0.95;
        Pow.(f{i}).pow(mask) = eff * powReq(mask) ...
                    .* (exp((dProg(mask)-3)/dCap*10)/22500) ...
                     * 0.3;
        mask = powReq >= 0 & dProg >= dCap * 0.95;
        Pow.(f{i}).pow(mask) = rPow;
        
        % Pumped energy.
        Pow.(f{i}).pumpPs = zeros(numel(timeAxis),1);
        mask = powReq < 0 & powReq <= pPow;
        Pow.(f{i}).pumpPs(mask) = -powReq(mask);
        mask = powReq < 0 & powReq > pPow;
        Pow.(f{i}).pumpPs(mask) = pPow;
        
        % Store dam volume progress and overflow.
        Pow.(f{i}).dProg = dProg;
        Pow.(f{i}).dOflow = dOflow;
        
        % Update power requirements.
        powReq = powReq - Pow.(f{i}).pow;
        
        % Update totals.
        Pow.Total = Pow.Total + Pow.(f{i}).pow;
        Pow.TotalPS = Pow.TotalPS + Pow.(f{i}).pumpPs;
        Pow.TotalDP = Pow.TotalDP + Pow.(f{i}).dProg;
        Pow.TotalOF = Pow.TotalOF + Pow.(f{i}).dOflow;
    end
end