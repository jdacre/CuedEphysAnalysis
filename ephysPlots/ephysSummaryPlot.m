clear all

MetaPathList

currentfolder = pwd;

pathfolder = leverData;
cd(pathfolder);

file_or_folder = input('Do you want to plot a single abf file (f) or a folder (F)?:', 's');

%file_or_folder = sprintf('f');
if file_or_folder == 'f'
    
    filename=uigetfile('*.*');
    abfList = 1;
    
elseif file_or_folder == 'F'
    
    directory_name  =   uigetdir;
    files           =   dir(directory_name);
    fileIndex       =   find(~[files.isdir]);
    numFiles        =   length(fileIndex);
    abfList         =   zeros(1,numFiles);
    
    for file_ID = fileIndex
        if ~isempty(regexp(files(file_ID).name,'.abf', 'once'))
            abfList(file_ID) = 1;
        end
    end
    
    abfList         = find(abfList == 1);
    numabfFiles     = length(abfList);
    
end
%filename = uigetfile('*.*');

for abfID=abfList
    filename = files(abfID);
    filename = filename.name;
    
    ABF = abfLoad2(filename);
    
    max_ephys = max(ABF(:,1));
    
    
    figure
    plot(ABF(:,1),'k')
    hold on
    plot(ABF(:,6)+max_ephys+5,'m')
    hold on
    plot(ABF(:,5)+max_ephys+11,'r')
    hold on
    plot(ABF(:,4)+max_ephys+17,'g')
    hold on
    plot(ABF(:,3)+max_ephys+23,'k')
    hold on
    plot(ABF(:,2)+max_ephys+29,'b')
    axis([0 inf -inf-5 inf+5])
    % TITLE = sprintf('
    cd(pwd);
end
