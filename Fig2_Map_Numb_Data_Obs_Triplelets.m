%% Loading datasets 
clear
clc

load F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\METC_Outcome_With_IMD_IMDAA_CHIRPS.mat
n(:,1)=gridN;
load F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\METC_Outcome_With_IMD_ERA5_CHIRPS.mat
n(:,2)=gridN;

ind_bound=shaperead("F:\Projects\2_Perfm_Analysis_Rain_Data\A_Datasets\India_BoundaryShapefile\India_Boundary_Marged.shp");
lsBound=shaperead('F:\Projects\4_Ranking_Rainfall_Datasets\Datasets\World_Country_Shapefile\SA_Land_Sea_Mask_Line.shp');
load F:\Projects\2_Perfm_Analysis_Rain_Data\A_Datasets\IMD_XY_Info.mat

for i=1:2
    plotMat(:,:,i)=GridPtData2RainfallMatrix(n(:,i));
end

%% Plotting
t=tiledlayout(2,3);
%tltTxt={'(a) Triplet Group 1: IMD-IMDAA-ERA5 Land','(b) Triplet Group 2: IMD-CHIRPS-MSWEP'};
tltTxt={'(a) Triplet Group 1: IMD-IMDAA-CHIRPS','(b) Triplet Group 2: IMD-ERA5 Land-CHIRPS'};

%[x_tik, y_tik] = xyTick_Creation([65 100],[5 40],5,5);

for i=1:2
nexttile
m=plotMat(:,:,i);
m(m==0)=NaN;
axesm bonne
map=pcolor(x,y,m');
map.EdgeAlpha=0;
hold on

set(gca,'FontSize',12,'XLim',[65 100],'YLim',[5 40], ...
    'XTick',65:5:100,'YTick',5:5:40,'Color', ...
    '#F9F9F9','TickDir','out','Box','off', ...
    'GridLineStyle','--','GridLineWidth',1,'GridColor', ...
    '#525252','Layer','bottom','XTickLabelRotation',90, ...
    'XTickLabel','','YTickLabel','','TickLength',[0 0])
xline(100)
yline(40)
grid on
clim([0 700])
title(tltTxt{i},'FontSize',14,'FontWeight','normal')

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

end

addpath F:\Projects\2_Perfm_Analysis_Rain_Data\B_Codes\Colorpmaps\ColorBrewer_v2\cbrewer2\
colormap(flip(cbrewer2('Spectral')))


t.Padding='compact';
t.TileSpacing='compact';

cb=colorbar;
cb.FontSize=15;
cb.Label.String='Number of Data Points';
cb.Location="southoutside";
cb.Ticks=0:100:700;












