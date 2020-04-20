clear all;

outFolder=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMatrixes/Leave1OutLDA');
inFolder=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/PredictMatrixesROIs');
ROIs={'lh_mOTS_fsavg_roi'};

ldaParams={};
ldaParams.DiscrimType='linear';
ldaParams.Standardize='off';
ldaParams.Prior='empirical';
ldaParams.zScore='true';
ldaParams.deMean='false';
ldaParams.ScoreTransform='none';
%ldaParams.Gamma=1;
%ldaParams.Delta=0.001;
ldaParams.predictors={'T1Gray' 'AF' 'ILF' 'VOF'}
cnt=0;

subjects=[1 3 4 6 7 9 10 12 15 17 19 20 21 23 24 25 26 27 28 29] 
for r=1:length(ROIs)
    for subjectToPredict=subjects
        cnt=cnt+1;
        subjectsForPrediction=subjects(subjects~=subjectToPredict);
        cd(inFolder);
        
        if find(strcmp(ldaParams.predictors,'GrpRoi'))>0
            ldaParams.predictors{find(strcmp(ldaParams.predictors,'GrpRoi'))}=strcat('GrpRoiL',num2str(subjectToPredict));
        end
            
        currentSubject=subjectToPredict
        % concat response and predictor matrixes for all N expect 1
        for i=1:length(subjectsForPrediction)
            load(strcat('Subject_',num2str(subjectsForPrediction(i)),'_',ROIs{r}));
            
            if strcmp(ldaParams.zScore,'true')>0 %should the predictors be zScored? %should the predictors be zScored?
            individualsPredictors=zscore(table2array(predictorsT(:,ldaParams.predictors)));
            elseif strcmp(ldaParams.deMean,'true')>0 
                individualsPredictors=table2array(predictorsT(:,ldaParams.predictors));
                individualsPredictorsMean=mean(individualsPredictors);
                individualsPredictors=individualsPredictors-individualsPredictorsMean;
            else
            individualsPredictors=table2array(predictorsT(:,ldaParams.predictors));   
            end
            
            individualsResponseRead=roiRead;
            if i==1
                predictorsMinus1=individualsPredictors;
                responseReadMinus1=roiRead;
            else
                predictorsMinus1=vertcat(predictorsMinus1, individualsPredictors);
                responseReadMinus1=vertcat(responseReadMinus1, individualsResponseRead);
                clear('individualsPredictors','individualsResponseMath','individualReponseRead','predictorsT','responseMath','responseRead');
                
            end
        end
        
        indicesReadBelowTresh = find(responseReadMinus1==0);
        indicesReadAboveTresh = find(responseReadMinus1==1);
        
        responseReadTraining=cell(size(responseReadMinus1));
        
        clear 'responseReadBinary'
        responseReadBinary(:,2)=zeros(size(responseReadMinus1));
        
        className1='BelowTresh';
        className2='AboveTresh';
        responseReadTraining(indicesReadBelowTresh)  ={className1};
        responseReadTraining(indicesReadAboveTresh) = {className2};
        responseReadBinary((indicesReadBelowTresh),1)=1;
        responseReadBinary((indicesReadAboveTresh),2)=1;
        
            % fit lda from concatenated and tresholded responses
            ldaModelRead = fitcdiscr(predictorsMinus1,responseReadTraining,...
                'DiscrimType',ldaParams.DiscrimType,... %which kernel to use %rbf or poly seem to work well
                'Prior',ldaParams.Prior,... This weights things correctly
                'ClassNames',{className1,className2},...
                'ScoreTransform',ldaParams.ScoreTransform); %this is what matlab recommends
                           % 'Delta',ldaParams.Delta,...
               % 'Gamma',ldaParams.Gamma,...
            
        
        %ScoreldaModelRead = fitPosterior(ldaModelRead,predictorsMinus1,responseReadTraining);
        
        %load predictors for left out subject and predict responses
        load(strcat('Subject_',num2str(subjectToPredict),'_',ROIs{r}));
        
        if ldaParams.zScore>0 %should the predictors be zScored?
            predictorsSubjectToPredict=zscore(table2array(predictorsT(:,ldaParams.predictors)));
        elseif strcmp(deMean,'true')>0
            predictorsSubjectToPredict=table2array(predictorsT(:,ldaParams.predictors));
            predictorsSubjectToPredictMean=mean(predictorsSubjectToPredict);
            predictorsSubjectToPredict=predictorsSubjectToPredict-predictorsSubjectToPredictMean;
        else
            predictorsSubjectToPredict=table2array(predictorsT(:,ldaParams.predictors));
        end

        [readLabel,readScore]=predict(ldaModelRead,predictorsSubjectToPredict);
        % [readLabel,readScore]=predict(ScoreldaModelRead,predictorsA_zS);
        
        clear predictedLabelBinary; %convert predictions to binary label
        for l=1:length(readLabel)
            if strcmp(readLabel{l},className1)>0
                predictedLabelBinary(l,1)=0;
            else
                predictedLabelBinary(l,1)=1;
            end
        end
        
        actualROIVertices=roiRead(:,1);
        predictedROIVertices=predictedLabelBinary(:,1);
        chanceROIVertices=Shuffle(predictedLabelBinary(:,1));
        
        correctPredictions=(predictedROIVertices>0 & actualROIVertices>0);
        chancePredictions=(chanceROIVertices>0 & actualROIVertices>0);
        
        DC=2*(sum(correctPredictions))/(sum(actualROIVertices)+sum(predictedROIVertices))
        DC_Chance=2*(sum(chancePredictions))/(sum(actualROIVertices)+sum(chanceROIVertices))
        results(cnt,1)=subjectToPredict;
        results(cnt,2)=DC;
        results(cnt,3)=DC_Chance;
        
        %save prediction as mat file
        cd(outFolder);
        save(strcat('Subject_',num2str(subjectToPredict(1)),'_',ROIs{r},'_',ldaParams.DiscrimType,'_',strcat(ldaParams.predictors{:})),...
        'ldaParams','ldaModelRead','predictedLabelBinary','roiRead','readScore','results','responseRead');
    
    if find(strcmp(ldaParams.predictors,strcat('GrpRoiL',num2str(subjectToPredict))))>0
        ldaParams.predictors{find(strcmp(ldaParams.predictors,strcat('GrpRoiL',num2str(subjectToPredict))))}='GrpRoi';
    end
    
    end
    
    resultsT=array2table(results,'VariableNames',{'subj','DC','DCChance'});
    meanDC=mean(table2array(resultsT(:,2)))
    steDC=std((table2array(resultsT(:,2)))) / sqrt(length(table2array(resultsT(:,2))));
    
    
        cd(outFolder);
        save(strcat('Summary_',ROIs{r},'_',ldaParams.DiscrimType,'_',strcat(ldaParams.predictors{:})),...
        'ldaParams','resultsT','meanDC','steDC');
end