
% this script converts predicted rois from mat format to freesurfer label, so that they can be displayed in FreeView 
ROIs={'lh_OTS_anat'};

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

for s=[1 3 4 6:9]
for r=1:length(ROIs)
    cd(fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/PredictMatrixes'));
    load(strcat('Poly_zST1_Subject_',num2str(s),'_',ROIs{r},'_roi_SmallMT1_output.mat'));
    label = read_label(fs_ids{s},fullfile('aparc2009/predictFuncFromStructBoundaries',ROIs{r}));

    label(:,5)=readLabelBinary(:,1);
    predctionLabel=label(label(:,5)>0,:);
    cd(fullfile('/share/kalanit/biac2/kgs/3Danat/FreesurferSegmentations',fs_ids{s},'label/aparc2009/predictFuncFromStructBoundaries'));
    write_label(predctionLabel(:,1), predctionLabel(:,2:4), predctionLabel(:,5),fullfile(strcat(ROIs{r},'_Poly_new_readPredicted.label')));
    
end
end
