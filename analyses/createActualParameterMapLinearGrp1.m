
% this script converts predicted rois from mat format to freesurfer label, so that they can be displayed in FreeView
ROIs={'lh_OTS_fsavg'};

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

predictors={'T1Gray' 'ILF' 'AF' 'VOF'}

%1,2,10,13,
for s=11%[2 5 8 11 13 14 16 18 22 30]
    for r=1:length(ROIs)
        if find(strcmp(predictors,'GrpMap'))>0
            predictors{find(strcmp(predictors,'GrpMap'))}=strcat('GrpMapL',num2str(s));
        end
        
        roiDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'ROIs');
        cd(fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMatrixes/Leave1OutLinearGrp1'));
        load(strcat('Subject_',num2str(s),'_Grp1_',ROIs{r},'_regression_',predictors{:},'.mat'));
        label = read_label(fs_ids{s},strcat('aparc2009/predictFuncFromStructBoundaries/','lh_OTS_from_fsaverage_manual'));
        
        label(:,5)=responseRead(:,1);
        
        surfFolder=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict', strcat('Subject_',num2str(s)), 'Surf');
        cd(surfFolder);
        [vol, M, mr_params] = load_mgh(strcat('02_reading_vs_all_lh_proj_max.mgh'));
        
        vol(:,1)=0;
        for i=1:length(label)
            vol(label(i,1)+1,1)=label(i,5);
        end
        
        if find(strcmp(predictors,strcat('GrpMapL',num2str(s))))>0
            predictors{find(strcmp(predictors,strcat('GrpMapL',num2str(s))))}='GrpMap';
        end
        
        
        cd(fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMaps/RegressionGrp2'));
        save_mgh(vol,strcat('Actual_Subject_',num2str(s),'_',ROIs{r},'_regression_linModel_Grp1_',predictors{:},'.mgh'), M, mr_params);
        
    end
end
