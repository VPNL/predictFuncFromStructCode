clear all;

outFolder=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMatrixes/Leave1OutLinearGrp2');
inFolder=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/PredictMatrixesMNI');
ROIs={'lh_OTS_fsavg_regression'};

predictors={'T1Gray' 'ILF' 'AF' 'VOF'}
zScore='true';
deMean='false';
cnt=0;
%
% figDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/Plots',strcat('predictionLinearReg','_',predictors{:}))
% mkdir(figDir);
%subjects=[2 5 8 11 13 14 16 18 22 30]
subjects=[1 3 4 6 7 9 10 12 15 17 19 20 21 23 24 25 26 27 28 29]
for r=1:length(ROIs)
    for subjectToPredict=subjects
        cnt=cnt+1;
        subjectsForPrediction=subjects(subjects~=subjectToPredict);
        cd(inFolder);
        
        if find(strcmp(predictors,'GrpMapS'))>0
            predictors{find(strcmp(predictors,'GrpMapS'))}=strcat('GrpMapSL',num2str(subjectToPredict));
        end
        
        if find(strcmp(predictors,'GrpMapV'))>0
            predictors{find(strcmp(predictors,'GrpMapV'))}=strcat('GrpMapVL',num2str(subjectToPredict));
        end
        
        currentSubject=subjectToPredict
        % concat response and predictor matrixes for all N expect 1
        for i=1:length(subjectsForPrediction)
            load(strcat('Subject_',num2str(subjectsForPrediction(i)),'_',ROIs{r}));
            
            if strcmp(zScore,'true')>0 %should the predictors be zScored?
                individualsPredictors=zscore(table2array(predictorsT(:,predictors)));
                
            elseif strcmp(deMean,'true')>0
                individualsPredictors=table2array(predictorsT(:,predictors));
                individualsPredictorsMean=mean(individualsPredictors);
                individualsPredictors=individualsPredictors-individualsPredictorsMean;
                
            else strcmp(deMean,'true')>0
                individualsPredictors=table2array(predictorsT(:,predictors));
            end
            
            individualsResponseRead=responseRead;
            if strcmp(zScore,'true')>0 %should the predictors be zScored?
                individualsResponseRead=zscore(individualsResponseRead);
                
            elseif strcmp(deMean,'true')>0
                individualsResponseReadMean=mean( individualsResponseRead);
                individualsResponseRead= individualsResponseRead- individualsResponseReadMean;
            end
            
            if i==1
                predictorsMinus1=individualsPredictors;
                responseReadMinus1=individualsResponseRead;
            else
                predictorsMinus1=vertcat(predictorsMinus1, individualsPredictors);
                responseReadMinus1=vertcat(responseReadMinus1, individualsResponseRead);
                clear('individualsPredictors','individualsResponseMath','individualsReponseRead','predictorsT','responseMath','responseRead');
            end
        end
        
        % fit svm from concatenated and tresholded responses
        linModelRead = fitlm(predictorsMinus1,responseReadMinus1,'RobustOpts','off'); %this is what matlab recommends
        %fixedModelRead = fitlm(predictorsTable,'Response~AF^3')
        
        %ScoreSVMModelRead = fitPosterior(SVMModelRead,predictorsMinus1,responseReadTraining);
        
        %load predictors for left out subject and predict responses
        load(strcat('Subject_',num2str(subjectToPredict),'_',ROIs{r}));
        
        if  strcmp(zScore,'true')>0  %should the predictors be zScored?
            predictorsSubjectToPredict=zscore(table2array(predictorsT(:,predictors)));
            
        elseif strcmp(deMean,'true')>0
            predictorsSubjectToPredict=table2array(predictorsT(:,predictors));
            predictorsSubjectToPredictMean=mean(predictorsSubjectToPredict);
            predictorsSubjectToPredict=predictorsSubjectToPredict-predictorsSubjectToPredictMean;
        else
            
            predictorsSubjectToPredict=table2array(predictorsT(:,predictors));
        end
        
        [readResponsePredicted]=predict(linModelRead,predictorsSubjectToPredict);
        %readResponsePredicted=zscore(readResponsePredicted);
        % [readLabel,readScore]=predict(ScoreSVMModelRead,predictorsA_zS);
        
        if  strcmp(zScore,'true')>0  %should the predictors be zScored?
            responseRead=zscore(responseRead);
            
        elseif strcmp(deMean,'true')>0
            responseReadMean=mean(responseRead);
            responseRead=responseRead-responseReadMean;
        end
        
        
        
        [~,peakIndexes]=sort(responseRead(:,1),'descend');
        [~,lowIndexes]=sort(responseRead(:,1),'ascend');
        roisize10=round(0.1*size(responseRead,1));
        peak10=peakIndexes(1:roisize10);
        low10=lowIndexes(1:roisize10);
        interm10=peakIndexes(floor(length(responseRead)/2-roisize10/2):floor(length(responseRead)/2+roisize10/2));
        
        roisize20=round(0.2*size(responseRead,1));
        peak20=peakIndexes(1:roisize20);
        low20=lowIndexes(1:roisize20);
        interm20=peakIndexes(floor(length(responseRead)/2-roisize20/2):floor(length(responseRead)/2+roisize20/2));
        
        roisize30=round(0.3*size(responseRead,1));
        peak30=peakIndexes(1:roisize30);
        low30=lowIndexes(1:roisize30);
        interm30=peakIndexes(floor(length(responseRead)/2-roisize30/2):floor(length(responseRead)/2+roisize30/2));
        
        peakbinary10=zeros(size(responseRead,1),1);
        peakbinary10(peak10)=1;
        lowbinary10=zeros(size(responseRead,1),1);
        lowbinary10(low10)=1;
        intermbinary10=zeros(size(responseRead,1),1);
        intermbinary10(interm10)=1;
        
        peakbinary20=zeros(size(responseRead,1),1);
        peakbinary20(peak20)=1;
        lowbinary20=zeros(size(responseRead,1),1);
        lowbinary20(low20)=1;
        intermbinary20=zeros(size(responseRead,1),1);
        intermbinary20(interm20)=1;
        
        peakbinary30=zeros(size(responseRead,1),1);
        peakbinary30(peak30)=1;
        lowbinary30=zeros(size(responseRead,1),1);
        lowbinary30(low30)=1;
        intermbinary30=zeros(size(responseRead,1),1);
        intermbinary30(interm30)=1;

        [~,predictedPeakIndexes]=sort((readResponsePredicted(:,1)),'descend');
        [~,predictedLowIndexes]=sort((readResponsePredicted(:,1)),'ascend');
        [~,predictionChanceIndexes]=Shuffle(sort((readResponsePredicted(:,1)),'descend'));
        
        predictedPeak10=predictedPeakIndexes(1:roisize10);
        predictedLow10=predictedLowIndexes(1:roisize10);
        predictedInterm10=predictedPeakIndexes(floor(length(predictedPeakIndexes)/2-roisize10/2):floor(length(predictedPeakIndexes)/2+roisize10/2));
        
        predictedPeak20=predictedPeakIndexes(1:roisize20);
        predictedLow20=predictedLowIndexes(1:roisize20);
        predictedInterm20=predictedPeakIndexes(floor(length(predictedPeakIndexes)/2-roisize20/2):floor(length(predictedPeakIndexes)/2+roisize20/2));
        
        predictedPeak30=predictedPeakIndexes(1:roisize30);
        predictedLow30=predictedLowIndexes(1:roisize30);
        predictedInterm30=predictedPeakIndexes(floor(length(predictedPeakIndexes)/2-roisize30/2):floor(length(predictedPeakIndexes)/2+roisize30/2));
        
        chance10=predictionChanceIndexes(1:roisize10);
        chance20=predictionChanceIndexes(1:roisize20);
        chance30=predictionChanceIndexes(1:roisize30);
        
        predictedpeakbinary10=zeros(size(responseRead,1),1);
        predictedpeakbinary10(predictedPeak10)=1;
        predictedpeakbinary20=zeros(size(responseRead,1),1);
        predictedpeakbinary20(predictedPeak20)=1;
        predictedpeakbinary30=zeros(size(responseRead,1),1);
        predictedpeakbinary30(predictedPeak30)=1;
        
        predictedlowbinary10=zeros(size(responseRead,1),1);
        predictedlowbinary10(predictedLow10)=1;
        predictedlowbinary20=zeros(size(responseRead,1),1);
        predictedlowbinary20(predictedLow20)=1;
        predictedlowbinary30=zeros(size(responseRead,1),1);
        predictedlowbinary30(predictedLow30)=1;
        
        predictedintermbinary10=zeros(size(responseRead,1),1);
        predictedintermbinary10(predictedInterm10)=1;
        predictedintermbinary20=zeros(size(responseRead,1),1);
        predictedintermbinary20(predictedInterm20)=1;
        predictedintermbinary30=zeros(size(responseRead,1),1);
        predictedintermbinary30(predictedInterm30)=1;
        
        
        chancebinary10=zeros(size(responseRead,1),1);
        chancebinary10(chance10)=1;
        chancebinary20=zeros(size(responseRead,1),1);
        chancebinary20(chance20)=1;
        chancebinary30=zeros(size(responseRead,1),1);
        chancebinary30(chance30)=1;
        
        correctPredictionsPeak10=(predictedpeakbinary10>0 & peakbinary10>0);
        correctPredictionsPeak20=(predictedpeakbinary20>0 & peakbinary20>0);
        correctPredictionsPeak30=(predictedpeakbinary30>0 & peakbinary30>0);
        
        correctPredictionsLow10=(predictedlowbinary10>0 & lowbinary10>0);
        correctPredictionsLow20=(predictedlowbinary20>0 & lowbinary20>0);
        correctPredictionsLow30=(predictedlowbinary30>0 & lowbinary30>0);
        
        correctPredictionsInterm10=(predictedintermbinary10>0 & intermbinary10>0);
        correctPredictionsInterm20=(predictedintermbinary20>0 & intermbinary20>0);
        correctPredictionsInterm30=(predictedintermbinary30>0 & intermbinary30>0);
        
        chancePredictions10=(chancebinary10>0 & peakbinary10>0);
        chancePredictions20=(chancebinary20>0 & peakbinary20>0);
        chancePredictions30=(chancebinary30>0 & peakbinary30>0);
        
        DC10Peak=2*(sum(correctPredictionsPeak10))/(sum(peakbinary10)+sum(predictedpeakbinary10));
        DC20Peak=2*(sum(correctPredictionsPeak20))/(sum(peakbinary20)+sum(predictedpeakbinary20));
        DC30Peak=2*(sum(correctPredictionsPeak30))/(sum(peakbinary30)+sum(predictedpeakbinary30));
        
        DC10Low=2*(sum(correctPredictionsLow10))/(sum(peakbinary10)+sum(predictedlowbinary10));
        DC20Low=2*(sum(correctPredictionsLow20))/(sum(peakbinary20)+sum(predictedlowbinary20));
        DC30Low=2*(sum(correctPredictionsLow30))/(sum(peakbinary30)+sum(predictedlowbinary30));
        
        DC10Interm=2*(sum(correctPredictionsInterm10))/(sum(intermbinary10)+sum(predictedintermbinary10));
        DC20Interm=2*(sum(correctPredictionsInterm20))/(sum(intermbinary20)+sum(predictedintermbinary20));
        DC30Interm=2*(sum(correctPredictionsInterm30))/(sum(intermbinary30)+sum(predictedintermbinary30));
        
        DC10Chance=2*(sum(chancePredictions10))/(sum(peakbinary10)+sum(chancebinary10));
        DC20Chance=2*(sum(chancePredictions20))/(sum(peakbinary20)+sum(chancebinary20));
        DC30Chance=2*(sum(chancePredictions30))/(sum(peakbinary30)+sum(chancebinary30));
        
        [R,P]=corrcoef(responseRead,readResponsePredicted);
