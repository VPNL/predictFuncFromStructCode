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

% avt kalanit swaroop

map_names = {'01_adding_vs_all' '02_reading_vs_all'};

% loop through sessions and transform maps to fsaverage surfaces using CBA
for ss = 2:30
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
    mkdir(fullfile(PredictDir,'SplitHalfOdd'));
    outDir=fullfile(surf_dir,'predictFuncFromStructOdd');
    mkdir(outDir);
    
    % generate parameter map files from mrVista parameter maps
    for mm = 1:length(map_names)
        map_name = map_names{mm}; % name of a mrVista parameter map file
        map_path = fullfile(ret_dir, 'Gray' ,'GLMs', [map_name '.mat']);
        out_path = fullfile(PredictDir,'SplitHalfOdd', [map_name '.nii.gz']);
        % convert mrVista parameter map into nifti
        cd(ret_dir);
        hg = initHiddenGray('GLMs', 2);
        hg = loadParameterMap(hg, map_path);
        hg = loadAnat(hg);
        functionals2itkGray(hg, 2, out_path);
        cd(mri_dir);
        unix(['mri_convert -ns 1 -odt float -rt interpolate -rl orig.mgz ' ...
            fullfile(PredictDir,'SplitHalfOdd', [map_name '.nii.gz'])...
            ' ' fullfile(PredictDir,'SplitHalfOdd', [map_name '_resliced.nii.gz']) ' --conform']);
        
        % generate freesurfer-compatible surface files for each hemisphere
        cd(surf_dir);
        
        proj_values=[-0.1:0.1:1];
        for p=1:length(proj_values)
            
            unix(['mri_vol2surf --mov ' fullfile(PredictDir,'SplitHalfOdd', [map_name '_resliced.nii.gz']) ...
                ' --reg register.dat --hemi lh --interp trilin --o ' ...
                fullfile(outDir,strcat(map_name, '_lh_proj_', num2str(proj_values(p)), '.mgh'))...
                ' --projfrac ' num2str(proj_values(p))]); % left hemi
            unix(['mri_vol2surf --mov ' fullfile(PredictDir,'SplitHalfOdd', [map_name '_resliced.nii.gz']) ...
                ' --reg register.dat --hemi rh --interp trilin --o ' ...
                fullfile(outDir,strcat(map_name, '_rh_proj_', num2str(proj_values(p)), '.mgh'))...
                ' --projfrac ' num2str(proj_values(p))]); % left hemi
        end
        
        cd(outDir);
        cmd_str=['rm ' strcat(map_name, '_lh_proj_max.mgh')]
        system(cmd_str)
        cmd_str=['rm ' strcat(map_name, '_rh_proj_max.mgh')]
        system(cmd_str)
        
        unix(['mri_concat --i ' strcat(map_name, '_lh_proj_*')...
            ' --o ' strcat(map_name, '_lh_proj_max.mgh')...
            ' --max']);
        unix(['mri_concat --i ' strcat(map_name, '_rh_proj_*')...
            ' --o ' strcat(map_name, '_rh_proj_max.mgh')...
            ' --max']);

        % right hemi
        % transform surface files to fsaverage
        %         map_stem = fullfile(fsa_dir, 'surf', map_name);
        %         subjects={'01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20'}
        %         subject=subjects{ss};
        %         unix(['mri_surf2surf --srcsubject ' fs_id ' --srcsurfval ' ...
        %             map_name '_lh_proj0.mgh --trgsubject fsaverage-bkup --trgsurfval ' ...
        %             map_stem '_lh_proj0_regFrom_subj_' subject '.mgh --hemi lh']); % left hemi
        %         unix(['mri_surf2surf --srcsubject ' fs_id ' --srcsurfval ' ...
        %             map_name '_rh_proj0.mgh --trgsubject fsaverage-bkup --trgsurfval ' ...
        %             map_stem '_rh_proj0_regFrom_subj_' subject '.mgh --hemi rh']);
        
    end
end
