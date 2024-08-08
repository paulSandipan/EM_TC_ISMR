clear
clc

% Data Index: IMD(1), IMDAA(2), ERA5(3), CHIRPS(4)
groupTxt=["IMD_IMDAA_ERA5"; "IMD_IMDAA_CHIRPS"; "IMD_ERA5_CHIRPS"];
groupInd=[1 2 3; 1 2 4; 1 3 4];
delIdx=[4 5; 3 5; 2 5];

for i=1:3
    EMTC_Triplet_Implementation(delIdx(i,:),groupTxt(i,:))
    disp(['Computatiion for Triplet Group ' num2str(i) ' is done'])
end





