%% This code was run in MATLAB R2012b to produce subplots in Fig 5 and save them

clear all
close all

% Experiment and code directories (path is machine specific)
ExpDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects','PredictFuncFromStruct');
CodeDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects','PredictFuncFromStruct','predictFuncFromStructCode');
OutDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects','PredictFuncFromStruct','predictFuncFromStructCode','figuresForPublication');

outFolder='Output_Fig5';
cd(OutDir)
mkdir(outFolder)

%% Fig 5a
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
roi={'lh_mOTS'}
cd(fullfile(OutDir,outFolder));
ROIs={'lh_OTS_from_fsaverage_manual'}

for s=[21 19 24] 
    outname=strcat('predicted_',roi{1},'_Subj_',num2str(s))
    surfDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'Surf');
      roiDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'ROIs');
      
label_command = [':label=' strcat(roiDir,'/',ROIs{1},'.label') ':label_color=black:label_outline=1',...
        ':label=./label/aparc2009/predictFuncFromStructROIs/' strcat(roi{:},'_morphing_reading_vs_all_proj_max.label') ':label_color=0,255,0:label_outline=1',...
        ':label=/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputLabels/' strcat('Subject_',num2str(s),'_predicted_',roi{1},'_fsavg_roi_',kernel{:},'_',predictors{:},'.label') ':label_color=255,76,255:label_outline=0'];
fs_loadFreeview(fs_ids{s},'lh','vl',fullfile(surfDir,'02_reading_vs_all_lh_proj_max.mgh'),0,[100,100],1.5,true,label_command,[],outname)
end

%% Fig 5b
cd('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMatrixes/Leave1OutLDA')

mOTS=load('Summary_lh_mOTS_fsavg_roi_linear_T1GrayAFILFVOF.mat')
Disk=load('Summary_lh_mOTS_disk7mm_fsavg_roi_linear_T1GrayAFILFVOF.mat')
OTS=load('Summary_lh_OTS_union_fsavg_roi_linear_T1GrayAFILFVOF.mat')

DCs=[mOTS.resultsT.DC Disk.resultsT.DC]
DCChance=[mOTS.resultsT.DCChance Disk.resultsT.DCChance]

close all
caption_x=['mOTS';'Disk'];
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

[ttest_h,ttest_p]=ttest(DCs(:,2),DCChance(:,2),'Alpha',0.05/2)

cd(fullfile(OutDir,outFolder));
outname=strcat('Fig5b.tif')
print(gcf, '-dtiff', outname,'-r600')

%% Fig 5c
close all;
sessions={'01_sc_morphing_112116' '02_at_morphing_102116' '03_as_morphing_112616'...
    '04_kg_morphing_120816' '05_mg_morphing_101916' '06_jg_morphing_102316'...
    '07_bj_morphing_102516' '08_sg_morphing_102716' '10_em_morphing_1110316'...
    '12_rc_morphing_112316' '13_cb_morphing_120916' '15_mn_morphing_012017'...
    '16_kw_morphing_081517' '17_ad_morphing_082217' '18_nc_morphing_083117'...
    '19_df_morphing_111218' '21_ew_morphing_111618' '22_th_morphing_112718'...
    '23_ek_morphing_113018' '24_gm_morphing_120618' '25_bl_morphing_122018'...
    '26_mw_morphing_031919' '27_jk_morphing_032119' '28_pe_morphing_040219'...
    '29_ie_morphing_040519' '30_pw_morphing_041119' '31_ks_morphing_041019'...
    '32_mz_morphing_042219' '33_mm_morphing_050619' '34_ans_morphing_05072019'};


rois={'predicted_lh_mOTS_fsavg_roi_linear_T1GrayAFILFVOF'}';
cnt=0;
r=1;
    
    for s = [1 3 4 6 7 9 10 12 15 17 19 20 21 23 24 25 26 27 28 29] 
        cnt=cnt+1;
        cd(fullfile(ExpDir,'data_mrAuto',sessions{s}));
        hi = initHiddenInplane(5,1,rois{r});
        if size(hi.ROIs,2)>0
            tc_plotScans(hi,1);
            tc_applyGlm;
            tc_dumpDataToWorkspace;
            d = fig1Data;
            betas(cnt,:) = d.glm.betas(5:10);
            sems(cnt,:) = d.glm.sems(5:10);
            close all;
        end
    end
    
    
bet=mean(betas);
sem=mean(sems);

xvalues=[bet(3:4) 0 bet(1:2) 0 bet(5:6)];
xerror=[sem(3:4) 0 sem(1:2) 0 sem(5:6)];

caption_x=['N'; 'L';' ';'N'; 'L';' '; 'N'; 'L'];
caption_y='betas';
fig=mybar(xvalues,xerror, caption_x,[],[0 0.5 0; 0.6 1 0; 1 1 1; 0 0 0.5; 0 .6 1; 1 1 1; 0.4 0 0.4; 1 0.2 1],2,0.8);
ylim([0 0.40]);
% t=title('Exp 2, N=13','FontSize',18,'FontName','Arial','FontWeight','bold');
% P = get(t,'Position');
% set(t,'Position',[P(1) P(2)-0.05 P(3)])
ylabel('signal change [%]','FontSize',22,'FontName','Arial','FontWeight','bold');
xlabel('Read     Add     Color','FontSize',24,'FontName','Arial','FontWeight','bold');
pbaspect([1 1 1])
set(gca,'FontSize',24,'FontWeight','bold'); box off; set(gca,'Linewidth',2);   
cd(fullfile(OutDir,outFolder));
outname=strcat('Fig5c.tif')
print(gcf, '-dtiff', outname,'-r600')

