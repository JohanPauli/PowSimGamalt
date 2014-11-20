function WindTurbine = getWindUnitTypes()
    % Specs from:
    % 'Power curve for E44 900kW.pdf'
    WindTurbine.EnerconE44.name = 'Enercon E44 900 kW';
    WindTurbine.EnerconE44.rPow = 0.900; % MW
    WindTurbine.EnerconE44.powerCurve = [linspace(1,34,34) ...
        ; [0 0 4 20 50 96 156 238 340 466 600 710 790 850 880 905 ...
           910 910 910 910 910 910 910 910 910 ... % approx ->
           850 710 600 466 340 156 96 50 20] ]';
    
    % Specs from:
    % windturbinewarehouse.com/pdfs/nordtank/Nordtank_150_SAC_DSM_4_20_07-unenc.pdf
    WindTurbine.Nordtank.name = 'Nordtank 150 kW';
    WindTurbine.Nordtank.rPow = 0.150; % MW
    WindTurbine.Nordtank.powerCurve = [linspace(1,25,25) ...
        ; [ 0 0 0 2.4 13.4 30.4 49.3 70.9 93.9 116.3 136.7 153.9 164.5 ...
            168 167.4 165.1 162.4 160.9 160 160 160 160 160 160 160] ]';
    
    % Specs from:
    % http://www.iufmrese.cict.fr/concours/2002/CG_2002STI_lycee/Pour_en_savoir_plus/Vestas_V47.pdf
    WindTurbine.VestasV47.name = 'Vestas V47 660 kW';
    WindTurbine.VestasV47.rPow = 0.660; % MW
    WindTurbine.VestasV47.powerCurve = [linspace(1,25,25) ...
        ; [ 0 0 0 2.9 43.8 96.7 166 252 350 450 538 600 635 651 657 ...
            659 660 660 660 660 660 660 660 660 660] ]';
end