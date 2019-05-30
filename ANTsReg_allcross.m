% this file loops through all available subjects and submits jobs for their registration with 
% all other subjects. This will spawn many jobs!

clear;

subs = ls('multisite_cropped/*.lbl.nii.gz');
subs = strsplit(subs)';
subs(end)=[];
subs = sort(subs);

njobs = 0;
subjobs = [];
for i=1:length(subs)-1
    for j=i+1:length(subs)        
        f1 = subs{i}(19:end-11); %(template)
        f2 = subs{j}(19:end-11); %(target)
        
        Rcheck = [];% don't rerun registrations if they exist!
        try
            % this should be the last file created by a given registration
            Rcheck = ls(['ANTSRegistrations/' f1 '-' f2 '/target_label-1_warped.nii.gz']);
        end
        if isempty(Rcheck)
            % remove any existing failed registrations
            system(['rm -rf ANTSRegistrations/' f1 '-' f2]);
            
            system(['regularSubmit ~/opt/HippUnfolding/tools/ANTS_tools/runAntsLabelMaps.sh '...
                subs{i} ' ' subs{j} ' ANTSRegistrations/' f1 '-' f2]);
            pause(60);
            njobs = njobs+1;
            subjobs{njobs} = [f1 f2];
        end
    end
end
fprintf('total jobs submitted: %d\n',njobs);
