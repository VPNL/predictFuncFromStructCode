%% store paths to data directories and copy necessary files
% before this runs you need to copy the regsiter.dat file form
% FreesurferSegmentations/subject/labels to
% FreesurferSegmentations/subject/surf


anat_ids = {'siobhan' 'avt' 'anthony_new_recon_2017'...
    'kalanit_new_recon_2017' 'mareike' 'jesse_new_recon_2017'...
    'brianna' 'swaroop' 'eshed'...
    'richard' 'cody' 'marisa'...
    'kari' 'alexis' 'nathan'...
    'dawn' 'erica' 'th'...
    'ek' 'gm' 'bl'...
    'mw' 'jk' 'pe'...
    'ie' 'pw' 'ks' ...
    'mz' 'mm' 'ans'};

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

RAID=['/sni-storage/kalanit/biac2/kgs'];

fsa_dir = fullfile(RAID, '3Danat', 'FreesurferSegmentations', 'fsaverage-bkup');

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

% loop through sessions and transform maps to fsaverage surfaces using CBA
for ss = 1:30
    anat_id = anat_ids{ss}; fs_id = fs_ids{ss}; ret_session = sessions{ss};
    % path to subject data in 3Danat
    anat_dir = fullfile(RAID, '3Danat', anat_id);
    % path to subject data in FreesurferSegmentations
    fs_dir = fullfile(RAID, '3Danat', 'FreesurferSegmentations', fs_id);
    % paths to subject mri and surf directories
    mri_dir = fullfile(fs_dir, 'mri'); surf_dir = fullfile(fs_dir, 'surf');
    % path to subject retinotopy session
    ret_dir = fullfile(RAID,'projects', 'NFA_tasks', 'data_mrAuto', ret_session);
    PredictDir = fullfile(RAID,'projects', 'PredictFuncFromStruct', 'data4Predict', strcat('Subject_',num2str(ss)));
    if ~exist(PredictDir)
        cmdstr=(['mkdir ', PredictDir]);
        system(cmdstr)
    end
    
        PredictDirVolume = fullfile(RAID,'projects', 'PredictFuncFromStruct', 'data4Predict', strcat('Subject_',num2str(ss)),'Volume');
    if ~exist(PredictDirVolume)
        cmdstr=(['mkdir ', PredictDirVolume]);
        system(cmdstr)
    end
    
        PredictDirSurf = fullfile(RAID,'projects', 'PredictFuncFromStruct', 'data4Predict', strcat('Subject_',num2str(ss)),'Surf');
    if ~exist(PredictDirSurf)
        cmdstr=(['mkdir ', PredictDirSurf]);
        system(cmdstr)
    end
    
%             PredictDirMatrix = fullfile(RAID,'projects', 'PredictFuncFromStruct', 'data4Predict', strcat('Subject_',num2str(ss)),'PredictMatrix');
%     if ~exist(PredictDirMatrix)
%         cmdstr=(['mkdir ', PredictDirMatrix]);
%         system(cmdstr)
%     end
    
    
    
    PredictDir3Danat = fullfile(RAID,'projects', 'PredictFuncFromStruct', 'data4Predict', strcat('Subject_',num2str(ss)),'3Danat');
    if ~exist(PredictDir3Danat)
        cmdstr=(['ln -s ', anat_dir, ' ', PredictDir3Danat]);
        system(cmdstr)
    end
    
        PredictDirFSDir = fullfile(RAID,'projects', 'PredictFuncFromStruct', 'data4Predict', strcat('Subject_',num2str(ss)),'FSDir');
    if ~exist(PredictDirFSDir)
        cmdstr=(['ln -s ', fs_dir, ' ', PredictDirFSDir]);
        system(cmdstr)
    end
    
    
end