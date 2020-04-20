%% organizes the data for the prediction project into mat files, which are then fed into the SVM
% before this runs you need to copy the regsiter.dat file form
% FreesurferSegmentations/subject/labels to
% FreesurferSegmentations/subject/surf


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

RAID=['/sni-storage/kalanit/biac2/kgs'];

fsfolder=fullfile(RAID, '3Danat', 'FreesurferSegmentations');


fsa_dir = fullfile(RAID, '3Danat', 'FreesurferSegmentations', 'fsaverage-bkup');
maps={'lh_mOTS_morphing_reading_vs_all_disk_7mm' '01_adding_vs_all' '02_reading_vs_all' '03_T1_in_GM' '03_T1_in_WM'};
outFolder=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/PredictMatrixesROIs');
output=[];

%     if exist(outFolder)
%     cmdstr=['rm -r ' outFolder]
%     system(cmdstr)
%     end
%     
%     cmdstr=['mkdir ' outFolder]
%     system(cmdstr)

for s=1:30

    labelfolder=fullfile(fsfolder, fs_ids{s}, 'label/aparc2009/predictFuncFromStructBoundaries')
    cd(labelfolder)
    
    cmdstr=['cp ' fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict', strcat('Subject_',num2str(s)), 'ROIs','lh_OTS_from_fsaverage_manual.label'),...
        ' ' fullfile(fsfolder,fs_ids{s},'label/aparc2009/predictFuncFromStructBoundaries/','lh_OTS_from_fsaverage_manual.label')];
    system(cmdstr);
    
    label = read_label(fs_ids{s},strcat('aparc2009/predictFuncFromStructBoundaries/','lh_OTS_from_fsaverage_manual'));
    
    predictorsA=zeros(length(label),length(maps)+14-4);
    roiRead=zeros(length(label),1);
    responseMath=zeros(length(label),1);
    responseRead=zeros(length(label),1);
    hem={'lh'}
    
    predictorsT = array2table(predictorsA,'VariableNames',{'T1Gray' 'T1White' 'TR' 'CS' 'CC' 'CH'...
        'CFMa' 'CFMi' 'IFOF' 'ILF' 'SLF' 'UCI' 'AF' 'VOF' 'pAF'});
    
    tracks_lh=[1 3 5 6 7 9  11 13 15 17 19 21 23]
    tracks_rh=[2 4 5 6 8 10 12 14 16 18 20 22 24]
    
    for m=1:length(maps)-1+13
        surfFolder=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict', strcat('Subject_',num2str(s)), 'Surf');
        GrpRoiFolder=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict', strcat('Subject_',num2str(s)), 'GrpROIs');
        roiFolder=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict', strcat('Subject_',num2str(s)), 'ROIs');
        cd(surfFolder);
        if m==1
            cd(roiFolder);
             [vol]  = load_mgh(strcat(maps{m}, '_proj_max.mgh'));
        elseif  m<4
            [vol]  = load_mgh(strcat(maps{m}, '_', hem{1}, '_proj_max.mgh'));
        elseif m==4 || m==5
            [vol]  = load_mgh(strcat(maps{m}, '_', hem{1}, '_proj_mean.mgh'));
        elseif m>5 && m<19
            if hem{1}=='lh'
                track=tracks_lh(1,m-5)
            else
                track=tracks_rh(1,m-5)
            end
            [vol]  = load_mgh(strcat('04_lh_OTS_from_fsaverage_manual_FG_track_', num2str(track), '_', hem{1}, '_proj_max.mgh'));
        end
        
        for i=1:length(label)
            if m==1
                roiRead(i,1)=vol(label(i,1)+1,1);
            elseif m==2
                responseMath(i,1)=vol(label(i,1)+1,1); %the labels are 0-based!!!!
            elseif m==3
                responseRead(i,1)=vol(label(i,1)+1,1);
            else
                predictorsT(i,m-3)=table(vol(label(i,1)+1,1));
                predictorsA(i,m-3)=vol(label(i,1)+1,1);
            end
        end
    end
    
    cd(outFolder)
    save(strcat('Subject_',num2str(s),'_','lh_mOTS_disk7mm_fsavg_roi.mat'),...
        'roiRead','responseMath','responseRead','predictorsT','predictorsA');
    clear('responseMath','responseRead','roiRead','predictorsT','vol');
    
end

