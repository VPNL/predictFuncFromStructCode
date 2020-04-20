
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

predictors={'T1Gray' 'ILF' 'AF' 'VOF'}

kernel={'linModel'}

outDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/Plots',strcat('actualMaps_Grp1_',kernel{:},'_',predictors{:}))
mkdir(outDir);
cd(outDir);

ROIs={'lh_OTS_from_fsaverage_manual'}
for s=11
for r=1:length(ROIs)
    surfDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMaps/RegressionGrp1');
      roiDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'ROIs');
      surf_command=[':overlay_color=colorwheel'];
label_command = [':label=' strcat(roiDir,'/',ROIs{r},'.label') ':label_color=black:label_outline=1',...%];
        ':label=./label/aparc2009/predictFuncFromStructROIs/' strcat('lh_OTS_union_morphing_reading_vs_all_proj_max.label') ':label_color=0,255,0:label_outline=1'];
fs_loadFreeview(fs_ids{s},'lh','vl',fullfile(surfDir,strcat('Actual_Subject_',num2str(s),'_lh_OTS_fsavg_regression_',kernel{:},'_Grp1_',predictors{:},'.mgh')),0,[0.0000000001,3],1.5,true,label_command,[],[])
end
end
% fs_load_freeview(subj, hemi, vw, map_name, nsmooth, thresh, zoom, screenshot)
% fs_load_freeview('fsaverage', 'lh', 'm', [], 1, [], 1.5, false)