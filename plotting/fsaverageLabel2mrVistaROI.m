% bringing an ROI that is a freesurfer label on the fsaverage brain into
% subject space and then transforming it into mrVista file format to be a
% Gray ROI there
% MR Aug 2017



%% initialization 
%this script loops over all subjects, labels and both hemispheres to align
%an fsaverage-bkup label to the target subjects specified in "targets"
FSdir = '/biac2/kgs/3Danat/FreesurferSegmentations/';   % subject directory for the source labels
ProjectDir = '/biac2/kgs/projects/NFA_tasks/data_mrAuto'; % the directory where the label that should be converted lives
hem = {'lh'};
source = 'fsaverage-bkup';
% savetargets = {'s4_kw_new' } %,'s5_kgs', 's6_nd_new', 's10_mh_new','s12_mf_new','s13_mt_new','s14_gt_new', 's15_mu_new','s16_mw_new','s17_mp_new','s18_xw_new', 's19_jw_new', 's20_gtg_new','s21_kk_new'};
targets = {'siobhan' 'avt' 'anthony_new_recon_2017'...
    'kalanit_new_recon_2017' 'mareike' 'jesse_new_recon_2017'...
    'brianna' 'swaroop' 'eshed' 'richard' 'cody' 'kari' 'alexis' 'nathan'}
%{'LB23_T1w1_final'}%{'KM25_edited'} %{'EA23_edited'}%{'CR24'}%{'CB24_edited'}; {'BM24_edited'};{'anthony_avg_1mm', 'jesse', 'brianna'}; % 'name in anatomy folder (in FreesurferSegmentations)
area = {'IFG1' 'IFG2' 'IPCS' 'OTS' 'ITG' 'STS1' 'STS2' 'STS3'}; % list of  labels that will be aligned, without the hemisphere as prefix
%area = {'Glasser_V1'};

%% prepare freesurfer files to be ready for script that transforms the ROI into a mrVista ROI - run on server
for h = 1:length(hem)
    for s = 1:length(targets)
        dir = [FSdir targets{s} '/'];
        
        for a = 1:length(area)
             
            % bring label from fsaverage space to subject space
            targetlabel =  [hem{h} '.' area{a} '.alignedTo.' targets{s} '.label']; % name it will have
            command = [ 'mri_label2label  --srcsubject ' source ' --srclabel ' FSdir '/' source '/label/' hem{h} '.' area{a}  '.label  --trgsubject ' targets{s} ' --trglabel ' targetlabel ' --regmethod surface --hemi ' hem{h}];
            unix(command);
            
            % convert the label to a nifti file
            %outname = [hem{h} '.' area{a} '.alignedTo.' targets{s} '.nii.gz'];
            outname = [hem{h} '.' area{a} '.nii.gz'];
            % convert label to volume
            command = ['mri_label2vol --label ', dir, 'label/', targetlabel ' --temp ', FSdir, targets{s}, '/mri/orig.mgz', ' --reg ', dir, 'label/register.dat --proj frac 0 1 .1  --fillthresh 0.1  --subject ', targets{s}, ' --hemi ', hem{h}, ' --o ', ProjectDir, outname ] ;
            system(command);
            
            % reslice like mrVista anatomy
             toConvert = [ProjectDir outname];
             fileToBe = [ProjectDir hem{h} '.' area{a} '.alignedTo.' targets{s} '_resampled.nii.gz' ];
%              if strcmp(targets{s}, 'anthony_avg_1mm') || strcmp(targets{s}, 'jesse') || strcmp(targets{s}, 'brianna')
                reffile = ['/biac2/kgs/3Danat/' targets{s} '/t1.nii.gz'];
