function TidalTurbine = getTidalUnitTypes()
    % Specs from:
    % Bárður og Knút
    TidalTurbine.MadeUp.name = 'Hypothetical turbine ~1 MW';
    TidalTurbine.MadeUp.rPow = 1; % MW
    TidalTurbine.MadeUp.eff = 0.4; % scalar
    TidalTurbine.MadeUp.area = pi * (20/2)^2; % m^2
    TidalTurbine.MadeUp.minSpeed = 1; % m/s
    TidalTurbine.MadeUp.ratedSpeed = 2.5; % m/s
end