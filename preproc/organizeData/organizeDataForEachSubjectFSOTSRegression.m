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
maps={'01_adding_vs_all' '02_reading_vs_all' '03_T1_in_GM' '03_T1_in_WM', ...
    'Group_02_reading_vs_all_lh_proj_max_without_Subject_' 'Group_02_reading_vs_all_resliced_affine_without_Subject_'};
outFolder=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/PredictMatrixesMNI');
output=[];

%     if exist(outFolder)
%     cmdstr=['rm -r ' outFolder]
%     system(cmdstr)
%     end
%     
     cmdstr=['mkdir ' outFolder]
     system(cmdstr)

for s=1:30

    labelfolder=fullfile(fsfolder, fs_ids{s}, 'label/aparc2009/predictFuncFromStructBoundaries')
    cd(labelfolder)
    
    cmdstr=['cp ' fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict', strcat('Subject_',num2str(s)), 'ROIs','lh_OTS_from_fsaverage_manual.label'),...
        ' ' fullfile(fsfolder,fs_ids{s},'label/aparc2009/predictFuncFromStructBoundaries/','lh_OTS_from_fsaverage_manual.label')];
    system(cmdstr);
    
    label = read_label(fs_ids{s},strcat('aparc2009/predictFuncFromStructBoundaries/','lh_OTS_from_fsaverage_manual'));
    
    predictorsA=zeros(length(label),2+13+30+30);
    roiRead=zeros(length(label),1);
    responseMath=zeros(length(label),1);
    responseRead=zeros(length(label),1);
    hem={'lh'}
    
    predictorsT = array2table(predictorsA,'VariableNames',{'T1Gray' 'T1White' 'TR' 'CS' 'CC' 'CH'...
        'CFMa' 'CFMi' 'IFOF' 'ILF' 'SLF' 'UCI' 'AF' 'VOF' 'pAF'...
        'GrpMapSL1' 'GrpMapSL2' 'GrpMapSL3' 'GrpMapSL4' 'GrpMapSL5' 'GrpMapSL6' 'GrpMapSL7' 'GrpMapSL8' 'GrpMapSL9' 'GrpMapSL10'...
        'GrpMapSL11' 'GrpMapSL12' 'GrpMapSL13' 'GrpMapSL14' 'GrpMapSL15' 'GrpMapSL16' 'GrpMapSL17' 'GrpMapSL18' 'GrpMapSL19' 'GrpMapSL20'...
        'GrpMapSL21' 'GrpMapSL22' 'GrpMapSL23' 'GrpMapSL24' 'GrpMapSL25' 'GrpMapSL26' 'GrpMapSL27' 'GrpMapSL28' 'GrpMapSL29' 'GrpMapSL30'...
        'GrpMapVL1' 'GrpMapVL2' 'GrpMapVL3' 'GrpMapVL4' 'GrpMapVL5' 'GrpMapVL6' 'GrpMapVL7' 'GrpMapVL8' 'GrpMapVL9' 'GrpMapVL10'...
        'GrpMapVL11' 'GrpMapVL12' 'GrpMapVL13' 'GrpMapVL14' 'GrpMapVL15' 'GrpMapVL16' 'GrpMapVL17' 'GrpMapVL18' 'GrpMapVL19' 'GrpMapVL20'...
        'GrpMapVL21' 'GrpMapVL22' 'GrpMapVL23' 'GrpMapVL24' 'GrpMapVL25' 'GrpMapVL26' 'GrpMapVL27' 'GrpMapVL28' 'GrpMapVL29' 'GrpMapVL30'});
    
    tracks_lh=[1 3 5 6 7 9  11 13 15 17 19 21 23]
    tracks_rh=[2 4 5 6 8 10 12 14 16 18 20 22 24]
    
    for m=1:length(maps)-2+13+30+30
        surfFolder=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict', strcat('Subject_',num2str(s)), 'Surf');
        grpMapSurfFolder=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict', strcat('Subject_',num2str(s)), 'GrpMaps');
        grpMapVolFolder=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/data4Predict', strcat('Subject_',num2str(s)), 'GrpMapsVolumeMNIInSurf');
        cd(surfFolder);
        if  m<3
            [vol]  = load_mgh(strcat(maps{m}, '_', hem{1}, '_proj_max.mgh'));
        elseif m==3 || m==4
            [vol]  = load_mgh(strcat(maps{m}, '_', hem{1}, '_proj_mean.mgh'));
        elseif m>4 && m<18
            if hem{1}=='lh'
                track=tracks_lh(1,m-4)
            else
                track=tracks_rh(1,m-4)
            end
            [vol]  = load_mgh(strcat('04_lh_OTS_from_fsaverage_FG_cleaner_track_', num2str(track), '_', hem{1}, '_proj_max.mgh'));
        elseif m>17 && m<48
            cd(grpMapSurfFolder);
            [vol]  = load_mgh(strcat(maps{5}, num2str(m-17), '.mgh'));
        elseif m>47
                       cd(grpMapVolFolder);
            [vol]  = load_mgh(strcat(maps{6}, num2str(m-47), '_lh_proj_max.mgh'));
        end
        
        for i=1:length(label)
            if m==1
                responseMath(i,1)=vol(label(i,1)+1,1); %the labels are 0-based!!!!
            elseif m==2
                responseRead(i,1)=vol(label(i,1)+1,1);
            else
                predictorsT(i,m-2)=table(vol(label(i,1)+1,1));
                predictorsA(i,m-2)=vol(label(i,1)+1,1);
            end
        end
    end
    
    cd(outFolder)
    save(strcat('Subject_',num2str(s),'_','lh_OTS_fsavg_regression_v2.mat'),...
        'roiRead','responseMath','responseRead','predictorsT','predictorsA');
    clear('responseMath','responseRead','roiRead','predictorsT','vol');
    
end

