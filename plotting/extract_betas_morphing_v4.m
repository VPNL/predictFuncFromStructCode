
clear all;
ExpDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects','NFA_tasks','data_mrAuto');
FigDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/Plots');

outFolder='BetasPredictedROIs';
cd(FigDir)
mkdir(outFolder)
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


rois={'predicted_lh_mOTS_fsavg_roi_linear_T1GrayAFILFVOF' 'predicted_lh_mOTS_disk7mm_fsavg_roi_linear_T1GrayAFILFVOF',...
    'actual_lh_mOTS_fsavg_roi_linear_T1GrayAFILFVOF' 'actual_lh_mOTS_disk7mm_fsavg_roi_linear_T1GrayAFILFVOF'}';
cnt=0;

for r=1
    
    for s = [1 3 4 6 7 9 10 12 15 17 19 20 21 23 24 25 26 27 28 29] 
        cnt=cnt+1;
        cd(fullfile(ExpDir,sessions{s}));
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
    

reshaped_betas=reshape(betas',6,20);
column_of_betas=reshaped_betas(:);

for s = 1:20
    subjects(:,s)=repmat(s,6,1)
end

column_of_subjects=subjects(:);


task=[1 1 2 2 3 3]'
column_of_tasks=repmat(task,s,1);

stims=[1 2 1 2 1 2]'
column_of_stims=repmat(stims,s,1);

input_for_ANOVA=[column_of_betas, column_of_subjects, column_of_tasks, column_of_stims];

factor_names={'task' 'stim'};

rm_anova2(column_of_betas, column_of_subjects, column_of_tasks, column_of_stims, factor_names)
end

%     
%     
%     
%     caption_x=['N'; 'L';' ';'N'; 'L'];
%     caption_y='betas';
%     fig=mybar(xvalues,xerror, caption_x,[],[0 0 0.5; 0 .6 1; 1 1 1; 0 0.5 0; 0.6 1 0; 1 1 1; 0.4 0 0.4; 1 0.2 1],2,0.8);
%     ylim([0 0.4]);
%     % t=title('Exp 2, N=13','FontSize',18,'FontName','Arial','FontWeight','bold');
%     % P = get(t,'Position');
%     % set(t,'Position',[P(1) P(2)-0.05 P(3)])
%     ylabel('signal change [%]','FontSize',22,'FontName','Arial','FontWeight','bold');
%     xlabel('  Add      Read ','FontSize',22,'FontName','Arial','FontWeight','bold');
%     pbaspect([1 1 1])
%     set(gca,'FontSize',22,'FontWeight','bold'); box off; set(gca,'Linewidth',2);
%     
%     cd(FigDir)
%     cd(outFolder)
%     outname=strcat('betas_', rois{r})
%     print(gcf, '-dtiff', outname,'-r600')
%     close all;
% end
% 
% 
% reshaped_betas=reshape(betas',4,20);
% column_of_betas=reshaped_betas(:);
% 
% for s = 1:20
%     subjects(:,s)=repmat(s,4,1)
% end
% 
% column_of_subjects=subjects(:);
% 
% 
% task=[1 1 2 2]'
% column_of_tasks=repmat(task,s,1);
% 
% stims=[1 2 1 2]'
% column_of_stims=repmat(stims,s,1);
% 
% input_for_ANOVA=[column_of_betas, column_of_subjects, column_of_tasks, column_of_stims];
% 
% factor_names={'task' 'stim'};
% 
% rm_anova2(column_of_betas, column_of_subjects, column_of_tasks, column_of_stims, factor_names)
