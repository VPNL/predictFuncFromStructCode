
% this script converts predicted rois from mat format to freesurfer label, so that they can be displayed in FreeView
ROIs={'lh_mOTS_disk7mm_fsavg'};

fs_ids = {'siobhan' 'avt' 'anthony_new_recon_2017'...
    'kalanit_new_recon_2017' 'mareike' 'jesse_new_recon_2017'...
    'brianna' 'swaroop' 'eshed'...
    'richard' 'cody' 'marisa'...
    'kari' 'alexis' 'nathan'...
    'dawn' 'erica' 'th'...
    'ek' 'gm' 'bl'...
    'mw' 'jk' 'pe'...
    'ie' 'pw' 'ks' ...
    'mz' 'mm' 'ans'};

predictors={'T1Gray' 'AF' 'ILF' 'VOF'}
kernel={'linear'}
%1,2,10,13,
for s=[1 3 4 6 7 9 10 12 15 17 19 20 21 23 24 25 26 27 28 29]
    for r=1:length(ROIs)
        if find(strcmp(predictors,'GrpRoi'))>0
            predictors{find(strcmp(predictors,'GrpRoi'))}=strcat('GrpRL',num2str(s));
        end
        
        roiDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'ROIs');
        cd(fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMatrixes/Leave1OutLDA'));
        load(strcat('Subject_',num2str(s),'_',ROIs{r},'_roi_',kernel{:},'_',predictors{:},'.mat'));
        label = read_label(fs_ids{s},strcat('aparc2009/predictFuncFromStructBoundaries/','lh_OTS_from_fsaverage_manual'));
        
        label(:,5)=roiRead(:,1);
        actualLabel=label(label(:,5)>0,:);
        cd(fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputLabels'));
        
        if find(strcmp(predictors,strcat('GrpRL',num2str(s))))>0
            predictors{find(strcmp(predictors,strcat('GrpRL',num2str(s))))}='GrpRoi';
        end
        
        write_label(actualLabel(:,1), actualLabel(:,2:4), actualLabel(:,5),fullfile(strcat('Subject_',num2str(s),'_actual_',ROIs{r},'_roi_',kernel{:},'_',predictors{:},'.label')));
    end
end
