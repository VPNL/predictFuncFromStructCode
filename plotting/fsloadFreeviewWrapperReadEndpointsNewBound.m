
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

tracts={'UCI' 'IFOF' 'ILF' 'AF' 'pAF' 'VOF'}
tractnums=[17 11 13 19 23 21];

for t=1:length(tractnums)
outDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/Plots',strcat(tracts{t},'_endpoints_newBound'));
mkdir(outDir);
cd(outDir);
outname=tracts{t};
ROIs={'lh_OTS_from_fsaverage_manual'}
for s=11
for r=1:length(ROIs)
    surfDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'Surf');
    roiDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'ROIs');
label_command = [':label=' strcat(roiDir,'/',ROIs{r},'.label') ':label_color=black:label_outline=1'];
    surf_command=[':overlay_color=colorwheel'];
fs_loadFreeview(fs_ids{s},'lh','vl',fullfile(surfDir,strcat('04_lh_OTS_from_fsaverage_manual_FG_track_',num2str(tractnums(t)),'_lh_proj_max.mgh')),0,[0.5,10],1.5,true,label_command,surf_command,outname)

end
end
end
% fs_load_freeview(subj, hemi, vw, map_name, nsmooth, thresh, zoom, screenshot)
% fs_load_freeview('fsaverage', 'lh', 'm', [], 1, [], 1.5, false)