%% Load the datasets and define the basic dependencies
clear 
clc

load F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\Original_Rainfall_Datsets\IMD_Grid_Rain_Extraction.mat

load F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\Original_Rainfall_Datsets\IMDAA_Grid_Rain_Extraction.mat
load F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\Original_Rainfall_Datsets\ERA5_Grid_Rain_Extraction.mat

load F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\Original_Rainfall_Datsets\Chirps_Grid_Rain_Extraction.mat

load F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\Weekly_Aggregated_Rainfall_ISMR.mat

avgRain(:,1)=mean(AggData,'omitmissing');
avgRain(:,2)=mean(imdaa_rain,'omitmissing');
avgRain(:,3)=mean(era5_rain,'omitmissing');
avgRain(:,4)=mean(chirps_rain,'omitmissing');

clearvars -except avgRain

ind_bound=shaperead("F:\Projects\2_Perfm_Analysis_Rain_Data\A_Datasets\India_BoundaryShapefile\India_Boundary_Marged.shp");
lsBound=shaperead('F:\Projects\4_Ranking_Rainfall_Datasets\Datasets\World_Country_Shapefile\SA_Land_Sea_Mask_Line.shp');
dataName=["IMD","IMDAA","ERA5 Land","CHIRPS"];
figIdx=["a: ","b: ","c: ","d: "];
load F:\Projects\2_Perfm_Analysis_Rain_Data\A_Datasets\IMD_XY_Info.mat

for i=1:size(avgRain,2)
    plotMat(:,:,i)=GridPtData2RainfallMatrix(avgRain(:,i));
end

%% Plotting
t=tiledlayout(2,3);
[x_tik, y_tik] = xyTick_Creation([65 100],[5 40],5,5);

cLim=[0 50]; 

for i=1:4
nexttile
m=plotMat(:,:,i); 
axesm eqacylin
%map=pcolor(x,y,m');map.EdgeAlpha=0;
imagescn(x,y,m')
axis xy
hold on

set(gca,'FontSize',12,'XLim',[65 100],'YLim',[5 40], ...
    'XTick',65:5:100,'YTick',5:5:40,'Color', ...
    '#F9F9F9','TickDir','out','Box','off', ...
    'GridLineStyle','--','GridLineWidth',1,'GridColor', ...
    '#525252','Layer','bottom','XTickLabelRotation',90, ...
    'XTickLabel',x_tik,'YTickLabel',y_tik,'TickLength',[0.02 0.02])
xline(100)
yline(40)
grid on
clim(cLim)
txt=strcat(figIdx(i)," Rainfall Climatology in (1981-2020) ", dataName(i));
title(txt,'FontSize',14,'FontWeight','normal')

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

colorbar

end

addpath F:\Projects\2_Perfm_Analysis_Rain_Data\B_Codes\Colorpmaps\ColorBrewer_v2\cbrewer2\
colormap((cbrewer2('YlGnBu')))

t.Padding='compact';
t.TileSpacing='compact';

cb=colorbar;
cb.FontSize=15;


%text(65,38,txt,'FontSize',13,'FontWeight','normal','BackgroundColor','w','EdgeColor','k')





