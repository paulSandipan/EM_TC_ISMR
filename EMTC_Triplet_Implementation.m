function EMTC_Triplet_Implementation(delIdx,groupTxt)
        %EMTC_Triplet_Implementation(groupInd,groupTxt)

% clear
% clc
tic

disp('-------------------------------------------')
disp('------ METC Computation has initiated -----')

path = 'F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\BootStrapSamples\';

% Load Rainfall Dataset and process it
load F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\Weekly_Aggregated_Rainfall_ISMR.mat

AggData(:,:,delIdx)=[];
AggData(AggData<2.5)=NaN; % Rainfall/no-rainfall threshold is choosen as 2.5mm/day as per IMD norms
LnAggData=log(AggData);

% Start Triple Collocation for Each Grid
for i=1:size(LnAggData,2) % Grid Index

    % Origianal log transformed rainfall data of the current grid
    clear iData ind rmse rho n idx
    iData=squeeze(LnAggData(:,i,1:3));

    % METC using the full set of original data
    ind=~isnan(iData(:,1)) & ~isnan(iData(:,2)) & ~isnan(iData(:,3));
    idx=find(ind==1);
    n=length(idx);
    if n>=30
        [rmse, rho] = ETC(iData(idx,:),'off');
    else
        rmse(1:3)=NaN; rho(1:3)=NaN;
    end

    if any(rmse<0) || any(rho<0)
        gridRMSE(i,1:3)=NaN;
        gridCC(i,1:3)=NaN;
    else
        gridRMSE(i,1:3)=rmse;
        gridCC(i,1:3)=rho;
    end
    gridN(i,1)=n;

    % Load the bootstrap samples for the current grid
    clear samples
    load([path 'Bootstrap_Sample_Grid_No_' num2str(i) '.mat'])

    for j=1:size(samples,2)% Bootstrap sample index

        % Define the three triplet (x,y,z) for each bootstrap sample
        clear x y x idx rmse rho
        x=iData(samples(:,j),1);    y=iData(samples(:,j),2);    z=iData(samples(:,j),3);
        idx=isnan(x) | isnan(y) | isnan(z); % Find the location where any
        x(idx)=[];  y(idx)=[];  z(idx)=[];

        if length(x)>=30
            avg(i,j,1)=mean(exp(x),'omitnan');
            avg(i,j,2)=mean(exp(y),'omitnan');
            avg(i,j,3)=mean(exp(z),'omitnan');
        else
            avg(i,j,1:3)=NaN;
        end

        if length(x)>=30
            [rmse, rho] = ETC([x,y,z],'off');
        else
            rmse(1:3)=NaN; rho(1:3)=NaN;
        end

        if any(rmse<0) || any(rho<0)
            tcRMSE(i,j,1:3)=NaN;
            tcCC(i,j,1:3)=NaN;
        else
            tcRMSE(i,j,1:3)=rmse;
            tcCC(i,j,1:3)=rho;
        end
        tcN(i,j)=length(x);

    end % j loop ends

    if rem(i,1000)==0
        disp(['METC Computation of ' num2str(i) ' grids are done'])
    end

end % i loop ends

% Saving the outputs
pathOut="F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\";
txt1=strcat(pathOut,"Avg_Bootstrap_Samples_With_",groupTxt,".mat");
txt2=strcat(pathOut,"METC_Outcome_With_",groupTxt,".mat");
save(txt1,'avg')
save(txt2,'tcRMSE','tcCC','tcN','gridN',"gridCC",'gridRMSE','-v7.3')

disp('METC Computation of all grids are done')

toc

end