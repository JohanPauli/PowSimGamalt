function HydroSites = loadHydroSites()
% loadHydroSites loads the default hydropower production sites.
% 
% HydroSites = loadHydroSites() loads the hydropower production
% site data struct with the default data.
% 
% Output:
% * HydroSites: struct representing hydropower production sites.

    %% Define hydropower production units.
    HydroUnit.MadeUp.name = 'Entire FO ~40 MW, 32e6 dam, 100e6 area';
    % TODO: Change HydroPower to utilise units.
    
    %% Set fields for statistics.
    % Power requirements are determined later.
    HydroSites.stats.powReq = [];
    
    % Set 'total production'.
    HydroSites.stats.pow = [];
    HydroSites.stats.powOP = [];
    
    %% Define hydropower sites.
    % Name information.
	Hogareyn.name = 'Høgareyn';
    % Site unit specifications.
    Hogareyn.units = [HydroUnit.MadeUp];
    Hogareyn.unitCount = 1;
    Hogareyn.ratedPow = 40; % MW
    Hogareyn.ratedFlx = 30; % m^3/s
    Hogareyn.rainArea = 100e6; % m^2
    Hogareyn.reservoirArea = 1.14e6 * 1.6; % m^2 (ca. 1.6 Eiðisvatn)
    Hogareyn.damCap = 32e6; % m^3
    Hogareyn.damInit = 16e6; % m^3
    Hogareyn.damLim = 0.8; % scalar
    Hogareyn.headInit = 150; % m (initial head)
    % Result containers.
	Hogareyn.rainInt = []; % mm/h
    Hogareyn.pow = []; % MWh / timeaxis interval
    Hogareyn.powOP = []; % MWh / timeaxis interval
    Hogareyn.damVolProg = []; % m^3 / timeaxis interval
    Hogareyn.damOverflow = [];
    HydroSites.Hogareyn = Hogareyn;
end