

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

for s=[1];
for r=1:length(ROIs)
    cd(fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/PredictMatrixes'));
    load(strcat('RBF_test_Subject_',num2str(s),'_',ROIs{r},'_roi_output.mat'));
    label = read_label(fs_ids{s},fullfile('aparc2009/predictFuncFromStructBoundaries',ROIs{r}));
    %read_label(fs_ids{s},fullfile('aparc2009',strcat(hems{hem},'.S_precentral-inf-part')
    label(:,5)=readLabelBinary(:,1);
    predctionLabel=label(label(:,5)>0,:);
    cd(fullfile('/share/kalanit/biac2/kgs/3Danat/FreesurferSegmentations',fs_ids{s},'label/aparc2009/predictFuncFromStructBoundaries'));
    write_label(predctionLabel(:,1), predctionLabel(:,2:4), predctionLabel(:,5),fullfile(strcat(ROIs{r},'_roi_RBF_test_readPredicted.label')));
    
end
end

% 
% label = read_label('fsaverage-bkup','lh.IFG_anat')
% cd('/share/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/surf')
% [vol, M, mr_params, volsz]  = load_mgh('02_reading_vs_all_lh_concat.mgh')
% 
% for tresh=[0 0.5 1]
%     clear labelN;
%     clear idx;
%     
% idx=find(vol>tresh);
% cnt=0;
% 
% for i=1:length(label(:,1))
%     
%     if find(idx==label(i,1))>0
%         cnt=cnt+1
%         labelN(cnt,:,:,:,:)=label(i,:,:,:,:)
%     end
% end
% 
% cd('/share/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/mrLanes')
% output= write_label(labelN(:,1), labelN(:,2:4), labelN(:,5),strcat('lh.IFG_anat_param_',num2str(tresh),'.label'));
% end
   % ok = write_label(lindex, lxzy, lvals, labelfile, <subjid>,<space name>)