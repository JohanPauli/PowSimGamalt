function SolarPanel = getSolarUnitTypes()
    % Specs from:
    % Nowhere, they're made up.
    SolarPanel.MadeUp.name = 'Hypothetical panel at ~200 W/m^2';
    SolarPanel.MadeUp.rPow = 0.002; % MW
    SolarPanel.MadeUp.eff = 0.2; % % (percent)
    SolarPanel.MadeUp.minIns = 10; % W/m^2
    SolarPanel.MadeUp.area = 10; % m^2
end