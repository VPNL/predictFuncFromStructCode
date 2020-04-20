
% This wrapper loads data into FreeView and saves ScreenShots

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
outDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/Plots',strcat('predictedLabels_',roi{:},'_',kernel{:},'_',predictors{:}))
mkdir(outDir);
cd(outDir);

ROIs={'lh_OTS_from_fsaverage_manual'}

for s=[1 3 4 6 7 9 10 12 15 17 19 20 21 23 24 25 26 27 28 29] 
for r=1:length(ROIs)
    outname=strcat('predicted_',roi{1},'_Subj_',num2str(s))
    surfDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'Surf');
      roiDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'ROIs');
      
label_command = [':label=' strcat(roiDir,'/',ROIs{r},'.label') ':label_color=black:label_outline=1',...
        ':label=./label/aparc2009/predictFuncFromStructROIs/' strcat(roi{:},'_morphing_reading_vs_all_proj_max.label') ':label_color=0,255,0:label_outline=1',...
        ':label=/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputLabels/' strcat('Subject_',num2str(s),'_predicted_',roi{1},'_fsavg_roi_',kernel{:},'_',predictors{:},'.label') ':label_color=255,76,255:label_outline=0'];
fs_loadFreeview(fs_ids{s},'lh','vl',fullfile(surfDir,'02_reading_vs_all_lh_proj_max.mgh'),0,[100,100],1.5,true,label_command,[],outname)

end
end
% fs_load_freeview(subj, hemi, vw, map_name, nsmooth, thresh, zoom, screenshot)
% fs_load_freeview('fsaverage', 'lh', 'm', [], 1, [], 1.5, false)