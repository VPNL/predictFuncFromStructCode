
%% This code was run in MATLAB R2015a to produce subplots in Fig 2 and save them
%% The present code produces Fig 1b, c and d. 
%% Fig 1a and e are schematics created in powerpoint. 

clear all
close all

% Experiment and code directories (path is machine specific)
ExpDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects','PredictFuncFromStruct');
CodeDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects','PredictFuncFromStruct','predictFuncFromStructCode');
OutDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects','PredictFuncFromStruct','predictFuncFromStructCode','figuresForPublication');

outFolder='Output_Fig1';
cd(CodeDir)
mkdir(outFolder)

%% Fig 1b
sessid={'13_cb_dti_mrTrix3_081317'}
t1name=['t1.nii.gz'];

cd(fullfile(ExpDir,'data_mrAuto',sessid{1},'/96dir_run1/fw_afq_ET_ACT_LiFE_3.0.2_lmax8/dti96trilin/fibers/afq'))
ROIfgname=['WholeBrainFGRoiSe_classified_clean.mat']
foi=[17 11 13 19 23 21]
hemi='lh'
colors=[0.9 0.9 0.9; 1 0 1; 0 0 0; 0 0 1; 0 0 0.5; 0.5 0.5 1; 0 0.8 0.8; 1 0.5 1; 0.45 0 0.45; 0.6,0.2,0.2; 1 0 0; 1 0.6 0; 0.6 1 0.05];        
fatRenderFibersForPublication(ExpDir, sessid{1}, '96dir_run1/fw_afq_ET_ACT_LiFE_3.0.2_lmax8', ROIfgname,foi,t1name,hemi,colors)
cd(fullfile(OutDir,outFolder));
outname=strcat('lh_Whole_connectome.tif')
print(gcf, '-dtiff', outname,'-r600')

%% Fig 1c
fs_ids = {'cody'};
predictors={'T1Gray' 'ILF' 'AF' 'VOF'}
kernel={'linModel'}
cd(fullfile(OutDir,outFolder));
s=11;
r=1;
ROIs={'lh_OTS_from_fsaverage_manual'}
    surfDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMaps/RegressionGrp1');
      roiDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'ROIs');
      surf_command=[':overlay_color=colorwheel'];
label_command = [':label=' strcat(roiDir,'/',ROIs{r},'.label') ':label_color=black:label_outline=1',...%];
        ':label=./label/aparc2009/predictFuncFromStructROIs/' strcat('lh_OTS_union_morphing_reading_vs_all_proj_max.label') ':label_color=0,255,0:label_outline=1'];
fs_loadFreeview(fs_ids{1},'lh','vl',fullfile(surfDir,strcat('Actual_Subject_',num2str(s),'_lh_OTS_fsavg_regression_',kernel{:},'_Grp1_',predictors{:},'.mgh')),0,[0.0000000001,3],1,true,label_command,[],'reading_map')

%% Fig 1d
fs_ids = {'cody'};
predictors={'T1Gray' 'ILF' 'AF' 'VOF'}
kernel={'linModel'}
cd(fullfile(OutDir,outFolder));
s=11;
r=1;
    surfDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMaps/RegressionGrp1');
      roiDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'ROIs');
      surf_command=[':overlay_color=truncated'];
label_command = [':label=' strcat(roiDir,'/',ROIs{r},'.label') ':label_color=black:label_outline=1'];
fs_loadFreeview(fs_ids{1},'lh','vl',fullfile(surfDir,strcat('Actual_Subject_',num2str(s),'_lh_OTS_fsavg_regression_T1_Grp1_',predictors{:},'.mgh')),0,[0.6,1.6],1,true,label_command,[],'t1_map')