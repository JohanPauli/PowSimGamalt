function Sites = makeWaveSites()
% makeWaveSites loads the default wave power production sites.
% 
% Sites = makeWaveSites() constructs the wave power production site
% data struct, and associates the default data with it.
% 
% Output:
% * Sites: struct representing wave power production sites.

    %% Define wave turbine types.
    WaveTurbine = getWaveUnitTypes();
    
    %% Set a reference to production function.
    Sites.prodFunc = @(Sites, Weather, timeAxis, SEV, powReq, powOP) ...
           calcPowWave(Sites, Weather, timeAxis, SEV, powReq, powOP);
    
    %% Maximum production from this type.
    Sites.maxProd = 0.8;
    
    %% Define wave sites.
    % Veðurboyan eystanfyri Føroyar.
    Eystanfyri.name = 'Eystanfyri Føroyar';
    Eystanfyri.units = [];
    Eystanfyri.unitCount = 0;
    Sites.Eystanfyri = Eystanfyri;
end