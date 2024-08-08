%% Loading datasets
clear
clc
groupComb=["IMD_IMDAA_CHIRPS";"IMD_ERA5_CHIRPS";"IMD_IMDAA_CHIRPS";"IMD_ERA5_CHIRPS"];
pathIn='F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\';
col=1;
for i=1:8
    groupTxt=groupComb(i);
    pathIn='F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\';
    txt1=strcat(pathIn,"Avg_Bootstrap_Samples_With_",groupTxt,".mat");
    txt2=strcat(pathIn,"METC_Outcome_With_",groupTxt,".mat");
    load(txt1)
    load(txt2)
    if i<=4; avgVar(:,1:3)=squeeze(mean(sqrt(tcRMSE).*avg,2,'omitmissing'));
    else; avgVar(:,1:3)=squeeze(mean(tcCC,2,'omitmissing'));end
    data(:,col,1:3)=avgVar;
    col=col+1;

    f=char(groupTxt);
    idx=1;row=1;
    for k=1:length(f)
        if string(f(k))=="_"
            dataName(row,i)=string(f(idx:k-1));
            idx=k+1;
            row=row+1;
        elseif k==length(f)
            dataName(row,i)=string(f(idx:k));
        end
    end

end

clearvars -except data dataName

%% Plotting
tltTxt=["a: " "b: ";"c: " "d: ";"e: " "f: ";"g: " "h: "];
AllCols={'b','#ff7f00','r','#4DBEEE','#33a02c'};
dataPos=string({'IMD', 'IMDAA', 'ERA5', 'CHIRPS'});
t=tiledlayout(4,4);
for i=1:4
    groupInd=dataName(:,i);
    for j=1:3; idx(j)=find(dataPos==groupInd(j)); end
    clSchm={AllCols{idx(1)} AllCols{idx(2)} AllCols{idx(3)}};
    nexttile
    for j=1:3
    x=data(:,i,j);
    x(x==0)=NaN;
    if i<5; bw=0.3; else; bw=0.07; end
    if i>4; [jY,jX]=ksdensity(x,'Function','pdf','Bandwidth',bw,'Support',[0 1],'Kernel','normal');
    else; [jY,jX]=ksdensity(x,'Function','pdf','Bandwidth',bw,'Support','positive','Kernel','normal'); end
    if i<5; plot(jX,jY*100,'LineStyle','-','LineWidth',1.5,'Color',clSchm{j});
    else; plot(jX,jY,'LineStyle','-','LineWidth',1.5,'Color',clSchm{j}); end
    hold on
    end
    if i<=4; Lim=[120 6]; Diff=[30 2]; else; Lim=[1 6]; Diff=[0.2 2]; end
    set(gca,'FontSize',14,'TickDir','out','XLim',[0 Lim(1)], ...
        'YLim',[0 Lim(2)],'YTick',0:Diff(2):Lim(2),'Box','off', ...
        'XTick',0:Diff(1):Lim(1),'TickLength',[0.025 0.025])
    if i==1 || i==5; ylabel('Kernel Density Estimate','FontSize',14); end
    xline(Lim(1))
    yline(Lim(2))
    if i<=4; xlabel('Mean RMSE'); else; xlabel('Mean CC'); end
    if i>4; loc='northwest'; else; loc='northeast'; end
    lgd=legend(strcat(dataName(1:3,i),"",""),'Location',loc);
    lgd.FontSize=12;
    if i<=4; title(lgd,strcat(tltTxt(i)," Group ",num2str(i+2)),'FontWeight','normal');
    else;title(lgd,strcat(tltTxt(i)," Group ",num2str(i-4+2)),'FontWeight','normal');end
    pbaspect([2 1 1])
end

t.Padding='compact';
t.TileSpacing='compact';

