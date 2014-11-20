function Sites = makeWindSites()
% makeWindSites makes the default wind power production sites.
% 
% Sites = makeWindSites() constructs the wind power production site
% data struct, and associates the default data with it.
% 
% Output:
% * Sites: struct representing wind power production sites.

    %% Define wind turbine types.
    WindTurbine = getWindUnitTypes();
    
	%% Set a reference to production function.
    Sites.prodFunc = @(Sites, Weather, timeAxis, SEV, powReq, powOP) ...
           calcPowWind(Sites, Weather, timeAxis, SEV, powReq, powOP);
       
    %% Maximum production for this type.
    Sites.maxProd = 0.4; % 40% of total.
    
    %% Define wind sites.
    Rokt.name = 'Røkt, Vestmanna';
    Rokt.units = [WindTurbine.VestasV47];
    Rokt.unitCount = 3;
    Sites.Rokt = Rokt;
    
    Neshagi.name = 'Neshagi';
    Neshagi.units = [WindTurbine.VestasV47, WindTurbine.Nordtank];
    Neshagi.unitCount = [1, 1];
    Sites.Neshagi = Neshagi;
end

