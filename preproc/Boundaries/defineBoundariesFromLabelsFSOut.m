%% store paths to data directories and copy necessary files
% before this runs you need to copy the regsiter.dat file form
% FreesurferSegmentations/subject/labels to
% FreesurferSegmentations/subject/surf


anat_ids = {'siobhan' 'avt' 'anthony_new_recon_2017'...
    'kalanit_new_recon_2017' 'mareike' 'jesse_new_recon_2017'...
    'brianna' 'swaroop' 'eshed'...
    'richard' 'cody' 'marisa'...
    'kari' 'alexis' 'nathan'...
    'dawn' 'erica' 'th'...
    'ek' 'gm' 'bl'...
    'mw' 'jk' 'pe'...
    'ie' 'pw' 'ks' ...
    'mz' 'mm' 'ans'};

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

fsa_dir = fullfile(RAID, '3Danat', 'FreesurferSegmentations', 'fsaverage-bkup');
fs_dir = fullfile(RAID, '3Danat', 'FreesurferSegmentations');

sessions={'01_sc_morphing_112116' '02_at_morphing_102116' '03_as_morphing_112616'...
    '04_kg_morphing_120816' '05_mg_morphing_101916' '06_jg_morphing_102316'...
    '07_bj_morphing_102516' '08_sg_morphing_102716' '10_em_morphing_1110316'...
    '12_rc_morphing_112316' '13_cb_morphing_120916' '15_mn_morphing_012017'...
    '16_kw_morphing_081517' '17_ad_morphing_082217' '18_nc_morphing_083117'...
    '19_df_morphing_111218' '21_ew_morphing_111618' '22_th_morphing_112718'...
    '23_ek_morphing_113018' '24_gm_morphing_120618' '25_bl_morphing_122018'...
    '26_mw_morphing_031919' '27_jk_morphing_032119' '28_pe_morphing_040219'...
    '29_ie_morphing_040519' '30_pw_morphing_041119' '31_ks_morphing_041019'...
    '32_mz_morphing_042219' '33_mm_morphing_050619' '34_ans_morphing_05072019'};

% avt kalanit swaroop 

annot_name = ['aparc.a2009s'];
hems={'lh' 'rh'}


%average surface maps across all sessions
cd(fullfile(RAID, '3Danat', 'FreesurferSegmentations', 'fsaverage-bkup', 'surf'));

for s=1
    
    outdir=fullfile(fs_dir,fs_ids{s},'label','aparc2009','predictFuncFromStructBoundaries');
    if ~exist(outdir)
    mkdir(outdir)
    end
    
    cd(outdir)
    
for hem = 1:length(hems)

    %% math boundaries
    PCS_in = read_label(fs_ids{s},fullfile('aparc2009',strcat(hems{hem},'.S_precentral-inf-part')));
    PCS_out = write_label(PCS_in(:,1), PCS_in(:,2:4), PCS_in(:,5),fullfile(outdir,strcat(hems{hem}, '_PCS_anat.label')));

    ITG_in1 = read_label(fs_ids{s},fullfile('aparc2009',strcat(hems{hem},'.G_temporal_inf')));
    ITG_in2 = read_label(fs_ids{s},fullfile('aparc2009',strcat(hems{hem},'.S_temporal_inf')));
    ITG_in= sortrows(vertcat(ITG_in1,ITG_in2));
    ITG_out = write_label(ITG_in(:,1), ITG_in(:,2:4), ITG_in(:,5),fullfile(outdir,strcat(hems{hem}, '_ITG_anat.label')));

    IPS_in1 = read_label(fs_ids{s},fullfile('aparc2009',strcat(hems{hem},'.G_parietal_sup')));
    
    if exist(fullfile(fs_dir,fs_ids{s},'label','aparc2009',strcat(hems{hem},'.S_intrapariet_and_P_trans.label')));
    IPS_in2 = read_label(fs_ids{s},fullfile('aparc2009',strcat(hems{hem},'.S_intrapariet_and_P_trans')));
    else
    IPS_in2 = read_label(fs_ids{s},fullfile('aparc2009',strcat(hems{hem},'.S_intrapariet&P_trans')));   
    end
    
    IPS_in= sortrows(vertcat(IPS_in1,IPS_in2));
    IPS_out = write_label(IPS_in(:,1), IPS_in(:,2:4), IPS_in(:,5),fullfile(outdir,strcat(hems{hem}, '_IPS_anat.label')));

    
    %% Reading boundaries
    OTS_in1 = read_label(fs_ids{s},fullfile('aparc2009',strcat(hems{hem},'.S_oc-temp_lat')));
    OTS_in2 = read_label(fs_ids{s},fullfile('aparc2009',strcat(hems{hem},'.S_collat_transv_ant')));
    OTS_in= sortrows(vertcat(OTS_in1,OTS_in2));
    OTS_out = write_label(OTS_in(:,1), OTS_in(:,2:4), OTS_in(:,5),fullfile(outdir,strcat(hems{hem}, '_OTS_anat.label')));

    STS_in1 = read_label(fs_ids{s},fullfile('aparc2009',strcat(hems{hem},'.S_temporal_sup')));
    STS_in2 = read_label(fs_ids{s},fullfile('aparc2009',strcat(hems{hem},'.G_temporal_middle')));
    STS_in= sortrows(vertcat(STS_in1,STS_in2));
    STS_out = write_label(STS_in(:,1), STS_in(:,2:4), STS_in(:,5),fullfile(outdir,strcat(hems{hem}, '_STS_anat.label')));

    SMG_in1 = read_label(fs_ids{s},fullfile('aparc2009',strcat(hems{hem},'.G_pariet_inf-Supramar')));
    SMG_in2 = read_label(fs_ids{s},fullfile('aparc2009',strcat(hems{hem},'.S_interm_prim-Jensen')));
    SMG_in= sortrows(vertcat(SMG_in1,SMG_in2));
    SMG_out = write_label(SMG_in(:,1), SMG_in(:,2:4), SMG_in(:,5),fullfile(outdir,strcat(hems{hem}, '_SMG_anat.label')));

    IFG_in1 = read_label(fs_ids{s},fullfile('aparc2009',strcat(hems{hem},'.G_front_inf-Orbital')));
    IFG_in2 = read_label(fs_ids{s},fullfile('aparc2009',strcat(hems{hem},'.Lat_Fis-ant-Horizont')));
    IFG_in3 = read_label(fs_ids{s},fullfile('aparc2009',strcat(hems{hem},'.G_front_inf-Triangul')));
    IFG_in4 = read_label(fs_ids{s},fullfile('aparc2009',strcat(hems{hem},'.Lat_Fis-ant-Vertical')));
    IFG_in5 = read_label(fs_ids{s},fullfile('aparc2009',strcat(hems{hem},'.G_front_inf-Opercular')));
    IFG_in= sortrows(vertcat(IFG_in1,IFG_in2,IFG_in3,IFG_in4,IFG_in5));
    IFG_out = write_label(IFG_in(:,1), IFG_in(:,2:4), IFG_in(:,5),fullfile(outdir,strcat(hems{hem}, '_IFG_anat.label')));

end
end