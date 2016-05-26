clear all

MetaPathList

currentfolder = pwd;

pathfolder = leverData;
cd(pathfolder);

%     directory_name = uigetdir;
%     files = dir(directory_name);
%     fileIndex = find(~[files.isdir]);

filename = uigetfile('*.*');

% for i=1:length(fileIndex)
%     filename = files(fileIndex);

ABF = daqread(filename);

max_ephys = max(ABF(:,1));


figure
plot(ABF(:,1),'k')
hold on 
plot(ABF(:,5)+max_ephys+5,'m')
hold on
plot(ABF(:,4)+max_ephys+11,'r')
hold on
plot(ABF(:,3)+max_ephys+17,'g')
hold on
plot(ABF(:,2)+max_ephys+23,'k')
% hold on
% plot(ABF(:,2)+max_ephys+29,'b')
axis([0 inf -inf-5 inf+5])
% TITLE = sprintf('
cd(pwd);
% end
