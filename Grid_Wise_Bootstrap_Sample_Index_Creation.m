clear
clc

tic 

path = 'F:\Projects\12_Triple_Collocation_Rainfall_Datasets\Datsets\BootStrapSamples\';  

% Define the Vector of the data point index
data=1:680;
data=data(:);

% Assign the bootstrap sample length
sampLen=round(0.7*size(data,1),0);

% Create a blank variable that will be filled by the bootstrap samples
for k=1:4964
clear samples
samples=NaN(sampLen,1000);
for i=1:1000
    samples(:,i)=datasample(data,sampLen,'Replace',false);
end

% Define the saving matfile name configuration 
matFileName = sprintf('Bootstrap_Sample_Grid_No_%d.mat', k);

% saving the samples for a particular grid of the current run
save([path matFileName],"samples",'-v7.3')

if rem(k,100)==0
disp([sprintf('Bootstrap Sample for Grid No %d', k) ' is done'])
end

end

toc