function HydroSites = calcPowHydro( HydroSites, timeAxis, SEV )
% calcPowHydro calculates hydropower production and overproduction.
% 
% HydroSites = calcPowHydro( HydroSites ) calculates hydropower production
% and overproduction based on hydropower production site data and power
% requirements contained in the HydroSites object.
% 
% Inputs:
% * HydroSites: a struct array containing all necessary data for hydropower
%               production.
%               See loadHydroSites() for more info.
% * timeAxis : vector of the points in time for which calculations
%              are done. This is in the output format of datenum().
% * powReq: vector of power requirements at each point in timeAxis.
% 
% Outputs:
% * HydroSites: an updated version of the input object of the same name.

    %% Initialise variables.
    % Initialise 'total production' variables.
    HydroSites.stats.pow = zeros(numel(timeAxis),1);
    HydroSites.stats.powOP = zeros(numel(timeAxis),1);
    
    % Power requirements are either power requirements after whatever comes
    % before this, or the ceiling set on this kind of production.
    powReq = min( HydroSites.stats.powReq ...
                , SEV.Total * HydroSites.stats.maxProd );
    
    %% Calculate production.
    % Loop through the sites.
    f = fieldnames(HydroSites);
    for i = 3:numel(f)
        % Don't do anything if no units installed.
        if isempty(HydroSites.(f{i}).units)
            continue;
        end
        
        % Rain intensity, converted from mm/h to m per timeaxis interval.
        rainInt = HydroSites.(f{i}).rainInt;
        rainInt = rainInt * 1e-3 * (timeAxis(2) - timeAxis(1)) * 24;
        rain = rainInt * HydroSites.(f{i}).area;
        
        % Units and unit count.
        u = HydroSites.(f{i}).units;
        uc = HydroSites.(f{i}).unitCount;
        % Gather units, sum production, average efficiency.
        rPow = 0;
        rFlx = 0;
        for j=1:numel(u)
            rPow = rPow + uc(j) * u(j).rPow;
            rFlx = rFlx + uc(j) * u(j).rFlx;
        end
        eff = 0;
        for j=1:numel(u)
            eff = eff + u(j).eff * uc(j) * u(j).rPow / rPow;
        end
        
        % Store and transform rated power/flux from SI to MWh/timeaxis.
        rPow = rPow * (timeAxis(2) - timeAxis(1)) * 24;
        rFlx = rFlx * 3600 * (timeAxis(2) - timeAxis(1))* 24;
        volPerPow = rFlx / rPow;
        
        % Dam variables
        h = HydroSites.(f{i}).head;
        dCap = HydroSites.(f{i}).dCap;
        
        % Dam status vectors.
        dOflow = zeros(numel(timeAxis),1);
        dProg = zeros(numel(timeAxis)+1,1);
        % Start value for the dam.
        dProg(1) = HydroSites.(f{i}).dCap * 0.90;
        
        % Rain predictions are an averaged rainInt.
        rPred = smooth(rain,500,'moving');
        baseVal = (sin(linspace(1,numel(timeAxis),numel(timeAxis)) ...
            / numel(timeAxis) / 10) / 4 + 0.5)';
        
        % Loop through rain data, calculating volume change.
        for j=1:numel(dProg)-1
            % Water over limit => production & overproduction.
%             if dProg(j) >= dCap * 0.95
%                 dProg(j+1) = dProg(j) - rFlx ...
%                            + rain(j);
%             % Water under limit => produce a fraction of powReq.
%             else % dProg(j) < dCap * 0.95
                dProg(j+1) = dProg(j) + rain(j) ...
                           - powReq(j) * volPerPow ...
                           * (exp((dProg(j)-3)/dCap*10)/22500) ...
                           * baseVal(j);
%             end
            
            % Dam volume is over capacity => overflow.
            if dProg(j+1) > dCap
                dOflow(j) = dOflow(j) ...
                    + dProg(j+1) - dCap;
                    dProg(j+1) = dCap;
            end
        end
        
        % The first element of dProg is just initial water level.
        dProg = dProg(2:end);
        HydroSites.(f{i}).dProg = dProg;
            
        % 'Raw' production.
        rawPow = zeros(numel(timeAxis),1);
        mask = dProg < dCap * 0.95;
        rawPow(mask) = eff * powReq(mask) ...
                    .* (exp((dProg(mask)-3)/dCap*10)/22500) ...
                    .* baseVal(mask);
        mask = dProg >= dCap * 0.95;
        rawPow(mask) = eff * powReq(mask) ...
                    .* (exp((dProg(mask)-3)/dCap*10)/22500) ...
                    .* baseVal(mask);
        
        % Overproduction.
        HydroSites.(f{i}).powOP = zeros(numel(timeAxis),1);
        mask = rawPow > powReq;
        HydroSites.(f{i}).powOP(mask) = HydroSites.(f{i}).powOP(mask)...
            + rawPow(mask) - powReq(mask);

        % Production.
        HydroSites.(f{i}).pow = rawPow - HydroSites.(f{i}).powOP;

        % Update power requirements.
        powReq = powReq - HydroSites.(f{i}).pow;
        
        % Store dam volume progress and overflow.
        HydroSites.(f{i}).dProg = dProg;
        HydroSites.(f{i}).dOflow = dOflow;
        
        % Add production to total.
        HydroSites.stats.pow = HydroSites.stats.pow ...
            + HydroSites.(f{i}).pow;
        HydroSites.stats.powOP = HydroSites.stats.powOP ...
            + HydroSites.(f{i}).powOP;
    end
end