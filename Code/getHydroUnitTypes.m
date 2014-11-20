function HydroGenerator = getHydroUnitTypes()
    Fossa1.name = 'Pelton/Maier/Th.B. Thrige 2.1 MW';
    Fossa1.rPow = 2.1; % MW
    Fossa1.rFlx = 1.25; % m^3/s
    Fossa1.eff = 0.92;
    HydroGenerator.Fossa1 = Fossa1;
    
    Fossa2.name = 'Francis/Voith/Titan 4.2 MW';
    Fossa2.rPow = 4.2; % MW
    Fossa2.rFlx = 2.5; % m^3/s
    Fossa2.eff = 0.92;
    HydroGenerator.Fossa2 = Fossa2;
    
    Heyga1.name = 'Francis/Voith/Titan 4.8 MW';
    Heyga1.rPow = 4.8;
    Heyga1.rFlx = 6;
    Heyga1.eff = 0.92;
    HydroGenerator.Heyga1 = Heyga1;
    
    Myru1.name = 'Francis/Voith/ASEA 2.4 MW';
    Myru1.rPow = 2.4;
    Myru1.rFlx = 1.3;
    Myru1.eff = 0.92;
    HydroGenerator.Myru1 = Myru1;
    
    Eidi1.name = 'Francis/Voith/Nebb 6.7 MW';
    Eidi1.rPow = 6.7;
    Eidi1.rFlx = 5;
    Eidi1.eff = 0.92;
    HydroGenerator.Eidi1 = Eidi1;
    
    Eidi2.name = 'Francis/Voith/TDPS 7.7 MW';
    Eidi2.rPow = 7.7;
    Eidi2.rFlx = 5.7;
    Eidi2.eff = 0.92;
    HydroGenerator.Eidi2 = Eidi2;
    
    Strond1.name = 'Francis/Sulzer/Leroy Summer 1.4 MW';
    Strond1.rPow = 1.4;
    Strond1.rFlx = 0.74;
    Strond1.eff = 0.92;
    HydroGenerator.Strond1 = Strond1;
end