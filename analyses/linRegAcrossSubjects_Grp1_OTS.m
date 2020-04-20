clear all;

outFolder=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMatrixes/Leave1OutLinearGrp1');
inFolder=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/PredictMatrixesMNI');
ROIs={'lh_OTS_fsavg_regression'};

predictors={'VOF'}
zScore='true';
deMean='false';
cnt=0;
% 
% figDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/Plots',strcat('predictionLinearReg','_',predictors{:}))
% mkdir(figDir);

%subjects=1:30
subjects=[2 5 8 11 13 14 16 18 22 30]
%subjects=[10:13 15:30]
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
                clear('individualsPredictors','individualsResponseMath','individualReponseRead','predictorsT','responseMath','responseRead'); 
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
        % [readLabel,readScore]=predict(ScoreSVMModelRead,predictorsA_zS);
        
                if  strcmp(zScore,'true')>0  %should the predictors be zScored?
            responseRead=zscore(responseRead);
                  
       elseif strcmp(deMean,'true')>0 
                responseReadMean=mean(responseRead);
                responseRead=responseRead-responseReadMean;
        end
        
        
        
        [~,actualROIIndexes]=sort(responseRead(:,1),'descend');
        roisize10=round(0.1*size(responseRead,1));
        actualROI10=actualROIIndexes(1:roisize10);
        
        roisize20=round(0.2*size(responseRead,1));
        actualROI20=actualROIIndexes(1:roisize20);
        
        roisize30=round(0.3*size(responseRead,1));
        actualROI30=actualROIIndexes(1:roisize30);
        
        actualROIbinary10=zeros(size(responseRead,1),1);
        actualROIbinary10(actualROI10)=1;
        
        actualROIbinary20=zeros(size(responseRead,1),1);
        actualROIbinary20(actualROI20)=1;
        
        actualROIbinary30=zeros(size(responseRead,1),1);
        actualROIbinary30(actualROI30)=1;
        
        [~,predictedROIIndexes]=sort((readResponsePredicted(:,1)),'descend');
        predictedROI10=predictedROIIndexes(1:roisize10);
        predictedROI20=predictedROIIndexes(1:roisize20);
        predictedROI30=predictedROIIndexes(1:roisize30);
          
        predictedROIbinary10=zeros(size(responseRead,1),1);
        predictedROIbinary10(predictedROI10)=1;
        
        predictedROIbinary20=zeros(size(responseRead,1),1);
        predictedROIbinary20(predictedROI20)=1;
        
        predictedROIbinary30=zeros(size(responseRead,1),1);
        predictedROIbinary30(predictedROI30)=1;
        
        correctPredictions10=(predictedROIbinary10>0 & actualROIbinary10>0);
        correctPredictions20=(predictedROIbinary20>0 & actualROIbinary20>0);
        correctPredictions30=(predictedROIbinary20>0 & actualROIbinary20>0);
          
          
        DC10=2*(sum(correctPredictions10))/(sum(actualROIbinary10)+sum(predictedROIbinary10));
        DC20=2*(sum(correctPredictions20))/(sum(actualROIbinary20)+sum(predictedROIbinary20));
        DC30=2*(sum(correctPredictions30))/(sum(actualROIbinary30)+sum(predictedROIbinary30));
        
             
          [R,P]=corrcoef(responseRead,readResponsePredicted);
%         fig1=fcnCorrMatrixPlot([responseRead,readResponsePredicted],{'MPS Score' 'T1 Read [s]'}, ' ')
%         ylabel('predicted resp reading [T]')
%         xlabel('actual resp reading [T]')
%         ylim([-5 5])
%         xlim([-5 5])
%         pbaspect([1 1 1]) 
%         set(gca,'FontSize',15,'FontWeight','bold'); box off; set(gca,'Linewidth',2); 
%         hold on;
%         cd(figDir);
%         outname=strcat('Subject_',num2str(subjectToPredict),'.tif');
%         print(gcf, '-dtiff', outname,'-r600');
%         close all;
        
        results(cnt,1)=subjectToPredict;
        results(cnt,2)=DC10;
        results(cnt,3)=DC20;
        results(cnt,4)=DC30;
        results(cnt,5)=R(1,2);
        results(cnt,6)=R(1,2)^2;
        
        %save prediction as mat file
        cd(outFolder);
        save(strcat('Subject_',num2str(subjectToPredict(1)),'_Grp1_',ROIs{r},'_',strcat(predictors{:})),...
            'responseRead','readResponsePredicted','actualROIbinary30','predictedROIbinary30');
        
        if find(strcmp(predictors,strcat('GrpMapSL',num2str(subjectToPredict))))>0
            predictors{find(strcmp(predictors,strcat('GrpMapSL',num2str(subjectToPredict))))}='GrpMapS';
        end
        
                
        if find(strcmp(predictors,strcat('GrpMapVL',num2str(subjectToPredict))))>0
            predictors{find(strcmp(predictors,strcat('GrpMapVL',num2str(subjectToPredict))))}='GrpMapV';
        end
    end
    
    resultsT=array2table(results,'VariableNames',{'subj','DC10','DC20','DC30','R','R2'});
    meanDC10=mean(table2array(resultsT(:,2)))
    steDC10=std((table2array(resultsT(:,2)))) / sqrt(length(table2array(resultsT(:,2))));
    
    meanDC20=mean(table2array(resultsT(:,3)))
    steDC20=std((table2array(resultsT(:,3)))) / sqrt(length(table2array(resultsT(:,3))));
    
    meanDC30=mean(table2array(resultsT(:,4)))
    steDC30=std((table2array(resultsT(:,4)))) / sqrt(length(table2array(resultsT(:,4))));
    
    meanR=mean(table2array(resultsT(:,5)))
    steR=std((table2array(resultsT(:,5)))) / sqrt(length(table2array(resultsT(:,5))));
    
    meanR2=mean(table2array(resultsT(:,6)))
    steR2=std((table2array(resultsT(:,6)))) / sqrt(length(table2array(resultsT(:,6))));
    
    
    cd(outFolder);
    save(strcat('Summary_Grp1_',ROIs{r},'_',strcat(predictors{:})),...
        'resultsT','meanDC10','steDC10','meanDC20','steDC20','meanDC30','steDC30','meanR','steR','meanR2','steR2');
    
end