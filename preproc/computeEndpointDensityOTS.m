% ﻿Diffusion tool combine Vistasoft, MRtrix, LiFE and AFQ  to produce functional defined fasciculus.
%It requires these toolboxs installed, and also required the fROI defined by vistasoft. 
%The pipeline is orgnized as bellow.
%clear all;

% The following parameters need to be adjusted to fit your system
fatDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects/NFA_tasks/data_mrAuto');
anatDir_system =fullfile('/biac2/kgs/3Danat');
anatDir =('/sni-storage/kalanit/biac2/kgs/3Danat');
fsDir=('/sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations');

sessid={'01_sc_dti_mrTrix3_080917' '02_at_dti_mrTrix3_080517' '03_as_dti_mrTrix3_083016'...
    '04_kg_dti_mrTrix3_101014' '05_mg_dti_mrTrix3_071217' '06_jg_dti_mrTrix3_083016'...
    '07_bj_dti_mrTrix3_081117' '08_sg_dti_mrTrix3_081417' '10_em_dti_mrTrix3_080817'...
    '12_rc_dti_mrTrix3_080717' '13_cb_dti_mrTrix3_081317' '15_mn_dti_mrTrix3_091718'...
    '16_kw_dti_mrTrix3_082117' '17_ad_dti_mrTrix3_081817' '18_nc_dti_mrTrix3_090817'...
    '19_df_dti_mrTrix3_111218' '21_ew_dti_mrTrix3_111618' '22_th_dti_mrTrix3_112718'...
    '23_ek_dti_mrTrix3_113018'  '24_gm_dti_mrTrix3_112818' '25_bl_dti_mrTrix3_120718'...
    '26_mw_dti_mrTrix3_032019' '27_jk_dti_mrTrix3_032019' '28_pe_dti_mrTrix3_040319'...
    '29_ie_dti_mrTrix3_040319' '30_pw_dti_mrTrix3_041219' '31_ks_dti_mrTrix3_041019'...
    '32_mz_dti_mrTrix3_041519' '33_mm_dti_mrTrix3_041619' '34_ans_dti_mrTrix3_041819'}

%anatid={'erica' 'th' 'ek' 'gm' 'ar'}
anatid={'siobhan' 'avt' 'anthony_new_recon_2017'...
    'kalanit_new_recon_2017' 'mareike' 'jesse_new_recon_2017'...
    'brianna' 'swaroop' 'eshed'...
    'richard' 'cody' 'marisa'...
    'kari' 'alexis' 'nathan'...
    'dawn' 'erica' 'th'...
    'ek' 'gm' 'bl'...
    'mw' 'jk' 'pe'...
    'ie' 'pw' 'ks' ...
    'mz' 'mm' 'ans'};

runName={'96dir_run1_noFW'};
t1_name=['t1.nii.gz'];

for s=1
    close all;
    % Ok, here we go
    
        PredictDirTracts = fullfile('/sni-storage/kalanit/biac2/kgs','projects', 'PredictFuncFromStruct', 'data4Predict', strcat('Subject_',num2str(s)),'Tracts');
    if ~exist(PredictDirTracts)
        cmdstr=(['mkdir ', PredictDirTracts]);
        system(cmdstr)
    end
    
    PredictDirVolume = fullfile('/sni-storage/kalanit/biac2/kgs','projects', 'PredictFuncFromStruct', 'data4Predict', strcat('Subject_',num2str(s)),'Volume');
    
    % save out individual tracts
for r=1:length(runName)
for fiberNum=[1:21 27]
    fgName=['WholeBrainFGRadSe_classified_clean.mat']
    fg=load(fullfile(fatDir,sessid{s},runName{r},'dti96trilin/fibers/afq',fgName))
    myfg = fg.fg(fiberNum); 
    
    if fiberNum<23
        fiberNumName=fiberNum;
    elseif fiberNum==27
        fiberNumName=23;
    elseif fiberNum==28
        fiberNumName=24;
    end
    
    fiberName = ['04_WholeBrainFG_track_' num2str(fiberNumName) '.tck'];
    fpn = fullfile(PredictDirTracts, fiberName);
    dr_fwWriteMrtrixTck(myfg, fpn);
end
end
    
    %convert to nifis
for r=1:length(runName)
    for fiberNum=[1:21 27]
        
        if fiberNum<23
            fiberNumName=fiberNum;
        elseif fiberNum==27
            fiberNumName=23;
        elseif fiberNum==28
            fiberNumName=24;
        end
        
        t1=fullfile(fatDir,sessid{s},runName{r},'/t1/t1.nii.gz');
        fiberName = ['04_WholeBrainFG_track_' num2str(fiberNumName) '.tck'];
        fg= fullfile(PredictDirTracts,fiberName);
        outname = ['04_WholeBrainFG_track_' num2str(fiberNumName) '.nii.gz'];
        outdir=fullfile(PredictDirVolume);
        
        if ~exist(PredictDirVolume)
        mkdir(outdir);
        end
        
        output=fullfile(outdir,outname);
        bkgrnd = false;
        verbose = true;
        mrtrixVersion = 3;
        
        cmd_str = ['tckmap -template ' t1...
            ' -ends_only -info'...
            ' -contrast tdi -force ' fg ' ' output]
        
        [status,results] = AFQ_mrtrix_cmd(cmd_str, bkgrnd, verbose,mrtrixVersion);
    end
end



end