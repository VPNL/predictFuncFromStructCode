
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

predictors={'T1Gray'}

kernel={'linModel'}

outDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/Plots',strcat('predictedMaps_',kernel{:},'_',predictors{:}))
mkdir(outDir);
cd(outDir);

ROIs={'lh_OTS_from_fsaverage_manual'}
for s=11% s=[2 5 8 11 13 14 16 18 22 30]
for r=1:length(ROIs)
    outname=strcat(predictors{:})
    surfDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/OutputMaps/RegressionGrp1');
      roiDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'ROIs');
      surf_command=[':overlay_color=colorwheel'];
label_command = [':label=' strcat(roiDir,'/',ROIs{r},'.label') ':label_color=black:label_outline=1'];
fs_loadFreeview(fs_ids{s},'lh','vl',fullfile(surfDir,strcat('Subject_',num2str(s),'_lh_OTS_fsavg_regression_',kernel{:},'_Grp1_',predictors{:},'.mgh')),0,[0.00000000000000001,0.5],1.5,true,label_command,[],outname)
end
end
% fs_load_freeview(subj, hemi, vw, map_name, nsmooth, thresh, zoom, screenshot)
% fs_load_freeview('fsaverage', 'lh', 'm', [], 1, [], 1.5, false)