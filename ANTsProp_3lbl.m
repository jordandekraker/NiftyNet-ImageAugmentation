% this script will propogate all labelmaps and underlying images through ANTs registrations.

clear;

subs = ls('multisite_cropped/*.lbl.nii.gz');
subs = strsplit(subs)';
subs(end)=[];
subs = sort(subs);

list = {};
for i=1:length(subs)-1
    for j=i+1:length(subs)
        
        f1 = subs{i}(19:end-11); %(template)
        f2 = subs{j}(19:end-11); %(target)
        
        Icheck = [];% don't rerun if they exist!
	Lcheck = [];
        try
            % this should be the last file created by a given registration
            Icheck = ls(['TrainingData/' f2 '-' f1 '.img*.nii.gz']);
            Lcheck = ls(['TrainingData/' f2 '-' f1 '.lbl-tri.nii.gz']);
        end
        if isempty(Icheck) | isempty(Lcheck)
            
            % list missing
            list = {list{:} [f1 '-' f2]};
            
            %% apply transforms to labelmaps
            %forward
            lbl = ['multisite_cropped/' f1 '.lbl.nii.gz'];
            lblGMDB = load_untouch_nii(lbl);
            lblGMDB.img(lblGMDB.img==4) = 2; % cycsts included in DB
            lblGMDB.img(lblGMDB.img>2) = 0; % keep only grey matter and dark band
            save_untouch_nii(lblGMDB,['TrainingData/' f1 '.lbl-tri.nii.gz'])
            system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
                '-i TrainingData/' f1 '.lbl-tri.nii.gz '...
                '-o TrainingData/' f1 '-' f2 '.lbl-tri.nii.gz '...
                '-r ANTSRegistrations/' f1 '-' f2 '/target_label-1.nii.gz '...
                '-t [ANTSRegistrations/' f1 '-' f2 '/ants_0GenericAffine.mat, 1] '...
                '-t ANTSRegistrations/' f1 '-' f2 '/ants_1InverseWarp.nii.gz '...
                ]);
            %backward
            lbl = ['multisite_cropped/' f2 '.lbl.nii.gz'];
            lblGMDB = load_untouch_nii(lbl);
            lblGMDB.img(lblGMDB.img==4) = 2; % cycsts included in DB
            lblGMDB.img(lblGMDB.img>2) = 0; % keep only grey matter and dark band
            save_untouch_nii(lblGMDB,['TrainingData/' f2 '.lbl-tri.nii.gz'])
            system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
                '-i TrainingData/' f2 '.lbl-tri.nii.gz '...
                '-o TrainingData/' f2 '-' f1 '.lbl-tri.nii.gz '...
                '-r ANTSRegistrations/' f1 '-' f2 '/template_label-1.nii.gz '...
                '-t ANTSRegistrations/' f1 '-' f2 '/ants_1Warp.nii.gz '...
                '-t ANTSRegistrations/' f1 '-' f2 '/ants_0GenericAffine.mat'...
                ]);
            
            %% apply transforms to underlying images
            %forward
            imgs = ls(['multisite_cropped/' f1 '*.img*']);
            imgs = strsplit(imgs)';
            imgs(end) = [];
            
            for k = 1:length(imgs)
                imgtype = strfind(imgs{k},'.img');
                imgtype = imgs{k}(imgtype:end);
                system(['cp ' imgs{k} ' TrainingData/' f1 imgtype]);
                system(['antsApplyTransforms -d 3 --interpolation Linear '...
                    '-i ' imgs{k} ' '...
                    '-o TrainingData/' f1 '-' f2 imgtype ' '...
                    '-r ANTSRegistrations/' f1 '-' f2 '/target_label-1.nii.gz '...
                    '-t [ANTSRegistrations/' f1 '-' f2 '/ants_0GenericAffine.mat, 1] '...
                    '-t ANTSRegistrations/' f1 '-' f2 '/ants_1InverseWarp.nii.gz '...
                    ]);
            end
            %backward
            imgs = ls(['multisite_cropped/' f2 '*.img*']);
            imgs = strsplit(imgs)';
            imgs(end) = [];
            
            for k = 1:length(imgs)
                imgtype = strfind(imgs{k},'.img');
                imgtype = imgs{k}(imgtype:end);
                system(['cp ' imgs{k} ' TrainingData/' f2 imgtype]);
                system(['antsApplyTransforms -d 3 --interpolation Linear '...
                    '-i ' imgs{k} ' '...
                    '-o TrainingData/' f2 '-' f1 imgtype ' '...
                    '-r ANTSRegistrations/' f1 '-' f2 '/template_label-1.nii.gz '...
                    '-t ANTSRegistrations/' f1 '-' f2 '/ants_1Warp.nii.gz '...
                    '-t ANTSRegistrations/' f1 '-' f2 '/ants_0GenericAffine.mat'...
                    ]);
            end
            disp([f1 '-' f2 ' done']);
        end
    end
end
