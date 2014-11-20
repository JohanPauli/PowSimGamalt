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
        
        % Units and unit count.
        u = HydroSites.(s{i}).units;
        uc = HydroSites.(s{i}).unitCount;
        % Gather units, sum production, average efficiency.
        ratedPow = 0;
        ratedFlx = 0;
        for j=1:numel(u)
            ratedPow = ratedPow + uc(j) * u(j).ratedPow;
            ratedFlx = ratedFlx + uc(j) * u(j).ratedFlx;
        end
        eff = 0;
        for j=1:numel(u)
            eff = eff + u.eff * uc(j) * u.ratedPow / ratedPow;
        end
        
        % Store and transform rated power/flux from SI to MWh/timeaxis.
        ratedPow = ratedPow * (timeAxis(2) - timeAxis(1)) * 24;
        ratedFlx = ratedFlx * 3600 * (timeAxis(2) - timeAxis(1))* 24;
        
        % Dam variables
        head0 = HydroSites.(s{i}).head0;
        damLim = HydroSites.(s{i}).damVolLim;
        damMin = HydroSites.(s{i}).damVolMin;
        damCap = HydroSites.(s{i}).damVolCap;
        ra = HydroSites.(s{i}).rainArea;
        da = HydroSites.(s{i}).damArea;
        
        % Dam status vectors.
        damOverflow = zeros(numel(timeAxis),1);
        damVolProg = zeros(numel(timeAxis)+1,1);
        % Start value for the dam.
        damVolProg(1) = HydroSites.(s{i}).damVol0;
        
        % Loop through rain data, calculating volume change.
        for j=1:numel(damVolProg)-1
            % Produce nothing if under min.
            if damVolProg(j) < damMin
                damVolProg(j+1) = damVolProg(j) + rainInt(j) * ra;
            % Produce maximum if over dam limit.
            elseif damVolProg(j) > damLim
                damVolProg(j+1) = damVolProg(j) + rainInt(j) * ra ...
                    - ratedFlx;
            else % damLim <= damVolProg <= damCap
                damVolProg(j+1) = damVolProg(j) + rainInt(j) * ra ...
                    - ratedFlx ...
                    * (1 - exp((-damVolProg(j)+damMin+(damCap-damMin)/1.5) ...
                    * 12 / (damCap/5) ));
            end
            
            % Dam volume is over capacity => overflow.
            if damVolProg(j+1) > damCap
                damOverflow(j) = damOverflow(j) ...
                    + damVolProg(j+1) - damCap;
                damVolProg(j+1) = damCap;
            end
        end
        
        % The first element of damVolProg is just initial water level.
        HydroSites.(s{i}).damVolProg = damVolProg;
        damVolProg = damVolProg(2:end);
        
        figure,plot(timeAxis,damVolProg),datetick('x','keeplimits');
            
        % 'Raw' production.
        rawPow = zeros(numel(timeAxis),1);
        mask = damVolProg <= damLim;
        const = (1 - exp((-damVolProg(mask)+damMin+(damCap-damMin)/1.5) ...
                    * 12 / (damCap/5) ));
        rawPow(mask) = eff * 1023  * ratedFlx * const * 9.82 ...
                     .* (ratedFlx * const / da + head0);
        figure,plot(timeAxis,rawPow),datetick('x','keeplimits');
        mask = damVolProg > damLim;
        rawPow(mask) = eff * ratedPow;
        figure,plot(timeAxis,rawPow),datetick('x','keeplimits');
        mask = damVolProg < damCap * damMin;
        rawPow(mask) = 0;
        figure,plot(timeAxis,rawPow),datetick('x','keeplimits');
            
        % Overproduction.
        HydroSites.(s{i}).powOP = zeros(numel(timeAxis),1);
        mask = rawPow > powReq;
        HydroSites.(s{i}).powOP(mask) = HydroSites.(s{i}).powOP(mask)...
            + rawPow(mask) - powReq(mask);

        % Production.
        HydroSites.(s{i}).pow = rawPow - HydroSites.(s{i}).powOP;

        % Update power requirements.
        powReq = HydroSites.stats.powReq - HydroSites.(s{i}).pow;
        
        % Store dam volume progress and overflow.
        HydroSites.(s{i}).damVolProg = damVolProg;
        HydroSites.(s{i}).damOverflow = damOverflow;
        
        % Add production to total.
        HydroSites.stats.pow = HydroSites.stats.pow ...
            + HydroSites.(s{i}).pow;
        HydroSites.stats.powOP = HydroSites.stats.powOP ...
            + HydroSites.(s{i}).powOP;
    end
end