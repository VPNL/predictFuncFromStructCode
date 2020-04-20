
clear all;
ExpDir=fullfile('/sni-storage/kalanit/biac2/kgs/projects','NFA_tasks','data_mrAuto');
FreesurferDir=fullfile('/sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations');

subjects = {'siobhan' 'avt' 'anthony_new_recon_2017'...
    'kalanit_new_recon_2017' 'mareike' 'jesse_new_recon_2017'...
    'brianna' 'swaroop' 'eshed'...
    'richard' 'cody' 'marisa'...
    'kari' 'alexis' 'nathan'...
    'dawn' 'erica' 'th'...
    'ek' 'gm' 'bl'...
    'mw' 'jk' 'pe'...
    'ie' 'pw' 'ks' ...
    'mz' 'mm' 'ans'};


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

for s=[1 3 4 6 7 9 10 12 15 17 19 20 21 23 24 25 26 27 28 29] 
    subjectDir=fullfile('/sni-storage/kalanit/biac2/kgs/3Danat/', subjects{s});
    dataPath = fullfile(subjectDir, '/niftiRois_Prediction');
    mkdir(dataPath)
    
    %    roiList={'lh_IFG_union_morphing_reading_vs_all'};
    
    roiList={'predicted_lh_mOTS_fsavg_roi_linear_T1GrayAFILFVOF' 'predicted_lh_mOTS_disk7mm_fsavg_roi_linear_T1GrayAFILFVOF',...
        'actual_lh_mOTS_fsavg_roi_linear_T1GrayAFILFVOF' 'actual_lh_mOTS_disk7mm_fsavg_roi_linear_T1GrayAFILFVOF'};
    
    
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
            spath = [fullfile(subjectDir,'ROIs/')];
            ROI = niftiROI2mrVistaROI(img, 'name', roiList{r}, 'spath', spath, 'color', 'm', 'layer', 2);   % function lives in: /projects/CytoArchitecture/segmentations/code.
            
            cd(fullfile(ExpDir,sessions{s}))
            h3 = initHiddenGray('GLM',1,roiList{r});
            
            hI = initHiddenInplane('GLMs',1);
            hI = vol2ipCurROI(h3,hI);
            saveROI(hI)
            
            
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