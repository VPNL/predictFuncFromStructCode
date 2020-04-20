clear all;

outFolder=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMatrixes/Leave1OutLinear');
inFolder=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/PredictMatrixesMNI');
ROIs={'lh_OTS_fsavg_regression'};

predictors={'T1Gray' 'ILF' 'AF' 'VOF'}
zScore='true';
deMean='false';
cnt=0;

figDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/Plots',strcat('predictionLinearReg','_',predictors{:}))
mkdir(figDir);


subjects=[2 5 8 11 13 14 16 18 22 30]
%subjects=[10:13 15:30]
for r=1:length(ROIs)
        cnt=cnt+1;
        subjectsForPrediction=subjects;
        cd(inFolder);
        
        if find(strcmp(predictors,'GrpMapS'))>0
            predictors{find(strcmp(predictors,'GrpMapS'))}=strcat('GrpMapSL',num2str(subjectToPredict));
        end
        
        if find(strcmp(predictors,'GrpMapV'))>0
            predictors{find(strcmp(predictors,'GrpMapV'))}=strcat('GrpMapVL',num2str(subjectToPredict));
        end
        
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
         
                   % predictorsTable = array2table([predictorsMinus1 responseReadMinus1],'VariableNames',{'ILF' 'AF' 'VOF' 'T1Gray' 'Response'});
%     % randomInterModelRead = fitlme(predictorsTable,'Response~ILF+(1|Subj)') %this is what matlab recommends
%             smallModelRead = fitlme(predictorsTable,'Response~ILF+AF+VOF')
%             bigModelRead = fitlme(predictorsTable,'Response~ILF+AF+VOF+T1Gray')
%            compare(smallModelRead,bigModelRead)
%         %[h,pValue,stat]=lratiotest(bigModelRead,smallModelRead,10)
%         
                 
                    predictorsTable = array2table([predictorsMinus1 responseReadMinus1],'VariableNames',{'ILF' 'AF' 'VOF' 'T1Gray' 'Response'});
    % randomInterModelRead = fitlme(predictorsTable,'Response~ILF+(1|Subj)') %this is what matlab recommends
            smallModelRead = fitlme(predictorsTable,'Response~ILF+AF+VOF')
            bigModelRead = fitlme(predictorsTable,'Response~ILF+AF+VOF+T1Gray')
           [resutls,siminfo]=compare(smallModelRead,bigModelRead,'Nsim', 1000)
        %[h,pValue,stat]=lratiotest(bigModelRead,smallModelRead,10)
       
end