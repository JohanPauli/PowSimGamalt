function Sites = changeSitesFile( Sites )


    %% Change wind sites.
    % Post 2012 Neshagi.
    WindUnit = getWindUnitTypes();
    Sites.Wind.Neshagi.units = [WindUnit.Nordtank, WindUnit.EnerconE44];
    Sites.Wind.Neshagi.unitCount = [1, 5];
    
    %% Change tidal sites.
    TidalUnit = getTidalUnitTypes();
    % Vestmanna.
    Sites.Tidal.Vest.units = [];
    Sites.Tidal.Vest.unitCount = 0;
    
    % Hestfjørður.
    Sites.Tidal.Hest.units = [];
    Sites.Tidal.Hest.unitCount = 0;
    
    % Leirvíksfjørður.
    Sites.Tidal.Leir.units = [];
    Sites.Tidal.Leir.unitCount = 0;
    
    %% Change wave sites.
    WaveUnit = getWaveUnitTypes();
    % Eystanfyri Føroyar.
    Sites.Wave.Eystanfyri.units = [];
    Sites.Wave.Eystanfyri.unitCount = 0;
    
    %% Change solar sites.
    SolarUnit = getSolarUnitTypes;
    % Koltur.
    Sites.Solar.Koltur.units = [];
    Sites.Solar.Koltur.unitCount = 0;
    
    %% Change hydro sites.
    HydroUnit = getHydroUnitTypes();
    % Mýruverkið.
    Sites.Hydro.Myru.units = [HydroUnit.Myru1];
    Sites.Hydro.Myru.unitCount = 1;
    
    %% Change pumped-storage sites.
    PsUnit = getPsUnitTypes();
    % Mýruverkið (maybe in future).
    Sites.Ps.Myru.units = [];
    Sites.Ps.Myru.unitCount = 0;
end