function [timevid,motionindexsq]=makevideoanalysis(date,filenum,varargin)

pathfolder=sprintf('C:/matlab_scripts/video/data/');

est1=sprintf('.m4v');
est2=sprintf('.mp4');
filename1=sprintf('%s%s_%s%s',pathfolder,date,filenum,est1);
filename2=sprintf('%s%s_%s%s',pathfolder,date,filenum,est2);


if exist(filename1,'file')
  est=est1;  
elseif exist(filename2,'file')
    est=est2;
end


filename=sprintf('%s%s_%s%s',pathfolder,date,filenum,est);           
fprintf('Opening video: %s \n\n',filename)

if exist(filename,'file')

    xyloObj = VideoReader(filename);

    nFrames = xyloObj.NumberOfFrames;
    vidHeight = xyloObj.Height;
    vidWidth = xyloObj.Width;
    dtime=1./xyloObj.FrameRate;
    
    if ~isempty(varargin)
        xrange=varargin{1};
        yrange=varargin{2};
    else
        xrange=[1;vidWidth];
        yrange=[1;vidHeigth];
    end

    xrange=xrange(1):xrange(2);
    yrange=yrange(1):yrange(2);
    
% Read one frame at a time.
k=1;
frameA = read(xyloObj, k);

motionindexsq=zeros(3,nFrames);

%nFrames=90;
tic
for k = 2 : nFrames
    
    frameB=read(xyloObj, k);
    difference=(frameB(:,:,1)-frameA(:,:,1));
    differenceRoi=(frameB(yrange,xrange,1)-frameA(yrange,xrange,1));
    
    motionindexsq(1,k)=sum(sum(difference.^2));
    motionindexsq(2,k)=sum(sum(differenceRoi.^2));
    
    clear difference
    clear differenceRoi
    
    frameA=frameB;
    
    
    if motionindexsq(1,k)==0 && k>3
       frameA(100,100,:)
       beep
    end
   
    
    if rem(k,500)==0
       toc
       fprintf('Analysing %i / %i frames\n',k,nFrames);
       tic
       
       timevid=dtime:dtime:dtime*k;
       
       [timevidreg,motionindexsqreg]=regularizemotion(timevid,motionindexsq);
       
       
       pathfolder=sprintf('C:/matlab_scripts/video/data/');
       est=sprintf('.csv');
       filenamesave=sprintf('%s%s_%s_%d%s',pathfolder,date,filenum,k,est);           
       %fprintf('Saving .csv file: %s \n\n',filenamesave)
       
       A=[timevidreg', motionindexsqreg(1,:)'];
       %save(filenamesave,'A','-ascii','-double','-tabs')
        
    end
    
end

timevid=dtime:dtime:dtime*nFrames;

motionindexsq(1,:)=motionindexsq(1,:)./(vidHeight*vidWidth);
motionindexsq(2,:)=motionindexsq(2,:)./(length(xrange)*length(yrange));

[timevidreg,motionindexsqreg]=regularizemotion(timevid,motionindexsq);


A=[timevidreg', motionindexsqreg(1,:)'];
Aroi=[timevidreg', motionindexsqreg(2,:)'];


pathfolder=sprintf('C:/matlab_scripts/video/data/');
est=sprintf('.csv');
filenamesavesq=sprintf('%s%s_%s%s',pathfolder,date,filenum,est);           
fprintf('Saving .csv file: %s %s \n\n',pathfolder,filenamesavesq)
       
save(filenamesavesq,'A','-ascii','-double','-tabs')   

filenamesaveroi=sprintf('%s%s_%s_Roi%s',pathfolder,date,filenum,est);           
fprintf('\n\nSaving the .csv file: %s%s \n',pathfolder,filenamesaveroi)
save(filenamesaveroi,'Aroi','-ascii','-double','-tabs')   

    
    
else
   
    fprintf('Did not found .m4v video: %s %s \n',pathfolder,filename)
    
end
        
%cd(currentfolder);

figure
       plot(timevidreg,motionindexsqreg(1,:));
       hold on
       plot(timevidreg,motionindexsqreg(2,:),'r');
       xlabel('time (s)')
       ylabel('M.I.')
       legend('FullFrame','Roi')
       

clear xyloObj

end