function RainfallMatrix = GridPtData2RainfallMatrix(inputData)
load F:\Projects\2_Perfm_Analysis_Rain_Data\A_Datasets\Valid_IMD_Grid_Location.mat
RainfallMatrix(1:135,1:129)=NaN;
for i=1:length(loc)
    RainfallMatrix(loc(i,2),loc(i,1),1)=inputData(i);
end

end

