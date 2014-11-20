function Sites = makeHydroSites()
% loadHydroSites loads the default hydropower production sites.
% 
% Sites = loadHydroSites() loads the hydropower production
% site data struct with the default data.
% 
% Output:
% * Sites: struct representing hydropower production sites.

    %% Load generator types.
    HydroGenerator = getHydroUnitTypes();
    
    %% Set a reference to production function.
    Sites.prodFunc = @(Sites, Weather, timeAxis, SEV, powReq, powOP) ...
          calcPowHydro(Sites, Weather, timeAxis, SEV, powReq, powOP);
    
    %% Maximum production for this type.
    Sites.maxProd = 1.0;
    
    %% Define hydropower sites.
    % Specs (for all) from:
    % http://www.sev.fo/Default.aspx?ID=69
    % Fossáverkið
    Fossa.name = 'Fossáverkið (4.96e6 m^3 & 16.7 km^2)';
    % Generator data.
    Fossa.units = [HydroGenerator.Fossa1, HydroGenerator.Fossa2];
    Fossa.unitCount = [1, 1];
    % Dam data.
    Fossa.head = 222; % m (initial head)
    Fossa.dCap = 4.960e6; % m^3
    Fossa.area = 16.7e6; % m^2
    Sites.Fossa = Fossa;
    
    % Heygaverkið.
    Heyga.name = 'Heygaverkið (6.1e6 m^3 & 27.1 km^2)';
    % Generator data.
    Heyga.units = [HydroGenerator.Heyga1];
    Heyga.unitCount = 1;
    % Dam data.
    Heyga.head = 107; % m
    Heyga.dCap = 6.1e6; % m^3
    Heyga.area = 27.1e6; % m^2
    Sites.Heyga = Heyga;
    
    % Mýruverkið.
    Myru.name = 'Mýruverkið (4.1e6 m^3 & 8 km^2)';
    % Generator data.
    Myru.units = [HydroGenerator.Myru1];
    Myru.unitCount = 1;
    % Dam data.
    Myru.head = 239; % m
    Myru.dCap = 4.1e6; % m^3
    Myru.area = 8e6; % m^2
    Sites.Myru = Myru;
    
    % Eiðisverkið
    Eidi.name = 'Eiðisverkið (33e6 m^3 & 42.6 km^2)';
    % Generator data.
    Eidi.units = [HydroGenerator.Eidi1];
    Eidi.unitCount = 2;
    % Dam data.
    Eidi.head = 149; % m
    Eidi.dCap = 33e6; % m^3
    Eidi.area = 42.6e6; % m^2
    Sites.Eidi = Eidi;
    
    % Verkið á Strondum.
    Strond.name = 'Verk á Strondum (40e3 m^3 & 3.7 km^2)';
    % Generator data.
    Strond.units = [HydroGenerator.Strond1];
    Strond.unitCount = 1;
    % Dam data.
    Strond.head = 223;
    Strond.dCap = 40e3;
    Strond.area = 4.7e6;
    Sites.Strond = Strond;
end