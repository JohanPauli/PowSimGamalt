function Sites = makeTidalSites()
% makeTidalSites loads the default tidal power production sites.
% 
% Sites = makeTidalSites() constructs the tidal power production site
% data struct, and associates the default data with it.
% 
% Output:
% * Sites: struct representing tidal power production sites.

    %% Turbine data.
    TidalTurbine = getTidalUnitTypes();
    
    %% Set a reference to production function.
    Sites.prodFunc = @(Sites, Weather, timeAxis, SEV, powReq, powOP) ...
          calcPowTidal(Sites, Weather, timeAxis, SEV, powReq, powOP);
    
    %% Maximum production.
    Sites.maxProd = 1.0;
    
    %% Site data.
    Vest.name = 'Vestmannasund';
    Vest.units = [];
    Vest.unitCount = 0;
    Sites.Vest = Vest;
    
    Hest.name = 'Hestfjørður';
    Hest.units = [];
    Hest.unitCount = 0;
    Sites.Hest = Hest;
    
    Leir.name = 'Leirvíksfjørður';
    Leir.units = [];
    Leir.unitCount = 0;
    Sites.Leir = Leir;
end