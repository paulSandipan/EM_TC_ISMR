%% Loading datasets 
clear
clc

load F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\METC_Outcome_With_IMD_IMDAA_CHIRPS.mat
load F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\Avg_Bootstrap_Samples_With_IMD_IMDAA_CHIRPS.mat
% For Linear Scale
    avgRMSE(:,1:3)=squeeze(mean(sqrt(tcRMSE).*avg,2,'omitmissing'));
    sdRMSE(:,1:3)=squeeze(std(sqrt(tcRMSE).*avg,[],2,'omitmissing'));

load F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\METC_Outcome_With_IMD_ERA5_CHIRPS.mat
load F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\Avg_Bootstrap_Samples_With_IMD_ERA5_CHIRPS.mat
% For Linear Scale
    avgRMSE(:,4:6)=squeeze(mean(sqrt(tcRMSE).*avg,2,'omitmissing'));
    sdRMSE(:,4:6)=squeeze(std(sqrt(tcRMSE).*avg,[],2,'omitmissing'));

load F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\Weekly_Aggregated_Rainfall_ISMR.mat

avgRain(:,1)=mean(AggData(:,:,1),'omitmissing');
avgRain(:,2)=mean(AggData(:,:,2),'omitmissing');
avgRain(:,3)=mean(AggData(:,:,4),'omitmissing');
avgRain(:,4)=mean(AggData(:,:,1),'omitmissing');
avgRain(:,5)=mean(AggData(:,:,3),'omitmissing');
avgRain(:,6)=mean(AggData(:,:,4),'omitmissing');

avgRMSE=(avgRMSE./avgRain)*100;

%% Load Koppen Gieger Locations
cd F:\Projects\8_Extrem_Precip_Analyis_Multi_Datasets\Datasets\KG_Grid_Locations\
loc=NaN(4965,5);
unitName={'Am','Aw','BSh','BWh','Cwa'};
for i=1:5
    load([unitName{i} '.mat'])
    loc(1:length(grid_loc),i)=grid_loc;
end

clearvars -except avgRMSE loc

%% Plotting
t=tiledlayout(2,3);
clSchm={'b','#ff7f00','#4DBEEE','b','r','#4DBEEE'};%{'b','#33a02c','r','b','#ff7f00','#4DBEEE'};
unitName={'a: Tropical Monsson (Am)','b: Tropical Savanna (Aw)','c: Hot Steepe (BSh)','d: Hot Desert (BWh)','e: Temperate (Cwa)'};
for i=1:5
nexttile
for j=1:length(loc)
    if ~isnan(loc(j,i))
        zoneAvgRMSE(j,1:6)=avgRMSE(loc(j,i),:);
    else
        zoneAvgRMSE(j,1:6)=NaN;
    end
end

n=length(zoneAvgRMSE);

for j=1:6
    if j==1
    boxchart(zoneAvgRMSE(:,j),'MarkerStyle','none','BoxFaceColor',clSchm{j},'LineWidth',1.2,'BoxWidth',0.5)
    hold on
    else
        boxchart([nan(n,j-1) zoneAvgRMSE(:,j)],'MarkerStyle','none','BoxFaceColor',clSchm{j},'LineWidth',1.2,'BoxWidth',0.5)
    end
end

xline(6.5)
xline(3.5,'--')
yline([250 0 -20])
set(gca,'FontSize',14,'TickDir','out','YLim',[-20 250], ...
    'YTick',0:50:250,'Box','off', ...
     'TickLength',[0.02 0.02],'XTickLabel','','XTick','')
area([0 6.5],[-20 -20],'FaceColor','#f0f0f0','EdgeColor','none')
text(2,-10,'Group 1','FontSize',14,'HorizontalAlignment','center')
text(5,-10,'Group 2','FontSize',14,'HorizontalAlignment','center')
pbaspect([1.5 1.2 1])
ylabel({['(RMSE / Mean Rainfall) \times 100'] ['(mm/week)']})
title(unitName{i},"FontSize",14,'FontWeight','normal')
end



