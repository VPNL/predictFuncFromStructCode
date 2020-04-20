
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

outDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/Plots/T1Gray');
mkdir(outDir);
cd(outDir);

ROIs={'lh_OTS_from_fsaverage_manual'}
for s=11
for r=1:length(ROIs)
    surfDir=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict',strcat('Subject_',num2str(s)),'Surf');
label_command = [':label=./label/aparc2009/predictFuncFromStructBoundaries/' strcat(ROIs{r},'.label') ':label_color=black:label_outline=1'];
   surf_command=[':overlay_color=truncated'];
fs_loadFreeview(fs_ids{s},'lh','vl',fullfile(surfDir,'03_T1_in_GM_lh_proj_mean.mgh'),0,[0.80,1.70],1.5,true,label_command,surf_command,[])



end
end
% fs_load_freeview(subj, hemi, vw, map_name, nsmooth, thresh, zoom, screenshot)
% fs_load_freeview('fsaverage', 'lh', 'm', [], 1, [], 1.5, false)