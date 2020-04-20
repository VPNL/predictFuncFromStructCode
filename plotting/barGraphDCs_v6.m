%%% Fig 2b

clear all
cd('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMatrixes/Leave1OutLinearGrp1')

UCI=load('Summary_Grp1_lh_OTS_fsavg_regression_UCI.mat')
IFOF=load('Summary_Grp1_lh_OTS_fsavg_regression_IFOF.mat')
ILF=load('Summary_Grp1_lh_OTS_fsavg_regression_ILF.mat')
AF=load('Summary_Grp1_lh_OTS_fsavg_regression_AF.mat')
pAF=load('Summary_Grp1_lh_OTS_fsavg_regression_pAF')
VOF=load('Summary_Grp1_lh_OTS_fsavg_regression_VOF')


Rmeans=[UCI.meanR IFOF.meanR ILF.meanR AF.meanR pAF.meanR VOF.meanR]

Rall=[UCI.resultsT.R IFOF.resultsT.R ILF.resultsT.R AF.resultsT.R pAF.resultsT.R VOF.resultsT.R]

caption_x=['UCI';'IFO';'ILF';'AF ';'pAF';'VOF'];
fig=mybar(Rmeans,Rste,caption_x,[],[0.5 0.5 0.5],2);
xticklabel_rotate([],45,[],'Fontsize',20,'FontWeight','bold')
ylim([-0.15 0.3]);
ylabel('R','FontSize',24,'FontName','Arial','FontWeight','bold');
pbaspect([1 1 2])
set(gca,'FontSize',18,'FontWeight','bold'); box off; set(gca,'Linewidth',2);  

[ttest_h,ttest_p]=ttest(Rall(:,1),0,'Alpha',0.05/6)

%%% Fig 3b
clear all;
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

%%% Fig 4b
cd('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMatrixes/Leave1OutLinearGrp2')
30
outDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/Plots')
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
[ttest_h,ttest_p]=ttest(DCInterm(:,3),DCChance(:,3),'Alpha',0.05/3)

% cd('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMatrixes/Leave1OutLinearGrp2')
% 
% outDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/Plots')
% Prediction=load('Summary_Grp2_lh_OTS_fsavg_regression_T1GrayILFAFVOF')
% 
% DCPeak=[Prediction.resultsT.DC10Peak Prediction.resultsT.DC20Peak Prediction.resultsT.DC30Peak...
%     Prediction.resultsT.DC40Peak Prediction.resultsT.DC50Peak Prediction.resultsT.DC60Peak...
%     Prediction.resultsT.DC70Peak Prediction.resultsT.DC80Peak Prediction.resultsT.DC90Peak Prediction.resultsT.DC100Peak]
% 
% DCChance=[Prediction.resultsT.DC10Chance Prediction.resultsT.DC20Chance Prediction.resultsT.DC30Chance...
%     Prediction.resultsT.DC40Chance Prediction.resultsT.DC50Chance Prediction.resultsT.DC60Chance...
%     Prediction.resultsT.DC70Chance Prediction.resultsT.DC80Chance Prediction.resultsT.DC90Chance Prediction.resultsT.DC100Chance]
% close all
% 
% color=[0 0.5 0];
% visibility=0.5;
% p1=shadedErrorBar([],mean(DCPeak),std(DCPeak)/sqrt(19),color,visibility)
% hold on
% 
% color=[0.75 0 0];
% p2=shadedErrorBar([],mean(DCChance),std(DCChance)/sqrt(19),color,visibility)
% hold on
%     
%     set(gca,'XTick',[1,3,5,7,9])
%     set(gca,'YTick',[0.1:0.2:1])
%     set(gca,'XTickLabel',[10,30,50,70,90]);
%     ylabel('DC')
%     ylim([0.05 1])
%     xlim([0.5 10.5])
%     pbaspect([1 1 1])
%     set(gca,'FontSize',20,'FontWeight','bold'); box off; set(gca,'Linewidth',2);
%     hold off
% [ttest_h,ttest_p]=ttest(DCPeak(:,3),DCChance(:,3),'Alpha',0.05/3)



%%% Fig 5b
clear all
cd('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMatrixes/Leave1OutLDA')

outDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/Plots')
mOTS=load('Summary_lh_mOTS_fsavg_roi_linear_T1GrayAFILFVOF.mat')
Disk=load('Summary_lh_mOTS_disk7mm_fsavg_roi_linear_T1GrayAFILFVOF.mat')
OTS=load('Summary_lh_OTS_union_fsavg_roi_linear_T1GrayAFILFVOF.mat')

%DCs=[mOTS.resultsT.DC Disk.resultsT.DC OTS.resultsT.DC]
%DCChance=[mOTS.resultsT.DCChance Disk.resultsT.DCChance OTS.resultsT.DCChance]

DCs=[mOTS.resultsT.DC Disk.resultsT.DC]
DCChance=[mOTS.resultsT.DCChance Disk.resultsT.DCChance]




close all
caption_x=['mOTS';'Disk';'uOTS'];
fig=mybar(mean(DCs),std(DCs)/sqrt(19),caption_x,[],[0.5 0.5 0.5],2);
ylim([0 0.15]);
ylabel('DC','FontSize',22,'FontName','Arial','FontWeight','bold');
pbaspect([1 1.5 1])
set(gca,'FontSize',22,'FontWeight','bold'); box off; set(gca,'Linewidth',2);   

hold on
fig=errorbar([1,2],mean(DCChance),std(DCChance)/sqrt(19),std(DCChance)/sqrt(19),'wo',...
    'LineWidth',2,...
    'Color',[0.75 0 0],...
    'MarkerSize',5,...
    'MarkerEdgeColor',[0.75 0 0],...
    'MarkerFaceColor',[0.75 0 0]);
%cd(fullfile(outdir));
%print(gcf, '-dtiff','Fig4_DCs.tif','-r300');

[ttest_h,ttest_p]=ttest(DCs(:,2),DCChance(:,2),'Alpha',0.05/2)

[ttest_h,ttest_p]=ttest(DCs(:,1),DCs(:,2),'Alpha',0.05/2)







% cd('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMatrixes/Leave1OutLDA')
% 
% GrpMap=load('Summary_lh_OTS_fsavg_roi_diaglinear_GrpRoi.mat')
% Tracts=load('Summary_lh_OTS_fsavg_roi_diaglinear_ILFAFpAFVOF')
% T1=load('Summary_lh_OTS_fsavg_roi_diaglinear_T1GrayT1White')
% GrpRoiTracts=load('Summary_lh_OTS_fsavg_roi_diaglinear_GrpRoiAFILFpAFVOF')
% GrpRoiT1=load('Summary_lh_OTS_fsavg_roi_diaglinear_GrpRoiT1GrayT1White')
% GrpRoiTractsT1=load('Summary_lh_OTS_fsavg_roi_diaglinear_GrpRoiT1GrayT1WhiteAFILFpAFVOF')
% 
% caption_x=['  GR  ';'  FT  ';'  T1  ';' GRFT ';' GRT1 ';'GRFTT1'];
% fig=mybar(DC20means,DC20ste,caption_x,[],[0.5 0.5 0.5],2);
% ylim([0 0.45]);
% ylabel('DC (20% most active)','FontSize',14,'FontName','Arial','FontWeight','bold');
% pbaspect([2 1 2])
% set(gca,'FontSize',14,'FontWeight','bold'); box off; set(gca,'Linewidth',2);   
%   
% lin=refline(0,0.1990);
% set(lin,'Linewidth',3);
% set(lin,'Color',[0 0 0]);
% set(lin,'LineStyle','--');
