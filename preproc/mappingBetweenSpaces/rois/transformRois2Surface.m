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

%ROIs = {'lh_ITG_anat' 'rh_ITG_anat' 'lh_OTS_union_morphing_reading_vs_all'};
ROIs = {'lh_mOTS_morphing_reading_vs_all_disk_7mm'};


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
    roiDir=fullfile(RAID,'projects', 'PredictFuncFromStruct', 'data4Predict', strcat('Subject_',num2str(ss)),'ROIs');
    surfDir=fullfile(RAID,'projects', 'PredictFuncFromStruct', 'data4Predict', strcat('Subject_',num2str(ss)),'Surf');
    mkdir(roiDir);
    % generate parameter map files from mrVista parameter maps
    
    cd(ret_dir);
    
    hG = initHiddenGray(1,1,ROIs);
    
    mkdir(roiDir);
    t1name=fullfile(anat_dir, 't1.nii.gz');
    
    
    t1=readFileNifti(t1name); % we are loading the t1 nifti to get all the nifti structure information correct so when we later use mri_convert it will be aligned properly to orig.mgz
    hG=loadAnat(hG); % this loads the anatomy based on the global variable vANATOMTPATH
    
    anatSize=viewGet(hG,'anatomy size'); % get the anatomy size;
    % add a check that it matches the t1 size
    
    if size(t1.data)~=anatSize
        fprintf('Error: size of t1 and vANAT do not match \n');
        return
    end
    
    if isempty(t1.data)
        fprintf('Error: t1 is empty\n');
        return
    end
    
    
    
    
    for rr = 1:length(ROIs)
        roi = ROIs{rr}; % name of a mrVista parameter map file
        
        hG.selectedROI=rr;
        if size(hG.ROIs,2)>0
            coords = getCurROIcoords(hG);
            len = size(coords, 2);
            
            % make a 3D image with all points set to zero except ROI = roiColor
            roiData = zeros(anatSize);
            for ii = 1:len
                roiData(coords(1,ii), coords(2,ii), coords(3,ii)) = 1;
            end
            
        else
            roiData = zeros(anatSize);
        end
        
        % Convert mrVista format to our preferred axial format for NIFTI
        mmPerVox = viewGet(hG, 'mmPerVox');
        [data, xform, ni] = mrLoadRet2nifti(roiData, mmPerVox);
        % create the nifti structure based on the original anatomy t1 structure
        % so all the transformation information matches up between the
        % functional ROIs and the t1 anatomy
        fROI=t1;
        fROI.data=ni.data; % data is the ROI data
        outname=fullfile(roiDir, strcat(ROIs{rr}, '.nii.gz')); % outfile for the nifti ROI
        fROI.fname=outname;
        %    fprintf('writing %s ...\n', outname);
        writeFileNifti(fROI); % write the nifti file
        
        cd(mri_dir);
        unix(['mri_convert -ns 1 -odt float -rt nearest -rl orig.mgz ' ...
            fullfile(roiDir, [roi '.nii.gz'])...
            ' ' fullfile(roiDir, [roi '_resliced.nii.gz']) ' --conform']);
        
        % generate freesurfer-compatible surface files for each hemisphere
        cd(surf_dir);
        
        proj_values=[-0.1:0.1:1];
        for p=1:length(proj_values)
            
            roiName=strsplit(roi,'_')
            if strcmp('lh',roiName(1))>0
                unix(['mri_vol2surf --mov ' fullfile(roiDir, [roi '_resliced.nii.gz']) ...
                    ' --reg register.dat --hemi lh --interp nearest --o ' ...
                    fullfile(roiDir,strcat(roi, '_proj_', num2str(proj_values(p)), '.mgh'))...
                    ' --projfrac ' num2str(proj_values(p))]); % left hemi
            else
                unix(['mri_vol2surf --mov ' fullfile(roiDir, [roi '_resliced.nii.gz']) ...
                    ' --reg register.dat --hemi rh --interp nearest --o ' ...
                    fullfile(roiDir,strcat(roi, '_proj_', num2str(proj_values(p)), '.mgh'))...
                    ' --projfrac ' num2str(proj_values(p))]); % left hemi
            end
        end
        
        cd(roiDir);
        cmd_str=['rm ' fullfile(roiDir,strcat(roi,'_proj_max.mgh'))]
        system(cmd_str)
        
        
        cd(roiDir);
        unix(['mri_concat --i ' strcat(roi, '_proj_*')...
            ' --o ' fullfile(roiDir,strcat(roi,'_proj_max.mgh'))...
            ' --max']);
        
    end
end
