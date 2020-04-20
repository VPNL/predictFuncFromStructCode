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
maps={'01_adding_vs_all' '01_adding_vs_all' '02_reading_vs_all' '02_reading_vs_all'};
outFolder=fullfile('/share/kalanit/biac2/kgs/projects/PredictFuncFromStruct/PredictMatrixesSplit');
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
    
    roiRead=zeros(length(label),1);
    responseMath=zeros(length(label),2);
    responseRead=zeros(length(label),2);
    hem={'lh'}

    
    for m=1:length(maps)
        surfFolderOdd=fullfile('/share/kalanit/biac2/kgs/3Danat/FreesurferSegmentations', fs_ids{s}, 'surf','predictFuncFromStructOdd');
     surfFolderEven=fullfile('/share/kalanit/biac2/kgs/3Danat/FreesurferSegmentations', fs_ids{s}, 'surf','predictFuncFromStructEven');
     
       if rem(m,2)>0
        cd(surfFolderOdd);
       else
           cd(surfFolderEven);
       end
       
       [vol]  = load_mgh(strcat(maps{m}, '_', hem{1}, '_proj_max.mgh'));

        for i=1:length(label)
            if m<3
                responseMath(i,m)=vol(label(i,1)+1,1); %the labels are 0-based!!!!
            elseif m>2
                responseRead(i,m-2)=vol(label(i,1)+1,1);
            end
        end
    end
    
    if s==1
    responseMathAll=responseMath;
    responseReadAll=responseRead;
    else
    responseMathAll=[responseMathAll;responseMath];
    responseReadAll=[responseReadAll;responseRead];
    end
        
    cd(outFolder)
    save(strcat('Subject_',num2str(s),'_','OddEvenSplit.mat'),...
        'responseMath','responseRead');
    clear('responseMath','responseRead','vol');
    
    
end

    cd(outFolder)
    save(strcat('All_Subject_OddEvenSplit.mat'),...
        'responseMathAll','responseReadAll');
    
    [R,p]=corrcoef(responseReadAll(:,1), responseReadAll(:,2))
    
for s=1:30
    load(strcat('Subject_',num2str(s),'_','OddEvenSplit.mat'),...
        'responseMath','responseRead');
 [R,p]=corrcoef(responseRead(:,1), responseRead(:,2))
 corrs(s,1)=R(1,2);
 clear('responseRead')
end
 
corrsMean=mean(corrs);
corrsSE=std(corrs) / sqrt(length(corrs));
    
    
