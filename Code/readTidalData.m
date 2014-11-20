function tideSpeed = readTidalData( loc, timeAxis )
% readTidalData generates tidal data ( reading).
% 
% tideSpeed = readTidalData( loc, timeAxis ) generates a vector of tidal
% speed data (tideSpeed) from a location (loc) and a time axis (timeAxis).
% 
% Input:
% * loc: The location for which to generate tidal data.
%        Options are: 'Vest' = Vestmannasund.
%                     'Leir' = Leirvíksfjørður.
%                     'Hest' = Hestfjørður.
% * timeAxis: vector representing points-in-time.
%             Format is the output of datenum().
% 
% Output:
% * tideSpeed: vector with tidal speeds for each point in timeAxis (m/s).

% constituents to use:
% Names=['M2  ';'S2  ';'N2  ';'M4  ';'MS4 ';'O1  '];

% define fequencies of constituents
M2 = 0.0805114007000000;
S2  = 0.0833333333000000;
N2  = 0.0789992488000000;
M4  = 0.161022801300000;
MS4 = 0.163844734000000;
O1  = 0.0387306544000000;
FRE = [M2 S2 N2 M4 MS4 O1];

% define phase corrections of constituents relative to 
phaCorM2  = 136.4902;
phaCorS2  = 8.8685e-07;
phaCorN2  = 8.0598;
phaCorM4  = 272.9804;
phaCorMS4 = 136.4902;
phaCorO1  = 126.5171;
CORPH = [phaCorM2 phaCorS2 phaCorN2 phaCorM4 phaCorMS4 phaCorO1];

% user fitted phase corrections to measurements from fjords (Skop,Sudu,Leirv)
%              M2  S2  N2  M4  MS4 O1
User_PHA_Corr=[12  23  16  0   0  -4];


% load tidal coonstants of location and store relevant in strucsure S
load('TidalConst_3locations.mat') % Hest, Leirv and Vest
if strcmp('Vest',loc)
    S=Vest;
elseif strcmp('Leir',loc)
    S=Leirv;
elseif strcmp('Hest',loc)
    S=Hest;
else
    error('Something wrong with Input Variable Loc')
end

% time axis is defined
Time=timeAxis;
Rel_Time=24*(Time-datenum(2000,1,1,0,0,0));
L=length(Rel_Time);

% prepare for calculations
Cur   = zeros(L,1);
tideSpeed = zeros(L,1);
Maj = [S.M2_Maj S.S2_Maj S.N2_Maj S.M4_Maj S.MS4_Maj S.O1_Maj];
Min = [S.M2_Min S.S2_Min S.N2_Min S.M4_Min S.MS4_Min S.O1_Min];
Inc = [S.M2_Inc S.S2_Inc S.N2_Inc S.M4_Inc S.MS4_Inc S.O1_Inc];
Pha = [S.M2_Pha S.S2_Pha S.N2_Pha S.M4_Pha S.MS4_Pha S.O1_Pha];
Pha = Pha - CORPH + User_PHA_Corr;
Period = 2 * pi * FRE; 
Wp = 0.5 * (Maj+Min); 
Wm = Maj - Wp;
fp = Inc - Pha;
fp_deg = fp .* pi/180;
fm = Inc + Pha;
fm_deg = fm .* pi/180;

% main time loop
for nt=1:L
     t=Rel_Time(nt);
     Cur(nt) = sum (Wp .* exp( 1i .* ( Period*t+fp_deg) ) + Wm.*exp( -1i .* ( Period*t-fm_deg))) + S.Res;
     %Cur(nt) = Wp .* exp( i .* ( 2*pi*Freq*t+fp*pi/180) ) + Wm.*exp(-i.*( 2*pi*Freq*t-fm*pi/180) );
end

tideSpeed = abs(Cur);

end % main function
