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

map_name = {'02_reading_vs_all_resliced.nii.gz'};

%average surface maps across all sessions
outdir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict/mniSpaceN20/');

cd(outdir);
for ss = [10:13 15:30]
    indir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict/',strcat('Subject_',num2str(ss)),'/Volume')
    anatdir=fullfile('/share/kalanit/biac2/kgs/3Danat/',fs_ids{ss})
    %cmd_str=['mrconvert ' fullfile(anatdir,'brain.mgz') ' '  fullfile(anatdir,'brain.nii.gz')]
    %system(cmd_str)
    nonlinAlign_1_createAffine(fs_ids{ss},'t1.nii.gz','average305_t1_tal_lin.nii',anatdir,outdir,outdir)
   % nonlinAlign_2_createWarp(fullfile(fs_ids{ss}),'MNI152_T1_1mm_256.nii',outdir,outdir,1)    
    nonlinAlign_3_applyAffine(fs_ids{ss},fullfile(indir,map_name{1}),strcat('Subject_',num2str(ss),'_02_reading_vs_all_resliced_affine.nii.gz'),outdir,outdir,1)
    %nonlinAlign_4_applyWarp(fs_ids{ss},strcat('Subject_',num2str(ss),'_02_reading_vs_all_resliced_affine.nii.gz'),strcat('Subject_',num2str(ss),'_02_reading_vs_all_resliced_affine_warped.nii.gz'),outdir,1)   
end

map_name = {'02_reading_vs_all_resliced_affine'};

for ss=[10:13 15:30]
    searchFor=strcat('Subject*',map_name{:},'*');
    all_inputs=dir(searchFor);
    leave1out=strcat('Subject_',num2str(ss),'_',map_name{:},'.nii.gz');
    
    for i=1:length(all_inputs)-1
        if strcmp(all_inputs(i).name,leave1out)
            all_inputs(i)=[];
        end
    end
    
    inputs=strcat({all_inputs(:).name},{' '});
    
    unix(['mri_concat --i ' horzcat(inputs{:}) '--o ' ...
        strcat('Group_',map_name{:}, '_without_Subject_', num2str(ss), '.nii.gz') ' --mean']); % left hemi
end