%              elseif strcmp(targets{s}, 'BM24_edited')
%                 reffile = ['/biac2/kgs/projects/V1myelination/data/retinotopy/BM24_08292015/3DAnatomy/T1_QMR_1mm.nii.gz'];
%              elseif strcmp(targets{s}, 'CB24_edited')
%                 reffile = ['/biac2/kgs/projects/V1myelination/data/retinotopy/CB24_11022015/3DAnatomy/T1wfs_2_1mm.nii.gz'];
%              elseif strcmp(targets{s}, 'CR24')
%                 reffile = ['/biac2/kgs/projects/V1myelination/data/retinotopy/CR24_02132016/3DAnatomy/T1_QMR_1mm.nii.gz'];
%              elseif strcmp(targets{s}, 'EA23_edited')
%                 reffile = ['/biac2/kgs/projects/V1myelination/data/retinotopy/EA23_09062015/3DAnatomy/T1_QMR_1mm.nii.gz'];
%              elseif strcmp(targets{s}, 'GB23_edited')
%                 reffile = ['/biac2/kgs/projects/V1myelination/data/retinotopy/GB23_10232015/3DAnatomy/T1_QMR_1mm.nii.gz'];
%              elseif strcmp(targets{s}, 'KM25_edited')
%                 reffile = ['/biac2/kgs/projects/V1myelination/data/retinotopy/KM25_03252015/3DAnatomy/T1_QMR_1mm.nii.gz'];
%              elseif strcmp(targets{s}, 'LB23_T1w1_final')
%                 reffile = ['/biac2/kgs/projects/V1myelination/data/retinotopy/LB23_12142014/3DAnatomy/T1_QMR_1mm.nii.gz'];
%               end
             
            command = ['mri_convert -ns 1 -rt nearest -rl  ',reffile, ' ', toConvert, ' ', fileToBe ];
             unix(command)
        end
    end
end

%% save out as mrVista ROI - run on mac!

%cd /Volumes/rosenke/projects/facehandsNew
%addpath('/sni-storage/kalanit/biac2/kgs/projects/V1myelination/')
subj = {'01_sc_morphing_112116' '02_at_morphing_102116' '03_as_morphing_112616'...
     '04_kg_morphing_120816' '05_mg_morphing_101916' '06_jg_morphing_102316'...
     '07_bj_morphing_102516' '08_sg_morphing_102716' '10_em_morphing_1110316'... 
     '12_rc_morphing_112316' '13_cb_morphing_120916' '16_kw_morphing_081517'...
     '17_ad_morphing_082217' '18_nc_morphing_083117'};
%{'LB23_12142014'} %{'KM25_03252015'} %{'GB23_10232015'} %{'EA23_09062015'}%{'CR24_02132016'}; %{'CB24_11022015'}; %{'BM24_08292015'};%{'as091515_ret','JG100515','bj110715_ret'};

cd(ProjectDir)


for s = 1:length(targets)
    dir = [FSdir targets{s} '/'];
    cd(subj{s})
    for h = 1:length(hem)
        for a = 1:length(area)
            % read in nifti file
            ni = readFileNifti([ProjectDir hem{h} '.' area{a} '.alignedTo.' targets{s} '_resampled.nii.gz']);
            
            fname = [hem{h} '_' area{a} '.mat' ]; % changing naming so as not to overwrite longi labels if there are preexisting ones
            %fname = [hem{h} '_atlas_' area{a} '.mat' ]; % changing naming so as not to overwrite longi labels if there are preexisting ones
%           
%             if a ==2
%                 fname = [hem{h} '_CoS_Weiner.mat'];
%             end
                    
            spath = [ProjectDir '/' subj{s} '/3Danat/ROIs/'];
            ROI = niftiROI2mrVistaROI(ni, 'name', fname, 'spath', spath, 'color', 'm', 'layer', 2);   % function lives in: /projects/CytoArchitecture/segmentations/code.
            
            h3 = initHiddenGray('GLM',1,fname);
            
            hI = initHiddenInplane('GLMs',1);
            hI = vol2ipCurROI(h3,hI);
            saveROI(hI)
            
            
        end
    end
    cd ..
end

%%

%mrVista
%INPLANE{1} = loadROI(INPLANE{1}, 'lh_Kastner_hV4'); INPLANE{1} = refreshScreen(INPLANE{1});
%INPLANE{1} = loadROI(INPLANE{1}, 'lh_CoS_Weiner'); INPLANE{1} = refreshScreen(INPLANE{1});


