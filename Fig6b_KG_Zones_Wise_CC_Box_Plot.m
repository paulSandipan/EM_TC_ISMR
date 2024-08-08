%% Loading datasets 
clear
clc

load F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\METC_Outcome_With_IMD_IMDAA_CHIRPS.mat
load F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\Avg_Bootstrap_Samples_With_IMD_IMDAA_CHIRPS.mat
avgCC(:,1:3)=squeeze(mean(tcCC,2,'omitmissing'));
%sdCC(:,1:3)=squeeze(std(tcCC,[],2,'omitmissing'));

load F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\METC_Outcome_With_IMD_ERA5_CHIRPS.mat
load F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\Avg_Bootstrap_Samples_With_IMD_ERA5_CHIRPS.mat
avgCC(:,4:6)=squeeze(mean(tcCC,2,'omitmissing'));
%sdCC(:,4:6)=squeeze(std(tcCC,[],2,'omitmissing'));


% Load Koppen Gieger Locations
cd F:\Projects\8_Extrem_Precip_Analyis_Multi_Datasets\Datasets\KG_Grid_Locations\
loc=NaN(4965,5);
unitName={'Am','Aw','BSh','BWh','Cwa'};
for i=1:5
    load([unitName{i} '.mat'])
    loc(1:length(grid_loc),i)=grid_loc;
end

clearvars -except avgCC loc

%% Plotting
t=tiledlayout(2,3);
clSchm={'b','#ff7f00','#4DBEEE','b','r','#4DBEEE'};%{'b','#33a02c','r','b','#ff7f00','#4DBEEE'};
unitName={'a: Tropical Monsson (Am)','b: Tropical Savanna (Aw)','c: Hot Steepe (BSh)','d: Hot Desert (BWh)','e: Temperate (Cwa)'};
for i=1:5
nexttile
for j=1:length(loc)
    if ~isnan(loc(j,i))
        zoneAvgRMSE(j,1:6)=avgCC(loc(j,i),:);
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

xline([-0.1 6.5])
xline(3.5,'--')
yline([1 0 -0.1])
set(gca,'FontSize',14,'TickDir','out','YLim',[-0.1 1], ...
    'YTick',0:0.2:1,'Box','off', ...
          'TickLength',[0.02 0.02],'XTickLabel','','XTick','')
area([0 6.5],[-0.2 -0.2],'FaceColor','#f0f0f0','EdgeColor','none')
text(2,-0.05,'Group 1','FontSize',14,'HorizontalAlignment','center')
text(5,-0.05,'Group 2','FontSize',14,'HorizontalAlignment','center')
pbaspect([1.5 1.2 1])
ylabel('Correlation Coefficient')
title(unitName{i},"FontSize",14,'FontWeight','normal')
end



