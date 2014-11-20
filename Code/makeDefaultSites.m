function Sites = makeDefaultSites()
% makeDefaultSites makes the default sites.
% 
% Sites = makeDefaultSites() makes the default sites for each type of
% energy production system. That means every site is makeed, but only those
% production units that existed in 2011 are attached to the sites.
% 
% Outputs:
% * Sites: a struct containing a field for each type of production site.
%          (ex.: Sites.Wind, Sites.Hydro).

    %% make the sites.
    Sites.Wind = makeWindSites();
    Sites.Tidal = makeTidalSites();
    Sites.Wave = makeWaveSites();
    Sites.Solar = makeSolarSites();
    Sites.Hydro = makeHydroSites();
    Sites.Ps = makePsSites();
    Sites.Fossil = makeFossilSites();
end