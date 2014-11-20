function cf = hfGetCapFactor( Sites, total, timeAxis )
% Help function to calculate capacity factor.
% 
% ...

    %% Get the potential production from Site.
    f = fields( Sites );
    pot = 0;
    t = (timeAxis(end) - timeAxis(1)) * 24;
    for i=3:numel(f)
        u = Sites.(f{i}).units;
        uc = Sites.(f{i}).unitCount;
        for j=1:numel(u)
            pot = pot + uc(j) * u(j).rPow;
        end
    end
    
    %% Calculate the capacity factor.
    if pot ~= 0
        cf = total / (t * pot / 1000) * 100;
    else
        cf = 0;
    end
end