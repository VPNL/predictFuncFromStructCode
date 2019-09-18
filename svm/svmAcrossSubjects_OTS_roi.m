clear all;
cd(fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/PredictMatrixes'));
ROIs={'lh_OTS_anat_roi'};

subjects=[1,3,4,5,6,7,8,9];
for r=1:length(ROIs)
    for subjectToPredict=[1,3,4,5,6,7,8,9]
        subjectsForPrediction=subjects(subjects~=subjectToPredict);
        
        currentSubject=subjectToPredict
        % concat response and predictor matrixes for all N expect 1
        for i=1:length(subjectsForPrediction)
            load(strcat('Subject_',num2str(subjectsForPrediction(i)),'_',ROIs{r}));
            individualsPredictors=predictorsA;
            individualsResponseRead=roiRead;
            if i==1
                predictorsMinus1=individualsPredictors;
                responseReadMinus1=roiRead;
            else
                predictorsMinus1=vertcat(predictorsMinus1, individualsPredictors);
                responseReadMinus1=vertcat(responseReadMinus1, individualsResponseRead);
                clear('individualsPredictorA','individualsResponseMath','individualReponseRead','predictorsA', 'responseMath', 'responseRead');
                
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
        
        % fit svm from concatenated and tresholded responses
        SVMModelRead = fitcsvm(predictorsMinus1,responseReadTraining,...
            'KernelFunction','polynomial',... %which kernel to use %rbf or poly seem to work well
            'PolynomialOrder',4,...
            'KernelScale',1,... % the size of the kernel
            'Standardize',true,... %standardize the predictor variables
            'Prior','uniform',... This weights things correctly
            'ScoreTransform','none', ... %???
            'BoxConstraint',30,... %how much error does the model allow
            'ClassNames',{className1,className2},...
            'Solver','L1Qp'); %this is what matlab recommends
        
        %ScoreSVMModelRead = fitPosterior(SVMModelRead,predictorsMinus1,responseReadTraining);
        
        %load predictors for left out subject and predict responses
        load(strcat('Subject_',num2str(subjectToPredict(1)),'_',ROIs{r}));
        predictorsSubjectToPredict=predictorsA;
        
        [readLabel,readScore]=predict(SVMModelRead,predictorsA);
        % [readLabel,readScore]=predict(ScoreSVMModelRead,predictorsA);
        
        clear readLabelBinary; %convert predictions to binary label
        for l=1:length(readLabel)
            if strcmp(readLabel{l},className1)>0
                readLabelBinary(l,1)=0;
            else
                readLabelBinary(l,1)=1;
            end
        end
        
        %save prediction as mat file
        save(strcat('Poly_new_Subject_',num2str(subjectToPredict(1)),'_',ROIs{r},'_output'),'predictorsA','responseRead','predictorsT','readScore','readLabelBinary');
    end
end