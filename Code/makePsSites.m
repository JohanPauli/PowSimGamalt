function Sites = makePsSites()
% loadPsSites loads the default pumped-storage production sites.
% 
% Sites = loadPsSites() constructs the pumped-storage production site data
% struct, and associates the default data with it.
% 
% Output:
% * Sites: struct representing hydropower production sites.

    %% Load generator types.
    PsUnit = getPsUnitTypes();
    
    %% Set a reference to production function.
    Sites.prodFunc = @(Sites, Weather, timeAxis, SEV, powReq, powOP) ...
             calcPowPs(Sites, Weather, timeAxis, SEV, powReq, powOP);
    
    %% Maximum production.
    Sites.maxProd = 1.0;
    
    %% Define pumped-storage sites.
    % Heygaverkið.
    Heyga.name = 'Heygaverkið (6.1e6 m^3 & 27.1 km^2)';
    % Generator data.
    Heyga.units = [];
    Heyga.unitCount = 0;
    % Dam data.
    Heyga.head = 107; % m
    Heyga.dCap = 6.1e6; % m^3
    Heyga.area = 27.1e6; % m^2
    Sites.Heyga = Heyga;
    
    % Mýruverkið.
    Myru.name = 'Mýruverkið (4.1e6 m^3 & 8 km^2)';
    % Generator data.
    Myru.units = [];
    Myru.unitCount = 0;
    % Dam data.
    Myru.head = 239; % m
    Myru.dCap = 4.1e6; % m^3
    Myru.area = 8e6; % m^2
    Sites.Myru = Myru;
end