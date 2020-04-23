%% This code was run in MATLAB R2015a to produce subplots in Fig 2 and save them

clear all
close all

% Experiment and code directories (path is machine specific)
ExpDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects','PredictFuncFromStruct');
CodeDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects','PredictFuncFromStruct','predictFuncFromStructCode');
OutDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects','PredictFuncFromStruct','predictFuncFromStructCode','figuresForPublication');

outFolder='Output_Fig3';
cd(OutDir)
mkdir(outFolder)

%% Fig 3a
cd('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMatrixes/Leave1OutLinearGrp1')

Tracts=load('Summary_Grp1_lh_OTS_fsavg_regression_ILFAFVOF.mat')
T1=load('Summary_Grp1_lh_OTS_fsavg_regression_T1Gray.mat')
TractsT1=load('Summary_Grp1_lh_OTS_fsavg_regression_T1GrayILFAFVOF.mat')

Rmeans=[Tracts.meanR TractsT1.meanR]
Rste=[Tracts.steR TractsT1.steR]
Rall=[Tracts.resultsT.R TractsT1.resultsT.R]

%caption_x=['Fascicles';' T1  ';'ED+T1'];
caption_x=['Fascicles   ';'Fascicles+T1'];
%caption_x=[' AF,ILF,VOF  ';' T1Gray      ';'AF,ILF,VOF,T1'];
fig=mybar(Rmeans,Rste,caption_x,[],[0.5 0.5 0.5],2);
xticklabel_rotate([],35,[],'Fontsize',20,'FontWeight','bold')
ylim([0 0.35]);
ylabel('R','FontSize',24,'FontName','Arial','FontWeight','bold');
pbaspect([1 1 2])
set(gca,'FontSize',18,'FontWeight','bold'); box off; set(gca,'Linewidth',2);   
[ttest_h,ttest_p]=ttest(Rall(:,2),0,'Alpha',0.05)
cd(fullfile(OutDir,outFolder));
outname=strcat('Fig3a.tif')
print(gcf, '-dtiff', outname,'-r600')

%% Fig 3b
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
label_command = [':label=' strcat(roiDir,'/',ROIs{r},'.label') ':label_color=black:label_outline=1'];
     %   ':label=./label/aparc2009/predictFuncFromStructROIs/' strcat('lh_OTS_union_morphing_reading_vs_all_proj_max.label') ':label_color=0,255,0:label_outline=1'];
fs_loadFreeview(fs_ids{1},'lh','vl',fullfile(surfDir,strcat('Actual_Subject_',num2str(s),'_lh_OTS_fsavg_regression_',kernel{:},'_Grp1_',predictors{:},'.mgh')),0,[0.0000000001,3],1.5,true,label_command,[],'reading_map')

predictors={'ILF' 'AF' 'VOF'}
outname=strcat(predictors{:})
surfDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMaps/RegressionGrp1');
roiDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'ROIs');
surf_command=[':overlay_color=colorwheel'];
label_command = [':label=' strcat(roiDir,'/',ROIs{r},'.label') ':label_color=black:label_outline=1'];
fs_loadFreeview(fs_ids{1},'lh','vl',fullfile(surfDir,strcat('Subject_',num2str(s),'_lh_OTS_fsavg_regression_',kernel{:},'_Grp1_',predictors{:},'.mgh')),0,[0.00000000000000001,0.5],1.5,true,label_command,[],outname)

predictors={'T1Gray' 'ILF' 'AF' 'VOF'}
outname=strcat(predictors{:})
surfDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMaps/RegressionGrp1');
roiDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'ROIs');
surf_command=[':overlay_color=colorwheel'];
label_command = [':label=' strcat(roiDir,'/',ROIs{r},'.label') ':label_color=black:label_outline=1'];
fs_loadFreeview(fs_ids{1},'lh','vl',fullfile(surfDir,strcat('Subject_',num2str(s),'_lh_OTS_fsavg_regression_',kernel{:},'_Grp1_',predictors{:},'.mgh')),0,[0.00000000000000001,0.5],1.5,true,label_command,[],outname)

