function lossvalue=lossfuncDC(Y,Sfit,W,cost)
% this function computes 1-DC, comparing predicted roi vertices with actual
% vertices

actualROIVertices=Y(:,2);

SfitBinary=Sfit>0;
predictedROIVertices=SfitBinary(:,2);

correctPredictions=(predictedROIVertices>0 & actualROIVertices>0);

DC=2*(sum(correctPredictions))/(sum(actualROIVertices)+sum(predictedROIVertices));

lossvalue=1-DC;


end