function Pow = calcPowHydro( Sites, Weather, timeAxis, SEV, powReq, ~ )
% calcPowHydro calculates hydro power production and overproduction.
% 
% Pow = calcPowHydro( Sites, Weather, timeAxis, SEV, powReq ) calculates
% hydro power production and overproduction from data about weather
% (Weather), points-in-time (timeAxis), power production (SEV), and power
% requirements (powReq).
% 
% Inputs:
% * Sites: a struct array containing hydro site unit data.
% * Weather: a struct array containing weather for all known sites.
% * timeAxis : vector of the points-in-time for which calculations
%              are done. This is in the output format of datenum().
% * SEV: struct containing SEV data for the period (or extrapolated data).
% * powReq: vector of power requirements at each point in timeAxis.
% 
% Outputs:
% * Pow: a struct containing hydro power production data.

    %% Initialise totals.
    Pow.Total = zeros(numel(timeAxis),1);
    Pow.TotalOP = zeros(numel(timeAxis),1);
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
        h = Sites.(f{i}).head;
        dCap = Sites.(f{i}).dCap;
        
        % Dam status vectors.
        dOflow = zeros(numel(timeAxis),1);
        dProg = zeros(numel(timeAxis)+1,1);
        % Start value for the dam.
        dProg(1) = Sites.(f{i}).dCap;
        
        % Rain predictions are an averaged rainInt.
        rPred = smooth(rain,500,'moving');
        prodVol = zeros(numel(timeAxis),1);
        prodVol(1) = 0.6 * rFlx;
        
        % Loop through rain data, calculating volume change.
        for j=1:numel(dProg)-1
            if prodVol(j) < dProg(j)
                dProg(j+1) = dProg(j) + rain(j) ...
                           - prodVol(j);
            else
                dProg(j+1) = dProg(j) + rain(j);
                prodVol(j+1) = 0;
            end
            
            % Dam volume is over capacity => overflow.
            if dProg(j+1) > dCap
                dOflow(j) = dOflow(j) ...
                    + dProg(j+1) - dCap;
                    dProg(j+1) = dCap;
            end
            
            
            % Exponential averaging over rain.
            prodVol(j+1) = 0.995 * prodVol(j) + 0.005 * rPred(j);
            if prodVol(j+1) > rFlx
                prodVol(j+1) = rFlx;
            end
        end
        
        % The first element of dProg is just initial water level.
        prodVol = prodVol(1:end-1);
        dProg = dProg(2:end);
        Sites.(f{i}).dProg = dProg;
        
        % 'Raw' production.
        rawPow = eff * prodVol / volPerPow;
        
        % Overproduction.
        Pow.(f{i}).powOP = zeros(numel(timeAxis),1);
        mask = rawPow > powReq;
        Pow.(f{i}).powOP(mask) = rawPow(mask) - powReq(mask);

        % Production.
        Pow.(f{i}).pow = rawPow - Pow.(f{i}).powOP;

        % Update power requirements.
        powReq = powReq - Pow.(f{i}).pow;
        
        % Store dam volume progress and overflow.
        Pow.(f{i}).dProg = dProg;
        Pow.(f{i}).dOflow = dOflow;
        
        % Update totals.
        Pow.Total = Pow.Total + Pow.(f{i}).pow;
        Pow.TotalOP = Pow.TotalOP + Pow.(f{i}).powOP;
        Pow.TotalDP = Pow.TotalDP + Pow.(f{i}).dProg;
        Pow.TotalOF = Pow.TotalOF + Pow.(f{i}).dOflow;
    end
end