function [ mouse,trainingsettings,cell] = loadEphysMetadata(filename)
%loadEphysMetadata used to load general metadata for training group or groups of mice
%   Data loaded includes mouse names, initial weights, number of training
%   days, position of reward zone (front/back) and type of lever action (pull, push,
%   pushpull etc.)

currentfolder = pwd;

MetaPathList

cd(ephysMetadataPath);

[~,~,raw] = xlsread(filename);

% cd(currentFolder)

mouse.name = raw{1,2};
mouse.numbercells = raw{2,2};

trainingsettings.hold_duration    = raw{5,1};
trainingsettings.lever_distance   = raw{6,1};
trainingsettings.randomisation    = raw{7,1};
trainingsettings.reward_amount    = raw{8,1};
trainingsettings.reward_action    = raw(5,3);
trainingsettings.ITI_min          = raw{6,3};
trainingsettings.ITI_max          = raw{7,3};
trainingsettings.tone_max         = raw{8,3};

if trainingsettings.tone_max > 0
    trainingsettings.tone_mode    = 2;
else trainingsettings.tone_mode   = 1;
end

for cell_ID = 1:mouse.numbercells
    
    cell.depth{1,cell_ID}  = raw{12+(cell_ID-1)*7,2};
    cell.thresh{1,cell_ID} = raw{13+(cell_ID-1)*7,2};
    
    temp_trace_number      = raw{14+(cell_ID-1)*7,2};
         
    for trace_ID = 1:temp_trace_number
        
        cell.traces_list{trace_ID,cell_ID} = raw{15+(cell_ID-1)*7,1+trace_ID};
        cell.traces_type{trace_ID,cell_ID} = raw{16+(cell_ID-1)*7,1+trace_ID};
        cell.video_list{trace_ID,cell_ID}  = raw{17+(cell_ID-1)*7,1+trace_ID};
        
    end
end

cd(currentfolder)

end

