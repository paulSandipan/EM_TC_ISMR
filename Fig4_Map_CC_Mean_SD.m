clear
clc

t=tiledlayout(3,4);
% Data Index: IMD(1), IMDAA(2), ERA5(3), CHIRPS(4)
groupComb=["IMD_IMDAA_CHIRPS";"IMD_ERA5_CHIRPS"];
%cLim=[0 1]; % mean CC
cLim=[0 20]; % sd CC
%tileIdx=[1 2  3  4; 5 6  7  8;9 10 11 12];

for j=1:length(groupComb)
    %plotEMTCvars(groupComb(j),tileIdx(:,j),cLim,'mean')
    plotEMTCvars(groupComb(j),tileIdx(:,j),cLim,'sd')
end


% addpath F:\Projects\2_Perfm_Analysis_Rain_Data\B_Codes\Colorpmaps\ColorBrewer_v2\cbrewer2\
% colormap(flip(cbrewer2('Spectral')))
addpath F:\Projects\Colorpmaps\NCL_Colormaps\
cMap=MPL_terrain;
colormap(cMap(5:end-30,:))

t.Padding='compact';t.TileSpacing='compact';

% cb=colorbar;
% cb.FontSize=15;

%% ------------------- Plotting Function ----------------------
function plotEMTCvars(groupTxt,loc,cLim,plotVar)
%------------------------- Loading datasets -------------------------------------
pathIn='F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\';
txt2=strcat(pathIn,"METC_Outcome_With_",groupTxt,".mat");
load(txt2)

avgCC(:,1:3)=squeeze(mean(tcCC,2,'omitmissing'));
sdCC(:,1:3)=squeeze(std(tcCC,[],2,'omitmissing'));

if string(plotVar) == "mean"; data=avgCC ;
else; data=(sdCC./avgCC)*100; end

for i=1:size(data,2)
    plotMat(:,:,i)=GridPtData2RainfallMatrix(data(:,i));
end

%clearvars -except plotMat avgRMSE sdRMSE groupTxt

ind_bound=shaperead("F:\Projects\2_Perfm_Analysis_Rain_Data\A_Datasets\India_BoundaryShapefile\India_Boundary_Marged.shp");
lsBound=shaperead('F:\Projects\4_Ranking_Rainfall_Datasets\Datasets\World_Country_Shapefile\SA_Land_Sea_Mask_Line.shp');
f=char(groupTxt);
idx=1;row=1;
for k=1:length(f)
    if string(f(k))=="_"
        dataName(row,1)=string(f(idx:k-1));
        idx=k+1;
        row=row+1;
    elseif k==length(f)
        dataName(row,1)=string(f(idx:k));
    end
end
load F:\Projects\2_Perfm_Analysis_Rain_Data\A_Datasets\IMD_XY_Info.mat

%------------------- Plotting - Bootstrap Sample Means & SD --------------------
tltTxt=strcat("Group : ", dataName(1),"-",dataName(2),"-",dataName(3));
%[%[x_tik, y_tik] = xyTick_Creation([65 100],[5 40],5,5);
x_tik=""; y_tik="";

for i=1:3
nexttile(loc(i))
m=plotMat(:,:,i);
imagescn(x,y,m')
axis xy
hold on

set(gca,'FontSize',12,'XLim',[65 100],'YLim',[5 40], ...
    'XTick',65:5:100,'YTick',5:5:40,'Color', ...
    '#F9F9F9','TickDir','out','Box','off', ...
    'GridLineStyle','--','GridLineWidth',1,'GridColor', ...
    '#525252','Layer','bottom','XTickLabelRotation',90, ...
    'XTickLabel',x_tik,'YTickLabel',y_tik,'TickLength',[0 0])
xline(100)
yline(40)
grid on
clim(cLim)
text(99,37.5,dataName(i),'FontSize',14,'FontWeight','normal','HorizontalAlignment','right')
if i==1; title(tltTxt,'FontSize',14); end

% Plot Koppen-Giegger Zones
kg_zones=["Zone11_Cwa_Temperate_dry_winter_hot_summer.shp","Zone3_Aw_Tropical_savannah.shp","Zone4_BWh__Arid_desert__hot.shp","Zone5_BWk__Arid_desert_cold.shp","Zone7_BSk_Arid_steppe_cold.shp"]';
path="F:\Projects\2_Perfm_Analysis_Rain_Data\A_Datasets\Hydroclimatic_Unit_Shapefiles\Final_Shapefiles\Kopen_Gigger_Zones\";
for k=1:length(kg_zones)
    roi=shaperead(strcat(path,kg_zones(k)));
    structNum=size(roi,1);
    for kk=1:structNum
        structAccess=roi(kk);
        plot(structAccess.X,structAccess.Y,'LineWidth',0.8,'Color','k','LineStyle','--')
        hold on
    end
end

plot(lsBound.X,lsBound.Y,'LineWidth',1,'Color','k');
plot(ind_bound.X,ind_bound.Y,'LineWidth',1,'Color','k')

%colorbar

pbaspect([1 1 1])

end

end % Function Ends
