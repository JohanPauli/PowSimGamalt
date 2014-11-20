function HydroSites = calcPowHydro( HydroSites, timeAxis )
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
% 
% Outputs:
% * HydroSites: an updated version of the input object of the same name.

    %% Initialise variables.
    % Alias for power requirements, since accessed often (changed).
    powReq = HydroSites.stats.powReq;
    
    % Initialise 'total production' variables.
    HydroSites.stats.pow = zeros(numel(timeAxis),1);
    HydroSites.stats.powOP = zeros(numel(timeAxis),1);
    
    %% Calculate production.
    % Loop through the sites.
    s = fieldnames(HydroSites);
    for i = 2:numel(s)
        % Rain intensity, converted from mm/h to m per timeaxis interval.
        rainInt = HydroSites.(s{i}).rainInt;
        rainInt = rainInt * 1e-3 * (timeAxis(2) - timeAxis(1)) * 24;
        
        % Rated power (MW) & flux (m^3/s).
        ratedPow = HydroSites.(s{i}).ratedPow;
        ratedFlx = HydroSites.(s{i}).ratedFlx;
        
        % Adjust units to MWh- and m^3 per timeaxis interval.
        ratedPow = ratedPow * (timeAxis(2) - timeAxis(1)) * 24;
        ratedFlx = ratedFlx * 3600 * (timeAxis(2) - timeAxis(1))* 24;
        
        % Volume per energy m^3/MWh (assuming load is evenly balanced).
        volPerPow = ratedFlx / ratedPow;
        
        % Loop through rain data, calculating volume change.
        damOverflow = zeros(numel(timeAxis),1);
        damVolProg = zeros(numel(timeAxis)+1,1);
        damVolProg(1) = HydroSites.(s{i}).damInit;
        damLim = HydroSites.(s{i}).damLim;
        damCap = HydroSites.(s{i}).damCap;
        ra = HydroSites.(s{i}).rainArea;
        for j=1:numel(damVolProg)-1
            % Not enough water for requirements => no production.
            if damVolProg(j) < powReq(j) * volPerPow
                damVolProg(j+1) = damVolProg(j) + rainInt(j) * ra;
            % Water over limit => production & overproduction.
            elseif damVolProg(j) >= damCap * damLim
                damVolProg(j+1) = damVolProg(j) - ratedFlx ...
                                + rainInt(j) * ra;
            % Not enough production capacity => produce at capacity.
            % Capacity is regulated by damVolProg.
            elseif powReq(j) > ratedPow
                damVolProg(j+1) = damVolProg(j) ...
                                - ratedFlx * (1 - exp(-damVolProg(j)/damCap)) ...
                                + rainInt(j) * ra;
            else % powReq(j) <= ratedPow
            damVolProg(j+1) = damVolProg(j) ...
                            - powReq(j) * volPerPow ...
                            * (1 - exp(-damVolProg(j)/damCap)) ...
                            + rainInt(j) * ra;
            end
            
            % Dam volume is over capacity => overflow.
            if damVolProg(j+1) > damCap
                damOverflow(j) = damVolProg(j+1) - damCap;
                damVolProg(j+1) = damCap;
            end
        end
        
        % Store dam overflow.
        HydroSites.(s{i}).damOverflow = damOverflow;
        
        % The first element of damVolProg is just initial water level.
        damVolProg = damVolProg(2:end);
        HydroSites.(s{i}).damVolProg = damVolProg;
        
        % 'Raw' production.
        rawPow = zeros(numel(timeAxis),1);
        mask = powReq <= ratedPow;
        rawPow(mask) = powReq(mask) .* (1 - exp(-damVolProg(mask)/damCap));
        mask = powReq > ratedPow;
        rawPow(mask) = ratedFlx / volPerPow * (1-exp(-damVolProg(mask)/damCap));
        mask = damVolProg >= damCap * damLim;
        rawPow(mask) = ratedFlx / volPerPow;
        mask = damVolProg < powReq * volPerPow;
        rawPow(mask) = 0;
        
        % Overproduction.
        mask = rawPow > powReq;
        HydroSites.(s{i}).powOP = zeros(numel(timeAxis),1);
        HydroSites.(s{i}).powOP(mask) = rawPow(mask) - powReq(mask);
        
        % Production.
        HydroSites.(s{i}).pow = rawPow - HydroSites.(s{i}).powOP;
        % Double precision problems, so some powHydro values > powReq.
        mask = HydroSites.(s{i}).pow > powReq;
        HydroSites.(s{i}).pow(mask) = powReq(mask);
        
        % Update power requirements.
        powReq = HydroSites.stats.powReq - HydroSites.(s{i}).pow;
        
        % Add production to total.
        HydroSites.stats.pow = HydroSites.stats.pow ...
            + HydroSites.(s{i}).pow;
        HydroSites.stats.powOP = HydroSites.stats.powOP ...
            + HydroSites.(s{i}).powOP;
    end
end