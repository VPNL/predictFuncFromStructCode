clear all;

outFolder=(fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMatrixes/Leave1Out'));
cd(fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/PredictMatrixes'));
ROIs={'lh_OTS_anat_roi'};

svmParams={};
svmParams.KernelFunction='rbf';
svmParams.KernelScale=10;
svmParams.Standardize='off';
svmParams.Prior='uniform';
svmParams.BoxContraint=1;
svmParams.Solver='L1Qp';
svmParams.zScore='true';
svmParams.PolynomialOrder=[];
svmParams.predictors={'ILF' 'AF' 'pAF'};

subjects=[1 3:9 11:12 14]
for r=1:length(ROIs)
    for subjectToPredict=[1]
        subjectsForPrediction=subjects(subjects~=subjectToPredict);
        
        currentSubject=subjectToPredict;
        % concat response and predictor matrixes for all N expect 1
        for i=1:length(subjectsForPrediction)
            load(strcat('Subject_',num2str(subjectsForPrediction(i)),'_',ROIs{r}));
            
            if svmParams.zScore>0 %should the predictors be zScored?
            individualsPredictors=zscore(table2array(predictorsT(:,svmParams.predictors)));
            else
            individualsPredictors=table2array(predictorsT(:,svmParams.predictors));   
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
        
        if strcmp(svmParams.KernelFunction,'polynomial')
            % fit svm from concatenated and tresholded responses
            SVMModelRead = fitcsvm(predictorsMinus1,responseReadTraining,...
                'KernelFunction',svmParams.KernelFunction,... %which kernel to use %rbf or poly seem to work well
                'PolynomialOrder',svmParams.PolynomialOrder,...
                'KernelScale',svmParams.KernelScale,... % the size of the kernel
                'Standardize',svmParams.Standardize,... %standardize the predictor variables
                'Prior',svmParams.Prior,... This weights things correctly
                'BoxConstraint',svmParams.BoxConstraint,... %how much error does the model allow
                'ClassNames',{className1,className2},...
                'Solver',svmParams.Solver); %this is what matlab recommends
        else
            % fit svm from concatenated and tresholded responses
            SVMModelRead = fitcsvm(predictorsMinus1,responseReadTraining,...
                'KernelFunction',svmParams.KernelFunction,... %which kernel to use %rbf or poly seem to work well
                'KernelScale',svmParams.KernelScale,... % the size of the kernel
                'Standardize',svmParams.Standardize,... %standardize the predictor variables
                'Prior',svmParams.Prior,... This weights things correctly
                'BoxConstraint',svmParams.BoxContraint,... %how much error does the model allow
                'ClassNames',{className1,className2},...
                'Solver',svmParams.Solver); %this is what matlab recommends
        end
        
        %ScoreSVMModelRead = fitPosterior(SVMModelRead,predictorsMinus1,responseReadTraining);
        
        %load predictors for left out subject and predict responses
        load(strcat('Subject_',num2str(subjectToPredict),'_',ROIs{r}));
        
                    if svmParams.zScore>0 %should the predictors be zScored?
                        predictorsSubjectToPredict=zscore(table2array(predictorsT(:,svmParams.predictors)));
                    else
                        predictorsSubjectToPredict=table2array(predictorsT(:,svmParams.predictors));
                    end

        [readLabel,readScore]=predict(SVMModelRead,predictorsSubjectToPredict);
        % [readLabel,readScore]=predict(ScoreSVMModelRead,predictorsA_zS);
        
        clear readLabelBinary; %convert predictions to binary label
        for l=1:length(readLabel)
            if strcmp(readLabel{l},className1)>0
                readLabelBinary(l,1)=0;
            else
                readLabelBinary(l,1)=1;
            end
        end
        
        actualROIVertices=roiRead(:,1);
        predictedROIVertices=readLabelBinary(:,1);
        
        correctPredictions=(predictedROIVertices>0 & actualROIVertices>0);
        
        DC=2*(sum(correctPredictions))/(sum(actualROIVertices)+sum(predictedROIVertices))
        DCs(subjectToPredict)=DC;
        
        %save prediction as mat file
        cd(outFolder);
        save(strcat('Subject_',num2str(subjectToPredict(1)),'_',ROIs{r},'_',svmParams.KernelFunction,'_',strcat(svmParams.predictors{:})),...
        'svmParams','SVMModelRead','readLabelBinary','readScore','DC','responseRead');
    end
end