
clear all;
ExpDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects','NFA_tasks','data_mrAuto');
FreesurferDir=fullfile('/sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations');

subjects={'siobhan' 'avt' 'anthony_new_recon_2017'...
    'kalanit_new_recon_2017' 'mareike' 'jesse_new_recon_2017'...
    'brianna' 'swaroop' 'eshed'...
    'richard' 'cody' 'marisa'...
    'kari' 'alexis' 'nathan'...
    'dawn' 'erica' 'th'...
    'ek' 'gm'}

sessions={'01_sc_dti_080917' '02_at_dti_080517' '03_as_dti_083016'...
    '04_kg_dti_101014' '05_mg_dti_071217' '06_jg_dti_083016'...
    '07_bj_dti_081117' '08_sg_dti_081417' '10_em_dti_080817'...
    '12_rc_dti_080717' '13_cb_dti_081317' '15_mn_dti_091718'...
    '16_kw_dti_082117' '17_ad_dti_081817' '18_nc_dti_090817'...
    '19_df_dti_111218' '21_ew_dti_111618' '22_th_dti_112718'... 
    '23_ek_dti_113018' '24_gm_dti_112818'}

for s=1
subjectDir=fullfile('/sni-storage/kalanit/biac2/kgs/3Danat/', subjects{s});
dataPath = fullfile(subjectDir, '/niftiRois_Prediction');
mkdir(dataPath)

%    roiList={'lh_IFG_union_morphing_reading_vs_all'};
    
        roiList={'lh_mOTS_fsavg_roi_linear_T1GrayAFILFVOF'};


labelPath=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputLabels');


roiVal=1;

for r=1:length(roiList)
    % first transform niftis to FreeSurfer labels
%nii2label(subjects{s},dataPath,roiList(r),roiVal,labelPath)

% 
%next dilate labels and safe as niftis
label=strcat(labelPath,'/', 'Subject_', num2str(s),'_',roiList{r}, '.label');
nifti=strcat(dataPath,'/', roiList{r});

ref= fullfile(subjectDir,'t1.nii.gz');

cd(fullfile(labelPath))

if exist(label)>0
    if r<11
        hem='lh'
    else hem='rh'
    end
    
fs_labelFileToNiftiRoiNew(subjects{s},label,nifti,hem,ref,0)

% finally save roi coordinates in mat file
img=niftiRead(strcat(dataPath,'/', roiList{r}, '.nii.gz'));

load(strcat(ExpDir,'/', sessions{s}, '/96dir_run1/dti96trilin/ROIs/', roiList{r},'.mat'))

imgCoords = find(img.data);
[I,J,K] = ind2sub(img.dim, imgCoords); 
roi.coords  = mrAnatXformCoords(img.qto_xyz, [I,J,K]);

cd(fullfile(ExpDir,'/', sessions{s}, '/96dir_run1/dti96trilin/ROIs/'));
outname=strcat(roiList{r},'_projed.mat')
save(outname,'roi','versionNum','coordinateSpace');
end
end
end



% 
% temp=strcat(subjectDir,'/','t1.nii.gz');
% registration=strcat(FreesurferDir, '/',subject,'/label/register.dat');
% 
% src=strcat(subjectDir, '/labels/lh_OTS_union_morphing_reading_vs_all_test.label')
% out=strcat(subjectDir, '/niftiRois/lh_OTS_union_morphing_reading_vs_all_surf.mgz')
% registration=strcat(FreesurferDir, '/',subject,'/label/register.dat');
% 
% % cmd = ['mri_vol2surf --src ', src, ' --out ', out, ' --srcreg ', registration, ' --hemi lh']
% % unix(cmd)
% %  
% %cmd = ['mri_vol2surf --src ', subject, ' --srclabel ', srclabel, ' --trgsubject ', subject, ' --trglabel ', trglabel,' --regmethod surface --projfrac -100 --hemi lh']
% %unix(cmd)
% 
% 

% cmd = ['mri_label2vol --subject ' subject, ' --label ', label, ' --temp ', temp, ' --reg ', registration, ' --proj abs -2.5 0 .1 --hemi lh --o test_label.nii.gz']
% unix(cmd)

%trglabel=strcat(labelPath,'/', roiList{1}, '_projed.label');
% 
% cmd = ['mri_label2label --srcsubject ', subject, ' --srclabel ', srclabel, ' --trgsubject ', subject, ' --trglabel ', trglabel,' --regmethod surface --projfrac -100 --hemi lh']
% unix(cmd)