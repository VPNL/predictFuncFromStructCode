clear all;
cd(fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/PredictMatrixes'));
ROIs={'lh_OTS_anat_roi'};

subjectsForPrediction=[1,3,4];
for r=1:length(ROIs)

    % concat response and predictor matrixes for all N expect 1
    for i=1:length(subjectsForPrediction)
        load(strcat('Subject_',num2str(subjectsForPrediction(i)),'_',ROIs{r}));
        individualsPredictors=predictorsA; %try if you can use the table instead for new matlab
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
    iter=0;
    for o=[3:4]
        for s=[0.5 1 2 3 4 5 10]
            for b=[ 1 2 3 4 5 10 20 30]
                
                iter=iter+1;
                SVMModelRead = fitcsvm(predictorsMinus1,responseReadTraining,...
                    'KernelFunction','polynomial',... %which kernel to use %rbf can optimized
                    'PolynomialOrder',o,...
                    'KernelScale',s,... % the size og the kernel
                    'Standardize',true,... %standardize the predictor variables
                    'Prior','uniform',... This should weight things correctly?
                    'ScoreTransform','none', ... %???
                    'BoxConstraint',b,...
                    'ClassNames',{className1,className2},...
                    'Solver','L1Qp');

                CVSVMRead=crossval(SVMModelRead,'kfold',10);
                L=kfoldLoss(CVSVMRead,'LossFun',@lossfuncDC);
                DC=1-L
                
                crossValDC(iter,1)=o;
                crossValDC(iter,2)=s;
                crossValDC(iter,3)=b;
                crossValDC(iter,4)=DC;
            end
        end
    end
end
