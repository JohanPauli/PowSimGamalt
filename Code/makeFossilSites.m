function Sites = makeFossilSites()
% makeFossilSites makes the default fossil production sites.
% 
% ...

    %% Set a reference to production function.
    Sites.prodFunc = @(Sites, Weather, timeAxis, SEV, powReq, powOP) ...
         calcPowFossil(Sites, Weather, timeAxis, SEV, powReq, powOP);
end