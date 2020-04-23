%% This code was run in MATLAB R2015a to produce subplots in Fig 4 and save them

clear all
close all

% Experiment and code directories (path is machine specific)
ExpDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects','PredictFuncFromStruct');
CodeDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects','PredictFuncFromStruct','predictFuncFromStructCode');
OutDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects','PredictFuncFromStruct','predictFuncFromStructCode','figuresForPublication');

outFolder='Output_Fig4';
cd(OutDir)
mkdir(outFolder)

%% Fig 4a
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

kernel={'linModel'}
cd(fullfile(OutDir,outFolder));
ROIs={'lh_OTS_from_fsaverage_manual'}
for s=[7 21 29] 
for r=1:length(ROIs)
    outname='reading_map'
    surfDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMaps/RegressionGrp2');
      roiDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'ROIs');
      surf_command=[':overlay_color=colorwheel'];
label_command = [':label=' strcat(roiDir,'/',ROIs{r},'.label') ':label_color=black:label_outline=1'];
fs_loadFreeview(fs_ids{s},'lh','vl',fullfile(surfDir,strcat('Actual_Subject_',num2str(s),'_lh_OTS_fsavg_regression_',kernel{:},'_Grp2_',predictors{:},'.mgh')),0,[0.0000000001,2],1.5,true,label_command,[],outname)

outname='predicted_map'
    surfDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMaps/RegressionGrp2');
      roiDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'ROIs');
      surf_command=[':overlay_color=colorwheel'];
label_command = [':label=' strcat(roiDir,'/',ROIs{r},'.label') ':label_color=black:label_outline=1'];
fs_loadFreeview(fs_ids{s},'lh','vl',fullfile(surfDir,strcat('Predicted_Subject_',num2str(s),'_lh_OTS_fsavg_regression_',kernel{:},'_Grp2_',predictors{:},'.mgh')),0,[0.0000000001,0.5],1.5,true,label_command,[],outname)
end
end

%% Fig 4b
cd('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMatrixes/Leave1OutLinearGrp2')
Prediction=load('Summary_Grp2_lh_OTS_fsavg_regression_T1GrayILFAFVOF')

DCPeak=[Prediction.resultsT.DC10Peak Prediction.resultsT.DC20Peak Prediction.resultsT.DC30Peak]
DCInterm=[Prediction.resultsT.DC10Interm Prediction.resultsT.DC20Interm Prediction.resultsT.DC30Interm]
DCLow=[Prediction.resultsT.DC10Low Prediction.resultsT.DC20Low Prediction.resultsT.DC30Low]
DCChance=[Prediction.resultsT.DC10Chance Prediction.resultsT.DC20Chance Prediction.resultsT.DC30Chance]
close all

color=[0 0.5 0];
visibility=0.5;
p1=shadedErrorBar([],mean(DCPeak),std(DCPeak)/sqrt(19),color,visibility)
hold on

color=[0 0.5 0.5];
p2=shadedErrorBar([],mean(DCInterm),std(DCInterm)/sqrt(19),color,visibility)
hold on

color=[0 0 0.5];
p3=shadedErrorBar([],mean(DCLow),std(DCLow)/sqrt(19),color,visibility)
hold on

color=[0.75 0 0];
p4=shadedErrorBar([],mean(DCChance),std(DCChance)/sqrt(19),color,visibility)
hold on
    
    set(gca,'XTick',[1,2,3])
    set(gca,'YTick',[0.1:0.1:0.5])
    set(gca,'XTickLabel',[10,20,30]);
    ylabel('DC')
    ylim([0.05 0.5])
    xlim([0.5 3.5])
    pbaspect([1 1.5 1])
    set(gca,'FontSize',20,'FontWeight','bold'); box off; set(gca,'Linewidth',2);
    hold off
[ttest_h,ttest_p]=ttest(DCInterm(:,2),DCChance(:,2),'Alpha',0.05/3)

cd(fullfile(OutDir,outFolder));
outname=strcat('Fig4b.tif')
print(gcf, '-dtiff', outname,'-r600')