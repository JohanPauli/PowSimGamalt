function Sites = makeSolarSites()
% makeSolarSites loads the default solar power production sites.
% 
% Sites = makeSolarSites() constructs the solar power production
% site data struct, and associates the default data with it.
% 
% Output:
% * Sites: struct representing solar power production sites.

    %% Define solar turbine types.
    SolarPanel = getSolarUnitTypes();
    
	%% Set a reference to production function.
    Sites.prodFunc = @(Sites, Weather, timeAxis, SEV, powReq, powOP) ...
          calcPowSolar(Sites, Weather, timeAxis, SEV, powReq, powOP);
    
    %% Maximum production for this type.
    Sites.maxProd = 1.0;
    
    %% Define solar sites.
    Koltur.name = 'Koltur';
    Koltur.units = [];
    Koltur.unitCount = 0;
    Sites.Koltur = Koltur;
end