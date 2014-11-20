function PsUnit = getPsUnitTypes()
    Heyga1.name = 'Francis/Voith/Titan 4.8 MW';
    Heyga1.rPow = 4.8;
    Heyga1.rFlx = 6;
    Heyga1.eff = 0.92;
    Heyga1.pPow = 4.8;
    Heyga1.pFlx = 4.5;
    Heyga1.pEff = 0.80;
    PsUnit.Heyga1 = Heyga1;
    
    Myru1.name = 'Francis/Voith/ASEA 2.4 MW + 2.4 MW pump';
    Myru1.rPow = 2.4;
    Myru1.rFlx = 1.3;
    Myru1.eff = 0.92;
    Myru1.pPow = 2.4;
    Myru1.pFlx = 1.1;
    Myru1.pEff = 0.80;
    PsUnit.Myru1 = Myru1;
end