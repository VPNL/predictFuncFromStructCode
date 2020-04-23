
%% This code was run in MATLAB R2015a to produce subplots in Fig 2 and save them

clear all
close all

% Experiment and code directories (path is machine specific)
ExpDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects','PredictFuncFromStruct');
CodeDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects','PredictFuncFromStruct','predictFuncFromStructCode');
OutDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects','PredictFuncFromStruct','predictFuncFromStructCode','figuresForPublication');

outFolder='Output_Fig2';
cd(OutDir)
mkdir(outFolder)

%% Fig 2a
fs_ids = {'brianna'};
cd(fullfile(OutDir,outFolder));
s=7;
r=1;
ROIs={'lh_OTS_from_fsaverage_manual'}
  tracts={'UCI' 'IFOF' 'ILF' 'AF' 'pAF' 'VOF'}
tractnums=[17 11 13 19 23 21];

for t=1:length(tractnums)
    outname=strcat('ED_',tracts{t})
    surfDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'Surf');
    roiDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'ROIs');
label_command = [':label=' strcat(roiDir,'/',ROIs{r},'.label') ':label_color=black:label_outline=1'];%,...
       % ':label=./label/aparc2009/predictFuncFromStructROIs/' strcat('lh_OTS_union_morphing_reading_vs_all_proj_max.label') ':label_color=green:label_outline=1'];
    surf_command=[':overlay_color=colorwheel'];
fs_loadFreeview(fs_ids{1},'lh','vl',fullfile(surfDir,strcat('04_lh_OTS_from_fsaverage_manual_FG_track_',num2str(tractnums(t)),'_lh_proj_max.mgh')),0,[0.5,10],1.5,true,label_command,surf_command,outname)

end


%% Fig 2b
cd('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMatrixes/Leave1OutLinearGrp1')

UCI=load('Summary_Grp1_lh_OTS_fsavg_regression_UCI.mat')
IFOF=load('Summary_Grp1_lh_OTS_fsavg_regression_IFOF.mat')
ILF=load('Summary_Grp1_lh_OTS_fsavg_regression_ILF.mat')
AF=load('Summary_Grp1_lh_OTS_fsavg_regression_AF.mat')
pAF=load('Summary_Grp1_lh_OTS_fsavg_regression_pAF')
VOF=load('Summary_Grp1_lh_OTS_fsavg_regression_VOF')


Rmeans=[UCI.meanR IFOF.meanR ILF.meanR AF.meanR pAF.meanR VOF.meanR]
Rste=[UCI.steR IFOF.steR ILF.steR AF.steR pAF.steR VOF.steR]
Rall=[UCI.resultsT.R IFOF.resultsT.R ILF.resultsT.R AF.resultsT.R pAF.resultsT.R VOF.resultsT.R]

caption_x=['UCIF';'IFOF';'ILF ';'AF  ';'pAF ';'VOF '];
fig=mybar(Rmeans,Rste,caption_x,[],[0.5 0.5 0.5],2);
xticklabel_rotate([],45,[],'Fontsize',20,'FontWeight','bold')
ylim([-0.15 0.3]);
ylabel('R','FontSize',24,'FontName','Arial','FontWeight','bold');
pbaspect([1 1 2])
set(gca,'FontSize',18,'FontWeight','bold'); box off; set(gca,'Linewidth',2);  

[ttest_h,ttest_p]=ttest(Rall(:,1),0,'Alpha',0.05/6)
cd(fullfile(OutDir,outFolder));
outname=strcat('Fig2b.tif')
print(gcf, '-dtiff', outname,'-r600')

%% Fig 2c
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
for p=1:length(predictors)
    predictor=predictors(p)
outname=strcat(predictor{:})
surfDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMaps/RegressionGrp1');
roiDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'ROIs');
surf_command=[':overlay_color=colorwheel'];
label_command = [':label=' strcat(roiDir,'/',ROIs{r},'.label') ':label_color=black:label_outline=1'];
fs_loadFreeview(fs_ids{1},'lh','vl',fullfile(surfDir,strcat('Subject_',num2str(s),'_lh_OTS_fsavg_regression_',kernel{:},'_Grp1_',predictor{:},'.mgh')),0,[0.00000000000000001,0.5],1.5,true,label_command,[],outname)
end
