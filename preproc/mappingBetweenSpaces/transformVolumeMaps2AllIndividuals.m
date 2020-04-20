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

% avt kalanit swaroop

map_name = {'Group_02_reading_vs_all_resliced_affine_without_Subject_'};

% loop through sessions and transform maps to fsaverage surfaces using CBA
for ss = 1:30%1:30 %the output subject
    
    anat_id = anat_ids{ss}; fs_id = fs_ids{ss};
    % path to subject data in 3Danat
    anat_dir = fullfile(RAID, '3Danat', anat_id);
    % path to subject data in FreesurferSegmentations
    fs_dir = fullfile(RAID, '3Danat', 'FreesurferSegmentations', fs_id);
    % paths to subject mri and surf directories
    mri_dir = fullfile(fs_dir, 'mri'); surf_dir = fullfile(fs_dir, 'surf');
    % path to subject retinotopy session
    in_dir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict/fsaverageSpace');
    sourcepath=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict/mniSpace');
    outdir = fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_', num2str(ss)),'/GrpMapsVolumeMNI/');
    mkdir(outdir)
    
    indir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict/',strcat('Subject_',num2str(ss)),'/Volume')
    anatdir=fullfile('/share/kalanit/biac2/kgs/3Danat',fs_ids{ss})
    nonlinAlign_1_createAffine(fs_ids{ss},'average305_t1_tal_lin.nii','t1.nii.gz',sourcepath,anatdir,outdir)
    %nonlinAlign_1_createAffine(subject,source,target,sourcepath,targetpath,outpath)
    %nonlinAlign_2_createWarp(fs_ids{ss},'brain.nii.gz',anatdir,outdir,1)
    for s=1:30%:30 %the left out subject
        nonlinAlign_3_applyAffine(fs_ids{ss},fullfile(sourcepath,strcat(map_name{1},num2str(s),'.nii.gz')),strcat(map_name{1},num2str(s),'.nii.gz'),outdir,outdir,1)
        %nonlinAlign_4_applyWarp(fs_ids{ss},strcat(map_name{1},num2str(s),'.nii.gz'),strcat(map_name{1},num2str(s),'_final.nii.gz'),outdir,1)
        
        
        % transform surface files to fsaverage
        %   unix(['mri_surf2surf --srcsubject fsaverage-bkup --srcsurfval ' ...
        %       fullfile(in_dir,strcat(map_name{:},num2str(s),'.mgh')) ' --trgsubject ' fs_id ' --trgsurfval ' ...
        %       fullfile(out_dir,strcat(map_name{:},num2str(s),'.mgh')) ' --hemi lh']); % left hemi
    end
end
