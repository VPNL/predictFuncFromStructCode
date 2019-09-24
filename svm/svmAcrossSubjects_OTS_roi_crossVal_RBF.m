clear all;

outFolder=(fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMatrixes/CrossVal'));
cd(fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/PredictMatrixes'));
ROIs={'lh_OTS_anat_roi'};

svmParams={};
svmParams.KernelFunction='rbf';
svmParams.KernelScale=[0.001 0.01 0.1 1 10 100];
svmParams.Standardize='off';
svmParams.Prior='uniform';
svmParams.BoxContraint=[0.001 0.01 0.1 1 10 100];
svmParams.Solver='L1Qp';
svmParams.zScore='true';
svmParams.PolynomialOrder=1;
svmParams.predictors={'ILF' 'AF' 'pAF'};

subjects=[1,4,6]
cnt=0;
for r=1:length(ROIs)
    for subjectToPredict=[1 6]
        cnt=cnt+1;
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
        
        iter=0;
        for o=svmParams.PolynomialOrder
            for s=svmParams.KernelScale
                for b=svmParams.BoxContraint
                    
                    
                    if strcmp(svmParams.KernelFunction,'polynomial')
                        
                        iter=iter+1;
                        % fit svm from concatenated and tresholded responses
                        SVMModelRead = fitcsvm(predictorsMinus1,responseReadTraining,...
                            'KernelFunction',svmParams.KernelFunction,... %which kernel to use %rbf or poly seem to work well
                            'PolynomialOrder',o,...
                            'KernelScale',s,... % the size of the kernel
                            'Standardize',svmParams.Standardize,... %standardize the predictor variables
                            'Prior',svmParams.Prior,... This weights things correctly
                            'BoxConstraint',b,... %how much error does the model allow
                            'ClassNames',{className1,className2},...
                            'Solver',svmParams.Solver); %this is what matlab recommends
                        
                    else
                        
                        iter=iter+1;
                        % fit svm from concatenated and tresholded responses
                        SVMModelRead = fitcsvm(predictorsMinus1,responseReadTraining,...
                            'KernelFunction',svmParams.KernelFunction,... %which kernel to use %rbf or poly seem to work well
                            'KernelScale',s,... % the size of the kernel
                            'Standardize',svmParams.Standardize,... %standardize the predictor variables
                            'Prior',svmParams.Prior,... This weights things correctly
                            'BoxConstraint',b,... %how much error does the model allow
                            'ClassNames',{className1,className2},...
                            'Solver',svmParams.Solver); %this is what matlab recommends
                    end
                    
                    %load predictors for left out subject and predict responses
                    
                    load(strcat('Subject_',num2str(subjectToPredict),'_',ROIs{r}));

                    if svmParams.zScore>0 %should the predictors be zScored?
                        predictorsSubjectToPredict=zscore(table2array(predictorsT(:,svmParams.predictors)));
                    else
                        predictorsSubjectToPredict=predictorsT(table2array(:,svmParams.predictors));
                    end
                    
                    [readLabel,readScore]=predict(SVMModelRead,predictorsSubjectToPredict);
                    
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
                    
                    crossValDC(cnt,iter,1)=o;
                    crossValDC(cnt,iter,2)=s;
                    crossValDC(cnt,iter,3)=b;
                    crossValDC(cnt,iter,4)=DC;
                end
            end
        end
    end
    DCmean=squeeze(mean(crossValDC));
    DCmax=max(DCmean(:,3));
    
       %save prediction as mat file
   cd(outFolder);
   save(strcat('CrossVal_',svmParams.KernelFunction,'_',strcat(svmParams.predictors{:})),...
       'SVMModelRead','svmParams','subjects','subjectToPredict','crossValDC','DCmean','DCmax');
    
end