%                 fig1=fcnCorrMatrixPlot([responseRead,readResponsePredicted],{'MPS Score' 'T1 Read [s]'}, ' ')
%                 ylabel('predicted resp reading [T]')
%                 xlabel('actual resp reading [T]')
%                 ylim([-5 5])
%                 xlim([-5 5])
%                 pbaspect([1 1 1])
%                 set(gca,'FontSize',15,'FontWeight','bold'); box off; set(gca,'Linewidth',2);
%                 hold on;
%                 cd(figDir);
%                 outname=strcat('Subject_',num2str(subjectToPredict),'.tif');
%                 print(gcf, '-dtiff', outname,'-r600');
%                 close all;
        
        results(cnt,1)=subjectToPredict;
        results(cnt,2)=R(1,2);
        results(cnt,3)=R(1,2)^2;
        results(cnt,4)=DC10Peak;
        results(cnt,5)=DC20Peak;
        results(cnt,6)=DC30Peak;
        results(cnt,7)=DC10Interm;
        results(cnt,8)=DC20Interm;
        results(cnt,9)=DC30Interm;
        results(cnt,10)=DC10Low;
        results(cnt,11)=DC20Low;
        results(cnt,12)=DC30Low;
        results(cnt,13)=DC10Chance;
        results(cnt,14)=DC20Chance;
        results(cnt,15)=DC30Chance;
        
        %save prediction as mat file
        cd(outFolder);
        save(strcat('Subject_',num2str(subjectToPredict(1)),'_Grp2_',ROIs{r},'_',strcat(predictors{:})),...
            'responseRead','readResponsePredicted','peakbinary30','predictedpeakbinary30');
        
        if find(strcmp(predictors,strcat('GrpMapSL',num2str(subjectToPredict))))>0
            predictors{find(strcmp(predictors,strcat('GrpMapSL',num2str(subjectToPredict))))}='GrpMapS';
        end
        
        
        if find(strcmp(predictors,strcat('GrpMapVL',num2str(subjectToPredict))))>0
            predictors{find(strcmp(predictors,strcat('GrpMapVL',num2str(subjectToPredict))))}='GrpMapV';
        end
    end
    
    resultsT=array2table(results,'VariableNames',{'subj','R','R2','DC10Peak','DC20Peak','DC30Peak','DC10Interm','DC20Interm','DC30Interm','DC10Low','DC20Low','DC30Low','DC10Chance','DC20Chance','DC30Chance',});
    meanDC10=mean(table2array(resultsT(:,4)))
    steDC10=std((table2array(resultsT(:,4)))) / sqrt(length(table2array(resultsT(:,4))));
    
    meanDC20=mean(table2array(resultsT(:,5)))
    steDC20=std((table2array(resultsT(:,5)))) / sqrt(length(table2array(resultsT(:,5))));
    
    meanDC30=mean(table2array(resultsT(:,6)))
    steDC30=std((table2array(resultsT(:,6)))) / sqrt(length(table2array(resultsT(:,6))));
    
    meanR=mean(table2array(resultsT(:,2)))
    steR=std((table2array(resultsT(:,2)))) / sqrt(length(table2array(resultsT(:,2))));
    
    meanR2=mean(table2array(resultsT(:,3)))
    steR2=std((table2array(resultsT(:,3)))) / sqrt(length(table2array(resultsT(:,3))));
    
    
    cd(outFolder);
    save(strcat('Summary_Grp2_',ROIs{r},'_',strcat(predictors{:})),...
        'resultsT','meanDC10','steDC10','meanDC20','steDC20','meanDC30','steDC30','meanR','steR','meanR2','steR2');
    
end